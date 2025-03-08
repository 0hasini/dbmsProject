const bcrypt = require("bcrypt");
const mysql = require("mysql2/promise");

(async () => {
    try {
        const db = await mysql.createConnection({
            host: "localhost",
            user: "root",
            password: "Kandula@@019",
            database: "lawrecords"
        });

        console.log("Connected to the database.");

        // Fetch users
        const [users] = await db.execute("SELECT user_id, password_hash FROM users");

        for (let user of users) {
            // Log current password
            console.log(`User ${user.user_id} - Old Password: ${user.password_hash}`);

            // Check if already hashed
            if (user.password_hash.startsWith("$2b$")) {
                console.log(`User ${user.user_id} already has a hashed password. Skipping...`);
                continue;
            }

            // Hash the password
            const hashed = await bcrypt.hash(user.password_hash, 10);
            console.log(`User ${user.user_id} - New Hashed Password: ${hashed}`);

            // Update DB
            await db.execute("UPDATE users SET password_hash = ? WHERE user_id = ?", [hashed, user.user_id]);
            console.log(`User ${user.user_id} password updated.`);
        }

        console.log("Passwords updated successfully!");
        await db.end();
    } catch (error) {
        console.error("Error updating passwords:", error);
    }
})();
