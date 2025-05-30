import express from "express";
import logger from "morgan";
import cors from 'cors';
import authRouter from "./routes/auth";
import poseRouter from "./routes/pose";
import mediaRouter from "./routes/media";
import flowRouter from "./routes/flow";
import flowPoseRouter from "./routes/flow_poses";
import feedbackRouter from "./routes/feedback";
import musicRouter from "./routes/music";
import tagRouter from "./routes/tags";

// Load values from .env file
import 'dotenv/config'


const app = express(); // TODO should this be let instead of const

app.use(logger('dev'));
app.use(express.json());
app.use(cors());

// middleware to only passes json related routes
app.use(express.json());

// bind route with prefix of /auth
app.use("/poses", poseRouter);
app.use("/auth", authRouter);
app.use("/media", mediaRouter);
app.use("/flows", flowRouter);
app.use("/flow_poses", flowPoseRouter); // TODO consistent routes - pose, flow, flow_pose/ (not poses)
app.use("/feedback", feedbackRouter);
app.use("/music", musicRouter);
app.use("/tags", tagRouter);

// create rest api
app.get("/", (req, res) => {
    res.send("Welcome to Aerialib ");
});

// start server
app.listen(8000, () => {
    console.log("Server started on port 8000");
}); 