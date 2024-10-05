// voting.js reformulado para compatibilidade com deploy no Vercel

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

// Endpoint para registrar um voto
app.post('/api/vote', (req, res) => {
  const { voterId, firstChoice, secondChoice } = req.body;

  if (!voterId || !firstChoice || !secondChoice) {
    return res.status(400).json({ error: 'Dados incompletos' });
  }

  // Verifica se o eleitor já votou
  if (votes[voterId]) {
    return res.status(400).json({ error: 'Eleitor já votou' });
  }

  // Registra o voto
  votes[voterId] = { firstChoice, secondChoice };
  res.json({ message: 'Voto registrado com sucesso!' });
});

// Inicia o servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});