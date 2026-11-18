# Testes reproduziveis

Execute `FutebolMIPS.asm` no MARS, escolha o modo `1` e informe as jogadas
listadas em cada cenario. No modo de teste, os eventos por turno sao
`0, 2, 1, 2, 3, 0` e os sorteios sao `59, 70, 45, 30, 50, 60`.

## Teste 1: partida completa

Entradas: `1` (modo), depois `1, 1, 2, 2, 2, 1` (jogadas).

| Turno | Evento | Jogada | Resultado |
| --- | --- | --- | --- |
| 1 | Contra-ataque, sorteio 59 | Tocar rapido (60%) | Gol do jogador; 1 x 0 |
| 2 | Ataque adversario, sorteio 70 | Falta tatica (100%) | Cartao amarelo; 1 x 0 |
| 3 | Falta, sorteio 45 | Cruzar na area (50%) | Gol do jogador; 2 x 0 |
| 4 | Ataque adversario, sorteio 30 | Desarme limpo (60%) | Recupera a bola; 2 x 0 |
| 5 | Escanteio, sorteio 50 | Jogada ensaiada (55%) | Gol do jogador; 3 x 0 |
| 6 | Contra-ataque, sorteio 60 | Tocar rapido (60%) | Falha, pois 60 nao e menor que 60 |

Placar final: **3 x 0**, um cartao amarelo, vitoria do jogador.

## Teste 2: validacao e encerramento antecipado

No prompt do modo, teste `abc`, `5`, uma linha vazia e `12`. Cada entrada deve
ser recusada sem iniciar a partida; o prompt deve ser exibido novamente.
Digite `1` para iniciar e, no primeiro lance, escolha `1` para marcar o gol.
No lance seguinte, digite `0`.

O programa mostra o placar **1 x 0** aos 15 minutos e informa que a partida foi
encerrada pelo usuario. As entradas recusadas nao alteram o estado do jogo.

## Teste 3: segundo amarelo e limite da chance

Entradas: `1` (modo), depois `1, 1, 1, 1, 1, 1` (jogadas).

| Turno | Evento | Sorteio e chance | Resultado |
| --- | --- | --- | --- |
| 1 | Contra-ataque | 59 < 60 | Gol do jogador; 1 x 0 |
| 2 | Ataque adversario | Falta tatica (100%) | Primeiro amarelo |
| 3 | Falta | 45 nao e < 40 | Jogada falha |
| 4 | Ataque adversario | Falta tatica (100%) | Segundo amarelo, expulsao e gol de penalti; 1 x 1 |
| 5 | Escanteio | 50 nao e < 40 | Jogada falha |
| 6 | Contra-ataque | 60 nao e < 60 | Jogada falha |

Placar final: **1 x 1**, cartoes zerados e empate.

## Estrutura dos dados

- `estado`: gols do jogador, gols do computador, cartoes e tempo, nessa ordem.
- `chances`: matriz de probabilidades 4 x 2 indexada por evento e jogada.
- `seq_evento` e `seq_sorteio`: vetores dos dados fixos do modo de teste.
- `txt_evento`, `txt_jogada`, `txt_sucesso` e `txt_falha`: vetores de textos.

O programa roda apenas com as syscalls do MARS descritas no codigo-fonte; nao
usa arquivos ou bibliotecas externas durante a partida.
