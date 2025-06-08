# API - Alerta

## GET
**Endpoint** - localhost:8080/alerta

## GetById
**Endpoint** - localhost:8080/alerta/1

## POST
**Endpoint** - localhost:8080/alerta
````
{
  "titulo": "Alerta de ventos fortes",
  "mensagem": "Ráfagas de vento de até 90 km/h são esperadas nas próximas 24 horas. Evite áreas abertas e mantenha janelas fechadas.",
  "dataPublicacao": "21/05/2025 07:45",
  "seriedadeAlerta": "MODERADO",
  "fonte": "Climatempo",
  "ativo": true
}
````

## PUT
**Endpoint** - localhost:8080/alerta/1
````
{
  "titulo": "Alerta de ventos fortes",
  "mensagem": "Ráfagas de vento de até 90 km/h são esperadas nas próximas 24 horas. Evite áreas abertas e mantenha janelas fechadas.",
  "dataPublicacao": "22/05/2025 07:45",
  "seriedadeAlerta": "MODERADO",
  "fonte": "Climatempo",
  "ativo": false
}
````

## DELETE
**Endpoint** - localhost:8080/alerta/1