const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const db = require("./db");

// ===============================
// 🔑 LOGIN USER (USERNAME + PASSWORD)
// ===============================
router.post("/login", (req, res) => {
  console.log("📩 Request body diterima:", req.body);

  const { username, password } = req.body;

  // 🔍 Validasi input
  if (!username || !password) {
    return res.status(400).json({
      success: false,
      message: "Username dan password wajib diisi!"
    });
  }

  // 🔍 Cek username di database
  const query = "SELECT * FROM users WHERE username = ?";
  db.query(query, [username], async (err, results) => {
    if (err) {
      console.error("❌ Database error:", err);
      return res.status(500).json({
        success: false,
        message: "Terjadi kesalahan server."
      });
    }

    if (results.length === 0) {
      return res.status(401).json({
        success: false,
        message: "Username tidak ditemukan."
      });
    }

    const user = results[0];
    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
      return res.status(401).json({
        success: false,
        message: "Password salah."
      });
    }

    console.log("✅ Login berhasil:", user.username);

    const { password: _, ...safeUser } = user;

    res.json({
      success: true,
      message: "Login berhasil",
      user: safeUser,
    });
  });
});

module.exports = router;
