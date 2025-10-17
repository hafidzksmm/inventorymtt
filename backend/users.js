const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const db = require("./db");

// ===============================
// 🧩 REGISTER USER
// ===============================
router.post("/register", (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return res.status(400).json({ message: "Semua field wajib diisi!" });
  }

  const checkQuery = "SELECT * FROM users WHERE email = ?";
  db.query(checkQuery, [email], async (err, results) => {
    if (err) {
      console.error("❌ Error cek email:", err);
      return res.status(500).json({ message: "Terjadi kesalahan server." });
    }

    if (results.length > 0) {
      return res.status(400).json({ message: "Email sudah digunakan!" });
    }

    try {
      const hashedPassword = await bcrypt.hash(password, 10);

      const insertQuery =
        "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
      db.query(insertQuery, [username, email, hashedPassword], (err2) => {
        if (err2) {
          console.error("❌ Error insert user:", err2);
          return res.status(500).json({ message: "Gagal menambahkan user." });
        }

        res.status(201).json({ message: "Registrasi berhasil!" });
      });
    } catch (hashErr) {
      console.error("❌ Error hashing password:", hashErr);
      res.status(500).json({ message: "Gagal memproses password." });
    }
  });
});

// ===============================
// 🔑 LOGIN USER (USERNAME + PASSWORD)
// ===============================
router.post("/login", (req, res) => {
  const { username, password } = req.body;
  console.log("📩 Data login diterima:", req.body);

  if (!username || !password) {
    return res.status(400).json({ message: "Username dan password wajib diisi!" });
  }

  const query = "SELECT * FROM users WHERE username = ?";
  db.query(query, [username], async (err, results) => {
    if (err) {
      console.error("❌ Database error:", err);
      return res.status(500).json({ message: "Terjadi kesalahan server." });
    }

    if (results.length === 0) {
      return res.status(401).json({ message: "Username tidak ditemukan." });
    }

    const user = results[0];
    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
      return res.status(401).json({ message: "Password salah." });
    }

    console.log("✅ Login berhasil:", user.username);
    res.json({ message: "Login berhasil", user });
  });
});

module.exports = router;
