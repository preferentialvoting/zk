const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const app = express();

// Configurações do Express
app.use(bodyParser.json());
app.use(cors());

// Dados simulados de candidatos
const candidates = [
  { id: 1, name: 'Candidato A', affiliation: 'Partido 1' },
  { id: 2, name: 'Candidato B', affiliation: 'Partido 2' },
  { id: 3, name: 'Candidato C', affiliation: 'Partido 3' }
];

// Variável para armazenar votos
let votes = {};

// Endpoint para obter lista de candidatos
app.get('/api/candidates', (req, res) => {
  res.json(candidates);
});

// Exporta o app para uso no Vercel
module.exports = app;