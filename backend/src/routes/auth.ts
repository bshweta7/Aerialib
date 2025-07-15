import { eq, and } from "drizzle-orm";
import { Router, Request, Response } from "express";
import {NewUser, usersTable, userRolesTable, eventsTable} from "../db/schema";
import { db } from "../db";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from "../middleware/auth";
import dotenv from "dotenv";
import {jsonb, text, timestamp, uuid} from "drizzle-orm/pg-core";
import nodemailer from "nodemailer";
import crypto from "crypto";
import {sendForgotUsernameEmail, sendPasswordResetEmail} from "../utils/email";

dotenv.config();

const authRouter = Router();

interface SignUpBody {
    username: string,
    email: string,
    password: string,
}

interface LoginBody {
    username: string,
    password: string,
}

interface ForgotBody {
    email: string,
}

/// Check if username or email already exists in db
authRouter.post("/validate", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        // get request body
        const { username, email } = req.body;

        // initialize response
        const taken = {
            email: true,
            username: true,
        };

        // check if the username is taken
        const [usernameExists] = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.username, username));

        if (!usernameExists) {
            taken.username = false;
        }

        // check if email is taken
        const [emailExists] = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.email, email));

        if (!emailExists) {
            taken.email = false;
        }

        res.status(201).json(taken);

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
});

/// Signup new user
authRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        // get request body
        const { username, email, password } = req.body;

        // check if a user with the same email already exists
        const existingEmailUser = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.email, email));

        // also ensure that a user with the same username doesn't exist
        const existingUsernameUser = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.username, username));

        if (existingEmailUser.length) {
            res.status(400).json({ error: "User with this email already exists." });
            // TODO if this error, then offer forgot password in snackbar
            return;
        }

        if (existingUsernameUser.length) {
            res.status(400).json({ error: "User with this username already exists." });
            // TODO if this error, then offer forgot password in snackbar
            return;
        }

        // hash the password
        const hashedPassword = await bcryptjs.hash(password, 8);

        // create a new user and store in db
        const newUser: NewUser = {
            username,
            email,
            password: hashedPassword
        }

        // insert new user into db
        const [user] = await db.insert(usersTable).values(newUser).returning()

        // insert signup event into events table
        await db.insert(eventsTable).values({
            eventType: "signup",
            userId: user.id,
            time: new Date(),
            note: user.username,
        });

        // send info to the frontend
        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET!);

        res.status(201).json({
            token: token,
            id: user.id,
            username: user.username,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            bio: user.bio,
        });

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
});

/// Login user
authRouter.post("/login", async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
        // get request body
        const { username, password } = req.body;

        //check if a user exists
        const [existingUser] = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.username, username));

        if (!existingUser) {
            res
                .status(400)
                .json({ error: "User with this username does not exist. Do you want to sign up?" });
            return
        }

        // check password
        const isMatch = await bcryptjs.compare(password, existingUser.password);
        if (!isMatch) {
            res.status(400).json({ error: "Incorrect password. Please try again." })
            return
        }

        const token = jwt.sign({ id: existingUser.id }, process.env.JWT_SECRET!);

        // insert login event
        await db.insert(eventsTable).values({
            eventType: "login",
            userId: existingUser.id,
            note: existingUser.username,
            time: new Date(),
        });

        // respond with user info and token
        res.json({
            token: token,
            id: existingUser.id,
            username: existingUser.username,
            email: existingUser.email,
            firstName: existingUser.firstName,
            lastName: existingUser.lastName,
            bio: existingUser.bio,
        });

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
});

/// Check if the token stored on the user's device is valid
authRouter.post("/tokenIsValid", async (req, res) => {
    try {
        // get the header (to get token)
        const token = req.header("x-auth-token"); // TODO rename x-auth-token

        if (!token) {
            res.json(false);
            return;
        }

        // verify if token is valid
        const verified = jwt.verify(token, process.env.JWT_SECRET!);

        if (!verified) {
            res.json(false);
            return;
        }

        // get user data if token is valid
        const verifiedToken = verified as { id: string };

        const [user] = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.id, verifiedToken.id));

        // if no user, return false
        if (!user) {
            res.json(false);
            return;
        }

        res.json(true);

    } catch (e) {
        res.status(500).json(false);
    }
});

/// Send email with a link to reset password
authRouter.post("/forgotPassword", async (req: Request<{}, {}, ForgotBody>, res: Response) => {
    const { email } = req.body;

    const [user] = await db.select().from(usersTable).where(eq(usersTable.email, email));
    if (!user) {
        res.status(200).json({ message: "If this email is registered, you'll receive reset instructions." });
        return;
    }

    const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET!, { expiresIn: "15m" });

    const resetLink = `${process.env.CLIENT_URL}/reset-password?token=${token}`;

    try {
        const info = await sendPasswordResetEmail(email, resetLink);
        console.log('Email sent successfully:', info.messageId);
    } catch (error) {
        console.error('Email sending failed:', error);
        // Still return success to prevent email enumeration
    }

    res.status(200).json({ message: "If this email is registered, you'll receive reset instructions." });
});

/// Send email with the username associated with the email
authRouter.post("/forgotUsername", async (req: Request<{}, {}, ForgotBody>, res: Response) => {
    const { email } = req.body;

    const [user] = await db.select().from(usersTable).where(eq(usersTable.email, email));
    if (!user) {
        res.status(200).json({ message: "If this email is registered, you'll receive reset instructions." });
        return;
    }

    // const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET!, { expiresIn: "15m" });

    // const resetLink = `${process.env.CLIENT_URL}/reset-password?token=${token}`;

    try {
        const info = await sendForgotUsernameEmail(email, user.username);
        console.log('Email sent successfully:', info.messageId);
    } catch (error) {
        console.error('Email sending failed:', error);
        // Still return success to prevent email enumeration
    }

    res.status(200).json({ message: "If this email is registered, you'll receive reset instructions." });
});

/// Update user info with new password
authRouter.post("/resetPassword", async (req: Request, res: Response) => {
    const { token, newPassword } = req.body;

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET!) as { id: string };
        const hashedPassword = await bcryptjs.hash(newPassword, 8);

        await db
            .update(usersTable)
            .set({ password: hashedPassword })
            .where(eq(usersTable.id, decoded.id));

        res.status(200).json({ message: "Password reset successful." });
    } catch (e) {
        res.status(400).json({ error: "Invalid or expired token." });
    }
});


export default authRouter;