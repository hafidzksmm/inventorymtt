const express = require('express');
const router = express.Router();
const db = require('../db');

// GET semua lokasi
router.get('/', (req, res) => {
  db.query('SELECT * FROM lokasi', (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// POST tambah lokasi
router.post('/', (req, res) => {
  const { nama_lokasi } = req.body;
  db.query('INSERT INTO lokasi (nama_lokasi) VALUES (?)', [nama_lokasi], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ id: result.insertId, nama_lokasi });
  });
});

module.exports = router;
