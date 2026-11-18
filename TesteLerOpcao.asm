.data
msg1:       .asciiz "Teste 1 (digite 0 a 2): "
msg2:       .asciiz "Teste 2 (digite 1 a 5): "
s_invalida: .asciiz "Opcao invalida. Digite um numero de 0 a 2.\n"
s_ret:      .asciiz "Valor retornado em $v0: "
s_nl:       .asciiz "\n\n"
buf:        .space 16

.text
.globl main

main:
    # --- Chamada 1: intervalo [0, 2] ---
    la    $a0, msg1              # mensagem
    li    $a1, 0                 # minimo = 0
    li    $a2, 2                 # maximo = 2
    jal   lerOpcao

    move  $t0, $v0               # salva o retorno antes de usar $v0 nas syscalls

    la    $a0, s_ret
    li    $v0, 4                 # imprime texto de retorno
    syscall

    move  $a0, $t0
    li    $v0, 1                 # syscall 1: imprime o inteiro retornado
    syscall

    la    $a0, s_nl
    li    $v0, 4
    syscall

    # --- Chamada 2: intervalo [1, 5] ---
    la    $a0, msg2              # mensagem
    li    $a1, 1                 # minimo = 1
    li    $a2, 5                 # maximo = 5
    jal   lerOpcao

    move  $t0, $v0               # salva o retorno

    la    $a0, s_ret
    li    $v0, 4
    syscall

    move  $a0, $t0
    li    $v0, 1                 # imprime o inteiro retornado
    syscall

    li    $v0, 10                # encerra o teste
    syscall


# Procedimento lerOpcao

lerOpcao:
    addiu $sp, $sp, -16
    sw    $ra, 0($sp)
    sw    $s0, 4($sp)
    sw    $s1, 8($sp)
    sw    $s2, 12($sp)

    move  $s0, $a0               # guarda endereco da mensagem
    move  $s1, $a1               # guarda valor minimo
    move  $s2, $a2               # guarda valor maximo

lerOpcao_loop:
    move  $a0, $s0               # carrega mensagem
    li    $v0, 4                 # syscall 4: imprimir string
    syscall

    la    $a0, buf               # endereco do buffer
    li    $a1, 16                # tamanho maximo de leitura
    li    $v0, 8                 # syscall 8: ler string
    syscall

    la    $t2, buf
    lb    $t0, 0($t2)            # primeiro caractere digitado
    lb    $t1, 1($t2)            # segundo caractere (espera-se '\n' ou 0)

    addi  $t3, $s1, 48           # converte minimo para ASCII ('0' = 48)
    addi  $t4, $s2, 48           # converte maximo para ASCII

    blt   $t0, $t3, lerOpcao_inv # invalido se menor que o minimo
    bgt   $t0, $t4, lerOpcao_inv # invalido se maior que o maximo

    li    $t5, 10                # codigo ASCII do '\n' (Enter)
    beq   $t1, $t5, lerOpcao_ok  # valido se o proximo for '\n'
    beqz  $t1, lerOpcao_ok       # valido se o proximo for fim de string (0)

lerOpcao_inv:
    la    $a0, s_invalida        # carrega mensagem de erro
    li    $v0, 4                 # imprime erro
    syscall
    j     lerOpcao_loop          # repete a leitura

lerOpcao_ok:
    subi  $v0, $t0, 48           # converte ASCII para inteiro e retorna em $v0

    lw    $ra, 0($sp)
    lw    $s0, 4($sp)
    lw    $s1, 8($sp)
    lw    $s2, 12($sp)
    addiu $sp, $sp, 16
    jr    $ra