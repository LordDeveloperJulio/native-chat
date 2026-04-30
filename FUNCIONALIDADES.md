# LinguaAI — Funcionalidades do App

> App de aprendizado de inglês com IA adaptativa, powered by GPT-4o.

---

## Visão Geral

O LinguaAI é um app Flutter que permite ao usuário praticar conversação em inglês com uma tutora virtual chamada **Aria**. A IA corrige erros gramaticais, ensina vocabulário novo e adapta automaticamente o nível de dificuldade com base no desempenho do usuário.

---

## Telas e Funcionalidades

### 0. Onboarding Screen

Exibida **apenas na primeira abertura do app** (controlada pela chave `onboarding_done` no SharedPreferences). Após a conclusão, nunca mais é exibida.

- **Página 1 — Nome:** campo de texto para o usuário informar seu nome; botão "Continuar" desabilitado enquanto o campo estiver vazio
- **Página 2 — Nível:** seleção do nível de inglês via cards interativos (Iniciante / Intermediário / Avançado)
- **Página 3 — Modo inicial:** seleção do modo de prática via grid 2×2 (Casual / Negócios / Viagem / Entrevista)
- Indicador de progresso com 3 bolinhas no topo (ativa verde cheia, inativas cinza vazias)
- Ao concluir: cria o registro do usuário no banco Drift, salva nome/nível/modo no SharedPreferences e redireciona para a HomeScreen

---

### 1. Home Screen

- Exibe saudação personalizada com o nome do usuário
- Mostra o **nível atual** do usuário (Iniciante / Intermediário / Avançado)
- Contador de **sequência de dias** de prática (streak 🔥)
- Seleção de **modo de conversa**:
  - **Casual** — conversas do cotidiano
  - **Business** — comunicação profissional
  - **Travel** — cenários de viagem
  - **Interview** — preparação para entrevistas de emprego
- Botão para iniciar uma nova sessão de chat

---

### 2. Chat Screen

- Conversa em tempo real com a tutora **Aria** (GPT-4o)
- **Bolhas de mensagem** diferenciadas: usuário (direita, verde) e IA (esquerda, branco)
- **Indicador de digitação** animado enquanto a IA processa a resposta
- **Card de correção** exibido após cada resposta da IA:
  - Mostra erro do usuário → forma correta
  - Lista palavras novas introduzidas na resposta
- **Limite freemium:** 10 mensagens gratuitas por dia com barra de progresso visível
- Banner de upgrade exibido ao atingir o limite diário
- Tratamento de erros com mensagens em português (timeout, falha de conexão, etc.)

---

### 3. Progress Screen

- **Cards de estatísticas:**
  - Total de mensagens enviadas
  - Palavras novas aprendidas
  - Dias consecutivos de prática
- **Gráfico de atividade semanal:** barras com mensagens por dia nos últimos 7 dias
- **Lista de erros frequentes:**
  - Pares "errado → correto" com frequência de ocorrência
  - Erros com 3+ ocorrências destacados em vermelho

---

### 4. Paywall / Premium Screen

- Lista de benefícios do plano premium:
  - Mensagens ilimitadas
  - Histórico completo de conversas
  - Analytics detalhados de progresso
  - Prática de pronúncia *(em breve)*
  - Acesso offline *(em breve)*
  - Suporte prioritário
- Opções de plano:
  - **Mensal:** R$ 19,90/mês
  - **Anual:** R$ 149/ano (economia de 38%)
- Interface completa — integração de pagamento ainda não implementada

---

## Inteligência Artificial

### Tutora Aria

- Modelo: **GPT-4o** via API OpenAI
- Responde sempre em inglês, mantendo o nível e modo selecionados
- Cada resposta retorna estrutura JSON com:
  - `reply` — resposta conversacional
  - `correction` — correção de erro (se houver)
  - `new_words` — vocabulário novo introduzido
  - `difficulty` — score de dificuldade de 1 a 10

### Adaptação Automática de Nível

- Avalia as últimas 3 respostas do usuário
- Sobe de nível se os 3 últimos scores forem < 3
- Desce de nível se os 3 últimos scores forem > 8
- Previne mudanças frequentes exigindo 3 avaliações consecutivas

### Prompt Dinâmico

O sistema prompt enviado à IA é montado dinamicamente a cada mensagem, incluindo:
- Identidade da Aria e tom de comunicação
- Modo de conversa ativo
- Nível atual do usuário
- Top 5 erros mais frequentes do usuário (para reforço)
- Formato de resposta JSON exigido

### Histórico de Contexto

- As últimas 10 mensagens são enviadas à IA em cada requisição
- Mantém coerência conversacional sem estourar o limite de tokens

---

## Banco de Dados Local (SQLite via Drift)

| Tabela | Dados armazenados |
|--------|-------------------|
| `users` | Nome, nível, modo ativo, streak, data da última sessão |
| `messages` | Histórico completo de mensagens por usuário |
| `corrections` | Erros cometidos com contador de ocorrências |
| `new_words` | Vocabulário novo com contador de vezes visto |

---

## Modelo Freemium

- 10 mensagens gratuitas por dia (reset diário à meia-noite UTC)
- Contagem visível na interface do chat
- Input desabilitado ao atingir o limite
- Banner de upgrade apresentado ao usuário

---

## Stack Técnica

| Camada | Tecnologia |
|--------|-----------|
| Framework | Flutter 3.11.5+ |
| State Management | Riverpod 2.x |
| HTTP Client | Dio 5.x |
| Banco de Dados | Drift (SQLite) |
| IA | OpenAI GPT-4o |
| Gráficos | fl_chart |
| Fontes | Google Fonts (Nunito) |
| Config/Secrets | flutter_dotenv |
| Preferências Locais | shared_preferences |

---

## O que ainda não está implementado

- Integração real de pagamento (paywall é UI apenas)
- Prática de pronúncia
- Acesso offline
- Suporte prioritário
