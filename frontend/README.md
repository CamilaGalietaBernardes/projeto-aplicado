# Frontend - Sistema de Gestão de Peças e Manutenção

## Visão Geral

Interface web desenvolvida em React para gerenciar estoque de peças, ordens de serviço e notificações. A aplicação oferece uma experiência moderna e responsiva, integrada com o backend Flask hospedado no Render.

**URL em Produção:** Hospedado no Firebase Hosting

---

## Tecnologias Utilizadas

- **React** 18+ - Biblioteca JavaScript para UI
- **Vite** - Build tool e dev server
- **React Router DOM** - Roteamento client-side
- **Tailwind CSS** - Framework CSS utilitário
- **React Hot Toast** - Sistema de notificações
- **Fetch API** - Requisições HTTP
- **Firebase Hosting** - Deploy e hospedagem

---

## Estrutura do Projeto

```
frontend/
├── src/
│   ├── components/
│   │   ├── DashboardLayout.jsx      # Layout principal com sidebar
│   │   ├── RotaProtegida.jsx        # Proteção de rotas autenticadas
│   │   ├── CadastroModal.jsx        # Modal para cadastro de usuários
│   │   ├── EstoqueModal.jsx         # Modal para cadastro/edição de peças
│   │   ├── ManutencaoModal.jsx      # Modal para ordens de serviço
│   │   └── FiltroRelatorios.jsx     # Filtros para relatórios
│   ├── pages/
│   │   ├── Login.jsx                # Página de autenticação
│   │   ├── Estoque.jsx              # Gestão de estoque e peças
│   │   ├── Manutencao.jsx           # Gestão de ordens de serviço
│   │   ├── Relatorios.jsx           # Visualização de relatórios
│   │   └── Notificacoes.jsx         # Central de notificações
│   ├── services/
│   │   ├── authService.js           # Serviços de autenticação
│   │   ├── estoqueService.js        # Serviços de estoque/peças
│   │   ├── osService.js             # Serviços de ordens de serviço
│   │   ├── notificacoesService.js   # Gestão de notificações locais
│   │   └── EstoqueNotificacoesApi.jsx # API de alertas de estoque
│   ├── contexts/
│   │   └── AuthContext.jsx          # Context API para autenticação
│   ├── utils/
│   │   └── storage.js               # Utilitários para localStorage
│   ├── App.jsx                      # Componente principal e rotas
│   └── main.jsx                     # Entry point da aplicação
├── public/                          # Arquivos estáticos
├── index.html                       # HTML principal
├── vite.config.js                   # Configuração Vite
├── tailwind.config.js               # Configuração Tailwind
├── firebase.json                    # Configuração Firebase
├── .firebaserc                      # Projeto Firebase
└── package.json                     # Dependências

```

---

## Funcionalidades

### 1. Autenticação
- Login com email e senha
- Validação de credenciais via API backend
- Armazenamento de sessão no localStorage
- Proteção de rotas privadas
- Logout e limpeza de sessão

### 2. Gestão de Estoque
- Listagem de todas as peças com quantidades
- Cadastro de novas peças
- Edição de peças existentes
- Exclusão de peças
- Alertas visuais para estoque baixo (qtd < qtd_min)
- Filtros e busca por nome/categoria

### 3. Ordens de Serviço
- Listagem completa de ordens
- Criação de novas ordens com:
  - Tipo (Preventiva, Corretiva, Preditiva)
  - Setor, data, recorrência
  - Equipamento vinculado
  - Solicitante
  - Peças utilizadas
- Edição de status e detalhes
- Exclusão de ordens
- Cards visuais com informações detalhadas

### 4. Notificações
- Sistema local de notificações
- Alertas automáticos para estoque baixo
- Notificações de ações bem-sucedidas/erros
- Central de notificações com histórico
- Limpeza de notificações

### 5. Relatórios
- Visualização de dados agregados
- Filtros por período e categoria
- Estatísticas de estoque
- Histórico de ordens de serviço

---

## Componentes Principais

### DashboardLayout
Layout padrão com sidebar de navegação:
- Links para Estoque, Manutenção, Relatórios
- Indicador de notificações
- Botão de logout
- Área de conteúdo principal

### RotaProtegida
Higher-Order Component para proteção de rotas:
- Verifica autenticação antes de renderizar
- Redireciona para login se não autenticado
- Usa localStorage para persistência de sessão

### Modais
Componentes reutilizáveis para formulários:
- **EstoqueModal**: Cadastro/edição de peças
- **ManutencaoModal**: Criação de ordens de serviço
- **CadastroModal**: Cadastro de usuários

---

## Serviços (API Integration)

### authService.js
```javascript
// Funções disponíveis:
autenticar(usuario, senha)      // Login
cadastrarUsuario(dados)          // Criar usuário
listarUsuarios()                 // Listar todos os usuários
```

### estoqueService.js
```javascript
// Funções disponíveis:
listarEstoque()                  // Listar todas as peças
cadastrarPeca(dados)             // Cadastrar nova peça
atualizarPeca(id, dados)         // Atualizar peça
excluirPeca(id)                  // Excluir peça
listarEquipamentos()             // Listar equipamentos
```

### osService.js
```javascript
// Funções disponíveis:
listarOS()                       // Listar ordens de serviço
cadastrarOS(dados)               // Criar ordem
atualizarOS(id, dados)           // Atualizar ordem
excluirOS(id)                    // Excluir ordem
```

### notificacoesService.js
```javascript
// Funções disponíveis (localStorage):
adicionarNotificacao(mensagem)   // Adicionar notificação
listarNotificacoes()             // Listar todas
limparNotificacoes()             // Limpar histórico
```

---

## Rotas da Aplicação

| Rota           | Componente    | Proteção | Descrição                    |
|----------------|---------------|----------|------------------------------|
| `/login`       | Login         | Pública  | Autenticação de usuários     |
| `/`            | Manutencao    | Privada  | Página inicial (Manutenção)  |
| `/estoque`     | Estoque       | Privada  | Gestão de estoque            |
| `/manutencao`  | Manutencao    | Privada  | Gestão de ordens de serviço  |
| `/relatorios`  | Relatorios    | Privada  | Visualização de relatórios   |
| `*`            | Login         | Pública  | Fallback para rotas inválidas|

---

## Configuração e Instalação

### Requisitos
- Node.js 16+
- npm ou yarn

### Instalação

1. **Clone o repositório:**
```bash
git clone https://github.com/camilagalieta/projeto-aplicado.git
cd projeto-aplicado/frontend
```

2. **Instale as dependências:**
```bash
npm install
```

3. **Configure a URL da API:**
Edite os arquivos de serviço em `src/services/` se necessário:
```javascript
const API_URL = "https://projeto-aplicado.onrender.com";
```

4. **Execute em modo de desenvolvimento:**
```bash
npm run dev
```

A aplicação estará disponível em `http://localhost:5173`

5. **Build para produção:**
```bash
npm run build
```

---

## Deploy no Firebase

1. **Instale o Firebase CLI:**
```bash
npm install -g firebase-tools
```

2. **Faça login no Firebase:**
```bash
firebase login
```

3. **Inicialize o projeto (já configurado):**
```bash
firebase init hosting
```

4. **Build e deploy:**
```bash
npm run build
firebase deploy
```

---

## Fluxos Principais

### Fluxo de Login
1. Usuário acessa `/login`
2. Preenche email e senha
3. Sistema valida via `authService.autenticar()`
4. Em caso de sucesso:
   - Dados do usuário salvos no localStorage
   - Redirecionamento para `/manutencao`
5. Em caso de erro:
   - Toast de erro exibido

### Fluxo de Cadastro de Peça
1. Na página `/estoque`, clicar em "Nova Peça"
2. Modal abre com formulário
3. Preencher: nome, categoria, quantidade, quantidade mínima
4. Sistema valida e envia via `estoqueService.cadastrarPeca()`
5. Lista atualizada automaticamente
6. Toast de sucesso exibido

### Fluxo de Criação de Ordem de Serviço
1. Na página `/manutencao`, clicar em "Nova OS"
2. Modal abre com formulário completo
3. Preencher dados obrigatórios
4. Selecionar equipamento e solicitante
5. Adicionar peças utilizadas (opcional)
6. Sistema envia via `osService.cadastrarOS()`
7. Estoque atualizado automaticamente
8. Notificação se estoque ficar baixo

---

## Sistema de Notificações

### Notificações Toast
- Usadas para feedback imediato de ações
- Tipos: sucesso, erro, loading
- Biblioteca: `react-hot-toast`
- Posição: top-right
- Auto-dismiss após 3-5 segundos

### Notificações Persistentes
- Armazenadas no localStorage
- Alertas de estoque baixo
- Visualização na rota `/notificacoes`
- Limpeza manual pelo usuário

---

## Estilização

### Tailwind CSS
Classes utilitárias para estilização rápida:
- Layout responsivo com flexbox/grid
- Cores personalizadas (emerald como primária)
- Componentes reutilizáveis
- Dark mode não implementado

### Paleta de Cores
- **Primária:** Emerald (verde) - `bg-emerald-600`
- **Sucesso:** Green
- **Erro:** Red
- **Aviso:** Yellow
- **Neutro:** Gray

---

## Estado da Aplicação

### Gerenciamento de Estado
- **Local State:** useState para componentes isolados
- **Context API:** AuthContext para autenticação global
- **localStorage:** Persistência de sessão e notificações
- **Server State:** Fetch direto dos serviços (sem cache)

### Dados no localStorage
```javascript
{
  "usuario": {...},           // Dados do usuário logado
  "notificacoes": [...],      // Array de notificações
  "usuarios": [...]           // Cache local (se usado)
}
```

---

## Responsividade

- Design responsivo para desktop e tablet
- Breakpoints Tailwind padrão
- Sidebar adaptável
- Tabelas com scroll horizontal em telas pequenas
- Modais centralizados e adaptáveis

---

## Tratamento de Erros

1. **Erros de Rede:**
   - Try/catch em todas as chamadas de API
   - Toast de erro com mensagem apropriada
   - Fallback para estados de erro

2. **Validação de Formulários:**
   - Validação client-side básica
   - Feedback visual em campos inválidos
   - Mensagens de erro contextuais

3. **Erros de Autenticação:**
   - Redirecionamento automático para login
   - Limpeza de sessão inválida
   - Mensagens de erro específicas (401, 403)

---

## Performance

### Otimizações Implementadas
- Build otimizado com Vite
- Code splitting por rotas (React.lazy não implementado ainda)
- Minificação automática em produção

### Melhorias Futuras
- [ ] Implementar React.lazy para code splitting
- [ ] Adicionar cache de requisições
- [ ] Implementar paginação nas listagens
- [ ] Otimizar re-renders com React.memo
- [ ] Adicionar Service Worker para PWA

---

## Segurança

- Proteção de rotas com RotaProtegida
- Armazenamento seguro no localStorage (sem tokens sensíveis)
- HTTPS em produção (Firebase Hosting)
- Sanitização de inputs (básica)
- CORS configurado no backend

**Nota:** Sistema atual não usa JWT. Melhorias futuras devem implementar tokens de autenticação.

---

## Melhorias Futuras

### Funcionalidades
- [ ] Dashboard com gráficos e estatísticas
- [ ] Exportação de relatórios (PDF, Excel)
- [ ] Filtros avançados e pesquisa global
- [ ] Sistema de permissões por role
- [ ] Histórico de alterações (audit log)
- [ ] Modo offline (PWA)
- [ ] Notificações push

### Técnicas
- [ ] Testes unitários (Jest + React Testing Library)
- [ ] Testes E2E (Cypress ou Playwright)
- [ ] Implementar TypeScript
- [ ] State management com Redux/Zustand
- [ ] Storybook para componentes
- [ ] CI/CD automatizado
- [ ] Monitoramento de erros (Sentry)
- [ ] Analytics (Google Analytics)

---

## Troubleshooting

### Problema: "Erro ao autenticar"
- Verificar se backend está online
- Conferir URL da API nos serviços
- Verificar credenciais no banco de dados

### Problema: Lista vazia após login
- Verificar resposta da API no Network tab
- Conferir se há dados no banco
- Verificar CORS no backend

### Problema: Modal não abre
- Verificar console do navegador
- Conferir se componente modal está importado
- Verificar estado de controle do modal

---

## Contribuindo

Pull requests são bem-vindos! Para mudanças maiores, abra uma issue primeiro para discutir o que você gostaria de mudar.

### Guidelines
1. Siga os padrões de código existentes
2. Use ESLint e Prettier (se configurados)
3. Teste suas mudanças localmente
4. Atualize a documentação se necessário

---

## Licença

Este projeto foi desenvolvido para fins acadêmicos no SENAI - Projeto Aplicado III.

---

## Contato e Suporte

Para dúvidas ou sugestões, abra uma issue no repositório GitHub.
