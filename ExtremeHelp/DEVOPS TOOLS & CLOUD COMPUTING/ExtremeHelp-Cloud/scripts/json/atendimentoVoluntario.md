# API - Atendimento Voluntário

## GET
**Endpoint** - localhost:8080/atendimento-voluntario

## GetById
**Endpoint** - localhost:8080/atendimento-voluntario/1

## POST
**Endpoint** - localhost:8080/atendimento-voluntario
````
{
  "dataAceite": "31/05/2025 09:00",
  "idPedidoAjuda": 4,
  "idUsuario": 1
}
````

## PUT
**Endpoint** - localhost:8080/atendimento-voluntario/1
````
{
  "dataAceite": "30/05/2025 10:30",
  "dataConclusao": "31/05/2025 18:55",
  "observacoes": "2 cestas básicas entregues para a família, pedido concluído!",
  "idPedidoAjuda": 4,
  "idUsuario": 1
}
````

## DELETE
**Endpoint** - localhost:8080/atendimento-voluntario/1