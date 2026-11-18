# Futebol MIPS

Simulador de uma partida de futebol por turnos, escrito em Assembly MIPS para
o simulador **MARS**. O jogador escolhe uma jogada em cada lance; o programa
resolve o resultado usando uma matriz de probabilidades e atualiza o placar.

## Como executar

1. Abra `FutebolMIPS.asm` no MARS.
2. Selecione **Assemble** e depois **Go**.
3. Escolha um modo:
   - `1`: modo de teste, com os seis lances e sorteios fixos documentados em
     [docs/testes.md](docs/testes.md).
   - `2`: partida aleatoria, com sorteios gerados pelo MARS.
   - `0`: sair.
4. Em cada lance, digite `1` ou `2` para escolher uma jogada, ou `0` para
   encerrar a partida.

As entradas precisam ser um unico digito entre `0` e `2`. Letras, linhas
vazias e entradas com mais de um caractere sao recusadas.

## Regras

Cada partida tem seis turnos de 15 minutos. O sorteio da jogada vai de 0 a 99;
a jogada tem sucesso quando esse valor e menor que sua chance.

| Lance | Jogada 1 | Jogada 2 |
| --- | --- | --- |
| Contra-ataque | Tocar rapido (60%) | Chutar de longe (30%) |
| Falta na entrada da area | Bater direto (40%) | Cruzar na area (50%) |
| Ataque do adversario | Falta tatica (100%, recebe amarelo) | Desarme limpo (60%) |
| Escanteio | Cobrar na area (40%) | Jogada ensaiada (55%) |

Uma falta tatica recebe cartao amarelo. O segundo amarelo resulta em expulsao,
gol de penalti do adversario e zeragem dos cartoes. No ataque adversario, um
desarme limpo bem-sucedido recupera a bola; se falhar, o adversario marca.

Veja [docs/testes.md](docs/testes.md) para os cenarios reproduziveis e os
resultados esperados.
