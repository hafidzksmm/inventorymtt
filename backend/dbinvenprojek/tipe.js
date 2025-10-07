const express = require('express');
const router = express.Router();
const db = require('../db');

// GET semua tipe
router.get('/', (req, res) => {
  db.query('SELECT t.*, j.nama_jenis FROM tipe t JOIN jenis j ON t.jenis_id=j.id', (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// POST tambah tipe
router.post('/', (req, res) => {
  const { jenis_id, nama_tipe } = req.body;
  db.query('INSERT INTO tipe (jenis_id, nama_tipe) VALUES (?, ?)', [jenis_id, nama_tipe], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ id: result.insertId, jenis_id, nama_tipe });
  });
});

module.exports = router;
