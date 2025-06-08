# API - Pedido de Ajuda

## GET
**Endpoint** - localhost:8080/pedido-ajuda

## GetById
**Endpoint** - localhost:8080/pedido-ajuda/1

## POST
**Endpoint** - localhost:8080/pedido-ajuda
````
{
  "tipoAjuda": "Alimentação",
  "descricão": "Solicita cesta básica para família com 2 crianças",
  "latitude": -23.561234,
  "longitude": -46.655678,
  "endereco": "Rua das Laranjeiras, 150, São Paulo, SP",
  "dataPedido": "30/05/2025 09:43",
  "statusPedido": "PENDENTE",
  "idUsuario": 1 
}
````

## PUT
**Endpoint** - localhost:8080/pedido-ajuda/1
````
{
  "tipoAjuda": "Alimentação",
  "descricão": "Solicita cesta básica para família com 2 crianças",
  "latitude": -23.561234,
  "longitude": -46.655678,
  "endereco": "Rua das Laranjeiras, 150, São Paulo, SP",
  "dataPedido": "30/05/2025 09:43",
  "statusPedido": "EM_ATENDIMENTO",
  "idUsuario": 1 
}
````

## DELETE
**Endpoint** - localhost:8080/pedido-ajuda/1