const express = require("express");
const router = express.Router();
const db = require("./db");

// ============================
// 🏠 Home route
// ============================
router.get("/", (req, res) => {
  res.send("🚀 API Inventaris Projek berjalan dengan baik!");
});

// ============================
// 🔹 CRUD INVENTARYPROJEK
// ============================

// GET semua data
router.get("/inventaryprojek", (req, res) => {
  db.query("SELECT * FROM inventaryprojek", (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal mengambil data" });
    res.json(result);
  });
});

// GET berdasarkan ID
router.get("/inventaryprojek/:id", (req, res) => {
  const { id } = req.params;
  db.query("SELECT * FROM inventaryprojek WHERE id = ?", [id], (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal mengambil data" });
    if (result.length === 0) return res.status(404).json({ message: "Data tidak ditemukan" });
    res.json(result[0]);
  });
});

// POST tambah data
router.post("/inventaryprojek", (req, res) => {
  const { item_barang, jenis, tipe, merk, ukuran, jumlah, lokasi } = req.body;
  if (!item_barang || !jenis || !tipe || !merk || !ukuran || !jumlah || !lokasi) {
    return res.status(400).json({ message: "⚠️ Semua field wajib diisi" });
  }

  const sql = `
    INSERT INTO inventaryprojek (item_barang, jenis, tipe, merk, ukuran, jumlah, lokasi)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;
  db.query(sql, [item_barang, jenis, tipe, merk, ukuran, jumlah, lokasi], (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal menambahkan data" });
    res.status(201).json({ message: "✅ Data inventaryprojek berhasil ditambahkan", id: result.insertId });
  });
});

// PUT update data
router.put("/inventaryprojek/:id", (req, res) => {
  const { id } = req.params;
  const { item_barang, jenis, tipe, merk, ukuran, jumlah, lokasi } = req.body;

  const sql = `
    UPDATE inventaryprojek
    SET item_barang=?, jenis=?, tipe=?, merk=?, ukuran=?, jumlah=?, lokasi=?
    WHERE id=?
  `;
  db.query(sql, [item_barang, jenis, tipe, merk, ukuran, jumlah, lokasi, id], (err) => {
    if (err) return res.status(500).json({ message: "Gagal mengupdate data" });
    res.json({ message: "✅ Data inventaryprojek berhasil diupdate" });
  });
});

// DELETE data
router.delete("/inventaryprojek/:id", (req, res) => {
  const { id } = req.params;
  db.query("DELETE FROM inventaryprojek WHERE id=?", [id], (err) => {
    if (err) return res.status(500).json({ message: "Gagal menghapus data" });
    res.json({ message: "🗑️ Data inventaryprojek berhasil dihapus" });
  });
});

module.exports = router;
