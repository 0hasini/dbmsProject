const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: "localhost",
    user: "",
    password: "",
    database: ""
});

db.connect((err) => {
    if (err) {
        console.error("Database connection failed:", err);
    } else {
        console.log("Connected to MySQL database");
    }
});

app.post("/login", (req, res) => {
    const { username, password } = req.body;

    const query = "SELECT * FROM users WHERE username = ?";
    db.query(query, [username], async (err, results) => {
        if (err) return res.status(500).json({ error: "Database error" });

        if (results.length === 0) {
            return res.status(401).json({ error: "User not found" });
        }

        const user = results[0];

        const passwordMatch = await bcrypt.compare(password, user.password_hash);
        if (!passwordMatch) {
            return res.status(401).json({ error: "Invalid password" });
        }

        res.status(200).json({ message: "Login successful", user_id: user.user_id });
    });
});

app.post("/signup", async (req, res) => {
    const { username, email, password, role } = req.body;
    if (!username || !email || !password || !role) return res.status(400).json({ message: "All fields required" });

    const hashedPassword = await bcrypt.hash(password, 10);

    db.query(`SELECT email FROM users WHERE email = '${email}'`, (err, result) => {
        if (result.length > 0) {
            return res.status(400).json({ message: "Email already exists" });
        }

        db.query(`INSERT INTO users (username, email, password_hash, role) VALUES ('${username}', '${email}', '${hashedPassword}', '${role}')`, (err, userResult) => {
            if (err) {
                return res.status(500).json({ message: "Database error" });
            }

            const userId = userResult.insertId;
            if (role === "Lawyer") {
                db.query(`INSERT INTO lawyers (lawyer_id, specialization, license_number) VALUES ('${userId}', 'General', 'Pending')`);
            } else {
                db.query(`INSERT INTO clients (user_id, phone_number, address) VALUES ('${userId}', 'Not Provided', 'Not Provided')`);
            }

            res.json({ message: "User registered successfully" });
        });
    });
});


app.listen(5000, () => {
    console.log("Server running on port 5000");
});
