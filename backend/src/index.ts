import express from "express";

// Load values from .env file
import 'dotenv/config'

const app = express(); // TODO should this be let instaed of const

// create rest api
app.get("/", (req, res) => {
    res.send("Welcome to Aerialib :DDDD");
});

// start server
app.listen(8000, () => {
    console.log("Server started on port 8000");
}); 