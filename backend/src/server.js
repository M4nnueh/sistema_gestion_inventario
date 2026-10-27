require('dotenv').config();
const express = require('express');
const cors = require('cors');
require('./db'); // init db + seed

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'API Inventario OK', version: '1.0.0' });
});

const productosRouter = require('./routes/productos');
app.use('/api/productos', productosRouter);

const PORT = process.env.PORT || 3000;
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`Servidor corriendo en http://0.0.0.0:${PORT}`);
  console.log(`Local: http://localhost:${PORT}`);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`El puerto ${PORT} ya esta en uso. Cierra el proceso anterior o cambia PORT en .env.`);
  } else {
    console.error('Error del servidor:', err);
  }
  process.exit(1);
});