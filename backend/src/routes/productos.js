const express = require('express');
const db = require('../db');
const { validateProducto } = require('../validators');

const router = express.Router();

router.get('/', (req, res) => {
  const rows = db.prepare('SELECT * FROM productos ORDER BY id ASC').all();
  res.json(rows);
});

router.get('/:id', (req, res) => {
  const id = Number(req.params.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: 'id invalido' });
  const row = db.prepare('SELECT * FROM productos WHERE id = ?').get(id);
  if (!row) return res.status(404).json({ message: 'Producto no encontrado' });
  res.json(row);
});

router.post('/', (req, res) => {
  const { valid, errors } = validateProducto(req.body);
  if (!valid) return res.status(422).json({ message: 'Validacion fallida', errors });

  const { nombre, codigo, descripcion, precio, cantidad, categoria } = req.body;
  try {
    const stmt = db.prepare(`INSERT INTO productos (nombre, codigo, descripcion, precio, cantidad, categoria)
      VALUES (?, ?, ?, ?, ?, ?)`);
    const info = stmt.run(nombre.trim(), codigo.trim(), descripcion ? descripcion.trim() : null, Number(precio), Number(cantidad), categoria.trim());
    const created = db.prepare('SELECT * FROM productos WHERE id = ?').get(info.lastInsertRowid);
    res.status(201).json(created);
  } catch (e) {
    if (String(e.message).toLowerCase().includes('unique constraint')) {
      return res.status(409).json({ message: 'El codigo ya existe', errors: { codigo: 'codigo duplicado' } });
    }
    console.error(e);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
});

router.put('/:id', (req, res) => {
  const id = Number(req.params.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: 'id invalido' });
  const existing = db.prepare('SELECT * FROM productos WHERE id = ?').get(id);
  if (!existing) return res.status(404).json({ message: 'Producto no encontrado' });

  const { valid, errors } = validateProducto(req.body, true);
  if (!valid) return res.status(422).json({ message: 'Validacion fallida', errors });

  const nombre = req.body.nombre !== undefined ? req.body.nombre.trim() : existing.nombre;
  const codigo = req.body.codigo !== undefined ? req.body.codigo.trim() : existing.codigo;
  const descripcion = req.body.descripcion !== undefined ? (req.body.descripcion ? req.body.descripcion.trim() : null) : existing.descripcion;
  const precio = req.body.precio !== undefined ? Number(req.body.precio) : existing.precio;
  const cantidad = req.body.cantidad !== undefined ? Number(req.body.cantidad) : existing.cantidad;
  const categoria = req.body.categoria !== undefined ? req.body.categoria.trim() : existing.categoria;

  try {
    db.prepare(`UPDATE productos SET nombre=?, codigo=?, descripcion=?, precio=?, cantidad=?, categoria=?, updated_at=datetime('now') WHERE id=?`)
      .run(nombre, codigo, descripcion, precio, cantidad, categoria, id);
    const updated = db.prepare('SELECT * FROM productos WHERE id = ?').get(id);
    res.json(updated);
  } catch (e) {
    if (String(e.message).toLowerCase().includes('unique constraint')) {
      return res.status(409).json({ message: 'El codigo ya existe', errors: { codigo: 'codigo duplicado' } });
    }
    console.error(e);
    res.status(500).json({ message: 'Error interno del servidor' });
  }
});

router.delete('/:id', (req, res) => {
  const id = Number(req.params.id);
  if (!Number.isInteger(id)) return res.status(400).json({ message: 'id invalido' });
  const info = db.prepare('DELETE FROM productos WHERE id = ?').run(id);
  if (info.changes === 0) return res.status(404).json({ message: 'Producto no encontrado' });
  res.status(204).send();
});

module.exports = router;