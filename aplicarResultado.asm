# ============================================================
#  ESQUELETO - FUTEBOL MIPS (MVP) - MARS
#  Preencha os TODO um procedimento por vez e teste a cada um.
#
#  Convencao:
#    argumentos em $a0-$a3, retorno em $v0
#    $t0-$t9 = temporarios (nao sobrevivem a um jal)
#    $s0-$s7 = valores que precisam sobreviver a um jal
#              -> salvar na pilha no inicio e restaurar no fim
#    procedimento que chama outro (jal) tambem salva $ra
#
#  Syscalls usadas:
#    1 print int | 4 print string | 8 read string | 10 exit
#    30 hora do sistema | 32 sleep (ms) | 40 semente | 42 inteiro aleatorio
# ============================================================

#constantes
.eqv N_TURNOS   6
.eqv MIN_TURNO  15
.eqv FIM_JOGO   90
.eqv PAUSA_MS   1500

.data
#textos do jogo
s_titulo:   .asciiz "MIPS United\n"
s_modo:     .asciiz "Modo de teste (sorteios fixos)? 1-Sim 2-Nao 0-Sair: "
s_acao:     .asciiz "Acao (0 = sair): "
s_invalida: .asciiz "Opcao invalida. Digite um numero de 0 a 2.\n"
s_tchau:    .asciiz "Ate a proxima!\n"
s_saiu:     .asciiz "\nPartida encerrada pelo usuario.\n"
s_linha:    .asciiz "\n-------------------------------\n"
s_tempo:    .asciiz "        TEMPO: "
s_min:      .asciiz " MIN\n   JOGADOR "
s_x:        .asciiz " x "
s_cpu:      .asciiz " CPU\n   Cartoes amarelos: "
s_venceu:   .asciiz "\nSOA O APITO FINAL!\nVOCE VENCEU A PARTIDA!\n"
s_perdeu:   .asciiz "\nE eh PONTO FINAL! VOCE PERDEU...\n"
s_empate:   .asciiz "\nFIM DE PAPO! EMPATE SUADO!\n"
s_expulso:  .asciiz ">>> SEGUNDO AMARELO! EXPULSAO! O adversario marca de penalti.\n"
s_seta:     .asciiz "\n>>> "
s_nl:       .asciiz "\n"
s_traco:    .asciiz " - "
s_abre:     .asciiz " ("
s_fecha:    .asciiz "%)\n"

s_ev0:  .asciiz "\n> EH CONTRA-ATAQUE! A defesa adversaria esta desarrumada.\n"
s_ev1:  .asciiz "\n> FALTA NA ENTRADA DA AREA!\n"
s_ev2:  .asciiz "\n> SITUACAO DE PERIGO! O adversario esta invadindo sua area!\n"
s_ev3:  .asciiz "\n> TIRO DE CANTO para seu time!\n"

s_j00:  .asciiz "Tocar rapido"
s_j01:  .asciiz "Chutar de longe"
s_j10:  .asciiz "Bater direto pro gol"
s_j11:  .asciiz "Cruzar na area"
s_j20:  .asciiz "Falta tatica para interromper a jogada"
s_j21:  .asciiz "Tentar desarmar limpo"
s_j30:  .asciiz "Cobrar na area"
s_j31:  .asciiz "Jogada ensaiada curta"

s_ok00: .asciiz "BELO GOL DEPOIS DE UM BOM PASSE!\n"
s_ok01: .asciiz "UM GOLACO DE FORA DA AREA!\n"
s_ok10: .asciiz "NA GAVETA! GOL DE FALTA!\n"
s_ok11: .asciiz "CABECADA PRO FUNDO DA REDE! GOL!\n"
s_ok20: .asciiz "Voce parou o ataque, mas tomou CARTAO AMARELO!\n"
s_ok21: .asciiz "DESARME PERFEITO! Voce recuperou a bola.\n"
s_ok30: .asciiz "GOL DE CABECA APOS COBRANCA!\n"
s_ok31: .asciiz "JOGADA INTELIGENTE! Chute cruzado e GOL!\n"

s_f0:   .asciiz "O goleiro defendeu e a zaga cortou!\n"
s_f1:   .asciiz "A bola bateu na barreira ou foi para fora.\n"
s_f2:   .asciiz "QUE DRIBLE DESCONCERTANTE!E EH GOL DO ADVERSARIO!\n"
s_f3:   .asciiz "A zaga afastou o perigo.\n"

# dados (alinhados em palavra)
.align 2
# estado: 0 - gols jogador, 4 - gols CPU, 8 - cartoes, 12 - tempo
estado:      .word 0, 0, 0, 0

# matriz 4x2 de chances (%), linha = evento, coluna = jogada - 1
# endereco de chances[ev][j-1] = chances + (ev*2 + (j-1)) * 4
chances:     .word 60, 30,   40, 50,   100, 60,   40, 55

# modo de teste: um valor por turno
seq_evento:  .word 0, 2, 1, 2, 3, 0
seq_sorteio: .word 59, 70, 45, 30, 50, 60
modo_teste:  .word 0

# vetores de enderecos de strings (mesmo indice da matriz)
txt_evento:  .word s_ev0, s_ev1, s_ev2, s_ev3
txt_jogada:  .word s_j00, s_j01, s_j10, s_j11, s_j20, s_j21, s_j30, s_j31
txt_sucesso: .word s_ok00, s_ok01, s_ok10, s_ok11, s_ok20, s_ok21, s_ok30, s_ok31
txt_falha:   .word s_f0, s_f1, s_f2, s_f3

buf:         .space 16          # linha lida pela syscall 8

.text
.globl main

#aqui eh onde narra o evento e atualiza o vetor de gols e cartões
aplicarResultado:
  move $t0, $a0

    li $v0, 4
    la $a0, s_seta
    syscall

    #verificar sucesso da jogada
    beqz $a2, falhou
    
    #evento * 2
    sll $t2, $t0, 1

    #jogada - 1
    li $t3, 1
    sub $t4, $a1, $t3

    #deslocamneto = (evento * 2 +(jogada-1))*4
    add $t5, $t2, $t4
    sll $t6, $t5, 2
    
    la $t8, txt_sucesso
    add $t8, $t8, $t6

    lw $t7, 0($t8)
    li $v0, 4
    move $a0, $t7 #imprime a frase de falha
    syscall
    
    #evento != 2 ?
    bne $t0, 2, gol_jogador

    beq $a1, 1, falta_tatica
    jr $ra

    falta_tatica:
      la $t9, estado
      lw $t1, 8($t9)
      addi $t1, $t1, 1
      sw $t1, 8($t9)

      la $t9, estado
      lw $t1, 8($t9)

      blt $t1, 2, amarelo 
      
      #jogador expulso
      li $v0, 4
      la $a0, s_expulso
      syscall
      
      la $t9, estado
      lw $t1, 4($t9)
      addi $t1, $t1, 1
      sw $t1, 4($t9)
      
      #zerando a contagem de cartoes
      sw $zero, 8($t9)
      jr $ra

      #somente amarelo
      amarelo:
        jr $ra

    gol_jogador:
      la $t9, estado
      lw $t1, 0($t9)
      addi $t1, $t1, 1
      sw $t1, 0($t9)
      jr $ra

      falhou:
      #txt_falha:   .word s_f0, s_f1, s_f2, s_f3
      #s_f0:   .asciiz "O goleiro defendeu e a zaga cortou!\n"
      #s_f1:   .asciiz "A bola bateu na barreira ou foi para fora.\n"
      #s_f2:   .asciiz "QUE DRIBLE DESCONCERTANTE!E EH GOL DO ADVERSARIO!\n"
      #s_f3:   .asciiz "A zaga afastou o perigo.\n"

        #calculando offset para acessar a frase do txt_falha
        li $t6, 2
        sll $t2, $t0, 2 #multiplicando o número do evento por 4

        la $t3, txt_falha
        add $t4, $t3, $t2 #somando com o endereço base de txt_falha

        lw $t5, 0($t4)
        li $v0, 4
        move $a0, $t5 #imprime a frase de falha
        syscall

        beq $t0, $t6, ataque_cpu
        jr $ra

        ataque_cpu:
          #adiciona 1 ao numero de gols da cpu
          la $t7, estado
          lw $t8, 4($t7)
          addi $t8, $t8, 1
          sw $t8, 4($t7)

          jr $ra