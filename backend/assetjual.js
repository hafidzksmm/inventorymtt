const multer = require("multer");
const xlsx = require("xlsx");
const path = require("path");
const fs = require("fs");
const express = require("express");
const router = express.Router();
const db = require("./db");

// Konfigurasi upload
const upload = multer({ dest: "uploads/" });
// ============================
// 🏠 Home route
// ============================
router.get("/", (req, res) => {
  res.send("🚀 API asset_jual WS berjalan dengan baik!");
});

router.get("/lokasi", (req, res) => {
  const query = "SELECT DISTINCT lokasi FROM asset_jual WHERE lokasi IS NOT NULL";
  db.query(query, (err, result) => {
    if (err) return res.status(500).json({ message: err.message });
    res.json(result);
  });
});
// ============================
// 🔍 FILTER DATA ASSET JUAL
// ============================
router.get("/filter", async (req, res) => {
  const { nama_barang, jenis, ukuran, dimensi } = req.query;

  let query = "SELECT * FROM assetjual WHERE 1=1";
  const params = [];

  if (nama_barang) {
    query += " AND nama_barang = ?";
    params.push(nama_barang);
  }
  if (jenis) {
    query += " AND jenis = ?";
    params.push(jenis);
  }
  if (ukuran) {
    query += " AND ukuran = ?";
    params.push(ukuran);
  }
  if (dimensi) {
    query += " AND dimensi = ?";
    params.push(dimensi);
  }

  try {
    const [rows] = await db.query(query, params);
    res.json(rows);
  } catch (err) {
    console.error("❌ Gagal memfilter data:", err);
    res.status(500).json({ message: "Gagal memfilter data" });
  }
});

// ============================
// 🔹 CRUD assetjual
// ============================

// GET semua data assetjual
router.get("/assetjual", (req, res) => {
  db.query("SELECT * FROM asset_jual", (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal ambil data assetjual" });
    res.json(result);
  });
});

// GET berdasarkan ID
router.get("/assetjual/:id", (req, res) => {
  const { id } = req.params;
  db.query("SELECT * FROM asset_jual WHERE id = ?", [id], (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal ambil data" });
    if (result.length === 0) return res.status(404).json({ message: "Data tidak ditemukan" });
    res.json(result[0]);
  });
});

// POST tambah data
router.post("/assetjual", (req, res) => {
  const {nama_barang, jenis, ukuran, dimensi, qty, satuan, lokasi} = req.body;
  if (!nama_barang || !jenis || !ukuran || !dimensi || !qty || !satuan || !lokasi) {
    return res.status(400).json({ message: "⚠️ Semua field harus diisi!" });
  }

  const sql = `
    INSERT INTO asset_jual (nama_barang, jenis, ukuran, dimensi, qty, satuan, lokasi)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;
  db.query(sql, [nama_barang, jenis, ukuran, dimensi, qty, satuan, lokasi], (err, result) => {
    if (err) return res.status(500).json({ message: "Gagal menambahkan data assetjual" });
    res.status(201).json({ message: "✅ Data assetjual berhasil ditambahkan!", id: result.insertId });
  });
});

// PUT update data
router.put("/assetjual/:id", (req, res) => {
  const { id } = req.params;
  const { nama_barang, jenis, ukuran, dimensi, qty, satuan, lokasi } = req.body;

  const sql = `
    UPDATE asset_jual
    SET nama_barang=?, jenis=?, ukuran=?, dimensi=?, qty=?, satuan=?, lokasi=?
    WHERE id=?
  `;
  db.query(sql, [nama_barang, jenis, ukuran, dimensi, qty, satuan, lokasi, id], (err) => {
    if (err) return res.status(500).json({ message: "Gagal memperbarui data assetjual" });
    res.json({ message: "✅ Data asset jual berhasil diperbarui!" });
  });
});

// DELETE hapus data
router.delete("/assetjual/:id", (req, res) => {
  const { id } = req.params;
  db.query("DELETE FROM asset_jual WHERE id=?", [id], (err) => {
    if (err) return res.status(500).json({ message: "Gagal menghapus data assetjual" });
    res.json({ message: "🗑️ Data assetjual berhasil dihapus!" });
  });
});

// =======================================
// 📥 IMPORT DATA DARI EXCEL (BARU)
// =======================================
// Import Excel ke database
router.post("/assetjual/import", (req, res) => {
  const data = req.body;

  if (!Array.isArray(data) || data.length === 0) {
    return res.status(400).json({ message: "Data tidak valid" });
  }

  const values = data.map(item => [
    item.nama_barang || "",
    item.jenis || "",
    item.ukuran || "",
    item.dimensi || "",
    item.satuan || "",
    item.qty || 0,
    item.lokasi || ""
  ]);

  const sql = `
    INSERT INTO asset_jual (nama_barang, jenis, ukuran, dimensi,satuan, qty, lokasi)
    VALUES ?
  `;

  db.query(sql, [values], (err, result) => {
    if (err) {
      console.error("Error inserting data:", err);
      return res.status(500).json({ message: "Gagal menyimpan ke database" });
    }
    res.json({ message: "Import berhasil", inserted: result.affectedRows });
  });
});



module.exports = router;
