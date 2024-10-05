// candidate-registration.js

const candidateForm = document.getElementById('candidateForm');
const candidateList = document.getElementById('candidateList');

let candidates = [];

// Função para atualizar a lista de candidatos na interface do usuário
function updateCandidateList() {
  candidateList.innerHTML = '';
  candidates.forEach((candidate, index) => {
    const listItem = document.createElement('li');
    listItem.textContent = `${candidate.name} (${candidate.affiliation})`;
    
    const deleteButton = document.createElement('button');
    deleteButton.textContent = 'Delete';
    deleteButton.onclick = () => {
      candidates.splice(index, 1);
      updateCandidateList();
    };
    
    listItem.appendChild(deleteButton);
    candidateList.appendChild(listItem);
  });
}

// Adiciona um novo candidato à lista
candidateForm.addEventListener('submit', (event) => {
  event.preventDefault();
  
  const nameInput = document.getElementById('name').value.trim();
  const affiliationInput = document.getElementById('affiliation').value.trim();

  if (nameInput && affiliationInput) {
    const newCandidate = {
      name: nameInput,
      affiliation: affiliationInput
    };
    
    candidates.push(newCandidate);
    updateCandidateList();

    document.getElementById('name').value = '';
    document.getElementById('affiliation').value = '';
  } else {
    alert('Por favor, preencha todos os campos!');
  }
});