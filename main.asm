include macros.asm

;======================================================================================================

.model small
.stack 100h
sdatos segment
;.data
;================ SEGMENTO DE DATOS ==============================

;VARIABLES USADAS PARA LA LECTURA DE UN ARCHIVO DE ENTRADA
ruta dw 20 dup('$') ;Variable que guarda la ruta ingresada por teclado
numero dw 2 dup("$") ;Variable para guardar las opciones numéricas
letra db ?,"$" ;Variable que guarda el caracter leído en ese momento
lectura db 10 dup("$") ;Variable que guarda un conjunto de letras de entrada leídas
reporte db 20000 dup("$") ;Variable que guarda el reporte de salida
escribir dw ';','$' ;Variable que guarda el EOF
;listaNumerosIn dw 80,41,34,1 ;Array que guarda los números de entrada  
listaNumerosIn dw 26 dup(0) ;Array que guarda los números de entrada
;listaNumerosOut dw 80,41,34,1 ;Array que guarda los números arreglados 
listaNumerosOut dw 26 dup(0) ;Array que guarda los números arreglados  

;valorMaximo dw 80 ;Variable que guardará el número con el valor máximo    
valorMaximo dw 0 ;Variable que guardará el número con el valor máximo
;contadorNumeros dw 8 ;Contador de números de entrada  
contadorNumeros dw 0 ;Contador de números de entrada
manejadorEntrada dw 0 ;Manejador para los archivos de entrada
manejadorSalida dw ? ;Manejador para los archivos de salida

;PALABRAS RESERVADAS ESPERADAS EN EL XML de entrada
entrada_numero db 'numero','$' ;Palabra esperada para cada número en el archivo de entrada
entrada_numeros db '/numeros','$' ;Palabra esperada para finalizar la lista de números en el archivo de entrada
extension db 'xml','$' ;Variable que guarda la extensión correcta de la ruta y archivo de entrada
extension_valida dw 0 ;Variable para determinar si la extensión es correcta

;Variables que guardan solicitudes a imprimir en consola
ingrese_ruta db 0dh,0ah,'Ingrese la ruta del archivo','$'
error_escritura db 0dh,0ah, 'Error en la escritura del archivo','$'
error_abertura db 0dh,0ah, 'Error, no se pudo abrir ese archivo','$'
archivoCargado db 0dh, 0ah, 'Archivo cargado $'
msj_errorApertura db 0ah,0dh, 'Hubo un error en la lectura del archivo.', '$'
prueba db 'hola mundo','$'

tipo_ord_texto db 0dh,0ah,'Ingrese el tipo de ordenamiento','$'
ord_bubble_texto db 0dh,0ah, '1) Ordenamiento BubbleSort','$'
ord_quick_texto db 0dh,0ah, '2) Ordenamiento QuickSort','$'
ord_shell_texto db 0dh,0ah, '3) Ordenamiento ShellSort','$'
ingrese_tipo_ord dw tipo_ord_texto,separacion,ord_bubble_texto,ord_quick_texto,ord_shell_texto,separacion



;menuPrincipal

cargarArchivo db 0dh,0ah, '1) Cargar Archivo$'
ordenar db 0dh,0ah, '2) Ordenar$'          
generar_reporte db 0dh,0ah, '3) Generar reporte$'
salir_app db 0dh,0ah, '4) Salir$'
ingreso db 0ah,0dh, 'Ingrese una opcion para continuar','$'
noDisponible_texto db 0ah,0dh, 'Opcion no disponible','$'
menuPrincipal dw cargarArchivo,ordenar,generar_reporte,salir_app


;Encabezado
linea1 db 0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA','$'
linea2 db 0ah,0dh,'FACULTAD DE INGENIERIA','$'
linea3 db 0ah,0dh,'ESCUELA DE CIENCIAS Y SISTEMAS','$'
linea4 db 0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1','$'
linea5 db 0ah,0dh,'SECCION A','$'
linea6 db 0ah,0dh,'PRIMER SEMESTRE 2021','$'
linea7 db 0ah,0dh,'Joel Rodriguez Santos','$'
linea8 db 0ah,0dh,'201115018','$'
linea9 db 0ah,0dh,'Practica 4','$'
encabezado dw linea1,linea2,linea3,linea4,linea5,linea6,linea7,linea8,linea9



ingrese_velocidad db 0dh,0ah,'Ingrese la velocidad [0-9]','$'

orden_ord_texto db 0dh,0ah,'Ingrese el orden','$'
asc db 0dh,0ah, '1) Ascendente','$'
desc db 0dh,0ah, '2) Descendente','$'
ingrese_orden_ord dw orden_ord_texto,separacion,asc,desc,separacion

;Variables para guardar las opciones de ordenamiento
numeroEntrada dw 5 dup("$") ;Variable que guarda el numero ingresado
velocidad dw 2 dup('$')
velocidad_numero dw 0
minutos dw 0   
segundos dw 0
tipo_orden dw 2 dup('$')
dir_orden dw 2 dup('$')

;Variables para imprimir mensajes en modo vídeo
quick db 'Quick $'
bubble db 'Bubble $'
shell db 'Shell $'
orden db 'Orden: $'
tiempo db 'Tiempo: $'
Velocidad_texto db 'Vel: $' 


;Variables utilizadas en los cálculos de las barras a pintar

anchoI dw 0
anchoF dw 0
alturaF dw 0
;color dw 2 dup('$')
color dw 0
auxiliar dw 0

;Otras variables útiles entre los mensajes
saltoLinea db 0ah, 0dh, "$"
eof db ';','$'
separacion db 0ah, 0dh, '-------------------------', '$'

etiqueta db 0ah,0dh,'ho','$'

numtemp dw 4 dup('$')
listatemp dw 80,41,34,1
maxtemp dw 80


;para ordenamiento bubble
i dw 0
j dw 0
valorTemp dw 0


sdatos ends
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
.code ;segmento de código
;org 100h
ASSUME DS:sdatos


;================== SEGMENTO DE CODIGO ===========================
	main proc

        ;======================CARGA DE DATOS AL DS===========================
        ;MOV AX, @data
        Mov ax,sdatos
        ;MOV BX, AX
        MOV DS, AX     
        ;=================================================================
        
        imprimirArray encabezado 9
        imprimirVariable saltoLinea
        esperarEnter
        limpiarConsola
        imprimirArray menuPrincipal 4
        imprimirVariable saltoLinea
        imprimirVariable ingreso
        leer:
                mov ah, 1   ; Leer entrada del teclado
                int 16h
                jz  leer    ; Determinar si se ha presionado algo
                mov ah, 0   ; Obtener tecla presionada
                int 16h    
                cmp al, '1' ; Comparar la tecla presionada
                je numeroUno  
                cmp al, '2' ; Comparar la tecla presionada
                je numeroDos
                cmp al, '3' ; Comparar la tecla presionada
                je numeroTres
                cmp al, '4' ; Comparar la tecla presionada
                je salir
                jne noDisponible  

        noDisponible:
                limpiarConsola
                imprimirVariable noDisponible_texto
                esperarEnter
                limpiarConsola
                imprimirArray menuPrincipal 5
                imprimirVariable ingreso
                jmp leer
		
        numeroUno:
                limpiarConsola
                limpiarVariableTexto ruta 30
                imprimirVariable ingrese_ruta
                imprimirVariable saltoLinea
                pedirPorTeclado ruta
                imprimirVariable saltoLinea
                abrirArchivo ruta,manejadorEntrada ;Abrir archivo
                jc errorApertura ; Verificar si existe un error
                extensionCorrecta ruta,extension,extension_valida
                cmp extension_valida, 1
                jne errorApertura
                escribirFin manejadorEntrada, escribir ;Escribir el EOF al archivo de entrada
                cerrarArchivo manejadorEntrada ;Cerrar el archivo
                ;imprimirVariable ruta              
                abrirArchivo ruta,manejadorEntrada ;Abrir archivo
                jc errorApertura ; Verificar si existe un error
                leerArchivo manejadorEntrada,letra,lectura,listaNumerosIn,listaNumerosOut,contadorNumeros,valorMaximo
                cerrarArchivo manejadorEntrada ;Cerrar el archivo
                imprimirVariable archivoCargado ;Archivo cargado con éxito
                imprimirVariable saltoLinea ; Salto de línea
                esperarEnter
                jmp salir


                errorApertura:
                    limpiarVariableTexto ruta,20
                    imprimirVariable msj_errorApertura ;Imprimir msj de error
                    esperarEnter
                    ;cerrarArchivo manejador  ;Cerrar el archivo
                    jmp numeroUno ;Saltar al final del programa                                              
        numeroDos:
                limpiarConsola
                imprimirArray ingrese_tipo_ord,6
                leerOrden:
                        mov ah, 1   ; Leer entrada del teclado
                        int 16h
                        jz  leerOrden; Determinar si se ha presionado algo
                        mov ah, 0   ; Obtener tecla presionada
                        int 16h    
                        cmp al, '1' ; Comparar la tecla presionada
                        je ordenBubble 
                        cmp al, '2' ; Comparar la tecla presionada
                        je ordenQuick
                        cmp al, '3' ; Comparar la tecla presionada
                        je ordenShell
                        jne ordenNoDisponible

                        ordenNoDisponible:
                                limpiarConsola
                                imprimirVariable noDisponible_texto
                                esperarEnter
                                jmp numeroDos                     

                        ordenBubble:
                                push si
                                lea si, tipo_orden
                                mov [si], '1'
                                pop si
                                jmp continuarAvelocidad
                        ordenQuick:
                                push si
                                lea si, tipo_orden
                                mov [si], '2'
                                pop si
                                jmp continuarAvelocidad
                        ordenShell:
                                push si
                                lea si, tipo_orden
                                mov [si], '3'
                                pop si
                                jmp continuarAvelocidad

                continuarAvelocidad:
                        limpiarConsola
                        imprimirVariable ingrese_velocidad
                        imprimirVariable saltoLinea

                leerVelocidad:
                        pedirPorTeclado velocidad                         
                        cmp velocidad, '9' ; Comparar la tecla presionada
                        jle continuarAdireccion
                        jg velocidadNoDisponible  

                velocidadNoDisponible:
                        limpiarConsola
                        imprimirVariable noDisponible_texto
                        limpiarVariableTexto velocidad 2
                        esperarEnter
                        jmp continuarAvelocidad


                continuarAdireccion:
                        limpiarConsola
                        imprimirArray ingrese_orden_ord 5
                        imprimirVariable saltoLinea
                leerDireccion:
                        mov ah, 1   ; Leer entrada del teclado
                        int 16h
                        jz  leerDireccion; Determinar si se ha presionado algo
                        mov ah, 0   ; Obtener tecla presionada
                        int 16h    
                        cmp al, '1' ; Comparar la tecla presionada
                        je dirUno
                        cmp al, '2' ; Comparar la tecla presionada
                        je dirDos
                        cmp al, '3' ; Comparar la tecla presionada
                        jge dir_noDisponible
                dir_noDisponible:
                        limpiarConsola
                        imprimirVariable noDisponible_texto
                        ;limpiarVariableTexto dir_orden 2
                        esperarEnter                       
                        jmp continuarAdireccion

                diruno:
                        push ax
                        mov ax,'1'
                        mov dir_orden,ax
                        pop ax
                        jmp ejecutarInstruccion
                dirDos:
                        push ax
                        mov ax,'2'
                        mov dir_orden,ax
                        pop ax
                        jmp ejecutarInstruccion

                ejecutarInstruccion:
                
        numeroTres:
                jmp salir
        numeroCuatro:
                jmp salir        
        
        jmp salir      

        salir:
        .exit
	main endp
end