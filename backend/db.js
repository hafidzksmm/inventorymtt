// db.js
const mysql = require("mysql2");

// Buat koneksi ke database
const db = mysql.createConnection({
  host: "localhost",
  user: "root", // ganti sesuai user MySQL kamu
  password: "", // ganti kalau pakai password
  database: "mttech", // ganti sesuai nama database kamu
});

// Tes koneksi
db.connect((err) => {
  if (err) {
    console.error("❌ Gagal terhubung ke database:", err.message);
  } else {
    console.log("✅ Koneksi ke database berhasil!");
  }
});

// Jangan ubah query bawaan mysql2
module.exports = db;
