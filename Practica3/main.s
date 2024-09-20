.global _start

.data
    encabezado:
        .asciz "Universidad de San Carlos de Guatemala\n"
        .asciz "Facultad de Ingenieria\n"
        .asciz "Escuela de Ciencias y Sistemas\n"
        .asciz "Arquitectura de Computadores y Ensambladores 1\n"
        .asciz "Sección A\n"
        .asciz "Fernando Misael Morales Ortiz\n"
        .asciz "202001950"
        lencabezado = . - encabezado

.text
_start:
    MOV x0, 1
    LDR x1, =encabezado
    LDR x2, =lencabezado
    MOV x8, 64
    SVC 0

    end:
        MOV x0, 0
        mov x8, 93
        SVC 0

