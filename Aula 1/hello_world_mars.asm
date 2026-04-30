.data                          # Inicia a secao de dados. Tudo que for declarado aqui sera armazenado na memoria antes da execucao

msg: .asciiz "Hello, World!\n" # Define um rotulo chamado msg que aponta para uma string em memoria
                               # .asciiz indica string ASCII terminada com caractere nulo (\0)
                               # "\n" representa quebra de linha ao final da mensagem

.text                          # Inicia a secao de codigo. A partir daqui ficam as instrucoes executadas pelo processador

.globl main                    # Torna o rotulo main visivel para o sistema, indicando o ponto inicial do programa

main:                          # Rotulo que marca o inicio da execucao. O programa comeca por aqui

    li $v0, 4                  # li (load immediate) coloca o valor 4 dentro do registrador $v0
                               # No MARS, o valor 4 em $v0 indica uma syscall de impressao de string

    la $a0, msg                # la (load address) carrega no registrador $a0 o endereco de memoria da string msg
			       # $a0 eh usado para passar o argumento da syscall, neste caso o endereco da string
                               # observacao: la e uma pseudo-instrucao, nao existe fisicamente no hardware
                               # o montador a converte em instrucoes reais como lui e ori
                               # durante esse processo, o registrador $at (assembler temporary) pode ser usado como auxiliar
                               # primeiro a parte alta do endereco pode ser carregada em $at, depois combinada e movida para $a0

    syscall                    # Executa a chamada de sistema
                               # O sistema verifica $v0 = 4 e entende que deve imprimir uma string
                               # Usa o endereco em $a0 para localizar e exibir "Hello, World!"

    li $v0, 10                 # Coloca o valor 10 em $v0
                               # No MARS, o valor 10 representa a syscall de encerramento do programa

    syscall                    # Executa a chamada de sistema de encerramento
                               # O programa termina sua execucao neste ponto