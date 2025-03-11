import express from "express";

// Load values from .env file
import 'dotenv/config'
import authRouter from "./routes/auth";

const app = express(); // TODO should this be let instaed of const

// middleware to only passes json related routes
app.use(express.json()); 
// bind route with prefix of /auth
app.use("/auth", authRouter)

// create rest api
app.get("/", (req, res) => {
    res.send("Welcome to Aerialib :DDDD");
});

// start server
app.listen(8000, () => {
    console.log("Server started on port 8000");
}); 