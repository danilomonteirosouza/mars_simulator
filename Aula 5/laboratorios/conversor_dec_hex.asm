# ====================================================================================
# SEÇÃO DE DADOS (.data)
# Declaração das mensagens de texto para interação com o usuário.
# ====================================================================================
.data
    msg_input:  .asciiz "Digite um numero decimal: "
    msg_output: .asciiz "Valor em Hexadecimal: 0x"

# ====================================================================================
# SEÇÃO DE CÓDIGO (.text)
# ====================================================================================
.text
.globl main

main:
    # --------------------------------------------------------------------------------
    # PASSO 1: LER O NÚMERO DECIMAL DO USUÁRIO
    # --------------------------------------------------------------------------------
    li $v0, 4                               # Syscall 4: Imprimir texto
    la $a0, msg_input                       # Carrega a mensagem de entrada
    syscall                                 
    
    li $v0, 5                               # Syscall 5: Ler número inteiro
    syscall                                 
    add $s0, $v0, $zero                     # Salva o número digitado no registrador $s0
    
    # Imprime o início da mensagem de saída (incluindo o "0x" que indica hexadecimal)
    li $v0, 4                               
    la $a0, msg_output                      
    syscall                                 

    # --------------------------------------------------------------------------------
    # PASSO 2: PREPARAÇÃO DO LAÇO (LOOP) DE CONVERSÃO
    # Um número inteiro tem 32 bits. Como cada dígito hexadecimal ocupa 4 bits,
    # precisaremos de 8 repetições (32 / 4 = 8) para extrair todos os dígitos.
    # --------------------------------------------------------------------------------
    li $t0, 8                               # Inicia o contador do loop em 8
    
loop_hex:
    beq $t0, $zero, fim_programa            # Se o contador zerar, terminamos de imprimir

    # --------------------------------------------------------------------------------
    # PASSO 3: ISOLAR OS 4 BITS MAIS SIGNIFICATIVOS (DA ESQUERDA PARA A DIREITA)
    # --------------------------------------------------------------------------------
    # 'srl' (Shift Right Logical): Empurra os bits do número ($s0) 28 posições para a direita.
    # Isso joga os 4 primeiros bits para o final, onde podemos analisá-los sozinhos, e 
    # preenche o resto com zeros. Salvamos esse "pedaço" em $t1.
    srl $t1, $s0, 28                        
    
    # 'andi' (AND Immediate): Aplica uma máscara (0xF, que é 1111 em binário).   0x111117888
    # Isso garante que estamos olhando APENAS para os últimos 4 bits isolados.
    andi $t1, $t1, 0xf                      

    # --------------------------------------------------------------------------------
    # PASSO 4: CONVERTER O VALOR (0 A 15) PARA O CARACTERE ASCII CORRESPONDENTE
    # Se for de 0 a 9, somamos 48 (código ASCII do '0').
    # Se for de 10 a 15 (A a F), somamos 55 (para chegar no código ASCII do 'A').
    # --------------------------------------------------------------------------------
    blt $t1, 10, eh_numero                  # Se o valor extraído for < 10, pula para 'eh_numero'
    
eh_letra:
    addi $t1, $t1, 55                       # Valor é entre 10 e 15. Soma 55 para virar 'A', 'B', 'C', 'D', 'E' ou 'F'
    j imprimir_char                         # Pula para a impressão

eh_numero:
    addi $t1, $t1, 48                       # Valor é entre 0 e 9. Soma 48 para virar o caractere '0' a '9'

    # --------------------------------------------------------------------------------
    # PASSO 5: IMPRIMIR O CARACTERE E PREPARAR O PRÓXIMO DÍGITO
    # --------------------------------------------------------------------------------
imprimir_char:
    add $a0, $t1, $zero                     # Coloca o caractere ASCII gerado em $a0
    li $v0, 11                              # Syscall 11: Imprimir UM caractere na tela
    syscall                                 

    # 'sll' (Shift Left Logical): Move todos os bits do número original ($s0) 4 posições 
    # para a ESQUERDA. Isso descarta os 4 bits que acabamos de imprimir e traz os próximos 
    # 4 bits para a "frente da fila", prontos para o próximo ciclo do loop.
    sll $s0, $s0, 4                         
    
    addi $t0, $t0, -1                       # Decrementa o contador de repetições (faltam menos dígitos)
    j loop_hex                              # Volta para o início do loop

    # --------------------------------------------------------------------------------
    # PASSO 6: ENCERRAR PROGRAMA
    # --------------------------------------------------------------------------------
fim_programa:
    li $v0, 10                              # Syscall 10: Encerrar a execução
    syscall
