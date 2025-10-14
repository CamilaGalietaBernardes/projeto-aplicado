# Roadmap para 100% - Mobile Flutter

## Status Atual: 75% Completo ✅

---

## ✅ O que JÁ está implementado (75%)

### Core Features
- ✅ **Autenticação completa**
  - Login com email e senha
  - Persistência de sessão
  - Proteção de rotas

- ✅ **Ordens de Serviço - COMPLETO**
  - Listagem com busca e filtros
  - Criação de novas ordens
  - **Edição de status**
  - **Exclusão de ordens**

- ✅ **Gestão de Estoque - COMPLETO**
  - Listagem com busca e filtros
  - Cadastro de peças
  - Edição de peças
  - Exclusão de peças
  - Indicadores visuais

- ✅ **Alertas de Estoque - COMPLETO**
  - Tela de alertas
  - Métricas visuais
  - Atualização rápida

---

## ❌ O que FALTA para 100% (25%)

### 1. Gestão Completa de Usuários (🟠 Prioridade MÉDIA - 10%)

**Tempo Estimado:** 1-2 dias

#### Arquivos a Criar:
```
lib/
├── domain/repository/
│   └── user_repository.dart (interface)
├── data/
│   ├── services/
│   │   └── user_api.dart
│   └── repository_impl/
│       └── user_repository_impl.dart
├── view_model/
│   └── user_view_model.dart
└── features/views/children/
    ├── user_list_view.dart
    └── user_form_view.dart (ou modal)
```

#### Funcionalidades:
- [ ] Tela de listagem de usuários
- [ ] Modal/Tela de cadastro de usuário
- [ ] Modal/Tela de edição de usuário
- [ ] Funcionalidade de exclusão com confirmação
- [ ] Busca e filtros (opcional)
- [ ] Integração com APIs:
  - `POST /usuarios` - Criar
  - `PUT /usuarios/<id>` - Atualizar
  - `DELETE /usuarios/<id>` - Excluir

#### Campos do Formulário:
- Nome (required)
- Email (required, validação)
- Função (required)
- Setor (required)
- Senha (required apenas no create)

#### Navegação:
- Adicionar nova rota `/users` no app_router
- Botão de acesso no menu ou configurações

---

### 2. Sistema de Notificações (🟠 Prioridade MÉDIA - 8%)

**Tempo Estimado:** 1-2 dias

#### Arquivos a Criar:
```
lib/
├── domain/
│   ├── models/
│   │   └── notification_model.dart
│   └── repository/
│       └── notification_repository.dart
├── data/
│   ├── services/
│   │   ├── notification_api.dart
│   │   └── notification_local_service.dart (SharedPreferences)
│   └── repository_impl/
│       └── notification_repository_impl.dart
├── view_model/
│   └── notification_view_model.dart
└── features/views/children/
    └── notifications_view.dart
```

#### Funcionalidades:
- [ ] Model de notificação (id, mensagem, timestamp, lida)
- [ ] Tela de central de notificações
- [ ] Lista de notificações com status lida/não lida
- [ ] Badge de contador no ícone (se houver)
- [ ] Marcar como lida
- [ ] Limpar todas as notificações
- [ ] Persistência local com SharedPreferences
- [ ] Integração com `GET /notificacoes-estoque` (opcional)

#### Tipos de Notificações:
- Estoque baixo (automático ao detectar alerta)
- Ações bem-sucedidas (criar/editar/excluir)
- Erros de operações

#### Navegação:
- Ícone de sino no AppBar com badge
- Rota `/notifications`

---

### 3. Relatórios e Dashboards (🟡 Prioridade BAIXA - 5%)

**Tempo Estimado:** 2-3 dias

#### Dependências Necessárias:
```yaml
dependencies:
  fl_chart: ^0.68.0        # Gráficos
  intl: ^0.19.0            # Formatação de datas
```

#### Arquivos a Criar:
```
lib/
├── view_model/
│   └── reports_view_model.dart
└── features/views/children/
    └── reports_view.dart
```

#### Funcionalidades:
- [ ] Tela de relatórios/dashboard
- [ ] Gráficos de estoque por categoria (pizza/barras)
- [ ] Gráficos de ordens por status (pizza/barras)
- [ ] Gráficos de ordens por período (linha/barras)
- [ ] Filtros de período (hoje, semana, mês, ano, customizado)
- [ ] Filtros por categoria
- [ ] Cards com estatísticas resumidas:
  - Total de peças
  - Peças com estoque baixo
  - Total de ordens
  - Ordens pendentes
  - Ordens concluídas
- [ ] Exportação para PDF (muito opcional)

#### Tipos de Gráficos:
1. **Estoque por Categoria** (PieChart)
2. **Ordens por Status** (PieChart)
3. **Ordens no Tempo** (LineChart)
4. **Top 5 Peças Mais Usadas** (BarChart)

#### Navegação:
- Já existe como terceira aba do BottomNav
- Atualmente aponta para `/settings`, mudar para `/reports`

---

### 4. Perfil do Usuário Completo (🟡 Prioridade BAIXA - 1%)

**Tempo Estimado:** 4-6 horas

#### Arquivo a Modificar:
```
lib/features/views/profile_view.dart
```

#### Funcionalidades:
- [ ] Exibir dados completos do usuário logado
  - Nome
  - Email
  - Função
  - Setor
- [ ] Botão "Editar Perfil"
- [ ] Modal/Tela de edição com:
  - Nome (editável)
  - Email (somente leitura ou validação)
  - Função (editável)
  - Setor (editável)
- [ ] Botão "Alterar Senha"
- [ ] Modal de alteração de senha:
  - Senha atual
  - Nova senha
  - Confirmar nova senha
- [ ] Avatar/Foto de perfil (opcional)
  - Usar iniciais se não houver foto
  - Upload de foto (image_picker package)

#### APIs Necessárias:
- `PUT /usuarios/<id>` (já existe)
- `PUT /usuarios/<id>/password` (novo endpoint no backend - opcional)

---

### 5. Configurações Funcionais (🟡 Prioridade BAIXA - 1%)

**Tempo Estimado:** 4-6 horas

#### Arquivo a Modificar:
```
lib/features/views/children/setting_view.dart
```

#### Funcionalidades:
- [ ] **Notificações**
  - Toggle para ativar/desativar notificações
  - Toggle para notificações de estoque baixo

- [ ] **Aparência**
  - Seletor de tema (claro/escuro)
  - Implementar ThemeProvider com Riverpod

- [ ] **Conta**
  - Botão "Editar Perfil" (navega para profile)
  - Botão "Alterar Senha"
  - Botão "Logout" (limpa sessão e volta para login)

- [ ] **Sobre**
  - Nome do app
  - Versão (usar package_info_plus)
  - Desenvolvido por
  - Link do repositório

- [ ] **Persistência de Configurações**
  - SharedPreferences para salvar preferências
  - Carregar ao iniciar o app

#### Dependências:
```yaml
dependencies:
  package_info_plus: ^8.0.0  # Info do app
```

---

## 📊 Tabela de Completude Atualizada

| Feature                    | Backend | Web | Mobile | Prioridade |
|----------------------------|---------|-----|--------|------------|
| **Core (Obrigatório)**     |         |     |        |            |
| Login                      | ✅      | ✅  | ✅     | -          |
| Listar Ordens              | ✅      | ✅  | ✅     | -          |
| Criar Ordem                | ✅      | ✅  | ✅     | -          |
| Editar Ordem               | ✅      | ✅  | ✅     | -          |
| Excluir Ordem              | ✅      | ✅  | ✅     | -          |
| Listar Estoque             | ✅      | ✅  | ✅     | -          |
| Criar Peça                 | ✅      | ✅  | ✅     | -          |
| Editar Peça                | ✅      | ✅  | ✅     | -          |
| Excluir Peça               | ✅      | ✅  | ✅     | -          |
| Alertas Estoque            | ✅      | ✅  | ✅     | -          |
| **Gestão (Importante)**    |         |     |        |            |
| Listar Usuários            | ✅      | ✅  | 🟡     | 🟠 MÉDIA   |
| Criar Usuário              | ✅      | ✅  | ❌     | 🟠 MÉDIA   |
| Editar Usuário             | ✅      | ✅  | ❌     | 🟠 MÉDIA   |
| Excluir Usuário            | ✅      | ✅  | ❌     | 🟠 MÉDIA   |
| **Notificações**           |         |     |        |            |
| Sistema Local              | ❌      | ✅  | ❌     | 🟠 MÉDIA   |
| Central de Notificações    | ❌      | ✅  | ❌     | 🟠 MÉDIA   |
| Badge Contador             | ❌      | ✅  | ❌     | 🟠 MÉDIA   |
| **Relatórios**             |         |     |        |            |
| Dashboard                  | ❌      | ✅  | ❌     | 🟡 BAIXA   |
| Gráficos                   | ❌      | ✅  | ❌     | 🟡 BAIXA   |
| Filtros de Período         | ❌      | ✅  | ❌     | 🟡 BAIXA   |
| **Perfil & Config**        |         |     |        |            |
| Ver Perfil                 | ✅      | ❌  | 🟡     | 🟡 BAIXA   |
| Editar Perfil              | ✅      | ❌  | ❌     | 🟡 BAIXA   |
| Alterar Senha              | ✅      | ❌  | ❌     | 🟡 BAIXA   |
| Configurações App          | ❌      | ❌  | 🟡     | 🟡 BAIXA   |
| Logout                     | ✅      | ✅  | ❌     | 🟡 BAIXA   |

**Legenda:**
- ✅ Completo
- 🟡 Parcial
- ❌ Não implementado

---

## 🎯 Plano de Implementação Sugerido

### Fase 1: Funcionalidades Essenciais (Para 85%)
**Tempo: 2-3 dias**

1. **Gestão de Usuários** (10%)
   - Dia 1: Repository, API, ViewModel
   - Dia 2: UI (listagem, forms)

### Fase 2: Experiência do Usuário (Para 93%)
**Tempo: 2-3 dias**

2. **Sistema de Notificações** (8%)
   - Dia 1: Models, Services, ViewModel
   - Dia 2: UI e persistência

### Fase 3: Visualização de Dados (Para 98%)
**Tempo: 2-3 dias**

3. **Relatórios** (5%)
   - Dia 1: Integração fl_chart, gráficos básicos
   - Dia 2-3: Filtros, estatísticas avançadas

### Fase 4: Refinamento (Para 100%)
**Tempo: 1 dia**

4. **Perfil Completo** (1%)
   - Manhã: Edição de perfil

5. **Configurações** (1%)
   - Tarde: Logout, configurações, sobre

---

## 📅 Estimativa Total para 100%

| Fase | Funcionalidades | Tempo | % Ganho | Total Acumulado |
|------|----------------|-------|---------|-----------------|
| Atual | Core + Estoque + Ordens | - | 75% | **75%** |
| Fase 1 | Usuários | 2-3 dias | +10% | **85%** |
| Fase 2 | Notificações | 2-3 dias | +8% | **93%** |
| Fase 3 | Relatórios | 2-3 dias | +5% | **98%** |
| Fase 4 | Perfil + Config | 1 dia | +2% | **100%** |

**Tempo Total Estimado:** 7-10 dias de desenvolvimento

---

## 🚀 Quick Wins (Implementação Rápida)

Se quiser atingir marcos rapidamente, siga esta ordem:

### Para 80% (1 dia)
1. Logout funcional (2h)
2. Listagem de usuários (4h)

### Para 85% (2-3 dias)
3. CRUD completo de usuários

### Para 90% (4-5 dias)
4. Sistema básico de notificações

### Para 100% (7-10 dias)
5. Relatórios + Perfil + Configurações

---

## 💡 Recomendações

### Priorize por Valor de Negócio:
1. **Gestão de Usuários** - Essencial para administração
2. **Notificações** - Melhora UX significativamente
3. **Relatórios** - Nice to have, mas dá valor ao app
4. **Perfil/Config** - Refinamento final

### Abordagem MVP:
Se o objetivo é lançar rápido:
- Implemente apenas **Fase 1 + Logout**
- Você terá 85% + experiência completa das funcionalidades core
- Relatórios podem ser adicionados depois

### Abordagem Completa:
Para um app profissional e completo:
- Implemente todas as 4 fases
- Foco em UX e polish
- Testes em dispositivos reais

---

## 📝 Checklist Final

### Antes de Marcar como 100%

**Funcionalidades:**
- [ ] Todas as features do web implementadas
- [ ] CRUD completo para todas as entidades
- [ ] Sistema de notificações funcionando
- [ ] Relatórios com dados reais
- [ ] Perfil editável
- [ ] Logout funcional
- [ ] Configurações persistentes

**Qualidade:**
- [ ] Sem erros de compilação
- [ ] Tratamento de erros em todos os fluxos
- [ ] Loading states em operações assíncronas
- [ ] Feedback visual (SnackBars, Dialogs)
- [ ] Responsividade testada (múltiplos tamanhos)
- [ ] Navegação fluida

**Performance:**
- [ ] Listas com paginação (se necessário)
- [ ] Cache de imagens (se houver)
- [ ] Sem memory leaks
- [ ] Tempo de resposta aceitável

**Documentação:**
- [ ] README atualizado
- [ ] Comentários em código complexo
- [ ] Guia de instalação testado
- [ ] Exemplos de uso

---

## 🎯 Meta Final

**Status Atual:** 75% ✅
**Status Meta:** 100% 🎯

**Funcionalidades Restantes:** 5
**Tempo Estimado Total:** 7-10 dias

**Próximo Marco:** 85% (Gestão de Usuários)
**Tempo:** 2-3 dias

---

**Última Atualização:** 11/10/2025
**Progresso:** 75/100 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━░░░░░░░░ 75%
