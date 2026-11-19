.data
s_linha:   .asciiz "\n"
s_tempo:   .asciiz "TEMPO "
s_min:     .asciiz " min"
s_jogador: .asciiz "JOGADOR "
s_x:       .asciiz " x "
s_cpu:     .asciiz " COMPUTADOR"

# estado[0] = gols do jogador
# estado[1] = reserva
# estado[2] = gols do computador
# estado[3] = tempo
estado:    .word 7, 0, 3, 30

.text
.globl main

main:
    jal imprimirPlacar

    li $v0, 10
    syscall

imprimirPlacar:
    li $v0, 4
    la $a0, s_jogador
    syscall

    lw $a0, estado
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, s_x
    syscall

    la $t0, estado
    lw $a0, 8($t0)
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, s_cpu
    syscall

    li $v0, 4
    la $a0, s_linha
    syscall

    li $v0, 4
    la $a0, s_tempo
    syscall

    lw $a0, 12($t0)
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, s_min
    syscall

    li $v0, 4
    la $a0, s_linha
    syscall

    jr $ra