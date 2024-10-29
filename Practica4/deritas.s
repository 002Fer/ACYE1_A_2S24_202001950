.global openFile
.global closeFile
.global readCSV
.global atoi
.global itoa
.global bubbleSort
.global _start


.data
    nombre: .asciz "reporte.txt"
    encabezado:
        .asciz "Universidad de San Carlos de Guatemala\n"
        .asciz "Facultad de Ingenieria\n"
        .asciz "Escuela de Ciencias y Sistemas\n"
        .asciz "Arquitectura de Computadores y Ensambladores 1\n"
        .asciz "Sección A\n"
        .asciz "Fernando Misael Morales Ortiz\n"
        .asciz "202001950\n"
        lencabezado = . - encabezado
      
    salto:
        .asciz "\n"
        lenSalto = .- salto

    espacio:
        .asciz " "
        lenEspacio = .- espacio

    clear_screen:
        .asciz "\x1B[2J\x1B[H"
        lenClear = .- clear_screen

    menuPrincipal:
        .asciz ">> Menu Principal\n"
        .asciz "1. Ingreso de lista de números\n"
        .asciz "2. Bubble Sort\n"
        .asciz "3. Insertion sort\n"
        .asciz "4. otro\n"
        .asciz "5. Salir\n"
        .asciz ">> Ingrese Una Opcion:\n"
        lenMenu = . - menuPrincipal

    menuCarga:
        .asciz ">> Metodo de  carga\n"
        .asciz "1. De forma manual\n"
        .asciz "2. Carga de Archivo csv\n"
        .asciz "3. Regresar al menú anterior\n"
        .asciz ">> Ingrese Una Opcion:\n"
        lenCarga = . - menuCarga
    menu3:
        .asciz ">> Metodo de  carga\n"
        .asciz "1. Ascendente\n"
        .asciz "2. Descendente\n"
        .asciz ">> Ingrese Una Opcion:\n"
        lenmenu3 = . - menu3

    msgFilename:
        .asciz "Ingrese el nombre del archivo: "
        lenMsgFilename = .- msgFilename

    errorOpenFile:
        .asciz "Error al abrir el archivo\n"
        lenErrOpenFile = .- errorOpenFile

    readSuccess:
        .asciz "El Archivo Se Ha Leido Correctamente\n"
        lenReadSuccess = .- readSuccess
    inputOperacion:
        .asciz ">> Ingrese el listado: "
        lenInputOperacion = . - inputOperacion
    salirMensaje:
    .asciz "¿Desea salir de la calculadora? (y/n): "
    lenSalirMensaje = . - salirMensaje

    nombre_ordenamiento: .asciz "Metodo burbuja\n"
.bss
// Almacenar el número de iteraciones
iteraciones:
    .word 0

// Buffer para almacenar el resultado convertido a ASCII
buffer:
    .space 100  // Ajustar según sea necesario
    
opcion:
    .space 5

opcion2:
    .space 5

filename:
    .zero 50

count:
    .zero 8

num:
    .space 4

character:
    .byte 0

fileDescriptor:
    .space 8
bufferConfirmacion:
    .space 2
inputBuffer:
    .space 100  // Buffer para almacenar la entrada del usuario
array:

.text
.global ingreso_por_comas
.global convert_array_to_ascii
// Macro para imprimir strings
.macro print reg, len
    MOV x0, 1
    LDR x1, =\reg
    MOV x2, \len
    MOV x8, 64
    SVC 0
.endm

// Macro para leer datos del usuario
.macro read stdin, buffer, len
    MOV x0, \stdin
    LDR x1, =\buffer
    MOV x2, \len
    MOV x8, 63
    SVC 0
.endm

.macro read2 reg, len
    MOV x0, 0
    LDR x1, =\reg
    MOV x2, \len
    MOV x8, 63
    SVC 0
.endm

readNUM:
    // code para leer numero y convertir
    LDR x10, =num    // Buffer para almacenar el numero
    LDR x11, =inputBuffer

    rd_num_manual:
        LDRB w3, [x11], 1
        CMP w3, 44
        BEQ rd_cv_num_manual
        CMP w3, 0
        BEQ rd_cv_num_manual_end

        MOV x20, x0
        CBZ x0, rd_cv_num_manual

        STRB w3, [x10], 1
        B rd_num_manual

 rd_cv_num_manual:
        LDR x5, =num
        LDR x8, =num
        LDR x12, =array

        STP x29, x30, [SP, -16]!

        BL atoi

        LDP x29, x30, [SP], 16

        LDR x12, =num
        MOV w13, 0
        MOV x14, 0

        cls_num_manual:
            STRB w13, [x12], 1
            ADD x14, x14, 1
            CMP x14, 3
            BNE cls_num_manual
            LDR x10, =num
            CBNZ x20, rd_num_manual


    rd_cv_num_manual_end:
        // Procesar el último número
        LDR x5, =num
        LDR x8, =num
        LDR x12, =array

        STP x29, x30, [SP, -16]!

        BL atoi

        LDP x29, x30, [SP], 16

        LDR x12, =num
        MOV w13, 0
        MOV x14, 0

        cls_num_manual_end:
            STRB w13, [x12], 1
            ADD x14, x14, 1
            CMP x14, 3
            BNE cls_num_manual_end

    rd_end_manual:
        print salto, lenSalto
        RET
clear_array:
    LDR x0, =array
    MOV x1, 0
    MOV x2, 400  // Tamaño del array en bytes
ingreso_por_comas:
    MOV x12, xzr
    print clear_screen, lenClear
    // Limpiar el array antes de ingresar nuevos datos
    BL clear_array
    // Mensaje para ingresar los números
    print inputOperacion, lenInputOperacion
    read 0, inputBuffer, 100
    // Agregar caracter nulo al final del buffer
    LDR x0, =inputBuffer
    loop1:
        LDRB w1, [x0], 1
        CMP w1, 10
        BEQ endLoop1
        B loop1

        endLoop1:
            MOV w1, 0
            STRB w1, [x0, -1]!

openFile:
    // param: x1 -> filename
    MOV x0, -100
    MOV x2, 0
    MOV x8, 56
    SVC 0

    CMP x0, 0
    BLE op_f_error
    LDR x9, =fileDescriptor
    STR x0, [x9]
    B op_f_end

    op_f_error:
        print errorOpenFile, lenErrOpenFile
        read 0, opcion, 1

    op_f_end:
        RET

closeFile:
    LDR x0, =fileDescriptor
    LDR x0, [x0]
    MOV x8, 57
    SVC 0
    RET

readCSV:
    // code para leer numero y convertir
    LDR x10, =num    // Buffer para almacenar el numero
    LDR x11, =fileDescriptor
    LDR x11, [x11]

    rd_num:
        read x11, character, 1
        LDR x4, =character
        LDRB w3, [x4]
        CMP w3, 44
        BEQ rd_cv_num

        MOV x20, x0
        CBZ x0, rd_cv_num

        STRB w3, [x10], 1
        B rd_num

    rd_cv_num:
        LDR x5, =num
        LDR x8, =num
        LDR x12, =array

        STP x29, x30, [SP, -16]!

        BL atoi

        LDP x29, x30, [SP], 16

        LDR x12, =num
        MOV w13, 0
        MOV x14, 0

        cls_num:
            STRB w13, [x12], 1
            ADD x14, x14, 1
            CMP x14, 3
            BNE cls_num
            LDR x10, =num
            CBNZ x20, rd_num

    rd_end:
        print salto, lenSalto
        print readSuccess, lenReadSuccess
        read 0, opcion, 2
        RET

atoi:
    // params: x5, x8 => buffer address, x12 => result address
    SUB x5, x5, 1
    a_c_digits:
        LDRB w7, [x8], 1
        CBZ w7, a_c_convert
        CMP w7, 10
        BEQ a_c_convert
        B a_c_digits

    a_c_convert:
        SUB x8, x8, 2
        MOV x4, 1
        MOV x9, 0

        a_c_loop:
            LDRB w7, [x8], -1
            CMP w7, 45
            BEQ a_c_negative

            SUB w7, w7, 48
            MUL w7, w7, w4
            ADD w9, w9, w7

            MOV w6, 10
            MUL w4, w4, w6

            CMP x8, x5
            BNE a_c_loop
            B a_c_end

        a_c_negative:
            NEG w9, w9

        a_c_end:
            LDR x13, =count
            LDR x13, [x13] // saltos
            MOV x14, 2
            MUL x14, x13, x14

            STRH w9, [x12, x14] // usando 16 bits

            ADD x13, x13, 1
            LDR x12, =count
            STR x13, [x12]

            RET

itoa:
    // Prologo: Guardar los registros que vamos a usar y que necesitan ser preservados
    STP x29, x30, [SP, -16]!     // Guardar Frame Pointer y Link Register
    STP x19, x20, [SP, -16]!     // Guardar registros x19 y x20 (si se utilizan)

    // Establecer el Frame Pointer
    MOV x29, SP

    // params: x0 => number, x1 => buffer address
    MOV x10, 0          // contador de digitos a imprimir
    MOV x12, 0          // flag para indicar si hay signo menos
    MOV w2, 10000       // Base 10
    CMP w0, 0           // Numero a convertir
    BGT i_convertirAscii
    CBZ w0, i_zero

    B i_negative

    i_zero:
        ADD x10, x10, 1
        MOV w5, 48
        STRB w5, [x1], 1
        B i_endConversion

    i_negative:
        MOV x12, 1
        MOV w5, 45
        STRB w5, [x1], 1
        NEG w0, w0

    i_convertirAscii:
        CBZ w2, i_endConversion
        UDIV w3, w0, w2
        CBZ w3, i_reduceBase

        MOV w5, w3
        ADD w5, w5, 48
        STRB w5, [x1], 1
        ADD x10, x10, 1

        MUL w3, w3, w2
        SUB w0, w0, w3

        CMP w2, 1
        BLE i_endConversion

    i_reduceBase:
        MOV w6, 10
        UDIV w2, w2, w6

        CBNZ w10, i_addZero
        B i_convertirAscii

    i_addZero:
        CBNZ w3, i_convertirAscii
        ADD x10, x10, 1
        MOV w5, 48
        STRB w5, [x1], 1
        B i_convertirAscii

    i_endConversion:
    ADD x10, x10, x12
    print num, x10  // Asume que 'print' es una subrutina válida

    // Epílogo: Restaurar los registros desde la pila
    LDP x19, x20, [SP], 16       // Restaurar registros x19 y x20
    LDP x29, x30, [SP], 16       // Restaurar Frame Pointer y Link Register
    RET                           // Retorna al llamador
    
convert_array_to_ascii:          // Aquí comienza la sección de código accesible globalmente
    STP x29, x30, [SP, -16]!     // Guardar x29 y x30 en la pila
    STP x7, x15, [SP, -16]!      // Guardar x7 y x15 en la pila para protegerlos

    LDR x9, =count
    LDR x9, [x9]                 // length => cantidad de números leídos del CSV
    MOV x7, 0
    LDR x15, =array

    loop_array:
        LDRH w0, [x15], 2            // Carga un número del array
        LDR x1, =num                 // Dirección del buffer para almacenar el ASCII
        STP x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        BL itoa                      // Convierte el número a ASCII
        LDP x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada

        print espacio, lenEspacio     // Imprime un espacio

        ADD x7, x7, 1
        CMP x9, x7                   // Compara si hemos procesado todos los números
        BNE loop_array               // Si no, vuelve al loop

        print salto, lenSalto         // Imprime un salto de línea al final

        LDP x7, x15, [SP], 16        // Restaurar x7 y x15 al finalizar
        LDP x29, x30, [SP], 16       // Restaurar x29 y x30 al finalizar
        RET                          // Retorno del procedimiento

bubbleSort:
    LDR x0, =count
    LDR x0, [x0] // length => cantidad de numeros leidos del csv

    MOV x1, 0 // index i - bubble sort algorithm
    SUB x0, x0, 1 // length - 1

    bs_loop1:
        MOV x9, 0 // index j - algoritmo de bubble sort
        SUB x2, x0, x1 // longitud - 1 - i

    bs_loop2:
        LDR x3, =array
        LDRH w4, [x3, x9, LSL 1] // array[i]
        ADD x9, x9, 1
        LDRH w5, [x3, x9, LSL 1] // array[i + 1]

        CMP w4, w5
        BLT bs_cont_loop2 // Cambia BLT a BGT para ordenar en orden descendente

        STRH w4, [x3, x9, LSL 1]
        SUB x9, x9, 1
        STRH w5, [x3, x9, LSL 1]
        ADD x9, x9, 1

    bs_cont_loop2:
        CMP x9, x2
        BNE bs_loop2

        ADD x1, x1, 1
        CMP x1, x0
        BNE bs_loop1
    RET

bubbleSort2:
    LDR x0, =count
    LDR x0, [x0] // length => cantidad de numeros leidos del csv

    MOV x1, 0 // index i - bubble sort algorithm
    SUB x0, x0, 1 // length - 1

    _loop1:
        MOV x9, 0 // index j - algoritmo de bubble sort
        SUB x2, x0, x1 // longitud - 1 - i

    _loop2:
        LDR x3, =array
        LDRH w4, [x3, x9, LSL 1] // array[i]
        ADD x9, x9, 1
        LDRH w5, [x3, x9, LSL 1] // array[i + 1]

        CMP w4, w5
        BGT _cont_loop2 // Cambia BLT a BGT para ordenar en orden descendente

        STRH w4, [x3, x9, LSL 1]
        SUB x9, x9, 1
        STRH w5, [x3, x9, LSL 1]
        ADD x9, x9, 1

    _cont_loop2:
        CMP x9, x2
        BNE _loop2

        ADD x1, x1, 1
        CMP x1, x0
        BNE _loop1
    RET
// Procedimiento para Insertion Sort

insertionSort:
    LDR x0, =count
    LDR x0, [x0]  // length => cantidad de números leídos del CSV

    MOV x1, 1  // Empezar desde el segundo elemento (índice 1)
    SUB x0, x0, 1  // length - 1

is_loop1:
    LDR x2, =array
    ADD x3, x2, x1, LSL 1  // Puntero a array[i]
    LDRH w4, [x3]  // array[i]
    MOV x5, x1  // j = i

is_loop2:
    SUB x5, x5, 1  // j--
    CMP x5, 0
    BLT is_insert

    LDRH w6, [x2, x5, LSL 1]  // array[j-1] - Leer el valor del elemento
    CMP w6, w4
    BLE is_insert

    // Shift array[j-1] a la derecha
    ADD x7, x5, 1
    STRH w6, [x2, x7, LSL 1]  // Escribir el valor en la posición j

    B is_loop2

is_insert:
    ADD x7, x5, 1
    STRH w4, [x2, x7, LSL 1]  // Insertar w4 en la posición correcta

    ADD x1, x1, 1
    CMP x1, x0
    BLE is_loop1

    RET

_start:
    // Limpiar salida de la terminal
    print clear_screen, lenClear
    
    
    
    print encabezado, lencabezado 
    read2 opcion, 1

    menu:
        print clear_screen, lenClear

        print menuPrincipal, lenMenu //cargo el menu principal
        read2 opcion, 5

        LDR x12, =opcion
        LDRB w12, [x12]
        CMP w12, 52      //comparo si es la opcion de salida 
        BEQ confirmar_salir

        CMP w12,49 //compara si es la opcion 1 y se va al submenu
        BEQ menu2

        CMP w12, 50
        BEQ orden_bubble

        CMP w12,51
        BEQ orden_insert
        

        
        menu2: //carga de archivo
            print clear_screen, lenClear
            print menuCarga,lenCarga
            read2 opcion2, 5

            LDR x12, =opcion2
            LDRB w12, [x12]
            CMP w12, #'1'     //si es la opcion 1 se pasa a listadoArr
            BEQ ingreso_por_comas

            CMP w12, 50
            BEQ cargaCSV

            B menu


            cargaCSV:
                print clear_screen, lenClear
                print msgFilename, lenMsgFilename
                read 0, filename, 50
                // Agregar caracter nulo al final del nombre del archivo
                 LDR x0, =filename
                 loop:
                    LDRB w1, [x0], 1
                    CMP w1, 10
                    BEQ endLoop
                    B loop

                    endLoop:
                        MOV w1, 0
                        STRB w1, [x0, -1]!

                    // funcion para abrir el archivo
                LDR x1, =filename
                BL openFile 
                    
                    // procedimiento para leer los numeros del archivo
                BL readCSV

                    // funcion para cerrar el archivo
                BL closeFile 

                B menu
        
    orden_bubble:
        print menu3, lenmenu3
        read2 opcion2, 5
        LDR x12, =opcion2
        LDRB w12, [x12]
        CMP w12, #'1'     //si es la opcion 1 se pasa a listadoArr
        BEQ desc

        
        desc:
            BL bubbleSort

        // recorrer array y convertir a ascii
            BL convert_array_to_ascii
        B menu
    orden_insert:
        BL insertionSort
        BL convert_array_to_ascii      
    confirmar_salir:
        print salirMensaje, lenSalirMensaje
        read2 bufferConfirmacion, 5

        LDR x0, =bufferConfirmacion 
        LDRB w2, [x0]              
        CMP w2, 121                  
        BEQ end

        BL menu
    end:
        MOV x0, 0
        MOV x8, 93
        SVC 0

