.data
	 torres: .word 5, 4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	 
	 # Torre de origem: [0, 16]
 	 # Torre auxiliar: [20, 36]
 	 # Torre de destino: [40, 56]
 	 
 	 cabecalho: .asciiz "\nT1\tT2\tT3\n"
 	 
 	 msg_inserir_origem: .asciiz "Insira a torre de origem (1, 2 ou 3): "
 	 msg_inserir_destino: .asciiz "Insira a torre de destino (1, 2, ou 3): "
 	 
 	 msg_fim_jogo: .asciiz "\nFim de jogo. Parabens!\n"
 	 
 	 msg_entrada_invalida: .asciiz "\nA entrada deve ser 1, 2 ou 3\n\n"
 	 msg_destino_cheio: .asciiz "\nA torre de destino esta cheia\n\n"
  	 msg_origem_vazia: .asciiz "\nA torre de origem esta vazia\n\n"
 	 msg_movimento_invalido: .asciiz "\nMovimento invalido. Escolha as torres novamente\n\n"
 	 
 	 tab: .asciiz "\t"
  	 quebra_linha: .asciiz "\n"

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #
 
.text
.globl main

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

main:
	# Define os topos das torres
	li $s0, 16
	li $s1, 20
	li $s2, 40
	
	# Loop para as rodadas do jogo
	jogo:
		jal imprime_torres
		
		li $t1, 1
		li $t2, 2
		li $t3, 3
		
		# Loop para verificar entrada da torre de origem valida
		le_torre_origem:
			li $v0, 4
			la $a0, msg_inserir_origem
			syscall
			jal le_torre
			la $a0, 0($v0)
			li $a1, -1
			jal valida_entrada
			la $s3, ($a0)
	
		bne $a0, $t1, ignore_vazia_um
		jal esta_vazia_um
		la $t7, ($s0)
		j continua_depois_de_vazia
		
		# Desvio para quando a torre de origem for diferente de 1
		ignore_vazia_um:
			bne $a0, $t2, ignore_vazia_dois
			jal esta_vazia_dois
			la $t7, ($s1)
			j continua_depois_de_vazia
		
		# Desvio para quando a torre de origem for diferente de 2
		ignore_vazia_dois:
			bne $a0, $t3, continua_depois_de_vazia
			jal esta_vazia_tres
			la $t7, ($s2)
			j continua_depois_de_vazia
		
		# Desvio para depois das validacoes da torre de origem
		continua_depois_de_vazia:
			
			# Loop para verificar entrada da torre de destino válida
			le_torre_destino:
				li $v0, 4
				la $a0, msg_inserir_destino
				syscall
				jal le_torre
				la $a0, 0($v0)
				li $a1, -2
				jal valida_entrada
				la $s4, ($a0)
	
			bne $a0, $t1, ignore_cheia_um
			jal esta_cheia_um
			la $t8, ($s0)
			j continua_depois_de_cheia
			
			# Desvio para quando a torre de destino for diferente de 1
			ignore_cheia_um:
				bne $a0, $t2, ignore_cheia_dois
				jal esta_cheia_dois
				la $t8, ($s1)	
				j continua_depois_de_cheia
			
			# Desvio para quando a torre de destino for diferente de 2
			ignore_cheia_dois:
				bne $a0, $t3, continua_depois_de_cheia
				jal esta_cheia_tres
				la $t8, ($s2)
				j continua_depois_de_cheia
			
			# Desvio para depois das validacoes da torre de origem
			continua_depois_de_cheia:
				la  $a0, ($t7)
				la  $a1, ($t8)
				j movimenta_disco
		
				continua_depois_de_movimento:
					li $t1, 1
					li $t2, 2
					li $t3, 3
		
					beq $s3, $t1, atualiza_topo_um_origem
					beq $s3, $t2, atualiza_topo_dois_origem
					beq $s3, $t3, atualiza_topo_tres_origem
		
					atualiza_topo_um_origem:
						move $s0, $v0
						j continua_depois_de_atualiza_topo_origem
	
					atualiza_topo_dois_origem:
						move $s1, $v0
						j continua_depois_de_atualiza_topo_origem

					atualiza_topo_tres_origem:
						move $s2, $v0
						j continua_depois_de_atualiza_topo_origem
		
					continua_depois_de_atualiza_topo_origem:
						beq $s4, $t1, atualiza_topo_um_destino
						beq $s4, $t2, atualiza_topo_dois_destino
						beq $s4, $t3, atualiza_topo_tres_destino
			
						atualiza_topo_um_destino:
							move $s0, $v1
							j continua_depois_de_atualiza_topo_destino
			
						atualiza_topo_dois_destino:
							move $s1, $v1
							j continua_depois_de_atualiza_topo_destino
				
						atualiza_topo_tres_destino:
							move $s2, $v1
							j continua_depois_de_atualiza_topo_destino
			
						continua_depois_de_atualiza_topo_destino:
							beq $s2, 56, fim
							j jogo

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

le_torre:
	li $v0, 5
	syscall
	jr $ra
			
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

valida_entrada:
	li $t1, 1
	li $t2, 2
	li $t3, 3
	
	# Verifica se o valor inserido pelo usuario esta entre 1 e 3
	sge $t4, $a0, $t1
	sle $t5, $a0, $t3
	and $t6, $t4, $t5
	
	beq $t6, $zero, entrada_invalida
	
	jr $ra

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Verifica se o topo da torre de origem 1 esta vazio
esta_vazia_um:
	lw $t0, torres($s0)
    beq $t0, $zero, origem_vazia
    jr $ra

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Verifica se o topo da torre de origem 2 esta vazio
esta_vazia_dois:
	lw $t0, torres($s1)
    beq $t0, $zero, origem_vazia
    jr $ra

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Verifica se o topo da torre de origem 3 esta vazio
esta_vazia_tres:
	lw $t0, torres($s2)
    beq $t0, $zero, origem_vazia
    jr $ra
   
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Verifica se o topo da torre de destino 1 eh 16 (maximo)
esta_cheia_um:
	la $t0, ($s0)
	li $t1, 16
    beq $t0, $t1, destino_cheio
    jr $ra

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Verifica se o topo da torre de destino 2 eh 36 (maximo)
esta_cheia_dois:
	la $t0, ($s1)
	li $t1, 36
    beq $t0, $t1, destino_cheio
    jr $ra

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Verifica se o topo da torre de destino 3 eh 56 (maximo)
esta_cheia_tres:
	la $t0, ($s2)
	li $t1, 56
    beq $t0, $t1, destino_cheio
    jr $ra

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Imprime mensagem de erro caso a entrada seja < 1 ou > 3
entrada_invalida:
	li $v0, 4
	la $a0, msg_entrada_invalida
	syscall
	
	# Retorna para o loop que le a torre de origem caso a1 = -1
	beq $a1, -1, le_torre_origem
	
	# Retorna para o loop que le a torre de destino caso a1 = -2
	beq $a1, -2, le_torre_destino

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Imprime mensagem de erro caso a torre de destino esteja cheia
destino_cheio:
	li $v0, 4
	la $a0, msg_destino_cheio
	syscall
	j le_torre_destino
	
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #		

# Imprime mensagem de erro caso a torre de origem esteja vazia
origem_vazia:
	li $v0, 4
	la $a0, msg_origem_vazia
	syscall
	j le_torre_origem

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Realiza verificacoes para movimentar os discos
movimenta_disco:
	# Recebe os elementos do topo das torres
	lw $t0, torres($a0)
	lw $t1, torres($a1)
	
	# Para caso o elemento da torre de destino ser zero
	bne $t1, $zero, ignora_zero
	jal move_disco
	move $v1, $a1
	j define_topos
	
	# Para caso o elemento da torre de destino ser diferente de zero
	ignora_zero:
		ble $t1, $t0, movimento_invalido
		add $a1, $a1, 4
		jal move_disco
		j define_topos
	
	# Realiza operacoes com os topos da torre em casos especiais
	define_topos:
		move $v1, $a1
	    beq $a0, 0, continua
	    beq $a0, 20, continua
	    beq $a0, 40, continua
		sub $v0, $a0, 4
		j continua_depois_de_movimento
		
		continua:
			move $v0, $a0
			j continua_depois_de_movimento
	
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Realiza o movimento dos discos entre torres
move_disco:
	sw $t0, torres($a1)
	sw $zero, torres($a0)
	jr $ra

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Imprime mensagem de erro caso o movimento seja invalido
movimento_invalido:
	li $v0, 4
	la $a0, msg_movimento_invalido
	syscall
	j continua_depois_de_atualiza_topo_destino

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Imprime mensagem de fim e finaliza a execucao do jogo
fim:
	li $v0, 4
	la $a0, msg_fim_jogo
	syscall
	li $v0, 10
	syscall	

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #

# Imprime os discos presentes nas torres
imprime_torres:
	li $t9, 16
	move $s6, $t9
	move $s7, $zero
	
	li $v0, 4
	la $a0, cabecalho
	syscall
	
	loop:
		blt $s6, 0, sai_do_loop
		li $v0, 1
		lw $a0, torres($s6)
		syscall
		
		blt $s7, 2, imprime_tab
		j imprime_quebra_linha 
	
	sai_do_loop:
		li $v0, 4
		la $a0, quebra_linha
		syscall
		jr $ra

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #		

# Funcao auxiliar da "imprime_torres"
imprime_tab:
	li $v0, 4
	la $a0, tab
	syscall
	add $s6, $s6, 20
	add $s7, $s7, 1
	j loop
	
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= #		

# Funcao auxiliar da "imprime_torres"
imprime_quebra_linha:
	li $v0, 4
	la $a0, quebra_linha
	syscall
	sub $s6, $s6, 44
	move $s7, $zero
	j loop
