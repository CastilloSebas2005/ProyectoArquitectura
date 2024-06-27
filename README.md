# ProyectoArquitectura
Integrantes: 

Sebastián Orozco Castillo C35719

Melanny Hernández Rivera B83808

Instrucciones para compilar:
    1. instalar mars https://courses.missouristate.edu/KenVollmar/MARS/ vaya donde dice download y siga las instrucciones.
    2. luego de instalar mars, irse arriba a la izquierda al apartado de file, seleccionar open y buscar el archivo juegoGato.asm de este repositorio y abrirlo con mars.
    3. buscar arriba en mars el apartado de "tools" abrir bitmap display y configurar con los siguientes parámetros: 
    Unit Width in Pixels: 4
    Unit Height in Pixels: 4
    Display Width in Pixels: 512
    Display Height in Pixels: 512
    Base address for display: 0x10008000($gp) que es el registro "pila" las funciones de este programa dependen de este registro
    y luego de esto darle a la opción Connect to MIPS
    4. buscar en tools Keyboard and Display MMIO Simulator y darle a la opción connect to MIPS, para que pueda recibir las teclas wsda y enter, que son las necesarias para moverse e insertar ficha, con wsda se mueve y con enter selecciona el lugar donde va a dibujar.
    5. arriba buscar el apartado de run y darle en Assemble esto es para asegurarse que el programa compila. 
    6. en el mismo lugar donde está Assemble pulsar el botón de Go y esto debería mostrar en BitMap Display el tablero de Gato y luego de esto apretar en el espacio en blanco de Keyboard and Display MMIO Simulator donde dice KEYBOARD:Characters typed here...
    y con esto ya podría jugar correctamente el gato.
    nota: importante, si quiere volver a jugar debe de darle en reset en ambas herramientas de mars y volver a compilar y darle en go de nuevo.
    IMPORTANTE: si desea salir del programa simplemente pulse la barra espaciadora.

Funcionalidad implementada:
    ciclo: función para iniciar el juego, esta función "es la principal" para recibir el teclado y dibujar demás cosas del juego.

    leerTeclado: espera un input del usuario para leer el teclado, recibe w a s d(funciones que dibujan una X o una O) y enter para poder jugar.
    ponerFigura: simplemente decide si se leyó una X o una O enviadas por leerTeclado y llama a la función de dibujar para colocar una X o una O en la posición enviada. Además de usar una función que se llama obtenerColor que esta lo que hace es controlar si se le envía un O o una X, y dependiendo de lo que sea decide que color se va a dibujar, las X son Rojas y los O son azules.

    dibujarTablero: función para dibujar el tablero del juego, se complementa con las demás funciones de "dibujar" explicadas posteriormente.

    dibujarVerticalIzquierda: función que dibuja una línea vertical a la izquierda de la pantalla (primera línea vertical del tablero), y llama a la función 

    dibujarVerticalCentral: dibuja la línea vertical central del tablero.

    dibujarVerticalDerecha: dibuja una línea vertical a la derecha de la pantalla (última línea vertical del tablero), y llama a la función dibujarPrimeraLinea.

    dibujarPrimeraLinea: reinicia los valores.

    dibujarHorizontalSuperior: función que dibuja la línea horizontal de arriba del tablero, y llama a la función dibujarHorizontalCentral.

    dibujarHorizontalCentral: función que dibuja la línea horizontal central del tablero.

    dibujarHorizontalInferior: función que dibuja la línea horizontal inferior del tablero, y llama a la función posicionarSelector.

    posicionarSelector: función que dibuja un pixel en el centro del tablero, el cual se mueve mediante las teclas a,s,d,e para elegir la posición del tablero en la que se quiere poner la figura correspondiente.

    dibujarX: función que dibuja pixel a pixel, una X dependiendo de donde se seleccione, usa las funciones dibujarPixel y posicionarSelector

    dibujarO: función que dibuja pixel a pixel, un O dependiendo de donde se seleccione, usa las funciones dibujarPixel y posicionarSelector esta fue un poco más compleja, no se hace un círculo perfecto ya que solo se pueden manejar pixeles en diagonal, entonces se intenta representar.

    guardarPosicion: Función que guarda donde se colocan los elementos en el tablero, se guarda el color y la ubicacion de la figura (ROJO = x & AZUL = O).

    comprobarGanador: función que dibuja pixel a pixel una línea amarilla sobre las tres casillas ganadoras, usa las funciones dibujarVertical, dibujarHorizontal, dibujarDiagonalIzquierda y dibujarDiagonalDerecha. 

    dibujarPixel: función encargada de dibujar un pixel, esta función es la más importante.
Funcionalidad no implementada:
    ReiniciarTablero para volver a jugar
    Controlar que no se sobreescriba en el espacio ya seleccionado
    estas dos no se implementaron porque no afectan al funcionamiento del programa, no son necesarias, ya que no producen un error como tal. Con lo que tiene el programa cumple con los requisitos mínimos requeridos.
Imagenes del código:
    aún no hay imágenes de la interfáz para mostrar.

Errores conocidos: 
    Si no se inicia la herramienta bitmap y la de leer el teclado, el programa no hará nada(no es un error como tal, simplemente el programa está hecho solo para que funcione con bitmap).
    Se puede sobreescribir en el tablero, es decir, se puede escribir una X encima de una O, sin embargo no afecta al funcionamiento.