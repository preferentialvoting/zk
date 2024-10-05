// dashboard.js

const apiEndpoint = '/api/results'; // Endpoint para obter os resultados

async function fetchResults() {
  try {
    const response = await fetch(apiEndpoint, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`Erro HTTP ${response.status}`);
    }

    const results = await response.json();
    return results;
  } catch (error) {
    console.error('Erro ao buscar resultados:', error);
    return []; // Retorna um array vazio para evitar erros adicionais
  }
}

const resultsTableBody = document.getElementById('resultsTableBody');

// Função para popular a tabela com os resultados
async function populateResults() {
  const results = await fetchResults();

  resultsTableBody.innerHTML = '';

  results.forEach((result) => {
    const row = document.createElement('tr');

    const candidateCell = document.createElement('td');
    candidateCell.textContent = result.candidate;
    row.appendChild(candidateCell);

    const votesCell = document.createElement('td');
    votesCell.textContent = result.votes;
    row.appendChild(votesCell);

    resultsTableBody.appendChild(row);
  });
}

// Chamar a função para popular a tabela ao carregar a página
populateResults();