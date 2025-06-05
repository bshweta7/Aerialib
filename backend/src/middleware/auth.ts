type UUID = string;
import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { db } from "../db";
import { usersTable } from "../db/schema";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
    // Request is the default type of req; AuthRequest extends it to add in user and token (i.e., auth info) as additional fields
    // Can be used even if not authenticated because user and token are nullable
    user?: string;
    token?: string;
}

export const auth = async (
    req: AuthRequest, 
    res: Response, 
    next: NextFunction
    
) => {
    try {
        
        // get the header (to get token)
        const token = req.header("x-auth-token");

        if(!token) {
            res.status(401).json({error: "No auth token, access denied!"});
            return;
        }

        // verify if token is valid
        const verified = jwt.verify(token, "passwordKey"); // TODO update passwordKey move to env file

        if(!verified){
            res.status(401).json({error: "Token verification failed!"});
            return;
        }

        // get user data if token is valid
        const verifiedToken = verified as {id: UUID}; 

        const [user] = await db
            .select()
            .from(usersTable)
            .where(eq(usersTable.id, verifiedToken.id));

        // if no user, return false
        if (!user) {
            res.status(401).json({error: "User not found!"});
            return;
        }

        req.user = verifiedToken.id;
        req.token = token;

        next();
    } catch(e) {
        res.status(500).json({error: e});
    }
};
