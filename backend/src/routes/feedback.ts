// routes/feedback.ts
import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import { feedbackTable, NewFeedback } from "../db/schema";

const feedbackRouter = Router();

feedbackRouter.post("/", auth, async (req: AuthRequest, res) => {
    try {
        const { type, message, email } = req.body;

        const newFeedback: NewFeedback = {
            type,
            message,
            email,
            userId: req.user,
            createdAt: new Date(),
        };

        console.log("[FeedbackRouter] Inserting feedback:", newFeedback);

        const [feedback] = await db.insert(feedbackTable).values(newFeedback).returning();

        res.status(201).json(feedback);
    } catch (e) {
        console.error("[FeedbackRouter] Error inserting feedback:", e);
        res.status(500).json({ error: e });
    }
});

export default feedbackRouter;
