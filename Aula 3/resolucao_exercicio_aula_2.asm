.data
msgEntrada: .asciiz "Digite o total de segundos: "
msgMin:     .asciiz "\nMinutos: "
msgSeg:     .asciiz "\nSegundos restantes: "

.text
.globl main

main:

    li $v0, 4               # Codigo da syscall para imprimir texto
    la $a0, msgEntrada      # Carrega a mensagem de entrada
    syscall                 # Exibe a mensagem para o usuario

    li $v0, 5               # Codigo da syscall para leitura de inteiro
    syscall                 # Le o valor digitado pelo usuario

    move $t0, $v0           # Copia o valor digitado para $t0

    li $t3, 60              # Armazena o valor 60 em $t3

    div $t0, $t3            # Divide o total de segundos por 60

    mflo $t1                # Copia o quociente da divisao para $t1
                             # $t1 armazenara os minutos

    mfhi $t2                # Copia o resto da divisao para $t2
                             # $t2 armazenara os segundos restantes

    li $v0, 4               # Codigo da syscall para imprimir texto
    la $a0, msgMin          # Carrega a mensagem "Minutos"
    syscall                 # Exibe a mensagem

    li $v0, 1               # Codigo da syscall para imprimir inteiro
    move $a0, $t1           # Move os minutos para $a0
    syscall                 # Exibe os minutos

    li $v0, 4               # Codigo da syscall para imprimir texto
    la $a0, msgSeg          # Carrega a mensagem "Segundos restantes"
    syscall                 # Exibe a mensagem

    li $v0, 1               # Codigo da syscall para imprimir inteiro
    move $a0, $t2           # Move os segundos restantes para $a0
    syscall                 # Exibe os segundos restantes

    li $v0, 10              # Codigo da syscall para encerrar o programa
    syscall                 # Finaliza o programa