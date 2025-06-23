# Projeto Aplicado – Gestão de Peças e Manutenção

  Este é o backend da aplicação desenvolvida para o Projeto Aplicado III do curso de Análise e Desenvolvimento de Sistemas do SENAI.
  A solução busca automatizar e centralizar o controle de estoque de peças e ordens de serviço de manutenção.

---

🚀 Tecnologias Utilizadas
  -  Python 3.x

  -  Flask 3.1.0

  -  Flask SQLAlchemy

  -  PostgreSQL

  -  Flask-CORS

  -  python-dotenv

---

🔧 **Como Executar**
  **1. Clone o Repositório**
    git clone https://github.com/camilagalieta/projeto-aplicado.git
    cd projeto-aplicado/backend

  **2. Crie um ambiente virtual e ative**
    python -m venv venv
    source venv/bin/activate  # ou venv\Scripts\activate no Windows

  **3. Instale as dependências**
    pip install -r requirements.txt

  **4. Configure o arquivo .env:**
    DATABASE_URL=postgresql://camila_pa:projetoaplicado@db:5432/gestao_estoque_manutencao
  
  **5. Execute o servidor:**
    python3 app.py
  
  O servidor estará disponível em http://localhost:5000.

**📌 Funcionalidades**
  Cadastro e autenticação de usuários

  Cadastro de peças

  Criação, listagem e gerenciamento de ordens de serviço
  
---

## 💾 Requisitos

* Python 3.9
* Flask 3.1.0
* PostgreSQL
* Docker + Docker Compose
  
---

## 🗃️ Banco de Dados

O banco de dados PostgreSQL é iniciado automaticamente pelo Docker e usa as variáveis do `.env` para configurar usuário, senha e nome do banco.

---

## 📂 Organização
  projeto-aplicado/
  ├── backend/  
  │   ├── app.py                     # Inicialização do app Flask
  │   ├── requirements.txt           # Dependências do backend
  │   └── app/
  │       ├── __init__.py            # Criação da aplicação e configuração do banco
  │       ├── models/                # Definições das tabelas e modelos SQLAlchemy
  │       ├── routes/                # Rotas da API
  │       ├── services/              # Lógica de negócio (ordem de serviço, usuário, etc.)
  │       └── utils/                 # Utilitários auxiliares
---

📂 **Pasta services/**
  A lógica principal está dividida em arquivos:

    login.py: autenticação de usuários

    usuario.py: operações com usuários

    ordem_servico.py: regras para ordens de serviço

    peca.py: controle de peças

📫** Contribuições**
  Pull requests são bem-vindas! Para mudanças maiores, abra uma issue para discutir o que deseja modificar.
