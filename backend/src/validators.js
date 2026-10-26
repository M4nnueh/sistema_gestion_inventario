function validateProducto(data, partial = false) {
  const errors = {};
  const required = ['nombre', 'codigo', 'precio', 'cantidad', 'categoria'];

  if (!partial) {
    for (const f of required) {
      if (data[f] === undefined || data[f] === null || String(data[f]).trim() === '') {
        errors[f] = `${f} es obligatorio`;
      }
    }
  }

  if (data.nombre !== undefined && String(data.nombre).trim() === '') errors.nombre = 'nombre no puede estar vacio';
  if (data.codigo !== undefined && String(data.codigo).trim() === '') errors.codigo = 'codigo no puede estar vacio';
  if (data.categoria !== undefined && String(data.categoria).trim() === '') errors.categoria = 'categoria no puede estar vacia';

  if (data.precio !== undefined) {
    const p = Number(data.precio);
    if (isNaN(p) || p < 0) errors.precio = 'precio debe ser un numero >= 0';
  }
  if (data.cantidad !== undefined) {
    const c = Number(data.cantidad);
    if (!Number.isInteger(c) || c < 0) errors.cantidad = 'cantidad debe ser un entero >= 0';
  }

  return { valid: Object.keys(errors).length === 0, errors };
}

module.exports = { validateProducto };