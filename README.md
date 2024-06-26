# ProyectoArquitectura
Integrantes: 

Sebastián Orozco Castillo C35719

Melanny Hernández Rivera B83808


Funcionalidad implementada:
    ciclo: función para iniciar el juego, esta función "es la principal" para recibir el teclado y dibujar demás cosas del juego.

    leerTeclado: espera un input del usuario para leer el teclado, recibe w a s d(funciones que dibujan una X o una O) y enter para poder jugar.
    ponerFigura: simplemente decide si se leyó una X o una O enviadas por leerTeclado y llama a la función de dibujar para colocar una X o una O en la posición enviada. Además de usar una función que se llama obtenerColor que esta lo que hace es controlar si se le envía un O o una X, y dependiendo de lo que sea decide que color se va a dibujar, las X son Rojas y los O son azules.

    dibujarTablero: función para dibujar el tablero del juego, se complementa con las demás funciones de "dibujar" explicadas posteriormente.

    dibujarVerticalIzquierda: función que dibuja una línea vertical a la izquierda de la pantalla (primera línea vertical del tablero), y llama a la función 

    dibujarVerticalCentral: dibuja la línea vertical central del tablero.

    dibujarVerticalDerecha: dibuja una línea vertical a la derecha de la pantalla (última línea vertical del tablero), y llama a la función dibujarPrimeraLinea.

    #dibujarPrimeraLinea: FALTA.

    dibujarHorizontalSuperior: función que dibuja la línea horizontal de arriba del tablero, y llama a la función dibujarHorizontalCentral.

    dibujarHorizontalCentral: función que dibuja la línea horizontal central del tablero.

    dibujarHorizontalInferior: función que dibuja la línea horizontal inferior del tablero, y llama a la función posicionarSelector.

    posicionarSelector: función que dibuja un pixel en el centro del tablero, el cual se mueve mediante las teclas a,s,d,e para elegir la posición del tablero en la que se quiere poner la figura correspondiente.

    dibujarX: función que dibuja pixel a pixel, una X dependiendo de donde se seleccione, usa las funciones dibujarPixel y posicionarSelector

    dibujarO: función que dibuja pixel a pixel, un O dependiendo de donde se seleccione, usa las funciones dibujarPixel y posicionarSelector esta fue un poco más compleja, no se hace un círculo perfecto ya que solo se pueden manejar pixeles en diagonal, entonces se intenta representar.

    guardarPosicion: Función que guarda donde se colocan los elementos en el tablero, se guarda el color y la ubicacion de la figura (ROJO = x & AZUL = O).

    comprobarGanador: función que dibuja pixel a pixel una línea amarilla sobre las tres casillas ganadoras, usa las funciones dibujarVertical, dibujarHorizontal, dibujarDiagonalIzquierda y dibujarDiagonalDerecha. 

Funcionalidad no implementada:
    
    juegoTerminado: para cuando alguien gana, se termina el juego.
    
Imagenes del código:
    aún no hay imágenes de la interfáz para mostrar.

Errores conocidos: 
    Se dibuja gran parte del tablero, pero no completamente, y se reciben valores desde el teclado.
    Se dibujan las figuras de juego y el pixel de posicionarSelector, pero la X no se dibuja completamente.
    El juego detecta que ya hubo ganadores, pero no finaliza la partida.
    El juego no reconoce las jugadas diagonales como ganadoras.
    Si no se inicia la herramienta bitmap y la de leer el teclado, el programa no hará nada
    Se puede sobreescribir en el tablero, es decir, se obtiene un ganador pero la partida no termina, por lo que se puede seguir colocando figuras en casillas ya ocupadas. 