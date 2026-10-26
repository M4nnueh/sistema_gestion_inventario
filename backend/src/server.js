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
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});