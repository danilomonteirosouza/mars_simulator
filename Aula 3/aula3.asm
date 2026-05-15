.data
msg1: .asciiz "Digite o primeiro numero: "
msg2: .asciiz "Digite o segundo numero: "
msg3: .asciiz "Digite o terceiro numero: "

msgSoma: .asciiz "\nSoma: "
msgSub:  .asciiz "\nSubtracao: "
msgMult: .asciiz "\nMultiplicacao: "
msgDiv:  .asciiz "\nDivisao inteira: "
msgResto:.asciiz "\nResto da divisao: "
msgMedia:.asciiz "\nMedia inteira: "
msgExpr: .asciiz "\nResultado da expressao ((A + B) * C) - (A / B): "

.text
.globl main

main:
    li $v0, 4              # Define o codigo 4 em $v0 para imprimir texto
    la $a0, msg1           # Carrega o endereco da mensagem msg1 em $a0
    syscall                # Executa a impressao da mensagem

    li $v0, 5              # Define o codigo 5 em $v0 para ler um inteiro
    syscall                # Le o numero digitado pelo usuario
    move $t0, $v0          # Copia o primeiro numero lido para $t0

    li $v0, 4              # Define o codigo 4 para imprimir texto
    la $a0, msg2           # Carrega o endereco da mensagem msg2 em $a0
    syscall                # Exibe a segunda mensagem

    li $v0, 5              # Define o codigo 5 para leitura de inteiro
    syscall                # Le o segundo numero digitado
    move $t1, $v0          # Copia o segundo numero para $t1

    li $v0, 4              # Define o codigo 4 para imprimir texto
    la $a0, msg3           # Carrega o endereco da mensagem msg3 em $a0
    syscall                # Exibe a terceira mensagem

    li $v0, 5              # Define o codigo 5 para leitura de inteiro
    syscall                # Le o terceiro numero digitado
    move $t2, $v0          # Copia o terceiro numero para $t2

    add $t3, $t0, $t1      # Soma A + B e guarda o resultado em $t3

    sub $t4, $t0, $t1      # Subtrai A - B e guarda o resultado em $t4

    mul $t5, $t0, $t1      # Multiplica A * B e guarda o resultado em $t5

    div $t0, $t1           # Divide A por B; quociente vai para LO e resto vai para HI
    mflo $t6               # Copia o quociente da divisao para $t6
    mfhi $t7               # Copia o resto da divisao para $t7

    add $s0, $t0, $t1      # Soma A + B e guarda em $s0
    add $s0, $s0, $t2      # Soma o valor anterior com C, formando A + B + C
    li $s1, 3              # Coloca o valor 3 em $s1
    div $s0, $s1           # Divide A + B + C por 3
    mflo $s2               # Copia a media inteira para $s2

    add $s3, $t0, $t1      # Calcula A + B e guarda em $s3
    mul $s4, $s3, $t2      # Calcula (A + B) * C e guarda em $s4
    sub $s5, $s4, $t6      # Calcula ((A + B) * C) - (A / B) e guarda em $s5

    li $v0, 4              # Define impressao de texto
    la $a0, msgSoma        # Carrega a mensagem da soma
    syscall                # Exibe a mensagem da soma

    li $v0, 1              # Define impressao de inteiro
    move $a0, $t3          # Move o resultado da soma para $a0
    syscall                # Exibe o resultado da soma

    li $v0, 4              # Define impressao de texto
    la $a0, msgSub         # Carrega a mensagem da subtracao
    syscall                # Exibe a mensagem da subtracao

    li $v0, 1              # Define impressao de inteiro
    move $a0, $t4          # Move o resultado da subtracao para $a0
    syscall                # Exibe o resultado da subtracao

    li $v0, 4              # Define impressao de texto
    la $a0, msgMult        # Carrega a mensagem da multiplicacao
    syscall                # Exibe a mensagem da multiplicacao

    li $v0, 1              # Define impressao de inteiro
    move $a0, $t5          # Move o resultado da multiplicacao para $a0
    syscall                # Exibe o resultado da multiplicacao

    li $v0, 4              # Define impressao de texto
    la $a0, msgDiv         # Carrega a mensagem da divisao inteira
    syscall                # Exibe a mensagem da divisao

    li $v0, 1              # Define impressao de inteiro
    move $a0, $t6          # Move o quociente da divisao para $a0
    syscall                # Exibe o quociente

    li $v0, 4              # Define impressao de texto
    la $a0, msgResto       # Carrega a mensagem do resto
    syscall                # Exibe a mensagem do resto

    li $v0, 1              # Define impressao de inteiro
    move $a0, $t7          # Move o resto da divisao para $a0
    syscall                # Exibe o resto

    li $v0, 4              # Define impressao de texto
    la $a0, msgMedia       # Carrega a mensagem da media
    syscall                # Exibe a mensagem da media

    li $v0, 1              # Define impressao de inteiro
    move $a0, $s2          # Move a media inteira para $a0
    syscall                # Exibe a media

    li $v0, 4              # Define impressao de texto
    la $a0, msgExpr        # Carrega a mensagem da expressao composta
    syscall                # Exibe a mensagem da expressao

    li $v0, 1              # Define impressao de inteiro
    move $a0, $s5          # Move o resultado da expressao para $a0
    syscall                # Exibe o resultado da expressao

    li $v0, 10             # Define o codigo 10 para encerrar o programa
    syscall                # Finaliza a execucao