# Backend - Sistema de Gestão de Peças e Manutenção

## Visão Geral

Backend desenvolvido em Flask para gerenciar estoque de peças, ordens de serviço, usuários e notificações de reposição. A aplicação utiliza PostgreSQL como banco de dados e está hospedada no Render.

**URL da API:** `http://localhost:5000`

---

## Tecnologias Utilizadas

- **Python** 3.9+
- **Flask** 3.1.0 - Framework web
- **Flask-SQLAlchemy** - ORM para banco de dados
- **PostgreSQL** - Banco de dados relacional
- **Flask-CORS** - Gerenciamento de CORS
- **Werkzeug** - Hash de senhas
- **python-dotenv** - Variáveis de ambiente
- **Docker** - Containerização
- **Gunicorn** - Servidor WSGI para produção

---

## Estrutura do Projeto

```
backend/
├── app/
│   ├── __init__.py           # Inicialização da aplicação Flask
│   ├── models/
│   │   ├── __init__.py
│   │   └── models.py         # Modelos do banco de dados
│   ├── routes/
│   │   └── routes.py         # Definição de todas as rotas da API
│   ├── services/
│   │   ├── login.py          # Lógica de autenticação
│   │   ├── usuario.py        # CRUD de usuários
│   │   ├── peca.py           # CRUD de peças/estoque
│   │   ├── ordem_servico.py  # CRUD de ordens de serviço
│   │   ├── alertas.py        # Alertas de reposição
│   │   └── notificacoes_estoque.py  # Notificações de estoque baixo
│   └── utils/
│       └── json_response.py  # Utilitário para respostas JSON
├── .env                      # Variáveis de ambiente
├── requirements.txt          # Dependências Python
├── wsgi.py                   # Entry point para produção
├── Dockerfile                # Configuração Docker
└── wait-for-db.sh           # Script de espera do banco

```

---

## Modelos de Dados

### 1. Usuario
```python
{
  "id": int,
  "nome": string,
  "email": string (único),
  "funcao": string,
  "setor": string,
  "senha_hash": string (não retornado pela API)
}
```

### 2. Peca
```python
{
  "id": int,
  "nome": string,
  "categoria": string
}
```

### 3. Estoque
```python
{
  "id": int,
  "peca": string,           # Nome da peça
  "categoria": string,
  "qtd": int,              # Quantidade atual
  "qtd_min": int           # Quantidade mínima (alerta)
}
```

### 4. OrdemServico
```python
{
  "id": int,
  "tipo": string,
  "setor": string,
  "data": datetime,
  "recorrencia": string,
  "detalhes": string (opcional),
  "status": string,
  "equipamento": {...} (opcional),  # Objeto Estoque
  "solicitante": {...}              # Objeto Usuario
}
```

### 5. Pecas_Ordem_Servico
Tabela de associação entre Ordens de Serviço e Peças utilizadas:
```python
{
  "os_id": int,
  "peca_id": int,
  "quantidade": int
}
```

---

## Endpoints da API

### Autenticação

#### POST `/login`
Autentica um usuário no sistema.

**Request Body:**
```json
{
  "usuario": "email@exemplo.com",
  "senha": "senha123"
}
```

**Response (200):**
```json
{
  "id": 1,
  "nome": "João Silva",
  "email": "email@exemplo.com",
  "funcao": "Técnico",
  "setor": "Manutenção"
}
```

**Response (401):**
```json
{
  "erro": "Usuário não encontrado"
}
```

---

### Usuários

#### GET `/usuarios`
Lista todos os usuários cadastrados.

**Response (200):**
```json
[
  {
    "id": 1,
    "nome": "João Silva",
    "email": "joao@exemplo.com",
    "funcao": "Técnico",
    "setor": "Manutenção"
  }
]
```

#### POST `/usuarios`
Cadastra um novo usuário.

**Request Body:**
```json
{
  "nome": "Maria Santos",
  "email": "maria@exemplo.com",
  "funcao": "Gerente",
  "setor": "Produção",
  "senha": "senha123"
}
```

**Response (201):**
```json
{
  "id": 2,
  "nome": "Maria Santos",
  "email": "maria@exemplo.com",
  "funcao": "Gerente",
  "setor": "Produção"
}
```

**Response (400):**
```json
{
  "erro": "Email já cadastrado."
}
```

#### PUT `/usuarios/<id>`
Atualiza dados de um usuário existente.

**Request Body:**
```json
{
  "nome": "Maria Santos Silva",
  "funcao": "Diretora"
}
```

**Response (200):**
```json
{
  "mensagem": "Usuário atualizado com sucesso!"
}
```

#### DELETE `/usuarios/<id>`
Remove um usuário do sistema.

**Response (200):**
```json
{
  "mensagem": "Usuário excluído com sucesso!"
}
```

---

### Peças / Estoque

#### GET `/peca`
Lista todas as peças e seus estoques.

**Response (200):**
```json
[
  {
    "id": 1,
    "peca": "Rolamento 6200",
    "categoria": "Rolamentos",
    "qtd": 50,
    "qtd_min": 10
  }
]
```

#### POST `/peca`
Cadastra uma nova peça no estoque.

**Request Body:**
```json
{
  "nome": "Correia V",
  "categoria": "Correias",
  "qtd": 30,
  "qtd_min": 5
}
```

**Response (201):**
```json
{
  "id": 2,
  "peca": "Correia V",
  "categoria": "Correias",
  "qtd": 30,
  "qtd_min": 5
}
```

**Response (400):**
```json
{
  "erro": "Peça já cadastrada"
}
```

#### PUT `/peca/<id>`
Atualiza informações de uma peça.

**Request Body:**
```json
{
  "qtd": 35,
  "qtd_min": 8
}
```

**Response (200):**
```json
{
  "mensagem": "Atualizado com sucesso"
}
```

#### DELETE `/peca/<id>`
Remove uma peça do estoque.

**Response (200):**
```json
{
  "mensagem": "Peça excluída com sucesso!"
}
```

---

### Ordens de Serviço

#### GET `/ordemservico`
Lista todas as ordens de serviço.

**Response (200):**
```json
[
  {
    "id": 1,
    "tipo": "Preventiva",
    "setor": "Produção",
    "recorrencia": "Mensal",
    "detalhes": "Manutenção do compressor",
    "status": "Pendente",
    "equipamento": {
      "id": 1,
      "peca": "Compressor XYZ",
      "categoria": "Equipamentos",
      "qtd": 1,
      "qtd_min": 1
    },
    "solicitante": {
      "id": 1,
      "nome": "João Silva",
      "email": "joao@exemplo.com",
      "funcao": "Técnico",
      "setor": "Manutenção"
    }
  }
]
```

#### POST `/ordemservico`
Cria uma nova ordem de serviço.

**Request Body:**
```json
{
  "tipo": "Corretiva",
  "setor": "Produção",
  "data": "2025-10-15T10:00:00",
  "recorrencia": "Única",
  "detalhes": "Reparo urgente",
  "status": "Pendente",
  "equipamento_id": 1,
  "solicitante_id": 1,
  "pecas_utilizadas": [
    {
      "peca_id": 2,
      "quantidade": 3
    }
  ]
}
```

**Response (201):**
```json
{
  "id": 2,
  "tipo": "Corretiva",
  "setor": "Produção",
  ...
}
```

#### PUT `/ordemservico/<id>`
Atualiza uma ordem de serviço existente.

**Request Body:**
```json
{
  "status": "Concluída",
  "detalhes": "Manutenção realizada com sucesso"
}
```

**Response (200):**
```json
{
  "mensagem": "Atualizado com sucesso"
}
```

#### DELETE `/ordemservico/<id>`
Remove uma ordem de serviço.

**Response (200):**
```json
{
  "mensagem": "Ordem excluída com sucesso"
}
```

---

### Alertas e Notificações

#### GET `/estoque/alertas`
Retorna peças com estoque abaixo do mínimo.

**Response (200):**
```json
[
  {
    "id": 3,
    "peca": "Filtro de Ar",
    "categoria": "Filtros",
    "qtd": 4,
    "qtd_min": 10
  }
]
```

#### GET `/notificacoes-estoque`
Retorna notificações de estoque baixo (implementação local/frontend).

---

## Configuração e Instalação

### Requisitos
- Python 3.9+
- PostgreSQL
- Docker e Docker Compose (opcional)

### Instalação Local

1. **Clone o repositório:**
```bash
git clone https://github.com/camilagalieta/projeto-aplicado.git
cd projeto-aplicado/backend
```

2. **Crie e ative o ambiente virtual:**
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# venv\Scripts\activate    # Windows
```

3. **Instale as dependências:**
```bash
pip install -r requirements.txt
```

4. **Configure o arquivo .env:**
```env
DATABASE_URL=postgresql://usuario:senha@localhost:5432/nome_banco
```

5. **Execute a aplicação:**
```bash
python3 app.py
```

A aplicação estará disponível em `http://localhost:5000`

### Usando Docker

```bash
docker-compose up --build
```

---

## Lógica de Negócios

### Autenticação
- Senhas são armazenadas com hash usando Werkzeug
- Login valida email e senha
- Retorna dados do usuário (sem senha)

### Gestão de Estoque
- Cada peça possui quantidade atual e quantidade mínima
- Sistema de alertas automático quando `qtd < qtd_min`
- Integração com ordens de serviço para controle de peças utilizadas

### Ordens de Serviço
- Tipos: Preventiva, Corretiva, Preditiva
- Status: Pendente, Em Andamento, Concluída, Cancelada
- Recorrência: Única, Diária, Semanal, Mensal, Anual
- Vínculo com equipamentos (estoque) e solicitante (usuário)
- Rastreamento de peças utilizadas em cada ordem

---

## Segurança

- Hash de senhas com Werkzeug
- CORS configurado para permitir acesso do frontend
- Validação de dados em todas as rotas
- Tratamento de erros com mensagens apropriadas

---

## Deploy

A aplicação está hospedada no Render com PostgreSQL gerenciado.

**URL de Produção:** `http://localhost:5000`

### Variáveis de Ambiente em Produção
```env
DATABASE_URL=postgresql://...
```

---

## Manutenção e Próximos Passos

### Melhorias Futuras
- [ ] Implementar autenticação JWT
- [ ] Adicionar paginação nas listagens
- [ ] Implementar filtros e ordenação nas consultas
- [ ] Adicionar logs de auditoria
- [ ] Implementar cache para queries frequentes
- [ ] Adicionar testes automatizados
- [ ] Implementar rate limiting
- [ ] Adicionar documentação Swagger/OpenAPI

---

## Contribuindo

Pull requests são bem-vindos! Para mudanças maiores, abra uma issue primeiro para discutir o que você gostaria de mudar.

---

## Licença

Este projeto foi desenvolvido para fins acadêmicos no SENAI - Projeto Aplicado III.
