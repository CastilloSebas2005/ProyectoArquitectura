.data
	#guardando colores y memoria que se usarán durante el programa
	#se usó eqv y no .word o otra porque es más fácil manejar los valores directamente así en vez de estar cargando la dirección de memoria en registros
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
	beq	$t4, 32, exit	# space
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
	#esto se usará más adelante, si $t7 es cero es una X y si no es una O, funciona igual que un booleano:)
	beq $t7, 0, dibujarX
	beq $t7, 1, dibujarY
