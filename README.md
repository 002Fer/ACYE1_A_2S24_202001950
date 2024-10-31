# ACYE1_A_2S24_202001950

# Manual Técnico
## PROYECTO NO. 2
## Arquitectura: ARM64
# Fernando Misael Morales Ortiz
## 202001950

## Descripcion
la aplicación trata sobre hojas de cálculo realizadas en el lenguaje Ensamblador.
Dicho software permitirá manejar datos numéricos por medio de diversas operaciones
matemáticas y lógicas, operando sobre datos puntuales o rangos. Se interactuará con
el programa a través de una interfaz de línea de comandos por la cual se instruirá al
programa sobre las acciones que debe realizar
## Organización del Código
## .data (Segmento de Datos)

Contiene cadenas de texto utilizadas para imprimir mensajes en pantalla y para procesar la entrada del usuario.

## .bss (Segmento de Variables Sin Inicializar)

En este segmento se definen los buffers que almacenan la entrada del usuario y los resultados de las operaciones.

## .text (Segmento de Código)

Contiene el código ejecutable del programa, incluidas las macros para entrada/salida, las funciones para conversión de datos y el bucle principal de ejecución.
## atoi (ASCII to Integer)

Convierte una cadena de caracteres (ASCII) que representa un número en formato entero.

    Recorre la cadena carácter por carácter y convierte cada dígito a su valor numérico.
    Gestiona números negativos.
    Utiliza multiplicadores para determinar el valor posicional de cada dígito.

# itoa (Integer to ASCII)

Convierte un número entero en su representación como cadena de caracteres ASCII.

    Convierte el número entero dividiéndolo en sus dígitos y convirtiendo cada uno a su valor ASCII.
    Añade un signo negativo si es necesario.
    Gestiona correctamente números negativos y el caso especial del número cero.
## macros
son secciones que sirven como funiones en este caso se usaron para poder hacer el pedido de una de las opciones del menu 

# _start (Punto de Entrada)

El flujo principal del programa comienza en la etiqueta _start, que contiene los siguientes pasos:

    Mostrar Encabezado y Menú Principal:
        Limpia la pantalla con clear_screen.
        Muestra el encabezado de la universidad y el menú de opciones.

    Leer la Opción del Usuario:
        Usa la macro read para obtener la opción del usuario desde el menú principal.
        Dependiendo de la opción seleccionada, realiza una de las siguientes operaciones: suma, resta, multiplicación, división o salir del programa.

    Operaciones Aritméticas:
        El programa solicita dos operandos al usuario y los convierte a enteros usando la función atoi.
        Ejecuta la operación seleccionada (suma, resta, multiplicación, división).
        Si se selecciona división, verifica si el divisor es cero y, de ser así, muestra un mensaje de error.

    Mostrar Resultados:
        El resultado de la operación se convierte de nuevo a una cadena ASCII usando la función itoa.
        Imprime el resultado en pantalla.
        Espera a que el usuario presione una tecla para continuar o finalizar el programa.


# Manual Técnico
## PROYECTO NO. 2
## Arquitectura: ARM64
# Fernando Misael Morales Ortiz
## 202001950
