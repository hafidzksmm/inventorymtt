const express = require("express");
const router = express.Router();
const db = require("./db");

// ============================
// 🏠 Home route
// ============================
router.get("/", (req, res) => {
  res.send("🚀 API Inventaris WS berjalan dengan baik!");
});

// ============================
// 🔹 CRUD INVENTARIS
// ============================

// GET semua data inventaris
router.get("/inventaris", (req, res) => {
  db.query("SELECT * FROM inventaris", (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal ambil data inventaris" });
    res.json(result);
  });
});

// GET berdasarkan ID
router.get("/inventaris/:id", (req, res) => {
  const { id } = req.params;
  db.query("SELECT * FROM inventaris WHERE id = ?", [id], (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal ambil data" });
    if (result.length === 0) return res.status(404).json({ message: "Data tidak ditemukan" });
    res.json(result[0]);
  });
});

// POST tambah data
router.post("/inventaris", (req, res) => {
  const { nama_barang, merk, deskripsi, dimensi, qty, satuan, lokasi } = req.body;
  if (!nama_barang || !merk || !deskripsi || !dimensi || !qty || !satuan || !lokasi) {
    return res.status(400).json({ message: "⚠️ Semua field harus diisi!" });
  }

  const sql = `
    INSERT INTO inventaris (nama_barang, merk, deskripsi, dimensi, qty, satuan, lokasi)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;
  db.query(sql, [nama_barang, merk, deskripsi, dimensi, qty, satuan, lokasi], (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal menambahkan data inventaris" });
    res.status(201).json({ message: "✅ Data inventaris berhasil ditambahkan!", id: result.insertId });
  });
});

// PUT update data
router.put("/inventaris/:id", (req, res) => {
  const { id } = req.params;
  const { nama_barang, merk, deskripsi, dimensi, qty, satuan, lokasi } = req.body;

  const sql = `
    UPDATE inventaris
    SET nama_barang=?, merk=?, deskripsi=?, dimensi=?, qty=?, satuan=?, lokasi=?
    WHERE id=?
  `;
  db.query(sql, [nama_barang, merk, deskripsi, dimensi, qty, satuan, lokasi, id], (err) => {
    if (err) return res.status(500).json({ message: "Gagal memperbarui data inventaris" });
    res.json({ message: "✅ Data inventaris berhasil diperbarui!" });
  });
});

// DELETE hapus data
router.delete("/inventaris/:id", (req, res) => {
  const { id } = req.params;
  db.query("DELETE FROM inventaris WHERE id=?", [id], (err) => {
    if (err) return res.status(500).json({ message: "Gagal menghapus data inventaris" });
    res.json({ message: "🗑️ Data inventaris berhasil dihapus!" });
  });
});

module.exports = router;
