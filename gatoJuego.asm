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
	dibujando: .asciiz "dibujando der"
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
	jal dibujarPixel
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
	bge $t0, $t9, posicionarSelector 
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	j dibujarHorizontalInferior
	
#este será un pixel dentro del tablero con la casilla a marcar
posicionarSelector: 
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
dibujarBarraIzquierda:
 	bge $t0, 20, reinicioDeValores
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j dibujarBarraIzquierda
	
reinicioDeValores: 	
 	addi $a1,$a1, -20
 	li $t0, 0
 	
dibujarBarraDerecha:
 	bge $t0, 20, XTerminada
	jal dibujarPixel
	addi $t0, $t0, 1
	addi $a0, $a0, -1
	addi $a1, $a1, 1
	j dibujarBarraDerecha
	
 XTerminada:	
 #luego de dibujar se verifica el ganador como se indicaba en el diagrama de flujo
 	jal comprobarGanador
 	
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
	jal comprobarGanador
	li $a0, 64
	li $a1, 64
	li $a2, BLANCO
	addi $t8, $t8, 1
	j ciclo
	
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
		
#Guarda donde se colocan los elementos en el tablero.
guardarLugar:
#Comportamiento del tablero desde estado s0 hasta estado s7     
#Se guarda el color y la ubicacion de la figura (ROJO = x    AZUL = O)

	addi $sp, $sp, -4
	sw $ra, ($sp)
	
		#
		s0:
			bge $a0, 43, s1 #ciclo s1 
			bge $a1, 43, s1
			
				beq $a2, ROJO, s0r
				beq $a2, AZUL, s0b
				
				s0r: 
				li $s0, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				s0b: 
				li $s0, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
		
		#						
		s1:
			bge $a0, 86, s2 #ciclo s2 
			bge $a1, 43, s2
			beq $a2, ROJO, s1r
				beq $a2, AZUL, s1b
				s1r: 
				li $s1, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				s1b: 
				li $s1, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
		
		#		
		s2:
			bge $a0, 127, s3 #ciclo s3
			bge $a1, 43, s3
			beq $a2, ROJO, s2r
				beq $a2, AZUL, s2b
				s2r: 
				li $s2, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				s2b: 
				li $s2, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
		
		#				
		s3:
			bge $a0, 43, s4 #ciclo s4 
			bge $a1,86, s4
			beq $a2, ROJO, s3r
				beq $a2, AZUL, s3b
				s3r: 
				li $s3, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				s3b: 
				li $s3, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
		
		#				
		s4:
			bge $a0, 86, s5 #ciclo s5 
			bge $a1, 86, s5
			beq $a2, ROJO, s4r
				beq $a2, AZUL, s4b
				s4r: 
				li $s4, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				s4b: 
				li $s4, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
			
		#			
		s5:
			bge $a0, 128, s6 #ciclo s6 
			bge $a1, 86, s6
			beq $a2, ROJO, s5r
				beq $a2, AZUL, s5b
				s5r: 
				li $s5, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				s5b: 
				li $s5, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				
		#		
		s6:
			bge $a0, 43, s7 #ciclo s7
			bge $a1, 128, s7
			beq $a2, ROJO, s6r
				beq $a2, AZUL, s6b
				s6r: 
				li $s6, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				s6b: 
				li $s6, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				
		#		
		s7:	
			bge $a0, 86, t6 
			bge $a1, 128, t6
			beq $a2, ROJO, s7r
				beq $a2, AZUL, s7b
				s7r: 
				li $s7, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				s7b: 
				li $s7, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				
		#t6 guarda 1 si es x & 2 si es O 
		t6:
			beq $a2, ROJO, t6r
			beq $a2, AZUL, t6b
				t6r: 
				li $t6, 1
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				t6b: 
				li $t6, 2
				lw $ra, ($sp)
				addi $sp, $sp, 4
				jr $ra
				
						
#Se verifica cada cuadr�cula del tablero para comprobar si hay ganador
#Si hay ganador, se dibuja una l�nea sobre las tres casillas ganadoras								
comprobarGanador:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	li $t0, 0
	li $a2, AMARILLO #la linea que se dibuja sobre las sillas es amarilla
	
	vertical1:
		beq $s0, $s3, vertical1con2
		j vertical2
		vertical1con2:
		li $a0, 22
		li $a1, 0
		beq $s3, $s6, dibujarVertical
		
	vertical2:
		beq $s1, $s4, vertical2con2
		j vertical3
		vertical2con2:
		li $a0, 64
		li $a1, 0
		beq $s4, $s7, dibujarVertical
		
	vertical3:
		beq $s2, $s5, vertical3con2
		j horizontal1
		vertical3con2:
		li $a0, 107
		li $a1, 0
		beq $s5 $t6, dibujarVertical
		
	horizontal1:
		beq $s0, $s1, horizontal1con2
		j horizontal2
		horizontal1con2:
			li $a0, 0
			li $a1, 22
			beq $s1, $s2, dibujarHorizontal
			
	horizontal2:
		beq $s3, $s4, horizontal2con2
		j horizontal3
		horizontal2con2:
			li $a0, 0
			li $a1, 64
			beq $s4, $s5, dibujarHorizontal
			
	horizontal3:
		beq $s6, $s7 horizontal3con2
		j diagonalDerecha
		horizontal3con2:
			li $a0, 0
			li $a1, 108
			beq $s7, $t6, dibujarHorizontal
			
	diagonalDerecha:
		beq $s2, $s4, diagonalDerechacon2
		j diagonalIzquierda
		diagonalDerechacon2:
			li $a0, 127
			li $a1, 0
			li $t0, 0
			beq $s4, $s6, dibujarDiagonalDerecha
			
	diagonalIzquierda:
		beq $s0, $s4, diagonalIzquierdacon2
		j backj
		diagonalIzquierdacon2:
			li $a0, 0
			li $a1, 0
			beq $s4, $t6, dibujarDiagonalIzquierda
			j backj
			
#Se dibuja la l�nea ganadora en vertical							
 dibujarVertical:
 	
 	beq $t0, 128, backj
 	jal dibujarPixel
 	addi $t0, $t0, 1
 	addi $a1, $a1, 1
 	j dibujarVertical
 	
#Se dibuja la l�nea ganadora en horizontal	
 dibujarHorizontal:
 	beq $t0, 128, backj
 	jal dibujarPixel
 	addi $t0, $t0, 1
 	addi $a0, $a0, 1
 	j dibujarHorizontal
 	
 #Se dibuja la l�nea diagonal izquierda ganadora
 dibujarDiagonalIzquierda: 
 	beq $t0, 512, backj
 	jal dibujarPixel
 	addi $t0, $t0, 1
 	addi $a0, $a0, 1
 	addi $a1, $a1, 1
 	j dibujarDiagonalIzquierda
 	
 #Se dibuja la l�nea diagonal derecha ganadora	
 dibujarDiagonalDerecha: 
 	beq $t0, 512, backj
 	jal dibujarPixel
 	addi $t0, $t0, 1
 	addi $a0, $a0, -1
 	addi $a1, $a1, 1
 	j dibujarDiagonalDerecha
 	
#Arregla el puntero de la pila y salta hacia atr�s
backj:
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra			
