const { DatabaseSync } = require('node:sqlite');
const path = require('path');
const fs = require('fs');

const dbPath = process.env.DB_PATH || './data/inventario.db';
const resolved = path.resolve(__dirname, '..', dbPath);
const dir = path.dirname(resolved);
if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });

const db = new DatabaseSync(resolved);
try { db.exec('PRAGMA journal_mode = WAL'); } catch (e) { /* ignore */ }
db.exec(`
CREATE TABLE IF NOT EXISTS productos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre TEXT NOT NULL,
  codigo TEXT NOT NULL UNIQUE,
  descripcion TEXT,
  precio REAL NOT NULL CHECK (precio >= 0),
  cantidad INTEGER NOT NULL CHECK (cantidad >= 0),
  categoria TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);
`);

const seedProducts = [
  { nombre: 'Laptop HP 15', codigo: 'LAP-001', descripcion: 'Laptop 15 pulgadas 8GB RAM', precio: 2500000, cantidad: 10, categoria: 'Computadores' },
  { nombre: 'Mouse Logitech', codigo: 'MOU-002', descripcion: 'Mouse inalambrico', precio: 80000, cantidad: 50, categoria: 'Perifericos' },
  { nombre: 'Teclado Mecanico', codigo: 'TEC-003', descripcion: 'Teclado RGB', precio: 150000, cantidad: 25, categoria: 'Perifericos' },
  { nombre: 'Monitor 24"', codigo: 'MON-004', descripcion: 'Monitor Full HD', precio: 600000, cantidad: 15, categoria: 'Monitores' },
  { nombre: 'Impresora Epson', codigo: 'IMP-005', descripcion: 'Impresora multifuncional', precio: 450000, cantidad: 8, categoria: 'Impresoras' },
  { nombre: 'Disco SSD 1TB', codigo: 'SSD-006', descripcion: 'Unidad de estado solido', precio: 220000, cantidad: 30, categoria: 'Almacenamiento' },
  { nombre: 'Memoria RAM 16GB', codigo: 'RAM-007', descripcion: 'DDR4 3200MHz', precio: 180000, cantidad: 40, categoria: 'Componentes' },
  { nombre: 'Webcam HD', codigo: 'WEB-008', descripcion: 'Camara 1080p', precio: 120000, cantidad: 20, categoria: 'Perifericos' },
  { nombre: 'Router WiFi', codigo: 'ROU-009', descripcion: 'Router doble banda', precio: 160000, cantidad: 12, categoria: 'Redes' },
  { nombre: 'Cable HDMI 2m', codigo: 'CAB-010', descripcion: 'Cable HDMI alta velocidad', precio: 25000, cantidad: 100, categoria: 'Accesorios' }
];

const count = db.prepare('SELECT COUNT(*) as c FROM productos').get().c;
if (count === 0) {
  const insert = db.prepare(`INSERT INTO productos (nombre, codigo, descripcion, precio, cantidad, categoria)
    VALUES (?, ?, ?, ?, ?, ?)`);
  db.exec('BEGIN');
  try {
    for (const r of seedProducts) {
      insert.run(r.nombre, r.codigo, r.descripcion, r.precio, r.cantidad, r.categoria);
    }
    db.exec('COMMIT');
    console.log('Seed: 10 productos insertados');
  } catch (e) {
    db.exec('ROLLBACK');
    throw e;
  }
}

module.exports = db;