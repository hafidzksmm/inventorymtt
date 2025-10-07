const express = require('express');
const router = express.Router();
const db = require('../db');

// GET semua jenis
router.get('/', (req, res) => {
  db.query(
    'SELECT j.*, i.nama_item FROM jenis j JOIN item_barang i ON j.item_id=i.id',
    (err, results) => {
      if (err) return res.status(500).send(err);
      res.json(results);
    }
  );
});

// POST tambah jenis
router.post('/', (req, res) => {
  const { item_id, nama_jenis } = req.body;
  db.query('INSERT INTO jenis (item_id, nama_jenis) VALUES (?, ?)', [item_id, nama_jenis], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ id: result.insertId, item_id, nama_jenis });
  });
});

module.exports = router;
