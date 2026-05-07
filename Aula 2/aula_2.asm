# Aula 2 - Arquitetura MIPS e Interface do MARS
# Objetivo: demonstrar registradores, operacoes aritmeticas e saida no console

.data
mensagem1: .asciiz "Valor de A: "
mensagem2: .asciiz "\nValor de B: "
mensagem3: .asciiz "\nSoma A + B: "
mensagem4: .asciiz "\nSubtracao A - B: "
mensagem5: .asciiz "\nMultiplicacao A * B: "

.text
.globl main

main:
    # Carrega valores imediatos nos registradores
    li $t0, 10          # $t0 recebe o valor 10
    li $t1, 5           # $t1 recebe o valor 5

    # Soma
    add $t2, $t0, $t1   # $t2 = $t0 + $t1

    # Subtracao
    sub $t3, $t0, $t1   # $t3 = $t0 - $t1

    # Multiplicacao
    mul $t4, $t0, $t1   # $t4 = $t0 * $t1

    # Exibe "Valor de A:"
    li $v0, 4
    la $a0, mensagem1
    syscall

    # Exibe valor de A
    li $v0, 1
    move $a0, $t0
    syscall

    # Exibe "Valor de B:"
    li $v0, 4
    la $a0, mensagem2
    syscall

    # Exibe valor de B
    li $v0, 1
    move $a0, $t1
    syscall

    # Exibe resultado da soma
    li $v0, 4
    la $a0, mensagem3
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    # Exibe resultado da subtracao
    li $v0, 4
    la $a0, mensagem4
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

    # Exibe resultado da multiplicacao
    li $v0, 4
    la $a0, mensagem5
    syscall

    li $v0, 1
    move $a0, $t4
    syscall

    # Encerra o programa
    li $v0, 10
    syscall
