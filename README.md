# ProyectoArquitectura
Integrantes: 

Sebastián Orozco Castillo C35719

Melanny Hernández Rivera B83808


Funcionalidad implementada:
    ciclo: función para iniciar el juego, esta función "es la principal" para recibir el teclado y dibujar demás cosas del juego.
    leerTeclado: espera un input del usuario para leer el teclado, recibe w a s d(funciones que dibujan una X o una O) y enter para poder jugar.
    ponerFigura: simplemente decide si se leyó una X o una O enviadas por leerTeclado y llama a la función de dibujar para colocar una X o una O en la posición enviada.
    dibujarTablero: función para dibujar el tablero del juego, se complementa con las demás funciones de "dibujar" explicadas posteriormente.
    dibujarVerticalIzquierda: función que dibuja una línea vertical a la izquierda de la pantalla (primera línea vertical del tablero), y llama a la función dibujarVerticalCentral.
    dibujarVerticalCentral: dibuja la línea vertical central del tablero.
    dibujarVerticalDerecha: dibuja una línea vertical a la derecha de la pantalla (última línea vertical del tablero), y llama a la función dibujarPrimeraLinea.
    #dibujarPrimeraLinea: FALTA.
    dibujarHorizontalSuperior: función que dibuja la línea horizontal de arriba del tablero, y llama a la función dibujarHorizontalCentral.
    dibujarHorizontalCentral: función que dibuja la línea horizontal central del tablero.
    dibujarHorizontalInferior: función que dibuja la línea horizontal inferior del tablero, y llama a la función posicionarSelector.

Funcionalidad no implementada:
    comprobarGanador: aún no se comprueba.
    dibujarX: aún no se dibuja.
    dibujarO: aún no se dibuja.
    posicionarSelector: será para guiar al usuario al momento de elegir la posición a marcar.


Imagenes del código:
    aún no hay imágenes de la interfáz para mostrar.

Errores conocidos: 
    Se dibuja gran parte del tablero, pero no completamente, y se reciben valores desde el teclado.