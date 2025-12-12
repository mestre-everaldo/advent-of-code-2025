# Advent of Code 2025 - Dia 10 - Parte 2

## Relatório Explicativo

### O Problema

Cada máquina possui **contadores** que precisam ser configurados para valores específicos. Temos **botões** que, quando pressionados, incrementam certos contadores em 1. O objetivo é encontrar o **menor número total de pressionamentos** para atingir os valores desejados.

---

## Exemplo 1: `[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}`

### Interpretação

- **Contadores**: 4 contadores (índices 0, 1, 2, 3) - um para cada caractere entre `[` e `]`
- **Valores iniciais**: `{0, 0, 0, 0}`
- **Valores desejados**: `{3, 5, 4, 7}`

### Botões disponíveis

| Botão | Afeta contadores |
|-------|------------------|
| B1    | (3)              |
| B2    | (1, 3)           |
| B3    | (2)              |
| B4    | (2, 3)           |
| B5    | (0, 2)           |
| B6    | (0, 1)           |

### Modelagem Matemática

Seja `x1, x2, x3, x4, x5, x6` o número de vezes que pressionamos cada botão.

**Objetivo**: Minimizar `x1 + x2 + x3 + x4 + x5 + x6`

**Restrições** (cada contador deve atingir o valor exato):

```
Contador 0:              x5 + x6 = 3
Contador 1:         x2 + x6      = 5
Contador 2:    x3 + x4 + x5      = 4
Contador 3: x1 + x2 + x4         = 7

Todas as variáveis >= 0 e inteiras
```

### Solução

Uma solução ótima (10 pressionamentos):
- B1 (3): **1 vez** → contador 3 recebe +1
- B2 (1,3): **3 vezes** → contadores 1 e 3 recebem +3 cada
- B4 (2,3): **3 vezes** → contadores 2 e 3 recebem +3 cada
- B5 (0,2): **1 vez** → contadores 0 e 2 recebem +1 cada
- B6 (0,1): **2 vezes** → contadores 0 e 1 recebem +2 cada

**Verificação**:
```
Contador 0: 0 + 0 + 0 + 1 + 2 = 3 ✓
Contador 1: 3 + 0 + 0 + 0 + 2 = 5 ✓
Contador 2: 0 + 0 + 3 + 1 + 0 = 4 ✓
Contador 3: 1 + 3 + 3 + 0 + 0 = 7 ✓

Total: 1 + 3 + 0 + 3 + 1 + 2 = 10
```

---

## Exemplo 2: `[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}`

### Interpretação

- **Contadores**: 5 contadores (índices 0, 1, 2, 3, 4)
- **Valores desejados**: `{7, 5, 12, 7, 2}`

### Botões disponíveis

| Botão | Afeta contadores |
|-------|------------------|
| B1    | (0, 2, 3, 4)     |
| B2    | (2, 3)           |
| B3    | (0, 4)           |
| B4    | (0, 1, 2)        |
| B5    | (1, 2, 3, 4)     |

### Sistema de equações

```
Contador 0: x1 + x3 + x4           = 7
Contador 1:           x4 + x5      = 5
Contador 2: x1 + x2 + x4 + x5      = 12
Contador 3: x1 + x2 +      x5      = 7
Contador 4: x1 + x3 +      x5      = 2
```

### Solução

Uma solução ótima (12 pressionamentos):
- B1 (0,2,3,4): **2 vezes**
- B2 (2,3): **5 vezes**
- B4 (0,1,2): **5 vezes**

**Verificação**:
```
Contador 0: 2 + 0 + 5 = 7  ✓
Contador 1: 0 + 5 + 0 = 5  ✓
Contador 2: 2 + 5 + 5 = 12 ✓
Contador 3: 2 + 5 + 0 = 7  ✓
Contador 4: 2 + 0 + 0 = 2  ✓

Total: 2 + 5 + 0 + 5 + 0 = 12
```

---

## Exemplo 3: `[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}`

### Interpretação

- **Contadores**: 6 contadores (índices 0, 1, 2, 3, 4, 5)
- **Valores desejados**: `{10, 11, 11, 5, 10, 5}`

### Botões disponíveis

| Botão | Afeta contadores   |
|-------|--------------------|
| B1    | (0, 1, 2, 3, 4)    |
| B2    | (0, 3, 4)          |
| B3    | (0, 1, 2, 4, 5)    |
| B4    | (1, 2)             |

### Solução

Uma solução ótima (11 pressionamentos):
- B1 (0,1,2,3,4): **5 vezes**
- B3 (0,1,2,4,5): **5 vezes**
- B4 (1,2): **1 vez**

**Verificação**:
```
Contador 0: 5 + 0 + 5 + 0 = 10 ✓
Contador 1: 5 + 0 + 5 + 1 = 11 ✓
Contador 2: 5 + 0 + 5 + 1 = 11 ✓
Contador 3: 5 + 0 + 0 + 0 = 5  ✓
Contador 4: 5 + 0 + 5 + 0 = 10 ✓
Contador 5: 0 + 0 + 5 + 0 = 5  ✓

Total: 5 + 0 + 5 + 1 = 11
```

---

## Resultado Total do Teste

```
Máquina 1: 10 pressionamentos
Máquina 2: 12 pressionamentos
Máquina 3: 11 pressionamentos
─────────────────────────────
Total:     33 pressionamentos
```

---

## O Algoritmo: Programação Linear Inteira (ILP)

### Por que não usar força bruta?

Com valores que podem chegar a centenas, uma busca BFS ou força bruta exploraria bilhões de estados. Inviável!

### A solução: Simplex + Branch and Bound

#### 1. Relaxação Linear (Simplex)

Primeiro, ignoramos a restrição de que as variáveis devem ser inteiras. Resolvemos o problema como **programação linear contínua** usando o algoritmo **Simplex**.

O Simplex encontra rapidamente o mínimo da função objetivo, mas pode retornar valores fracionários (ex: `x1 = 2.5`).

#### 2. Branch and Bound

Se a solução do Simplex tem variáveis fracionárias, dividimos o problema:

```
Encontrou x1 = 2.5?

Cria dois subproblemas:
├── Subproblema A: adiciona restrição x1 <= 2
└── Subproblema B: adiciona restrição x1 >= 3
```

Recursivamente resolvemos cada subproblema. Podamos ramos que:
- Já têm custo maior que a melhor solução inteira encontrada
- São inviáveis (sem solução)

#### 3. Resultado

O algoritmo garante encontrar a **solução inteira ótima** em tempo razoável, explorando apenas uma fração do espaço de busca.

---

## Representação Matricial

Para o Exemplo 1, montamos a matriz de restrições:

```
Variáveis:  x1  x2  x3  x4  x5  x6  | RHS
──────────────────────────────────────────
Cont 0 >=:   0   0   0   0   1   1  |  3
Cont 1 >=:   0   1   0   0   0   1  |  5
Cont 2 >=:   0   0   1   1   1   0  |  4
Cont 3 >=:   1   1   0   1   0   0  |  7
Cont 0 <=:   0   0   0   0  -1  -1  | -3
Cont 1 <=:   0  -1   0   0   0  -1  | -5
Cont 2 <=:   0   0  -1  -1  -1   0  | -4
Cont 3 <=:  -1  -1   0  -1   0   0  | -7
x1 >= 0:    -1   0   0   0   0   0  |  0
x2 >= 0:     0  -1   0   0   0   0  |  0
...
```

O Simplex opera nesta matriz para encontrar a solução ótima.
