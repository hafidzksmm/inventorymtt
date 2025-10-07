const express = require('express');
const router = express.Router();
const db = require('../db');

// GET semua item_barang
router.get('/', (req, res) => {
  db.query('SELECT * FROM item_barang', (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// POST tambah item_barang
router.post('/', (req, res) => {
  const { nama_item } = req.body;
  db.query('INSERT INTO item_barang (nama_item) VALUES (?)', [nama_item], (err, result) => {
    if (err) return res.status(500).send(err);
    res.json({ id: result.insertId, nama_item });
  });
});

// PUT update item_barang
router.put('/:id', (req, res) => {
  const { id } = req.params;
  const { nama_item } = req.body;
  db.query('UPDATE item_barang SET nama_item=? WHERE id=?', [nama_item, id], err => {
    if (err) return res.status(500).send(err);
    res.json({ message: 'Item barang updated' });
  });
});

// DELETE item_barang
router.delete('/:id', (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM item_barang WHERE id=?', [id], err => {
    if (err) return res.status(500).send(err);
    res.json({ message: 'Item barang deleted' });
  });
});

module.exports = router;
