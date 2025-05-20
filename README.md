# Projeto Aplicado – Gestão de Peças e Manutenção

Este é o backend da aplicação desenvolvida para o Projeto Aplicado III do curso de Análise e Desenvolvimento de Sistemas do SENAI.

A solução busca automatizar e centralizar o controle de estoque de peças e ordens de serviço de manutenção.

---

## ✅ Funcionalidades já implementadas

* Cadastro e listagem de usuários
* Cadastro, listagem, atualização e exclusão de peças do estoque
* Registro de entrada e saída de peças

---

## 🔌 Endpoints da API

### 🧑‍💼 Usuários

#### `GET /usuarios`

Lista todos os usuários.

#### `POST /usuarios`

Cria um novo usuário.

**JSON de entrada:**

```json
{
  "nome": "Maria Souza",
  "email": "maria@example.com",
  "funcao": "Analista",
  "setor": "RH",
  "senha": "123456"
}
```

---

### 🔩 Estoque de Peças

#### `GET /estoque`

Lista todas as peças do estoque. Pode usar query params como:

```
/estoque?peca=parafuso&categoria=fixação
```

#### `POST /estoque`

Cadastra uma nova peça.

**JSON de entrada:**

```json
{
  "peca": "Parafuso M8",
  "qtd": 100,
  "categoria": "fixação"
}
```

#### `PUT /estoque/<id>`

Atualiza os dados de uma peça.

**JSON opcional (parcial ou total):**

```json
{
  "peca": "Parafuso M8",
  "qtd": 200,
  "categoria": "fixação pesada"
}
```

#### `DELETE /estoque/<id>`

Remove uma peça do estoque.

---

### 📦 Entrada/Saída de Peças

#### `POST /estoque/entrada`

Registra entrada de uma peça no estoque.

**JSON:**

```json
{
  "peca_id": 1,
  "quantidade": 50
}
```

#### `POST /estoque/saida`

Registra saída de uma peça no estoque.

**JSON:**

```json
{
  "peca_id": 1,
  "quantidade": 20
}
```

---

## 💾 Requisitos

* Python 3.9
* Flask 3.1.0
* PostgreSQL
* Docker + Docker Compose

---

## 🚀 Como subir a aplicação com Docker

```bash
docker compose up --build
```

A API estará disponível em: [http://localhost:5000](http://localhost:5000)

---

## 🗃️ Banco de Dados

O banco de dados PostgreSQL é iniciado automaticamente pelo Docker e usa as variáveis do `.env` para configurar usuário, senha e nome do banco.

---

## 📂 Organização

* `app/models/models.py` – modelos do SQLAlchemy
* `app/routes/routes.py` – rotas da API
* `app/utils/json_response.py` – utilitário para retorno com UTF-8
* `app.py` – inicializador da aplicação
* `docker-compose.yml` – configuração dos containers

---
