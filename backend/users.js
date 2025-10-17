const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const db = require("./db");

const SECRET_KEY = "rahasia-super-aman"; // ganti dengan process.env.JWT_SECRET di production

// 🧱 Simpan token yang di-blacklist (misalnya saat logout)
let tokenBlacklist = [];

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
    if (err) return res.status(500).json({ message: "Terjadi kesalahan server." });

    if (results.length > 0) {
      return res.status(400).json({ message: "Email sudah digunakan!" });
    }

    try {
      const hashedPassword = await bcrypt.hash(password, 10);
      const insertQuery =
        "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
      db.query(insertQuery, [username, email, hashedPassword, "user"], (err2) => {
        if (err2) return res.status(500).json({ message: "Gagal menambahkan user." });
        res.status(201).json({ message: "Registrasi berhasil!" });
      });
    } catch (hashErr) {
      res.status(500).json({ message: "Gagal memproses password." });
    }
  });
});

// ===============================
// 🔑 LOGIN USER
// ===============================
router.post("/login", (req, res) => {
  const { username, password } = req.body;
  console.log("📩 Data login diterima:", req.body);

  if (!username || !password) {
    return res.status(400).json({ message: "Username dan password wajib diisi!" });
  }

  const query = "SELECT * FROM users WHERE username = ?";
  db.query(query, [username], async (err, results) => {
    if (err) return res.status(500).json({ message: "Terjadi kesalahan server." });

    if (results.length === 0) {
      return res.status(401).json({ message: "Username tidak ditemukan." });
    }

    const user = results[0];
    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
      return res.status(401).json({ message: "Password salah." });
    }

    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      SECRET_KEY,
      { expiresIn: "1h" } // timeout 1 jam
    );

    console.log("✅ Login berhasil:", user.username);
    res.json({
      message: "Login berhasil",
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
      },
    });
  });
});

// ===============================
// 🔒 MIDDLEWARE CEK TOKEN
// ===============================
function verifyToken(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).json({ message: "Token tidak ditemukan" });

  const token = authHeader.split(" ")[1];

  // Cek apakah token sudah di-blacklist
  if (tokenBlacklist.includes(token)) {
    return res.status(401).json({ message: "Sesi sudah berakhir, silakan login lagi." });
  }

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({ message: "Token tidak valid atau sudah expired" });
    }

    req.user = user; // simpan user ke req
    next();
  });
}

// ===============================
// 🔒 CEK TOKEN VALID
// ===============================
router.get("/check-token", verifyToken, (req, res) => {
  res.json({ valid: true, user: req.user });
});

// ===============================
// 🚪 LOGOUT (End Session)
// ===============================
router.post("/logout", (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(400).json({ message: "Token tidak ditemukan." });

  const token = authHeader.split(" ")[1];
  tokenBlacklist.push(token); // blacklist token ini

  // Opsional: otomatis hapus dari blacklist setelah expired
  const decoded = jwt.decode(token);
  if (decoded && decoded.exp) {
    const timeUntilExpire = decoded.exp * 1000 - Date.now();
    if (timeUntilExpire > 0) {
      setTimeout(() => {
        tokenBlacklist = tokenBlacklist.filter((t) => t !== token);
      }, timeUntilExpire);
    }
  }

  res.json({ message: "Logout berhasil, sesi telah berakhir." });
});

module.exports = router;
