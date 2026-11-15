const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const db = require('../db');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

const JWT_SECRET = process.env.JWT_SECRET || 'default_secret';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '24h';

// POST /api/auth/login
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email y contraseña son obligatorios.' });
  }

  const user = db.prepare('SELECT * FROM usuarios WHERE email = ?').get(email);

  if (!user) {
    return res.status(401).json({ message: 'Credenciales incorrectas.' });
  }

  const validPassword = bcrypt.compareSync(password, user.password);

  if (!validPassword) {
    return res.status(401).json({ message: 'Credenciales incorrectas.' });
  }

  const token = jwt.sign(
    { id: user.id, nombre: user.nombre, email: user.email },
    JWT_SECRET,
    { expiresIn: JWT_EXPIRES_IN }
  );

  res.json({
    message: 'Inicio de sesion exitoso',
    token,
    user: {
      id: user.id,
      nombre: user.nombre,
      email: user.email,
    },
  });
});

// GET /api/auth/profile - Ruta protegida para verificar token y obtener perfil
router.get('/profile', authenticateToken, (req, res) => {
  const user = db.prepare('SELECT id, nombre, email, created_at FROM usuarios WHERE id = ?').get(req.user.id);
  if (!user) {
    return res.status(404).json({ message: 'Usuario no encontrado.' });
  }
  res.json(user);
});

// POST /api/auth/verify - Verificar si un token es válido
router.post('/verify', authenticateToken, (req, res) => {
  res.json({ valid: true, user: req.user });
});

module.exports = router;
