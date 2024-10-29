.global openFile
.global closeFile
.global readCSV
.global atoi
.global itoa
.global bubbleSort
.global quickSort
.global insertionSort
.global convert_array_to_ascii
.global getFilename
.global openFile
.global openReport
.global closeFile

.global _start

.data

clear:
        .asciz "\x1B[2J\x1B[H"
        lenClear = . - clear

msgEnterNumbers:
    .asciz "Ingrese números separados por comas:\n"
    lenMsgEnterNumbers = . - msgEnterNumbers

ingresoManualText:
    .asciz "Ingresando lista de forma manual: \n\n"
    lenIngresoManualText = . - ingresoManualText
datosGuardadosText:
    .asciz "Datos almacenados correctamente.\n"
    lenDatosGuardadosText = . - datosGuardadosText
formatoText:
    .asciz "¿Como desea ingresar los números?\n"
    .asciz "1. Separados por coma\n"
    .asciz "2. Por archivo csv\n"
    .asciz "3. Mostrar datos almacenados\n"
    .asciz "4. Regresar al menú anterior\n"
    lenFormatoText = . -  formatoText
encabezado:
    .asciz "Universidad de San Carlos de Guatemala\n"
    .asciz "Facultad de Ingenieria\n"
    .asciz "Escuela de Ciencias y Sistemas\n"
    .asciz "Arquitectura de Computadoras y Ensambladores 1\n"
    .asciz "Seccion A\n"
    .asciz "Adrian Josue Fernandez Avila\n"
    .asciz "201800701\n"
    lenEncabezado = . - encabezado
menuPrincipal:
    .asciz "Menu Principal\n"
    .asciz "1. Insertar lista de números\n"
    .asciz "2. Ordenar por Bubble Sort\n"
    .asciz "3. Ordenar por Insertion Sort\n"
    .asciz "4. Ordenar por Quick Sort\n"
    .asciz "5. Salir\n"
    lenMenuPrincipal = . - menuPrincipal
mostrarDatosText:
    .asciz "Datos actuales: \n\n"
    lenMostrarDatosText = . - mostrarDatosText
ingreso_numerosText:
    .asciz "Ingreso de lista de numeros:\n"
    leningreso_numerosText = . - ingreso_numerosText
msgOpcion:
    .asciz "Ingrese la opcion a seleccionar:\n"
    lenOpcion = . - msgOpcion
salto:
    .asciz "\n"
    lenSalto = .- salto
preguntaText:
    .asciz "¿Está seguro de que desea salir del programa?\n"
    .asciz "1. Sí, salir.\n"
    .asciz "2. No, volver al menú principal.\n"
    lenPreguntaText = . - preguntaText
finalizarText:
    .asciz "Finalizando programa\n"
    .asciz "ACYE A 2S24\n"
    lenFinalizarText = . - finalizarText
espacio:
    .asciz " "
    lenEspacio = .- espacio

msgFilename:
    .asciz "Ingrese el nombre del archivo: "
    lenMsgFilename = .- msgFilename

errorOpenFile:
    .asciz "Error al abrir el archivo\n"
    lenErrOpenFile = .- errorOpenFile

readSuccess:
    .asciz "El Archivo Se Ha Leido Correctamente\n"
    lenReadSuccess = .- readSuccess

bubble_sortText:
    .asciz "Ordenando por Bubble Sort:\n"
    .asciz "-------------------------------------------\n\n"
    .asciz "1. Ascendente\n"
    .asciz "2. Descendente\n"
    lenbubble_sortText = . - bubble_sortText

quick_sortText:
    .asciz "Ordenando por Quick Sort:\n"
    .asciz "-------------------------------------------\n\n"
    lenquick_sortText = . - quick_sortText

insertion_sortText:
    .asciz "Ordenando por Insertion Sort:\n"
    .asciz "-------------------------------------------\n\n"
    leninsertion_sortText = . - insertion_sortText

createSucces:
    .asciz "El Reporte Se Ha Abierto Correctamente\n"
    lenCreateSuccess = .- createSucces

msgExecuteTime:
    .asciz "El tiempo de ejecucion fue de: "
    lenExecute = .- msgExecuteTime

prefixSec:
    .asciz " segundos "
    lenPrefixSec = .- prefixSec

prefixMicro:
    .asciz " microsegundos\n"
    lenPrefixMicro = .- prefixMicro

bubbletxt:
    .asciz "Bubble Sort"
    lenBubbletxt = .- bubbletxt

.bss
opcion:
    .space 2

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

timeStart:
    .xword 0, 0
    
timeEnd:
    .xword 0, 0

lista:
    .space 256

input_buffer:
    .space 100

manualInput: 
    .space 100

inputBuffer:
    .space 100  // Buffer para almacenar la entrada del usuario

array:
    .space 400

.text
.global ingreso_por_comas
// Macro para imprimir strings
.macro print stdout, reg, len
    MOV x0, \stdout
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

.macro getTime storage
    LDR x0, =\storage
    MOV x1, 0
    MOV x8, 169
    SVC 0
.endm

getFilename:
    print 1, msgFilename, lenMsgFilename
    read 0, filename, 50

    // Agregar caracter nulo al final del nombre del archivo
    LDR x0, =filename
    loopF:
        LDRB w1, [x0], 1
        CMP w1, 10
        BEQ endLoopF
        B loopF

        endLoopF:
            MOV w1, 0
            STRB w1, [x0, -1]!
    
    RET

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
        print 1, errorOpenFile, lenErrOpenFile
        read 0, opcion, 1

    op_f_end:
        RET

closeFile:
    LDR x0, =fileDescriptor
    LDR x0, [x0]
    MOV x8, 57
    SVC 0
    RET

openReport:
    MOV x0, -100        // open
    LDR x1, =filename   // filename address
    MOV x2, 101         // O_WRONLY | O_CREAT
    MOV x3, 0777        // permissions
    MOV x8, 56          // openat
    SVC #0              // syscall

    CMP x0, 0
    BLE op_r_error
    LDR x9, =fileDescriptor
    STR x0, [x9]
    B op_r_end

    op_r_error:
        print 1, errorOpenFile, lenErrOpenFile
        read 0, opcion, 1
        RET

    op_r_end:
        print 1, createSucces, lenCreateSuccess
        read 0, opcion, 1
        RET


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
        print 1, salto, lenSalto
        print 1, readSuccess, lenReadSuccess
        RET

clear_array:
    LDR x0, =array
    MOV x1, 0
    MOV x2, 400  // Tamaño del array en bytes

clear_loop:
    CMP x2, 0
    BEQ clear_done
    STRB w1, [x0], 1
    SUB x2, x2, 1
    B clear_loop

clear_done:
    // Limpiar num
    LDR x0, =num
    STR x1, [x0]

    // Limpiar count
    LDR x0, =count
    STR x1, [x0]

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
        print 1, salto, lenSalto
        print 1, readSuccess, lenReadSuccess
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
    print 1, num, x10  // Asume que 'print' es una subrutina válida

    // Epílogo: Restaurar los registros desde la pila
    LDP x19, x20, [SP], 16       // Restaurar registros x19 y x20
    LDP x29, x30, [SP], 16       // Restaurar Frame Pointer y Link Register
    RET                           // Retorna al llamador
    
convert_array_to_ascii:
    STP x29, x30, [SP, -16]!     // Guardar x29 y x30 en la pila
    STP x7, x15, [SP, -16]!      // Guardar x7 y x15 en la pila para protegerlos

    LDR x9, =count
    LDR x9, [x9]                 // length => cantidad de números leídos del CSV
    MOV x7, 0
    LDR x15, =array

    print 1, count, x9             // Asume que 'print' es una subrutina válida

    loop_array:
        CMP x7, x9               // Compara si hemos procesado todos los números
        BGE end_loop_array       // Si hemos procesado todos los números, salir del bucle

        LDRH w0, [x15], 2        // Carga un número del array
        LDR x1, =num             // Dirección del buffer para almacenar el ASCII
        STP x29, x30, [SP, -16]! // Guardar x29 y x30 antes de la llamada
        BL itoa                  // Convierte el número a ASCII
        LDP x29, x30, [SP], 16   // Restaurar x29 y x30 después de la llamada

        print 1, espacio, lenEspacio // Imprime un espacio

        ADD x7, x7, 1
        B loop_array             // Vuelve al bucle

    end_loop_array:
        print 1, salto, lenSalto    // Imprime un salto de línea al final

        LDP x7, x15, [SP], 16    // Restaurar x7 y x15 al finalizar
        LDP x29, x30, [SP], 16   // Restaurar x29 y x30 al finalizar
        RET                         // Retorno del procedimiento

itoaR:
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
    BGT i_convertirAsciiR
    CBZ w0, i_zeroR

    B i_negativeR

    i_zeroR:
        ADD x10, x10, 1
        MOV w5, 48
        STRB w5, [x1], 1
        B i_endConversion

    i_negativeR:
        MOV x12, 1
        MOV w5, 45
        STRB w5, [x1], 1
        NEG w0, w0

    i_convertirAsciiR:
        CBZ w2, i_endConversionR
        UDIV w3, w0, w2
        CBZ w3, i_reduceBaseR

        MOV w5, w3
        ADD w5, w5, 48
        STRB w5, [x1], 1
        ADD x10, x10, 1

        MUL w3, w3, w2
        SUB w0, w0, w3

        CMP w2, 1
        BLE i_endConversionR

    i_reduceBaseR:
        MOV w6, 10
        UDIV w2, w2, w6

        CBNZ w10, i_addZeroR
        B i_convertirAsciiR

    i_addZeroR:
        CBNZ w3, i_convertirAsciiR
        ADD x10, x10, 1
        MOV w5, 48
        STRB w5, [x1], 1
        B i_convertirAsciiR

    i_endConversionR:
    ADD x10, x10, x12
    print X20, num, x10  // Asume que 'print' es una subrutina válida

    // Epílogo: Restaurar los registros desde la pila
    LDP x19, x20, [SP], 16       // Restaurar registros x19 y x20
    LDP x29, x30, [SP], 16       // Restaurar Frame Pointer y Link Register
    RET                           // Retorna al llamador
    
convert_array_to_asciiR:
    STP x29, x30, [SP, -16]!     // Guardar x29 y x30 en la pila
    STP x7, x15, [SP, -16]!      // Guardar x7 y x15 en la pila para protegerlos

    LDR x9, =count
    LDR x9, [x9]                 // length => cantidad de números leídos del CSV
    MOV x7, 0
    LDR x15, =array

    print X20, count, x9             // Asume que 'print' es una subrutina válida

    loop_arrayR:
        CMP x7, x9               // Compara si hemos procesado todos los números
        BGE end_loop_arrayR       // Si hemos procesado todos los números, salir del bucle

        LDRH w0, [x15], 2        // Carga un número del array
        LDR x1, =num             // Dirección del buffer para almacenar el ASCII
        STP x29, x30, [SP, -16]! // Guardar x29 y x30 antes de la llamada
        BL itoaR                  // Convierte el número a ASCII
        LDP x29, x30, [SP], 16   // Restaurar x29 y x30 después de la llamada

        print X20, espacio, lenEspacio // Imprime un espacio

        ADD x7, x7, 1
        B loop_arrayR             // Vuelve al bucle

    end_loop_arrayR:
        print X20, salto, lenSalto    // Imprime un salto de línea al final

        LDP x7, x15, [SP], 16    // Restaurar x7 y x15 al finalizar
        LDP x29, x30, [SP], 16   // Restaurar x29 y x30 al finalizar
        RET                         // Retorno del procedimiento



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

bubbleSortDescendente:

    LDR x0, =count
    LDR x0, [x0] // length => cantidad de numeros leidos del csv

    MOV x1, 0 // index i - bubble sort algorithm
    SUB x0, x0, 1 // length - 1

    bsD_loop1:
        MOV x9, 0 // index j - algoritmo de bubble sort
        SUB x2, x0, x1 // longitud - 1 - i

    bsD_loop2:
        LDR x3, =array
        LDRH w4, [x3, x9, LSL 1] // array[i]
        ADD x9, x9, 1
        LDRH w5, [x3, x9, LSL 1] // array[i + 1]

        CMP w4, w5
        BGT bsD_cont_loop2 // Cambia BLT a BGT para ordenar en orden descendente

        STRH w4, [x3, x9, LSL 1]
        SUB x9, x9, 1
        STRH w5, [x3, x9, LSL 1]
        ADD x9, x9, 1

    bsD_cont_loop2:
    
        CMP x9, x2
        BNE bsD_loop2

        ADD x1, x1, 1
        CMP x1, x0
        BNE bsD_loop1
    RET

bubbleSortAsc:
    print 1, clear, lenClear
    print 1, bubble_sortText, lenbubble_sortText

    getTime timeStart
    bl bubbleSort
    getTime timeEnd

    BL convert_array_to_ascii

    // Escribir tiempo de ejecucion en archivo de texto
    BL getFilename
    BL openReport

    LDR x20, fileDescriptor
    print x20, bubbletxt, lenBubbletxt
    print x20, salto, lenSalto
    BL convert_array_to_asciiR
    print x20, msgExecuteTime, lenExecute

    LDR x0, =timeStart
    LDR x1, =timeEnd
    LDR x2, [x0]
    LDR x3, [x1]

    LDR x4, [x0, 8]
    LDR x5, [x1, 8]

    SUB x3, x3, x2 
    SUBS x5, x5, x4
    CNEG x3, x3, MI

    MOV x15, x5

    MOV x0, x3
    LDR x1, =num
    BL itoa

    print x20, num, x10
    print x20, prefixSec, lenPrefixSec

    MOV x0, x15
    LDR x1, =num
    BL itoa

    print x20, num, x10
    print x20, prefixMicro, lenPrefixMicro

    BL closeFile

    B cont 

bubbleSortDesc:
    print 1, clear, lenClear
    print 1, bubble_sortText, lenbubble_sortText

    getTime timeStart
    bl bubbleSortDescendente
    getTime timeEnd

    BL convert_array_to_ascii

    // Escribir tiempo de ejecucion en archivo de texto
    BL getFilename
    BL openReport

   LDR x20, fileDescriptor
    print x20, bubbletxt, lenBubbletxt
    print x20, salto, lenSalto
    BL convert_array_to_asciiR
    print x20, msgExecuteTime, lenExecute

    LDR x0, =timeStart
    LDR x1, =timeEnd
    LDR x2, [x0]
    LDR x3, [x1]

    LDR x4, [x0, 8]
    LDR x5, [x1, 8]

    SUB x3, x3, x2 
    SUBS x5, x5, x4
    CNEG x3, x3, MI

    MOV x15, x5

    MOV x0, x3
    LDR x1, =num
    BL itoa

    print x20, num, x10
    print x20, prefixSec, lenPrefixSec

    MOV x0, x15
    LDR x1, =num
    BL itoa

    print x20, num, x10
    print x20, prefixMicro, lenPrefixMicro

    BL closeFile

    B cont 

.macro input buffer, size
    MOV x0, 0
    LDR x1, =\buffer
    MOV x2, \size
    MOV x8, 63
    SVC 0
.endm

bubble_sort:
    print 1, clear, lenClear
    print 1, bubble_sortText, lenbubble_sortText

    // INgresar opcion de ascendente y descendente

    input opcion, 5

    LDR x10, =opcion
    LDRB w10, [x10]

    CMP w10, #'1'
    BEQ bubbleSortAsc
    //BL convert_array_to_ascii

    CMP w10, #'2'
    BEQ bubbleSortDesc
    //BL convert_array_to_ascii

    // Llamar Algoritmo de Ordenamiento Burbuja
    //BL bubbleSortDescendente
    // recorrer array y convertir a ascii

    //B cont

//quickSort-----------------------------

quickSort:
    // x1 = start, x2 = end
    CMP x1, x2           // Si start >= end, salir
    BGE qs_return

    STP x29, x30, [SP, -16]!  // Guardar Frame Pointer y Link Register
    MOV x29, SP

    // Partición del array
    STP x19, x20, [SP, -16]!  // Guardar registros temporales x19 y x20
    MOV x19, x1               // Guardar el índice inicial (start)
    MOV x20, x2               // Guardar el índice final (end)
    
    BL partition              // Particionar el array, el pivote queda en x0

    // Ordenar recursivamente los elementos antes y después del pivote
    SUB x2, x0, 1             // Final = pivote - 1
    BL quickSort              // Llamada recursiva para la primera mitad

    ADD x1, x0, 1             // Inicio = pivote + 1
    MOV x2, x20               // Restaurar el valor original de end
    BL quickSort              // Llamada recursiva para la segunda mitad

    LDP x19, x20, [SP], 16    // Restaurar registros x19 y x20
    LDP x29, x30, [SP], 16    // Restaurar Frame Pointer y Link Register
qs_return:
    RET

partition:
    // x1 = start, x2 = end
    STP x29, x30, [SP, -16]!     // Guardar Frame Pointer y Link Register
    MOV x29, SP

    // Escoger el pivote (último elemento)
    LDR x3, =array
    LDRH w0, [x3, x2, LSL 1]     // Cargar el pivote (array[end])

    // Inicializar los índices de partición
    SUB x4, x1, 1                // índice i = start - 1
    MOV x5, x1                   // índice j = start

    partition_loop:
        CMP x5, x2               // Mientras j < end
        BGE partition_done

        LDRH w6, [x3, x5, LSL 1] // Cargar array[j]

        CMP w6, w0               // Comparar array[j] con el pivote
        BGT skip_swap            // Si array[j] > pivote, no hacer swap

        ADD x4, x4, 1            // i++
        LDRH w7, [x3, x4, LSL 1] // Cargar array[i]

        // Intercambiar array[i] con array[j]
        STRH w6, [x3, x4, LSL 1] // array[i] = array[j]
        STRH w7, [x3, x5, LSL 1] // array[j] = array[i]

    skip_swap:
        ADD x5, x5, 1            // j++
        B partition_loop

    partition_done:
        // Colocar el pivote en su posición correcta
        ADD x4, x4, 1
        LDRH w6, [x3, x4, LSL 1] // Cargar array[i + 1]

        STRH w0, [x3, x4, LSL 1] // array[i + 1] = pivote
        STRH w6, [x3, x2, LSL 1] // array[end] = array[i + 1]

        // Devolver la posición del pivote
        MOV x0, x4

        LDP x29, x30, [SP], 16   // Restaurar Frame Pointer y Link Register
        RET

quick_sort:
    print 1, clear, lenClear
    print 1, quick_sortText, lenquick_sortText
    MOV x1, 0                      // start = 0
    LDR x2, =count
    LDR x2, [x2]                   // end = count - 1
    SUB x2, x2, 1
    // Llamar Algoritmo de Ordenamiento Quick sort
    getTime timeStart
    BL quickSort
    getTime timeEnd
    // recorrer array y convertir a ascii
    BL convert_array_to_ascii

    // Escribir tiempo de ejecucion en archivo de texto
    BL getFilename
    BL openReport

    LDR x20, fileDescriptor
    print x20, quick_sortText, lenquick_sortText
    print x20, salto, lenSalto
    BL convert_array_to_asciiR
    print x20, msgExecuteTime, lenExecute

    LDR x0, =timeStart
    LDR x1, =timeEnd
    LDR x2, [x0]
    LDR x3, [x1]

    LDR x4, [x0, 8]
    LDR x5, [x1, 8]

    SUB x3, x3, x2

    SUBS x5, x5, x4
    CNEG x3, x3, MI

    MOV x15, x5

    MOV x0, x3
    LDR x1, =num
    BL itoa

    print x20, num, x10
    print x20, prefixSec, lenPrefixSec

    MOV x0, x15
    LDR x1, =num
    BL itoa

    print x20, num, x10
    print x20, prefixMicro, lenPrefixMicro

    BL closeFile

    B cont

// TERMINA Quicksort------------------------



//INSERTION SORT------------------------------

insertionSort:
    STP x29, x30, [SP, -16]!    // Guardar Frame Pointer y Link Register
    MOV x29, SP

    // x1 = start, x2 = end (índices del array)
    MOV x1, 0                   // Inicio del array
    LDR x2, =count              // Cargar la cantidad de elementos
    LDR x2, [x2]                // end = count - 1
    SUB x2, x2, 1

    // Ciclo principal de Insertion Sort
insertion_loop:

    ADD x3, x1, 1               // x3 = i + 1 (el siguiente índice)
    CMP x3, x2                  // Si i+1 >= end, salir
    BGT insertion_done

    LDR x4, =array              // Dirección base del array
    LDRH w5, [x4, x3, LSL 1]    // Cargar array[i+1] en w5 (key)

    // Comenzar el proceso de desplazamiento
    MOV x6, x1                  // j = i
    insertion_shift:
        LDRH w7, [x4, x6, LSL 1] // Cargar array[j] en w7
        CMP w7, w5               // Comparar array[j] con la key
        BLE insertion_place      // Si array[j] <= key, insertar

        // Desplazar array[j] hacia la derecha
        ADD x8, x6, 1
        STRH w7, [x4, x8, LSL 1] // array[j+1] = array[j]

        SUB x6, x6, 1            // j--
        CMP x6, -1               // Si j < 0, detener desplazamiento
        BGE insertion_shift

    insertion_place:
        ADD x8, x6, 1
        STRH w5, [x4, x8, LSL 1] // Insertar la key en su lugar (array[j+1])

    ADD x1, x1, 1                // i++
    B insertion_loop             // Repetir para el siguiente elemento

insertion_done:
    LDP x29, x30, [SP], 16       // Restaurar Frame Pointer y Link Register
    RET

insertion_sort:
    print 1, clear, lenClear
    print 1, insertion_sortText, leninsertion_sortText
    MOV x1, 0                      // start = 0
    LDR x2, =count
    LDR x2, [x2]                   // end = count - 1
    SUB x2, x2, 1

    // Llamar Algoritmo de Ordenamiento Insertion sort
    getTime timeStart
    BL insertionSort
    getTime timeEnd

    // recorrer array y convertir a ascii
    BL convert_array_to_ascii

     // Escribir tiempo de ejecucion en archivo de texto
    BL getFilename
    BL openReport

    LDR x20, fileDescriptor
    print x20, insertion_sortText, leninsertion_sortText
    print x20, salto, lenSalto
    BL convert_array_to_asciiR
    print x20, msgExecuteTime, lenExecute

    LDR x0, =timeStart
    LDR x1, =timeEnd
    LDR x2, [x0]
    LDR x3, [x1]

    LDR x4, [x0, 8]
    LDR x5, [x1, 8]

    SUB x3, x3, x2 
    SUBS x5, x5, x4
    CNEG x3, x3, MI

    MOV x15, x5

    MOV x0, x3
    LDR x1, =num
    BL itoa

    print x20, num, x10
    print x20, prefixSec, lenPrefixSec

    MOV x0, x15
    LDR x1, =num
    BL itoa

    print x20, num, x10
    print x20, prefixMicro, lenPrefixMicro

    BL closeFile

    B cont



//TERMINA INSERTION SORT------------------------

menu:
    print 1, clear, lenClear
    print 1, menuPrincipal, lenMenuPrincipal
    print 1, msgOpcion, lenOpcion
    input opcion, 5

    LDR x10, =opcion
    LDRB w10, [x10]

    CMP w10, 49
    BEQ ingreso_numeros

    CMP w10, 50
    BEQ bubble_sort

    CMP w10, 51
    BEQ insertion_sort

    CMP w10, 52
    BEQ quick_sort

    CMP w10, 53
    BEQ finalizar_programa

finalizar_programa:
    print 1, clear, lenClear
    print 1, preguntaText, lenPreguntaText
    print 1, msgOpcion, lenOpcion
    input opcion, 5

    LDR x10, =opcion
    LDRB w10, [x10]

    CMP w10, 49
    BEQ end

    CMP w10, 50
    BEQ menu

end:
    print 1, clear, lenClear
    print 1, finalizarText, lenFinalizarText
    MOV x0, 0 // Codigo de error de la aplicacion -> 0: no hay error
    MOV x8, 93 // Codigo de la llamada al sistema
    SVC 0 // Ejecutar la llamada al sistema

ingreso_numeros:
    print 1, clear, lenClear
    print 1, ingreso_numerosText, leningreso_numerosText
    print 1, formatoText, lenFormatoText
    print 1, msgOpcion, lenOpcion
    
    input opcion, 5
    
    LDR x10, =opcion
    LDRB w10, [x10]
    CMP w10, #'1'
    BEQ ingreso_por_comas
    CMP w10, #'2'
    BEQ ingreso_por_csv
    CMP w10, #'3'
    BEQ mostrar_datos
    CMP w10, #'4'
    BEQ regresar_menu

regresar_menu:
    B menu

ingreso_por_comas:
    MOV x12, xzr
    print 1, clear, lenClear
    // Limpiar el array antes de ingresar nuevos datos
    BL clear_array
    // Mensaje para ingresar los números
    print 1, msgEnterNumbers, lenMsgEnterNumbers
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

    // Procedimiento para leer los números
    LDR x1, =inputBuffer
    // Función para leer los números
    BL readNUM
    // Recorrer array y convertir a ASCII
    BL convert_array_to_ascii
    // Mensaje de datos guardados
    print 1, datosGuardadosText, lenDatosGuardadosText
    // Esperar input del usuario
    input opcion, 5
    B ingreso_numeros


cont:
    input opcion, 5
    B menu
ingreso_por_csv:
    MOV x12,xzr
    print 1, clear, lenClear
    // Limpiar el array antes de ingresar nuevos datos
    BL clear_array
    // Mensaje para ingresar el nombre del archivo
    print 1, msgFilename, lenMsgFilename
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
    // recorrer array y convertir a ascii
    BL convert_array_to_ascii
    // BL mostrar_datos
    input opcion, 5
    B ingreso_numeros


mostrar_datos:
    print 1, clear, lenClear
    print 1, mostrarDatosText, lenMostrarDatosText
    // Imprimir los datos almacenados del contendio del csv
    BL convert_array_to_ascii
    input opcion, 5
    B menu
// Etiqueta de inicio del programa
_start:
    // Limpiar salida de la terminal
    print 1, clear, lenClear
    print 1, encabezado, lenEncabezado
    input opcion, 5

    B menu
