.data
msg1: .asciiz "Digite o primeiro numero: "     # Cria uma mensagem de texto na memória para pedir o primeiro número
msg2: .asciiz "Digite o segundo numero: "      # Cria uma mensagem de texto na memória para pedir o segundo número
msg3: .asciiz "Digite o terceiro numero: "     # Cria uma mensagem de texto na memória para pedir o terceiro número
resultado: .asciiz "\nMedia inteira: "         # Cria uma mensagem de texto na memória para mostrar o resultado final

.text                                           # Indica o início da área onde ficam as instruções do programa
.globl main                                     # Define o rótulo main como ponto principal do programa

main:                                           # Início da execução do programa

    li $v0, 4                                   # Coloca o código 4 em $v0 para solicitar impressão de texto
    la $a0, msg1                                # Carrega em $a0 o endereço da mensagem do primeiro número
    syscall                                     # Executa a impressão da mensagem armazenada em msg1

    li $v0, 5                                   # Coloca o código 5 em $v0 para solicitar leitura de número inteiro
    syscall                                     # Lê o primeiro número digitado pelo usuário e guarda em $v0
    move $t0, $v0                               # Copia o primeiro número de $v0 para o registrador $t0

    li $v0, 4                                   # Coloca o código 4 em $v0 para solicitar impressão de texto
    la $a0, msg2                                # Carrega em $a0 o endereço da mensagem do segundo número
    syscall                                     # Executa a impressão da mensagem armazenada em msg2

    li $v0, 5                                   # Coloca o código 5 em $v0 para solicitar leitura de número inteiro
    syscall                                     # Lê o segundo número digitado pelo usuário e guarda em $v0
    move $t1, $v0                               # Copia o segundo número de $v0 para o registrador $t1

    li $v0, 4                                   # Coloca o código 4 em $v0 para solicitar impressão de texto
    la $a0, msg3                                # Carrega em $a0 o endereço da mensagem do terceiro número
    syscall                                     # Executa a impressão da mensagem armazenada em msg3

    li $v0, 5                                   # Coloca o código 5 em $v0 para solicitar leitura de número inteiro
    syscall                                     # Lê o terceiro número digitado pelo usuário e guarda em $v0
    move $t2, $v0                               # Copia o terceiro número de $v0 para o registrador $t2

    add $t4, $t0, $t1                           # Soma o primeiro número com o segundo e guarda o resultado em $t4
    add $t4, $t4, $t2                           # Soma o terceiro número ao valor que já estava em $t4

    li $t5, 3                                   # Coloca o valor 3 em $t5 para ser usado como divisor
    div $t4, $t5                                # Divide a soma dos três números por 3

    mflo $t3                                    # Copia o quociente da divisão para $t3, que será a média inteira

    li $v0, 4                                   # Coloca o código 4 em $v0 para solicitar impressão de texto
    la $a0, resultado                           # Carrega em $a0 o endereço da mensagem de resultado
    syscall                                     # Executa a impressão da mensagem "Media inteira: "

    li $v0, 1                                   # Coloca o código 1 em $v0 para solicitar impressão de número inteiro
    move $a0, $t3                               # Copia a média inteira de $t3 para $a0, pois syscall usa $a0 para imprimir
    syscall                                     # Exibe no console o valor da média inteira

    li $v0, 10                                  # Coloca o código 10 em $v0 para encerrar o programa
    syscall                                     # Finaliza a execução do programa no MARS