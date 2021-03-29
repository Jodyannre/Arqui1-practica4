include macros.asm

;======================================================================================================

.model small
.stack 100h
;sdatos segment
.data
;================ SEGMENTO DE DATOS ==============================

;VARIABLES USADAS PARA LA LECTURA DE UN ARCHIVO DE ENTRADA
ruta dw 30 dup("$") ;Variable que guarda la ruta ingresada por teclado
numero dw 2 dup("$") ;Variable para guardar las opciones numéricas
letra db ?,"$" ;Variable que guarda el caracter leído en ese momento
lectura db 10 dup("$") ;Variable que guarda un conjunto de letras de entrada leídas
reporte db 20000 dup("$") ;Variable que guarda el reporte de salida
escribir db ';','$' ;Variable que guarda el EOF
listaNumerosIn dw 26 dup(0) ;Array que guarda los números de entrada
listaNumerosOut dw 26 dup(0) ;Array que guarda los números arreglados
valorMaximo dw 0 ;Variable que guardará el número con el valor máximo
contadorNumeros dw 0 ;Contador de números de entrada
manejadorEntrada dw 0 ;Manejador para los archivos de entrada
manejadorSalida dw ? ;Manejador para los archivos de salida

;PALABRAS RESERVADAS ESPERADAS EN EL XML de entrada
entrada_numero db 'numero','$' ;Palabra esperada para cada número en el archivo de entrada
entrada_numeros db '/numeros','$' ;Palabra esperada para finalizar la lista de números en el archivo de entrada
extension db 'xml','$' ;Variable que guarda la extensión correcta de la ruta y archivo de entrada

;Variables que guardan solicitudes a imprimir en consola
ingrese_ruta db 0dh,0ah,'Ingrese la ruta del archivo','$'
error_escritura db 0dh,0ah, 'Error en la escritura del archivo','$'
error_abertura db 0dh,0ah, 'Error, no se pudo abrir ese archivo','$'
prueba db 'hola mundo','$'

tipo_ord_texto db 0dh,0ah,'Ingrese el tipo de ordenamiento','$'
ord_bubble db 0dh,0ah, '1) Ordenamiento BubbleSort','$'
ord_quick db 0dh,0ah, '2) Ordenamiento QuickSort','$'
ord_shell db 0dh,0ah, '3) Ordenamiento ShellSort','$'
ingrese_tipo_ord dw tipo_ord_texto,ord_bubble,ord_quick,ord_shell,separacion

ingrese_velocidad db 0dh,0ah,'Ingrese la velocidad','$'

orden_ord_texto db 0dh,0ah,'Ingrese el orden','$'
asc db 0dh,0ah, '1) Ascendente','$'
desc db 0dh,0ah, '2) Descendente','$'
ingrese_orden_ord dw orden_ord_texto,asc,desc,separacion

;Variables para guardar las opciones de ordenamiento
velocidad dw 0
tipo_ord dw 0
orden_ord dw 0


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

numtemp dw 8
listatemp dw 34,1,41,80
maxtemp dw 80


;para ordenamiento



;sdatos ends
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
.code ;segmento de código
;org 100h
;ASSUME DS:sdatos


;================== SEGMENTO DE CODIGO ===========================
	main proc

        ;======================CARGA DE DATOS AL DS===========================
        MOV AX, @data
        ;Mov ax,sdatos
        ;MOV BX, AX
        MOV DS, AX     
        ;=================================================================

        ;imprimirVariable ingrese_ruta
        ;imprimirVariable saltoLinea
        ;pedirPorTeclado ruta
        ;imprimirVariable ruta
        ;abrirArchivo ruta,manejadorEntrada
        ;escribirFin eof,manejadorEntrada
        ;cerrarArchivo manejadorEntrada
        ;abrirArchivo ruta, manejadorEntrada
        ;leerArchivo manejadorEntrada,letra,lectura,listaNumerosIn,listaNumerosOut,contadorNumeros,valorMaximo
        ;esperarEnter
        ;cerrarArchivo manejadorEntrada

        entrarModoVideo

        posicionarCursor 1,20
        entrarModoDatos 0
        pintarlista numtemp,anchoI,anchoF,alturaF,color,maxtemp,listatemp,0
        ;delay 3000
        esperarEnter
        borrarBarra 1,numtemp,anchoI,anchoF,0
        esperarEnter
        entrarModoDatos 0
        ;repintarBarra macro numero,lugar,contadorNumeros,anchoI,anchoF,alturaF,valorMaximo,sdatos
        repintarBarra 31d,1,numtemp,anchoI,anchoF,alturaF,maxtemp,0
        esperarEnter
        entrarModoDatos 0
        borrarBarra 2,numtemp,anchoI,anchoF,0
        esperarEnter
        entrarModoDatos 0
        repintarBarra 1d,2,numtemp,anchoI,anchoF,alturaF,maxtemp,0
        esperarEnter
        entrarModoDatos 0
        borrarBarra 3,numtemp,anchoI,anchoF,0
        esperarEnter
        entrarModoDatos 0
        repintarBarra 41d,3,numtemp,anchoI,anchoF,alturaF,maxtemp,0
        esperarEnter
        entrarModoDatos 0
        borrarBarra 4,numtemp,anchoI,anchoF,0
        esperarEnter
        entrarModoDatos 0
        repintarBarra 80d,4,numtemp,anchoI,anchoF,alturaF,maxtemp,0
        esperarEnter
        ;entrarModoDatos 0
        
        ;repintarBarra macro valorMaximo,anchoI,anchoF,alturaF,numero,sdatos
        salirModoVideo 0
        
        ;limpiarRegistros
        ;pintarMarco 20d,299d,29d,179d,10d
        ;pintarPixel 31,80,10
        
        ;entrarModoDatos 0
        ;pintarBarra 40,100,31,4d,0
        ;pintarlista contadorNumeros,anchoI,anchoF,alturaF,color,valorMaximo,listaNumerosIn,0
        ;esperarEnter
        ;pintarlista numtemp,anchoI,anchoF,alturaF,color,maxtemp,listatemp,0,etiqueta
        ;pintarBarra 40,80,60,4,0
        
        ;pintarPixel macro fila,columna,color
        ;pintarlista numtemp,anchoI,anchoF,alturaF,color,maxtemp,listatemp,0
        ;pintarlista contadorNumeros,anchoI,anchoF,alturaF,color,valorMaximo,listaNumerosIn,sdatos

        ;regresarAvideo
        ;delay 3000
        ;salirModoVideo 0
        ;salirModoVideo sdatos
        imprimirVariable separacion
        jmp salir        




        salir:
        .exit
	main endp
end