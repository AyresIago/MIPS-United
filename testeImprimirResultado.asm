.data
s_venceu:  .asciiz "VOCE venceu!\n"
s_perdeu:  .asciiz "VOCE perdeu!\n"
s_empate:  .asciiz "Empate!\n"

# estado[0] = gols do jogador
# estado[2] = gols do computador
estado:    .word 7, 0, 3

.text
.globl main

main:
    jal imprimirResultado

    li $v0, 10
    syscall

imprimirResultado:
    la $t0, estado
    lw $t1, 0($t0)
    lw $t2, 8($t0)

    blt $t1, $t2, resultado_perdeu
    bgt $t1, $t2, resultado_venceu

resultado_empate:
    li $v0, 4
    la $a0, s_empate
    syscall
    jr $ra

resultado_venceu:
    li $v0, 4
    la $a0, s_venceu
    syscall
    jr $ra

resultado_perdeu:
    li $v0, 4
    la $a0, s_perdeu
    syscall
    jr $ra
