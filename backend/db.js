const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",       // sesuaikan
  database: "mttech", // sesuaikan
});

db.connect((err) => {
  if (err) {
    console.error("❌ Koneksi database gagal:", err);
  } else {
    console.log("✅ Terhubung ke database MySQL");
  }
});

module.exports = db;
