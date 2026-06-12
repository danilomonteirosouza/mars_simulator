.data                         # Início da seção de dados

vetorA: .space 32             # Reserva 32 bytes para o vetor A
                              # 8 inteiros x 4 bytes = 32 bytes

vetorB: .space 32             # Reserva 32 bytes para o vetor B
                              # Também terá 8 inteiros

msgEntrada: .asciiz "Digite um numero: "
                              # Mensagem exibida antes da leitura

msgPares: .asciiz "Quantidade de pares: "
                              # Mensagem para mostrar total de pares

msgImpares: .asciiz "Quantidade de impares: "
                              # Mensagem para mostrar total de ímpares

quebra: .asciiz "\n"          # Quebra de linha


.text                         # Início da seção de código
.globl main                   # Define main como ponto inicial do programa

main:                         # Início do programa principal

    li $t0, 0                 # $t0 será o contador do loop de leitura
    la $t1, vetorA            # $t1 recebe o endereço inicial do vetor A

ler_loop:                     # Início do loop de leitura

    li $v0, 4                 # Código 4: imprimir string
    la $a0, msgEntrada        # Carrega a mensagem de entrada em $a0
    syscall                   # Exibe a mensagem na tela

    li $v0, 5                 # Código 5: ler inteiro
    syscall                   # Lê o número digitado
                              # O valor lido fica em $v0

    sw $v0, 0($t1)            # Armazena o número lido na posição atual do vetor A

    addi $t1, $t1, 4          # Avança para a próxima posição do vetor A
    addi $t0, $t0, 1          # Incrementa o contador

    li $t9, 8                 # Define o limite do loop como 8
    bne $t0, $t9, ler_loop    # Se contador diferente de 8, repete o loop


    li $t0, 0                 # Reinicia o contador para processar o vetor
    la $t1, vetorA            # $t1 volta para o início do vetor A
    la $t2, vetorB            # $t2 recebe o endereço inicial do vetor B

    li $t6, 0                 # $t6 contará os números pares
    li $t7, 0                 # $t7 contará os números ímpares

processar_loop:               # Início do loop de processamento

    lw $t3, 0($t1)            # Carrega em $t3 o valor atual do vetor A

    li $t4, 2                 # Coloca o número 2 em $t4
    div $t3, $t4              # Divide o valor de A por 2

    mfhi $t5                  # Pega o resto da divisão
                              # Se o resto for 0, o número é par
                              # Se o resto for 1, o número é ímpar

    beq $t5, $zero, eh_par    # Se o resto for 0, vai para eh_par

eh_impar:                     # Caso o número seja ímpar

    mul $t4, $t3, 3           # Multiplica o valor por 3
    sw $t4, 0($t2)            # Armazena o resultado no vetor B

    addi $t7, $t7, 1          # Incrementa o contador de ímpares

    j continuar               # Pula para continuar o loop

eh_par:                       # Caso o número seja par

    mul $t4, $t3, 2           # Multiplica o valor por 2
    sw $t4, 0($t2)            # Armazena o resultado no vetor B

    addi $t6, $t6, 1          # Incrementa o contador de pares

continuar:                    # Continuação comum para pares e ímpares

    addi $t1, $t1, 4          # Avança para a próxima posição do vetor A
    addi $t2, $t2, 4          # Avança para a próxima posição do vetor B

    addi $t0, $t0, 1          # Incrementa o contador do loop

    li $t9, 8                 # Define o limite como 8
    bne $t0, $t9, processar_loop
                              # Se ainda não processou 8 valores, repete


    li $t0, 0                 # Reinicia o contador para exibir o vetor B
    la $t2, vetorB            # $t2 volta para o início do vetor B

exibir_loop:                  # Início do loop de exibição

    lw $a0, 0($t2)            # Carrega o valor atual do vetor B em $a0

    li $v0, 1                 # Código 1: imprimir inteiro
    syscall                   # Exibe o valor do vetor B

    li $v0, 4                 # Código 4: imprimir string
    la $a0, quebra            # Carrega a quebra de linha
    syscall                   # Pula uma linha

    addi $t2, $t2, 4          # Avança para a próxima posição do vetor B
    addi $t0, $t0, 1          # Incrementa o contador

    li $t9, 8                 # Define o limite como 8
    bne $t0, $t9, exibir_loop # Se ainda não exibiu 8 valores, repete


    li $v0, 4                 # Código 4: imprimir string
    la $a0, msgPares          # Carrega a mensagem de pares
    syscall                   # Exibe "Quantidade de pares: "

    li $v0, 1                 # Código 1: imprimir inteiro
    add $a0, $t6, $zero       # Copia o contador de pares para $a0
    syscall                   # Exibe a quantidade de pares

    li $v0, 4                 # Código 4: imprimir string
    la $a0, quebra            # Carrega a quebra de linha
    syscall                   # Pula uma linha


    li $v0, 4                 # Código 4: imprimir string
    la $a0, msgImpares        # Carrega a mensagem de ímpares
    syscall                   # Exibe "Quantidade de impares: "

    li $v0, 1                 # Código 1: imprimir inteiro
    add $a0, $t7, $zero       # Copia o contador de ímpares para $a0
    syscall                   # Exibe a quantidade de ímpares


    li $v0, 10                # Código 10: finalizar programa
    syscall                   # Encerra a execução