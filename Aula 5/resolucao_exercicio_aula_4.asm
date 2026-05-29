# ====================================================================================
# SEÇÃO DE DADOS (.data)
# Aqui declaramos as variáveis e os espaços de memória RAM que o programa vai usar.
# ====================================================================================
.data
    # Vetor: Um número inteiro no MIPS ocupa 32 bits (ou seja, 4 bytes).
    # Como precisamos armazenar 5 números, precisamos de 5 * 4 = 20 bytes de memória.
    # A diretiva '.space' reserva essa quantidade exata de bytes consecutivos na RAM.
    vetor:      .space 20                   
    
    # Strings: Textos que serão exibidos na tela. A diretiva '.asciiz' salva o texto 
    # na memória e coloca um caractere nulo (zero) no final para indicar onde o texto acaba.
    msg_input:  .asciiz "Digite um numero: "
    msg_maior:  .asciiz "Maior valor: "     
    msg_soma:   .asciiz "\nSoma dos pares: "
    msg_impar:  .asciiz "\nQuantidade de impares: " 

# ====================================================================================
# SEÇÃO DE CÓDIGO (.text)
# Aqui ficam as instruções (o algoritmo propriamente dito) que o processador vai rodar.
# ====================================================================================
.text
.globl main                                 # Define 'main' como o ponto de partida do programa

main:
    # --------------------------------------------------------------------------------
    # PASSO 1: CONFIGURAR O LOOP DE LEITURA
    # Precisamos de um contador (para repetir 5 vezes) e do endereço do vetor.
    # --------------------------------------------------------------------------------
    li $t0, 5                               # 'li' (Load Immediate): Carrega o número 5 direto no registrador $t0. Este será nosso contador regressivo.
    la $t1, vetor                           # 'la' (Load Address): Pega o endereço base (a posição inicial) do 'vetor' na RAM e guarda no registrador $t1 (nosso ponteiro).

loop_leitura:
    # 'beq' (Branch if Equal): Compara $t0 com $zero (que sempre vale 0). 
    # Se $t0 for igual a 0, significa que já lemos 5 números, então ele "pula" para 'pre_processamento'.
    beq $t0, $zero, pre_processamento       
    
    # --- Solicitando o número ao usuário ---
    li $v0, 4                               # O registrador $v0 avisa ao sistema (syscall) qual ação tomar. O código '4' significa: "Imprimir um texto".
    la $a0, msg_input                       # Para imprimir um texto, o sistema procura o endereço dele no registrador $a0. Passamos o endereço de 'msg_input'.
    syscall                                 # Executa a ação solicitada (mostra "Digite um numero: " na tela).
    
    # --- Lendo o que o usuário digitou ---
    li $v0, 5                               # O código '5' no $v0 significa: "Ler um número inteiro do teclado".
    syscall                                 # Executa a ação. O número que o usuário digitar será salvo automaticamente no registrador $v0.
    
    # --- Salvando o número lido na memória RAM ---
    # 'sw' (Store Word): Salva uma "palavra" (4 bytes) de um registrador para a RAM.
    # Ele pega o valor lido (em $v0) e guarda na posição de memória apontada por $t1.
    # O '0(' indica que não queremos deslocamento (offset) do endereço atual.
    sw $v0, 0($t1)                          
    
    # --- Atualizando os controles para a próxima rodada do loop ---
    addi $t1, $t1, 4                        # 'addi' (Add Immediate): Soma 4 ao ponteiro da memória ($t1). Por que 4? Porque o próximo inteiro começa 4 bytes à frente na RAM.
    addi $t0, $t0, -1                       # Subtrai 1 do contador de repetições ($t0), pois já lemos um número.
    j loop_leitura                          # 'j' (Jump): Pula incondicionalmente de volta para a etiqueta 'loop_leitura', reiniciando o ciclo.

    # --------------------------------------------------------------------------------
    # PASSO 2: PREPARAÇÃO PARA ANALISAR OS DADOS
    # O vetor está preenchido. Agora vamos reiniciar nossos ponteiros e preparar as variáveis de resultado.
    # --------------------------------------------------------------------------------
pre_processamento:
    li $t0, 5                               # Reinicia nosso contador para 5, para o próximo loop.
    la $t1, vetor                           # O ponteiro $t1 tinha avançado até o final do vetor no passo 1. Aqui, forçamos ele a apontar para o INÍCIO do vetor novamente.
    
    # Para encontrar o maior valor, assumimos que o primeiro elemento da RAM é o maior provisoriamente.
    # 'lw' (Load Word): Lê um dado da RAM e traz para o processador. Pega o primeiro número guardado no vetor ($t1) e bota no registrador $t2.
    lw $t2, 0($t1)                          
    
    li $t3, 0                               # Registrador $t3 vai guardar a SOMA DOS PARES. Começa em 0.
    li $t4, 0                               # Registrador $t4 vai guardar a QUANTIDADE DE ÍMPARES. Começa em 0.
    li $t6, 2                               # Registrador $t6 guarda o número 2. Vamos usá-lo como divisor para descobrir se um número é par ou ímpar (divisão por 2).

loop_processamento:
    beq $t0, $zero, fim_processamento       # Se o contador zerou, terminamos de processar os 5 números. Pula para o final.
    
    # Lê o número atual do vetor (da RAM) e joga para o registrador $t5 para podermos fazer contas com ele.
    lw $t5, 0($t1)                          
    
    # --- Lógica do MAIOR VALOR ---
    # 'bgt' (Branch if Greater Than): Se o número atual que lemos ($t5) for MAIOR que o maior valor salvo até agora ($t2), pula para 'atualiza_maior'.
    bgt $t5, $t2, atualiza_maior            
    
    # Se não for maior, ignoramos a atualização do maior valor e saltamos direto para checar se ele é par ou ímpar.
    j verifica_par_impar                    

atualiza_maior:
    # Substitui o maior valor anterior. Soma o número atual ($t5) com 0 ($zero) e guarda em $t2. É um jeito MIPS de copiar valores entre registradores.
    add $t2, $t5, $zero                     

    # --- Lógica de PARES E ÍMPARES ---
verifica_par_impar:
    # 'div': Divide o número atual ($t5) pelo registrador que contém o 2 ($t6).
    # O MIPS guarda o quociente em um registrador invisível chamado LO, e o RESTO da divisão em um registrador chamado HI.
    div $t5, $t6                            
    
    # 'mfhi' (Move From HI): Puxa o RESTO da divisão que estava no registrador especial HI para o nosso registrador $t7.
    mfhi $t7                                
    
    # 'bne' (Branch if Not Equal): Se o resto ($t7) não for igual a 0, o número não divide perfeitamente por 2. Logo, ele é ímpar! Pula para a etiqueta 'eh_impar'.
    bne $t7, $zero, eh_impar                
    
eh_par:
    # Se o código chegou nesta linha (não pulou no bne acima), o resto é 0. O número é PAR.
    add $t3, $t3, $t5                       # Pega a soma dos pares atual ($t3), adiciona o número lido ($t5), e salva o resultado no próprio $t3.
    j proximo_elemento                      # Já somou, então pula a parte do ímpar para não processar a mesma coisa duas vezes.

eh_impar:
    # Se chegou aqui, o número é ÍMPAR.
    addi $t4, $t4, 1                        # Aumenta a contagem de ímpares ($t4) em 1. Em vez de somar o valor do número, somamos apenas a quantidade.

proximo_elemento:
    # --- Atualiza controles para testar o próximo espaço na RAM ---
    addi $t1, $t1, 4                        # Pula 4 bytes na memória para o ponteiro focar no próximo número inteiro do vetor.
    addi $t0, $t0, -1                       # Diminui o contador de números restantes a processar.
    j loop_processamento                    # Volta para o início da análise.

    # --------------------------------------------------------------------------------
    # PASSO 3: EXIBIR RESULTADOS NA TELA
    # Já temos todos os dados (maior em $t2, soma_pares em $t3, qtd_impares em $t4).
    # Agora apenas usamos as chamadas de sistema (syscall) para escrevê-los no console.
    # --------------------------------------------------------------------------------
fim_processamento:

    # 1. Mostrar o texto "Maior valor: "
    li $v0, 4                               # Prepara impressão de string
    la $a0, msg_maior                       # Passa endereço do texto
    syscall                                 
    
    # 2. Mostrar o número inteiro correspondente ao maior valor
    li $v0, 1                               # O código '1' no $v0 significa: "Imprimir um número inteiro".
    add $a0, $t2, $zero                     # O sistema espera o número no registrador $a0. Copiamos $t2 para $a0.
    syscall                                 
    
    # 3. Mostrar o texto "\nSoma dos pares: " (\n pula linha)
    li $v0, 4                               
    la $a0, msg_soma                        
    syscall                                 
    
    # 4. Mostrar o número inteiro da soma dos pares
    li $v0, 1                               
    add $a0, $t3, $zero                     # Copia $t3 (soma dos pares) para $a0 para impressão.
    syscall                                 
    
    # 5. Mostrar o texto "\nQuantidade de impares: "
    li $v0, 4                               
    la $a0, msg_impar                       
    syscall                                 
    
    # 6. Mostrar o número inteiro da quantidade de ímpares
    li $v0, 1                               
    add $a0, $t4, $zero                     # Copia $t4 (qtd ímpares) para $a0 para impressão.
    syscall                                 
    
    # --------------------------------------------------------------------------------
    # ENCERRAR PROGRAMA DE FORMA LIMPA
    # --------------------------------------------------------------------------------
    li $v0, 10                              # O código '10' indica ao sistema operacional (MARS) que o programa terminou e pode ser finalizado com segurança.
    syscall
