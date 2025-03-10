import express from "express";

const app = express();

// create rest api
app.get("/", (req, res) => {
    res.send("Welcome to Aerialib");
});

// start server
app.listen(8000, () => {
    console.log("Server started on port 8000");
}); 