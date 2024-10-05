// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StarknetMessaging {
    // Constantes para mensagens
    uint256 constant MAX_L1_MSG_FEE = 1 ether;
    uint256 constant CANCELLATION_DELAY = 1 days;

    // Estrutura para armazenar mensagens
    struct Message {
        address sender;
        bytes32 payloadHash;
        uint256 timestamp;
        bool consumed;
    }

    // Mapeamento de mensagens L1 -> L2
    mapping(bytes32 => Message) public l1ToL2Messages;

    // Mapeamento de mensagens L2 -> L1
    mapping(bytes32 => Message) public l2ToL1Messages;

    // Eventos para notificar mudanças
    event L1MessageSent(address indexed sender, bytes32 indexed messageHash, uint256 timestamp);
    event L2MessageConsumed(bytes32 indexed messageHash);
    event L1MessageCancelled(bytes32 indexed messageHash);

    // Função para enviar uma mensagem L1 -> L2
    function sendMessageToL2(bytes32 payloadHash, uint256 fee) external payable {
        // Verificar se o valor pago é suficiente
        require(msg.value >= fee, "Valor pago insuficiente");

        // Verificar se o valor pago não excede o máximo permitido
        require(fee <= MAX_L1_MSG_FEE, "Valor pago excede o máximo permitido");

        bytes32 messageHash = keccak256(abi.encode(msg.sender, payloadHash, block.timestamp));

        // Armazenar a mensagem
        l1ToL2Messages[messageHash] = Message({
            sender: msg.sender,
            payloadHash: payloadHash,
            timestamp: block.timestamp,
            consumed: false
        });

        emit L1MessageSent(msg.sender, messageHash, block.timestamp);
    }

    // Função para consumir uma mensagem L2 -> L1
    function consumeMessageL2ToL1(bytes32 messageHash) external {
        // Verificar se a mensagem existe
        require(l2ToL1Messages[messageHash].sender != address(0), "Mensagem não existe");

        // Verificar se a mensagem não foi consumida anteriormente
        require(!l2ToL1Messages[messageHash].consumed, "Mensagem já consumida");

        // Marcar a mensagem como consumida
        l2ToL1Messages[messageHash].consumed = true;

        emit L2MessageConsumed(messageHash);
    }

    // Função para cancelar uma mensagem L1 -> L2
    function cancelMessageL1ToL2(bytes32 messageHash) external {
        // Verificar se a mensagem existe
        require(l1ToL2Messages[messageHash].sender != address(0), "Mensagem não existe");

        // Verificar se a mensagem não foi consumida anteriormente
        require(!l1ToL2Messages[messageHash].consumed, "Mensagem já consumida");

        // Verificar se o tempo de cancelamento foi atingido
        require(block.timestamp >= l1ToL2Messages[messageHash].timestamp + CANCELLATION_DELAY, "Tempo de cancelamento não atingido");

        // Remover a mensagem
        delete l1ToL2Messages[messageHash];

        emit L1MessageCancelled(messageHash);
    }
}