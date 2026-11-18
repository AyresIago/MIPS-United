.data
modo_teste:  .word 1
seq_sorteio: .word 59, 70, 45, 30, 50, 60

s_teste1:    .asciiz "Teste 1 (esperado 59): "
s_teste2:    .asciiz "\nTeste 2 (esperado 70): "
s_aleat1:    .asciiz "\nAleatorio 1 (0 a 99): "
s_aleat2:    .asciiz "\nAleatorio 2 (0 a 99): "

.text
.globl main

main:
    # Teste 1: modo_teste = 1, turno = 0
    la    $a0, s_teste1
    li    $v0, 4
    syscall

    li    $a0, 0                 # turno 0
    la    $a1, seq_sorteio       # vetor
    li    $a2, 100               # limite
    jal   sortear

    move  $a0, $v0               # imprime retorno
    li    $v0, 1
    syscall

    # Teste 2: modo_teste = 1, turno = 1
    la    $a0, s_teste2
    li    $v0, 4
    syscall

    li    $a0, 1                 # turno 1
    la    $a1, seq_sorteio
    li    $a2, 100
    jal   sortear

    move  $a0, $v0
    li    $v0, 1
    syscall

    # Muda para modo aleatorio
    la    $t0, modo_teste
    sw    $zero, 0($t0)          # modo_teste = 0

    # Semente aleatoria
    li    $v0, 30                # hora do sistema
    syscall
    move  $a1, $a0
    li    $a0, 0
    li    $v0, 40                # define semente
    syscall

    # Teste 3: aleatorio 1
    la    $a0, s_aleat1
    li    $v0, 4
    syscall

    li    $a0, 0
    la    $a1, seq_sorteio
    li    $a2, 100
    jal   sortear

    move  $a0, $v0
    li    $v0, 1
    syscall

    # Teste 4: aleatorio 2
    la    $a0, s_aleat2
    li    $v0, 4
    syscall

    li    $a0, 1
    la    $a1, seq_sorteio
    li    $a2, 100
    jal   sortear

    move  $a0, $v0
    li    $v0, 1
    syscall

    li    $v0, 10                # fim
    syscall

sortear:
    la    $t0, modo_teste        # endereco de modo_teste
    lw    $t1, 0($t0)            # le modo_teste
    beqz  $t1, sortear_aleat     # se 0, sorteia aleatorio

    sll   $t2, $a0, 2            # turno * 4
    add   $t2, $a1, $t2          # base + deslocamento
    lw    $v0, 0($t2)            # retorna seq[turno]
    jr    $ra

sortear_aleat:
    move  $a1, $a2               # limite maximo
    li    $a0, 0                 # gerador 0
    li    $v0, 42                # numero aleatorio
    syscall
    move  $v0, $a0               # retorno em $v0
    jr    $ra