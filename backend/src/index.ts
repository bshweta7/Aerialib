import express from "express";
import logger from "morgan";
import cors from 'cors';
import authRouter from "./routes/auth";
import poseRouter from "./routes/pose";

// Load values from .env file
import 'dotenv/config'

const app = express(); // TODO should this be let instaed of const

app.use(logger('dev'));
app.use(express.json());
app.use(cors());

// middleware to only passes json related routes
app.use(express.json());

// bind route with prefix of /auth
app.use("/poses", poseRouter);
app.use("/auth", authRouter);

// create rest api
app.get("/", (req, res) => {
    res.send("Welcome to Aerialib ");
});

// start server
app.listen(8000, () => {
    console.log("Server started on port 8000");
}); 