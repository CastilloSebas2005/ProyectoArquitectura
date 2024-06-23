.data
	#guardando colores y memoria que se usarán durante el programa
	#se usar� eqv y no .word o otra porque es más fácil manejar los valores directamente así en vez de estar cargando la dirección de memoria en registros
	.eqv	ROJO	0x00FF0000
	.eqv	AZUL	0x000000FF
	.eqv	BLANCO	0x00FFFFFF
	.eqv	AMARILLO  0x00FFFF00
	.eqv	ALTURA 128
	.eqv 	ANCHO 128
	.eqv	MEM	0x10008000
	
.text
#$t0 va a ser el contador en las diferentes etapas de los ciclos
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
	#esto se va a usar en el futuro, si $t7 es cero es una X y si no es una O, funciona igual que un booleano:)
	beq $t7, 0, dibujarX
	beq $t7, 1, dibujarO
	
obtenerColor:
	subi $sp, $sp, 4
	sw $ra, ($sp)
		beq $t7, 0, rojo
		beq $t7, 1, azul
	rojo:
		li $a2, ROJO
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra	
	azul:
		li $a2, AZUL
		lw $ra, ($sp)
		addi $sp, $sp, 4
		jr $ra 
#t0 va a ser el índice al igual que un contador en un ciclo y dibujar tablero es el método por el cual se van a crear las lineas horizontales y verticales que se verán en pantalla 
dibujarTablero:	
	subi $sp, $sp, 4
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
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j dibujarHorizontalSuperior
	
dibujarHorizontalCentral:
	li $t0, 0
	li $a0, 0
	li $a1, 86
	li $t9, 128
	
dibujarHorizontalInferior: 
	bge $t0, $t9, casillaAMarcar 
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j dibujarHorizontalInferior
	
#este será un pixel dentro del tablero con la casilla a marcar
posicionarSelector: #falta correcta implentación
	li $a0, 64
	li $a1, 64 
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra		
exit:
	li $v0, 10
	syscall

#t4 es la dirección del pixel donde se va a dibujar
#función que va pixel por pixel dibujando
dibujarPixel:
	subi $sp, $sp, 8
	
	sw $t4, 4($sp)
	sw $ra, ($sp)
	
	mul $t4, $a1, ANCHO
	add $t4, $t4, $a0
	mul $t4, $t4, 4
	add $t4, $t4, MEM
	sw $a2, ($t4)
	move $t5, $a0
	move $a0, $t5
	
	lw $ra, ($sp)
	lw $t4,4 ($sp)
	
	addi $sp, $sp, 8
	jr $ra
	
		
dibujarX:
	#lugar donde va a ser dibujada la X
	jal guardarLugar
	addi $a0, $a0, -10
	addi $a1,$a1, -10
	li $t0, 0
 dibujarBarraIquierda:
 	bge $t0, 20, dibujarBarraDerecha
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j dibujarBarraIzquierda
reinicioDeValores: 	
 	addi $a1,$a1, -20
 	li $t0, 0
 dibujarBarraDerecha:
 	bge $t0, 20, Xterminada
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a0, $a0, -1
	addi $a1, $a1, 1
	j dibujarBarraDerecha
 XTerminada:	
 #luego de dibujar se verifica el ganador como se indicaba en el diagrama de flujo
 	jal verificarGanador
 	
 	li $a0, 64
	li $a1, 64
	li $a2, BLANCO
	addi $t8, $t8, 1
	j ciclo

# comandos para dibujar un círculo, tienen que ser codificados
dibujarO:	
	jal guardarLugar
	addi $a0, $a0, -8
	addi $a1, $a1, 3
	li $t0, 0

dibujarIzquierda:	
# dibujar porción izquierda del círculo
	bge $t0, 6, arcoIzquierdo
	jal dibujarPixel
	addi $a1, $a1, -1
	addi $t0, $t0, 1
	j dibujarIzquierda

arcoIzquierdo:	
# dibujar arco izquierdo del círculo
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $a1, $a1, -1
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $a1, $a1, -1
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $a1, $a1, -1
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $a1, $a1, -1
	jal dibujarPixel
	li $t0, 0

parteSuperior:	
# dibujar línea superior del círculo
	bge $t0, 7, arcoDerechoSuperior
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	j parteSuperior	

arcoDerechoSuperior:	
# dibujar arco superior derecho del círculo
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	jal dibujarPixel
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	jal dibujarPixel
	li $t0, 0

dibujarDerecha:	
# dibujar lado derecho del círculo
	bge $t0, 7, arcoDerechoInferior
	jal dibujarPixel
	addi $a1, $a1, 1
	addi $t0, $t0, 1
	j dibujarDerecha

arcoDerechoInferior:	
# dibujar arco inferior derecho del círculo
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $a1, $a1, 1
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $a1, $a1, 1
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $a1, $a1, 1
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $a1, $a1, 1
	jal dibujarPixel
	li $t0, 0

parteInferior:	
# dibujar línea inferior del círculo
	bge $t0, 7, arcoIzquierdoInferior
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $t0, $t0, 1
	j parteInferior

arcoIzquierdoInferior:	
# dibujar arco inferior izquierdo del círculo
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	jal dibujarPixel
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	jal dibujarPixel
	
OTerminado:
# círculo terminado, ahora saltar de regreso y verificar si ganó
	jal verificarVictoria
	li $a0, 64
	li $a1, 64
	li $a2, BLANCO
	addi $t8, $t8, 1
	j ciclo
