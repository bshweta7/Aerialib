import { eq } from "drizzle-orm";
import { Router, Request, Response } from "express";
import { NewUser, usersTable } from "../db/schema";
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

// signup route
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
            res
                .status(400)
                .json({ error: "User with the same email already exists. Did you forget your password?" });
        }

        if (existingUsernameUser.length) {
            res
                .status(400)
                .json({ error: "User with the same username already exists. Please choose a different username." });
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
// TODO also include a "forgot password" button to send an email with updated token

// check existing users
authRouter.post("/check", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
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


// login route
authRouter.post("/login", async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
        // get request body
        const { username, password } = req.body;

        //check if a user doesn't exist
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

        // hash the password
        const isMatch = await bcryptjs.compare(password, existingUser.password);
        if (!isMatch) {
            res.status(400).json({ error: "Incorrect password. Please try again." })
            return
        }

        const token = jwt.sign({ id: existingUser.id }, process.env.JWT_SECRET!);

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


// check if the token stored on the user's device is valid
authRouter.post("/tokenIsValid", async (req, res) => {
    try {
        // get the header (to get token)
        const token = req.header("x-auth-token");

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

// TODO pose search can use the query string: authRouter.post("/profile?level=1", async (req: Request<{}, {level}, ProfileBody>, res: Response) => {

authRouter.get("/", auth, async (req: AuthRequest, res) => {
    try {
        if (!req.user) {
            res.status(401).json({ error: "User not found!" });
            return;
        }

        const [user] = await db.select().from(usersTable).where(eq(usersTable.id, req.user));

        res.json({ ...user, token: req.token })
    } catch (e) {
        res.status(500).json(false);
    }
});


authRouter.get("/profile/:id", async (req: Request<{ id: string }>, res) => {
    const { id } = req.params;
    const [user] = await db
        .select()
        .from(usersTable)
        .where(
            eq(usersTable.id, id)
        );
    res.json(user);
});


authRouter.post("/forgot-password", async (req: Request, res: Response) => {
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

authRouter.post("/forgot-username", async (req: Request, res: Response) => {
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



authRouter.post("/reset-password", async (req: Request, res: Response) => {
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