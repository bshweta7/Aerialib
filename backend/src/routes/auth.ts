import { eq } from "drizzle-orm";
import { Router, Request, Response } from "express";
import { NewUser, usersTable } from "../db/schema";
import { db } from "../db";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from "../middleware/auth";

const authRouter = Router();

interface SignUpBody {
    name: string,
    email: string,
    password: string,
}

interface LoginBody {
    email: string,
    password: string,
}

// signup route
authRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        // get request body
        const { name, email, password } = req.body;

        //check if user already exists
        const existingUser = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.email, email));

        if (existingUser.length) {
            res
                .status(400)
                .json({ error: "User with the same email already exists." }); // TODO this should lead to "forgot password" button to send an email 
            return
        }

        // hash the password
        const hashedPassword = await bcryptjs.hash(password, 8);

        // create a new user and store in db
        const newUser: NewUser = {
            name,
            email,
            password: hashedPassword
        }

        const [user] = await db.insert(usersTable).values(newUser).returning()
        res.status(201).json(user);

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
});

// login route
authRouter.post("/login", async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
        // get request body
        const { email, password } = req.body;

        //check if user doesn't exists
        const [existingUser] = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.email, email));

        if (!existingUser) {
            res
                .status(400)
                .json({ error: "User with this email does not exists!" });
            return
        }

        // hash the password
        const isMatch = await bcryptjs.compare(password, existingUser.password);
        if (!isMatch) {
            res.status(400).json({ error: "Incorrect password!" })
            return
        }

        const token = jwt.sign({ id: existingUser.id }, "passwordKey") //TODO: move secret key to .env file

        res.json({ token, ...existingUser });

    } catch (e) {
        console.log(e)
        res.status(500).json({ error: e })
    }
});


// check if the token stored on user's device is valid
authRouter.post("/tokenIsValid", async (req, res) => {
    try {
        // get the header (to get token)
        const token = req.header("x-auth-token");

        if (!token) {
            res.json(false);
            return;
        }

        // verify if token is valid
        const verified = jwt.verify(token, "passwordKey"); // TODO update passwordKey

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


// TODO profile can use the dynamic one: authRouter.post("/profile:id", async (req: Request<{id}, {}, ProfileBody>, res: Response) => {
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

export default authRouter;