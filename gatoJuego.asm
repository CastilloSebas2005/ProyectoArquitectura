.data
	#guardando colores y memoria que se usar√°n durante el programa
	#se usar· eqv y no .word o otra porque es m√°s f√°cil manejar los valores directamente as√≠ en vez de estar cargando la direcci√≥n de memoria en registros
	.eqv	ROJO	0x00FF0000
	.eqv	AZUL	0x000000FF
	.eqv	BLANCO	0x00FFFFFF
	.eqv	AMARILLO  0x00FFFF00
	.eqv	ALTURA 128
	.eqv 	ANCHO 128
	.eqv	MEM	0x10008000
	
.text
#$a0 va a ser el ancho, $a1 va a ser la altura, igual que en un plano cartesiano, #a2 va a guardar los colores, $t8 contador de X o de O
main:
	li $s0, 9
	li $s1, 8
	li $s2, 7
	li $s3, 6
	li $s4, 5
	li $s6, 12
	li $s7, 17
	li $t6, 106
	li $t0, 0
	li $t9, 512
	jal dibujarTablero
	
ciclo:
	#li $a2, 7	
		#loop draw
	jal dibujarPixel #loop draw
leerTeclado:	
	# esperando tecla
	lw $t0, 0xffff0000  
    	beq $t0, 0, ciclo
	
	# se guarda la tecla ingresada en $t4
	lw 	$t4, 0xffff0004
	beq	$t4, 32, exit	# espacio
	beq	$t4, 119, w 	# w
	beq	$t4, 115, s 	#  s
	beq 	$t4, 97, a  	# a
	beq	$t4, 100, d	#  d
	beq	$t4, 10, ponerFigura	#  enter
	
	j	ciclo

#se valida la entrada
w:	
	li $a2, 0
	jal dibujarPixel
	li $a2, BLANCO
	subi $a1, $a1, 42
	jal dibujarPixel
	j ciclo

s:	
	li $a2, 0
	jal dibujarPixel
	li $a2, BLANCO
	addi $a1, $a1, 42
	jal dibujarPixel
	j ciclo
	
a:	
	li $a2, 0
	jal dibujarPixel
	li $a2, BLANCO
	subi $a0, $a0, 42
	jal dibujarPixel
	j ciclo
	
d:
	li $a2, 0
	jal dibujarPixel
	li $a2, BLANCO
	addi $a0, $a0, 42
	jal dibujarPixel
	j ciclo
	
ponerFigura:
	li $a2, 0
	jal dibujarPixel
	li $a2, BLANCO
	
	and $t7, $t8, 0x0001
	jal obtenerColor
	#esto se usar· m·s adelante, si $t7 es cero es una X y si no es una O, funciona igual que un booleano:)
	beq $t7, 0, dibujarX
	beq $t7, 1, dibujarY

dibujarTablero:	
#$t0 = i
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	li $a2, BLANCO
	li $a0, 171
	li $a1, 0
	
dibujarVerticalIzquierda:	
	bge $t0, $t9, dibujarVerticalCentral
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a1, $a1, 1
	j dibujarVerticalIzquierda

dibujarVerticalCentral:	
	li $t0, 0
	li $a0, 342
	li $a1, 0
		
dibujarVerticalDerecha:	
	bge $t0, $t9, dibujarPrimeraLinea
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a1, $a1, 1	
	j dibujarVerticalDerecha
	
dibujarPrimeraLinea:	
	li $t0, 0
	li $a0, 0
	li $a1, 43
	li $t9, 128
	
dibujarHorizontalSuperior:	
	bge $t0, $t9, dibujarHorizontalCentral
	jal drawPixel
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j dibujarHorizontalSuperior
	
dibujarHorizontalCentral:
	li $t0, 0
	li $a0, 0
	li $a1, 86
	li $t9, 128
	
dibujarHorizontalInferior: 
	bge $t0, $t9, middlePlacementDone #middlePlacementDone ser· un pixel dentro del tablero para elegir la casilla a marcar
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j dibujarHorizontalInferior