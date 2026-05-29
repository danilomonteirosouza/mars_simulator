# ====================================================================================
# SEÇÃO DE DADOS (.data)
# Declaração de variáveis, mensagens de texto e alocação de memória RAM.
# ====================================================================================
.data
    # Vetor: Reservamos 80 bytes na RAM. Como cada número inteiro ocupa 4 bytes,
    # isso nos permite armazenar até 20 termos da sequência de Fibonacci.
    vetor:      .space 80                   
    
    # Textos para interação com o usuário
    msg_input:  .asciiz "Quantos termos de Fibonacci deseja gerar? "
    msg_result: .asciiz "\nSequencia de Fibonacci: "
    msg_espaco: .asciiz ", "                # Usado para separar os números na impressão

# ====================================================================================
# SEÇÃO DE CÓDIGO (.text)
# Instruções lógicas do algoritmo.
# ====================================================================================
.text
.globl main

main:
    # --------------------------------------------------------------------------------
    # PASSO 1: LER A QUANTIDADE DE TERMOS (N)
    # --------------------------------------------------------------------------------
    li $v0, 4                               # Syscall 4: Imprimir texto
    la $a0, msg_input                       # Carrega o endereço da pergunta
    syscall                                 
    
    li $v0, 5                               # Syscall 5: Ler inteiro digitado pelo usuário
    syscall                                 
    add $s0, $v0, $zero                     # Salva a quantidade de termos (N) no registrador $s0
    
    # Se o usuário digitar 0 ou um número negativo, encerramos o programa para evitar erros.
    blez $s0, fim_programa                  # 'blez' (Branch if Less than or Equal to Zero): pula para o fim se $s0 <= 0

    # --------------------------------------------------------------------------------
    # PASSO 2: INICIALIZAR OS DOIS PRIMEIROS TERMOS NA RAM
    # Fibonacci sempre começa com 0 e 1.
    # --------------------------------------------------------------------------------
    la $t1, vetor                           # $t1 será nosso PONTEIRO da memória RAM (aponta para o vetor)
    
    li $t2, 0                               # Fib(0) = 0. Guarda o valor 0 em $t2.
    sw $t2, 0($t1)                          # 'sw' (Store Word): Salva o 0 na primeira posição da RAM (deslocamento 0).
    
    li $t3, 1                               # Fib(1) = 1. Guarda o valor 1 em $t3.
    sw $t3, 4($t1)                          # Salva o 1 na segunda posição. Usamos '4(' porque avançamos 4 bytes.
    
    # Se o usuário pediu apenas 1 termo, pulamos direto para a exibição.
    li $t4, 1                               # Carrega 1 em $t4 para comparar
    beq $s0, $t4, exibir_resultados         # Se N ($s0) for igual a 1 ($t4), vai para impressão.

    # --------------------------------------------------------------------------------
    # PASSO 3: LAÇO DE REPETIÇÃO - CALCULAR E SALVAR NA RAM
    # Lógica: O próximo número é sempre a soma dos dois anteriores.
    # --------------------------------------------------------------------------------
    li $t0, 2                               # Inicia o contador do loop ($t0) em 2, pois já temos Fib(0) e Fib(1).
    addi $t1, $t1, 8                        # Avança o ponteiro da RAM em 8 bytes (para apontar para a 3ª posição).

loop_calculo:
    bge $t0, $s0, exibir_resultados         # 'bge' (Branch if Greater or Equal): Se o contador >= N, termina o cálculo.
    
    # Calcula o novo termo: $t4 = Termo Anterior 1 ($t2) + Termo Anterior 2 ($t3)
    add $t4, $t2, $t3                       
    
    # Salva o novo termo calculado na memória RAM
    sw $t4, 0($t1)                          
    
    # Atualiza os registradores para a próxima rodada (O "passo" para frente na sequência)
    add $t2, $t3, $zero                     # O número que era o Fib(1) passa a ser o Fib(0)
    add $t3, $t4, $zero                     # O número que acabamos de calcular passa a ser o Fib(1)
    
    # Atualiza controles do loop
    addi $t1, $t1, 4                        # Avança o ponteiro da RAM em 4 bytes para o próximo espaço vazio
    addi $t0, $t0, 1                        # Incrementa o contador do loop em 1
    j loop_calculo                          # Volta para calcular o próximo número

    # --------------------------------------------------------------------------------
    # PASSO 4: LER DA RAM E IMPRIMIR RESULTADOS
    # --------------------------------------------------------------------------------
exibir_resultados:
    li $v0, 4                               # Syscall para imprimir string
    la $a0, msg_result                      # Imprime "Sequencia de Fibonacci: "
    syscall                                 

    li $t0, 0                               # Reinicia o contador para 0
    la $t1, vetor                           # Reinicia o ponteiro da RAM para o início do vetor

loop_impressao:
    bge $t0, $s0, fim_programa              # Se o contador atingiu N, vai para o fim
    
    # Lê o número atual da RAM e imprime
    lw $a0, 0($t1)                          # 'lw' (Load Word): Puxa o dado da RAM para $a0
    li $v0, 1                               # Syscall 1: Imprimir inteiro
    syscall                                 
    
    # Imprimir a vírgula e espaço (", "), exceto no último número
    addi $t5, $s0, -1                       # $t5 = N - 1 (índice do último elemento)
    beq $t0, $t5, pula_virgula              # Se for o último elemento, pula a impressão da vírgula
    
    li $v0, 4                               # Syscall 4: Imprimir texto
    la $a0, msg_espaco                      # Carrega a vírgula com espaço
    syscall                                 

pula_virgula:
    # Atualiza controles para imprimir o próximo número
    addi $t1, $t1, 4                        # Avança o ponteiro da RAM
    addi $t0, $t0, 1                        # Incrementa contador
    j loop_impressao                        

    # --------------------------------------------------------------------------------
    # ENCERRAR PROGRAMA
    # --------------------------------------------------------------------------------
fim_programa:
    li $v0, 10                              # Código 10: Finalizar a execução no simulador MARS
    syscall