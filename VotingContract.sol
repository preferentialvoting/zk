// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    // Estrutura para armazenar informações de candidatos
    struct Candidate {
        string name;
        string affiliation;
        uint256 votes;
        bool exists;
    }

    // Mapeamento de candidatos
    mapping(uint256 => Candidate) public candidates;

    // Contador de candidatos
    uint256 public candidateCount;

    // Mapeamento para rastrear se o eleitor já votou
    mapping(address => bool) public hasVoted;

    // Eventos para notificar mudanças
    event CandidateRegistered(uint256 candidateId, string name, string affiliation);
    event VoteCast(address voter, uint256 candidateId);

    // Função para registrar um novo candidato
    function registerCandidate(string memory _name, string memory _affiliation) public {
        candidateCount++;
        candidates[candidateCount] = Candidate({
            name: _name,
            affiliation: _affiliation,
            votes: 0,
            exists: true
        });
        
        emit CandidateRegistered(candidateCount, _name, _affiliation);
    }

    // Função para votar em um candidato
    function vote(uint256 _candidateId) public {
        // Verificar se o eleitor já votou
        require(!hasVoted[msg.sender], "Você já votou");

        // Verificar se o candidato existe
        require(candidates[_candidateId].exists, "Candidato não existe");

        // Incrementar o número de votos do candidato
        candidates[_candidateId].votes++;

        // Marcar o eleitor como tendo votado
        hasVoted[msg.sender] = true;

        emit VoteCast(msg.sender, _candidateId);
    }

    // Função para obter o número de votos de um candidato
    function getVotes(uint256 _candidateId) public view returns (uint256) {
        // Verificar se o candidato existe
        require(candidates[_candidateId].exists, "Candidato não existe");

        return candidates[_candidateId].votes;
    }

    // Função para listar todos os candidatos
    function getAllCandidates() public view returns (Candidate[] memory) {
        Candidate[] memory candidateArray = new Candidate[](candidateCount);

        for (uint256 i = 1; i <= candidateCount; i++) {
            candidateArray[i - 1] = candidates[i];
        }

        return candidateArray;
    }
}