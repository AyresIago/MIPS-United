lerOpcao:
    addiu $sp, $sp, -16
    sw    $ra, 0($sp)
    sw    $s0, 4($sp)
    sw    $s1, 8($sp)
    sw    $s2, 12($sp)

    move  $s0, $a0
    move  $s1, $a1
    move  $s2, $a2

lerOpcao_loop:
    move  $a0, $s0
    li    $v0, 4
    syscall

    la    $a0, buf
    li    $a1, 16
    li    $v0, 8
    syscall

    la    $t2, buf
    lb    $t0, 0($t2)
    lb    $t1, 1($t2)

    addi  $t3, $s1, 48
    addi  $t4, $s2, 48

    blt   $t0, $t3, lerOpcao_inv
    bgt   $t0, $t4, lerOpcao_inv

    li    $t5, 10
    beq   $t1, $t5, lerOpcao_ok
    beqz  $t1, lerOpcao_ok

lerOpcao_inv:
    la    $a0, s_invalida
    li    $v0, 4
    syscall
    j     lerOpcao_loop

lerOpcao_ok:
    subi  $v0, $t0, 48

    lw    $ra, 0($sp)
    lw    $s0, 4($sp)
    lw    $s1, 8($sp)
    lw    $s2, 12($sp)
    addiu $sp, $sp, 16
    jr    $ra