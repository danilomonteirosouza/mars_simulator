.data
vetor: .space 40              # Reserva espaço para 10 inteiros
msgQtd: .asciiz "Digite 10 numeros inteiros:\n" # Mensagem inicial
msgNum: .asciiz "Numero: "    # Mensagem para entrada
msgMaior: .asciiz "\nMaior valor: " # Mensagem do maior valor
msgSoma: .asciiz "\nSoma dos pares: " # Mensagem da soma dos pares
msgFim: .asciiz "\nFim do programa.\n" # Mensagem final

.text
.globl main

main:
    li $v0, 4                 # Código syscall para imprimir string
    la $a0, msgQtd            # Carrega endereço da mensagem inicial
    syscall                   # Imprime a mensagem

    la $t0, vetor             # Carrega o endereço inicial do vetor
    li $t1, 0                 # Inicializa contador i = 0
    li $t2, 10                # Define limite do vetor como 10

leitura_loop:
    beq $t1, $t2, fim_leitura # Se i == 10, encerra leitura

    li $v0, 4                 # Código syscall para imprimir string
    la $a0, msgNum            # Carrega endereço da mensagem "Numero"
    syscall                   # Imprime a mensagem

    li $v0, 5                 # Código syscall para ler inteiro
    syscall                   # Lê o número digitado
    sw $v0, 0($t0)            # Grava o número lido na memória RAM

    addi $t0, $t0, 4          # Avança para a próxima posição do vetor
    addi $t1, $t1, 1          # Incrementa contador i
    j leitura_loop            # Retorna para o início do loop de leitura

fim_leitura:
    la $t0, vetor             # Retorna ao endereço inicial do vetor
    lw $t3, 0($t0)            # Lê o primeiro valor do vetor como maior
    li $t4, 0                 # Inicializa soma dos pares com 0
    li $t1, 0                 # Reinicia contador i = 0

processa_loop:
    beq $t1, $t2, fim_processa # Se i == 10, encerra o processamento

    lw $t5, 0($t0)            # Lê o valor atual do vetor da memória RAM

    ble $t5, $t3, nao_maior   # Se valor atual <= maior, pula atualização
    move $t3, $t5             # Atualiza o maior valor encontrado

nao_maior:
    li $t6, 2                 # Carrega divisor 2
    div $t5, $t6              # Divide valor atual por 2
    mfhi $t7                  # Obtém o resto da divisão

    bne $t7, $zero, impar     # Se resto != 0, o número é ímpar
    add $t4, $t4, $t5         # Soma o valor atual se ele for par

impar:
    addi $t0, $t0, 4          # Avança para a próxima posição do vetor
    addi $t1, $t1, 1          # Incrementa contador i
    j processa_loop           # Retorna para o início do loop de processamento

fim_processa:
    li $v0, 4                 # Código syscall para imprimir string
    la $a0, msgMaior          # Carrega mensagem do maior valor
    syscall                   # Imprime a mensagem

    li $v0, 1                 # Código syscall para imprimir inteiro
    move $a0, $t3             # Move maior valor para $a0
    syscall                   # Imprime o maior valor

    li $v0, 4                 # Código syscall para imprimir string
    la $a0, msgSoma           # Carrega mensagem da soma dos pares
    syscall                   # Imprime a mensagem

    li $v0, 1                 # Código syscall para imprimir inteiro
    move $a0, $t4             # Move soma dos pares para $a0
    syscall                   # Imprime a soma dos pares

    li $v0, 4                 # Código syscall para imprimir string
    la $a0, msgFim            # Carrega mensagem final
    syscall                   # Imprime mensagem final

    li $v0, 10                # Código syscall para encerrar programa
    syscall                   # Finaliza o programa
