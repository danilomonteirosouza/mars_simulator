# ====================================================================================
# SECÇÃO DE DADOS (.data)
# Aqui declaramos o vetor que queremos ordenar e as mensagens a exibir no ecrã.
# ====================================================================================
.data
    # Vetor pré-definido com 7 números desordenados. A diretiva '.word' aloca 4 bytes por número.
    vetor:      .word 64, 34, 25, 12, 22, 11, 90  
    tamanho:    .word 7                           # Variável para guardar o tamanho do vetor
    
    msg_antes:  .asciiz "Vetor original: \n"
    msg_depois: .asciiz "\n\nVetor ordenado (Bubble Sort): \n"
    msg_espaco: .asciiz "  "

# ====================================================================================
# SECÇÃO DE CÓDIGO (.text)
# ====================================================================================
.text
.globl main

main:
    # --------------------------------------------------------------------------------
    # PASSO 1: IMPRIMIR O VETOR ORIGINAL (ANTES DA ORDENAÇÃO)
    # --------------------------------------------------------------------------------
    li $v0, 4                               # Syscall para imprimir texto
    la $a0, msg_antes                       
    syscall

    la $a0, vetor                           # Passa o endereço base do vetor para impressão
    lw $a1, tamanho                         # Passa o tamanho do vetor
    jal imprimir_vetor                      # Salta e guarda o retorno (Jump and Link) para a função de imprimir

    # --------------------------------------------------------------------------------
    # PASSO 2: PREPARAR O ALGORITMO BUBBLE SORT
    # Precisamos de dois ciclos (loops): um externo para garantir que percorremos o vetor
    # vezes suficientes, e um interno para fazer as comparações lado a lado.
    # --------------------------------------------------------------------------------
    la $s0, vetor                           # $s0 guarda o endereço base do vetor na RAM
    lw $s1, tamanho                         # $s1 guarda o tamanho do vetor (N)
    
    # Se o vetor tiver 1 ou 0 elementos, não precisa ser ordenado.
    li $t0, 1
    ble $s1, $t0, fim_ordenacao             # Branch if Less or Equal (Se N <= 1, salta para o fim)

    # Configuração do Ciclo Externo (i de 0 até N-1)
    li $t0, 0                               # $t0 será o nosso 'i' (contador do ciclo externo)
    addi $s2, $s1, -1                       # $s2 = N - 1 (número máximo de passagens necessárias)

ciclo_externo:
    bge $t0, $s2, fim_ordenacao             # Se i >= N-1, o vetor já está totalmente ordenado

    # Configuração do Ciclo Interno (j de 0 até N-i-1)
    # A cada passagem, o maior elemento já foi para o final, logo não precisamos de o verificar novamente.
    li $t1, 0                               # $t1 será o nosso 'j' (contador do ciclo interno)
    sub $s3, $s2, $t0                       # $s3 = (N - 1) - i (limite do ciclo interno)

ciclo_interno:
    bge $t1, $s3, fim_ciclo_interno         # Se j >= limite, termina a passagem atual e volta ao ciclo externo

    # --------------------------------------------------------------------------------
    # PASSO 3: LER E COMPARAR ELEMENTOS ADJACENTES
    # --------------------------------------------------------------------------------
    # Precisamos calcular o endereço exato de vetor[j] na memória.
    # Multiplicamos o índice 'j' por 4 (pois cada .word tem 4 bytes).
    # 'sll' (Shift Left Logical) por 2 é matematicamente igual a multiplicar por 4.
    sll $t2, $t1, 2                         # $t2 = j * 4
    add $t3, $s0, $t2                       # $t3 = Endereço base + offset (Endereço de vetor[j])
    
    lw $t4, 0($t3)                          # Lê o elemento atual: $t4 = vetor[j]
    lw $t5, 4($t3)                          # Lê o próximo elemento: $t5 = vetor[j+1] (avançamos 4 bytes)

    # Verifica se os elementos estão na ordem errada (elemento atual MAIOR que o próximo)
    ble $t4, $t5, nao_troca                 # Se vetor[j] <= vetor[j+1], a ordem está correta, não faz a troca

    # --------------------------------------------------------------------------------
    # PASSO 4: EFETUAR A TROCA (SWAP) NA MEMÓRIA RAM
    # --------------------------------------------------------------------------------
    sw $t5, 0($t3)                          # Guarda o elemento menor na posição atual (vetor[j])
    sw $t4, 4($t3)                          # Guarda o elemento maior na posição seguinte (vetor[j+1])

nao_troca:
    addi $t1, $t1, 1                        # Incrementa o 'j' (avança para o próximo par)
    j ciclo_interno                         # Repete o ciclo interno

fim_ciclo_interno:
    addi $t0, $t0, 1                        # Incrementa o 'i' (já fizemos uma passagem completa)
    j ciclo_externo                         # Repete o ciclo externo

    # --------------------------------------------------------------------------------
    # PASSO 5: IMPRIMIR O VETOR ORDENADO E TERMINAR
    # --------------------------------------------------------------------------------
fim_ordenacao:
    li $v0, 4                               # Imprime a mensagem final
    la $a0, msg_depois
    syscall

    la $a0, vetor                           # Passa o endereço do vetor
    lw $a1, tamanho                         # Passa o tamanho
    jal imprimir_vetor                      # Chama a função de imprimir novamente

    li $v0, 10                              # Código 10 para terminar o programa
    syscall


# ====================================================================================
# FUNÇÃO: imprimir_vetor
# Função auxiliar para imprimir os elementos de um vetor no ecrã.
# Recebe: $a0 = Endereço base do vetor | $a1 = Tamanho do vetor
# ====================================================================================
imprimir_vetor:
    add $t6, $a0, $zero                     # Copia o endereço base para $t6
    li $t7, 0                               # Contador = 0

ciclo_imprimir:
    bge $t7, $a1, fim_imprimir              # Se contador >= tamanho, sai da função

    lw $a0, 0($t6)                          # Lê o elemento atual da memória
    li $v0, 1                               # Syscall 1: Imprimir inteiro
    syscall

    li $v0, 4                               # Syscall 4: Imprimir texto (espaço)
    la $a0, msg_espaco
    syscall

    addi $t6, $t6, 4                        # Avança o ponteiro de memória em 4 bytes
    addi $t7, $t7, 1                        # Incrementa contador
    j ciclo_imprimir

fim_imprimir:
    jr $ra                                  # 'jr' (Jump Register): Regressa para a linha logo a seguir ao 'jal' que chamou a função