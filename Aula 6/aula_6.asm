.data                              # Início da seção de dados

vetorA: .space 40                  # Reserva 40 bytes para o vetorA
                                   # Cada inteiro ocupa 4 bytes
                                   # 10 inteiros x 4 bytes = 40 bytes

msgSoma: .asciz "Soma dos valores: "
                                   # Mensagem para exibir a soma

msgPositivos: .asciz "Quantidade de positivos: "
                                   # Mensagem para exibir a quantidade de positivos

msgNegativos: .asciz "Quantidade de negativos: "
                                   # Mensagem para exibir a quantidade de negativos

msgZeros: .asciz "Quantidade de zeros: "
                                   # Mensagem para exibir a quantidade de zeros

msgMaior: .asciz "Maior valor: "
                                   # Mensagem para exibir o maior valor

msgMenor: .asciz "Menor valor: "
                                   # Mensagem para exibir o menor valor

quebra: .asciz "\n"                # String usada para pular linha


.text                              # Início da seção de código

.globl main                        # Define o rótulo main como início do programa

main:                              # Início da função principal

    li t0, 0                       # t0 será o contador do loop de leitura

    la t1, vetorA                  # t1 recebe o endereço inicial do vetorA


leitura_loop:                      # Início do loop de leitura dos 10 números

    li a7, 5                       # Código 5 no RARS: ler um número inteiro

    ecall                          # Executa a leitura do inteiro digitado
                                   # O valor lido fica armazenado em a0

    sw a0, 0(t1)                   # Armazena o número lido na posição atual do vetorA

    addi t1, t1, 4                 # Avança o endereço do vetorA para a próxima posição

    addi t0, t0, 1                 # Incrementa o contador de leitura

    li t2, 10                      # t2 recebe o limite do loop, que é 10

    bne t0, t2, leitura_loop       # Se t0 for diferente de 10, repete o loop


    li t0, 0                       # Reinicia t0 para ser usado no loop de processamento

    la t1, vetorA                  # t1 volta a apontar para o início do vetorA

    li t3, 0                       # t3 armazenará a soma dos valores

    li t4, 0                       # t4 contará a quantidade de números positivos

    li t5, 0                       # t5 contará a quantidade de números negativos

    li t6, 0                       # t6 contará a quantidade de zeros

    lw s0, 0(t1)                   # s0 recebe o primeiro valor do vetor
                                   # Esse valor será usado como maior valor inicial

    lw s1, 0(t1)                   # s1 recebe o primeiro valor do vetor
                                   # Esse valor será usado como menor valor inicial


processamento_loop:                # Início do loop que percorre o vetorA

    lw s2, 0(t1)                   # s2 recebe o valor atual do vetorA

    add t3, t3, s2                 # Soma o valor atual ao acumulador da soma

    beq s2, zero, eh_zero          # Se o valor atual for igual a zero, vai para eh_zero

    blt s2, zero, eh_negativo      # Se o valor atual for menor que zero, vai para eh_negativo


eh_positivo:                       # Trecho executado quando o número é positivo

    addi t4, t4, 1                 # Incrementa o contador de positivos

    j verificar_maior_menor        # Vai para a etapa de verificar maior e menor


eh_negativo:                       # Trecho executado quando o número é negativo

    addi t5, t5, 1                 # Incrementa o contador de negativos

    j verificar_maior_menor        # Vai para a etapa de verificar maior e menor


eh_zero:                           # Trecho executado quando o número é zero

    addi t6, t6, 1                 # Incrementa o contador de zeros


verificar_maior_menor:             # Início da verificação de maior e menor valor

    bgt s2, s0, atualizar_maior    # Se o valor atual for maior que s0, vai atualizar o maior

    j verificar_menor              # Caso contrário, vai verificar o menor


atualizar_maior:                   # Trecho usado para atualizar o maior valor

    add s0, s2, zero               # Copia o valor atual para s0
                                   # s0 passa a guardar o novo maior valor


verificar_menor:                   # Início da verificação do menor valor

    blt s2, s1, atualizar_menor    # Se o valor atual for menor que s1, vai atualizar o menor

    j continuar_processamento      # Caso contrário, continua o loop


atualizar_menor:                   # Trecho usado para atualizar o menor valor

    add s1, s2, zero               # Copia o valor atual para s1
                                   # s1 passa a guardar o novo menor valor


continuar_processamento:           # Continuação do loop de processamento

    addi t1, t1, 4                 # Avança para a próxima posição do vetorA

    addi t0, t0, 1                 # Incrementa o contador do loop de processamento

    li t2, 10                      # t2 recebe o limite do loop, que é 10

    bne t0, t2, processamento_loop # Se t0 for diferente de 10, processa o próximo valor


    li a7, 4                       # Código 4 no RARS: imprimir string

    la a0, msgSoma                 # Carrega a mensagem da soma em a0

    ecall                          # Exibe a mensagem "Soma dos valores: "

    li a7, 1                       # Código 1 no RARS: imprimir inteiro

    add a0, t3, zero               # Copia a soma para a0

    ecall                          # Exibe o valor da soma

    li a7, 4                       # Código 4: imprimir string

    la a0, quebra                  # Carrega a quebra de linha

    ecall                          # Pula uma linha


    li a7, 4                       # Código 4: imprimir string

    la a0, msgPositivos            # Carrega a mensagem dos positivos

    ecall                          # Exibe a mensagem "Quantidade de positivos: "

    li a7, 1                       # Código 1: imprimir inteiro

    add a0, t4, zero               # Copia a quantidade de positivos para a0

    ecall                          # Exibe a quantidade de positivos

    li a7, 4                       # Código 4: imprimir string

    la a0, quebra                  # Carrega a quebra de linha

    ecall                          # Pula uma linha


    li a7, 4                       # Código 4: imprimir string

    la a0, msgNegativos            # Carrega a mensagem dos negativos

    ecall                          # Exibe a mensagem "Quantidade de negativos: "

    li a7, 1                       # Código 1: imprimir inteiro

    add a0, t5, zero               # Copia a quantidade de negativos para a0

    ecall                          # Exibe a quantidade de negativos

    li a7, 4                       # Código 4: imprimir string

    la a0, quebra                  # Carrega a quebra de linha

    ecall                          # Pula uma linha


    li a7, 4                       # Código 4: imprimir string

    la a0, msgZeros                # Carrega a mensagem dos zeros

    ecall                          # Exibe a mensagem "Quantidade de zeros: "

    li a7, 1                       # Código 1: imprimir inteiro

    add a0, t6, zero               # Copia a quantidade de zeros para a0

    ecall                          # Exibe a quantidade de zeros

    li a7, 4                       # Código 4: imprimir string

    la a0, quebra                  # Carrega a quebra de linha

    ecall                          # Pula uma linha


    li a7, 4                       # Código 4: imprimir string

    la a0, msgMaior                # Carrega a mensagem do maior valor

    ecall                          # Exibe a mensagem "Maior valor: "

    li a7, 1                       # Código 1: imprimir inteiro

    add a0, s0, zero               # Copia o maior valor para a0

    ecall                          # Exibe o maior valor

    li a7, 4                       # Código 4: imprimir string

    la a0, quebra                  # Carrega a quebra de linha

    ecall                          # Pula uma linha


    li a7, 4                       # Código 4: imprimir string

    la a0, msgMenor                # Carrega a mensagem do menor valor

    ecall                          # Exibe a mensagem "Menor valor: "

    li a7, 1                       # Código 1: imprimir inteiro

    add a0, s1, zero               # Copia o menor valor para a0

    ecall                          # Exibe o menor valor


    li a7, 10                      # Código 10 no RARS: finalizar o programa

    ecall                          # Encerra a execução