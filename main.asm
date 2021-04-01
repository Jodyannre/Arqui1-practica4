include macros.asm

;======================================================================================================

.model small
.stack 100h
sdatos segment
;.data
;================ SEGMENTO DE DATOS ==============================

escribir dw ';','$' ;Variable que guarda el EOF
;listaNumerosIn dw 34,41,80,1 ;Array que guarda los numeros de entrada  
listaNumerosIn dw 26 dup(0) ;Array que guarda los numeros de entrada
;listaNumerosOut dw 34,41,80,1 ;Array que guarda los numeros arreglados 
listaNumerosOut dw 26 dup(0) ;Array que guarda los numeros arreglados  

;valorMaximo dw 80 ;Variable que guardara el numero con el valor maximo    
valorMaximo dw 0 ;Variable que guardara el numero con el valor maximo
;contadorNumeros dw 8 ;Contador de numeros de entrada  
contadorNumeros dw 0 ;Contador de numeros de entrada
manejadorEntrada dw 0 ;Manejador para los archivos de entrada
manejadorSalida dw ? ;Manejador para los archivos de salida

;PALABRAS RESERVADAS ESPERADAS EN EL XML de entrada
entrada_numero db 'numero','$' ;Palabra esperada para cada numero en el archivo de entrada
entrada_numeros db '/numeros','$' ;Palabra esperada para finalizar la lista de numeros en el archivo de entrada
extension db 'xml','$' ;Variable que guarda la extensión correcta de la ruta y archivo de entrada
extension_valida dw 0 ;Variable para determinar si la extensión es correcta

;Variables que guardan solicitudes a imprimir en consola
ingrese_ruta db 0dh,0ah,'Ingrese la ruta del archivo','$'
error_escritura db 0dh,0ah, 'Error en la escritura del archivo','$'
error_abertura db 0dh,0ah, 'Error, no se pudo abrir ese archivo','$'
archivoCargado db 0dh, 0ah, 'Archivo cargado $'
msj_errorApertura db 0ah,0dh, 'Hubo un error en la lectura del archivo.', '$'
reporteCreado db 'Reporte creado.','$'

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
linea1 db 'Universidad de San Carlos de Guatemala','$'
linea2 db 'Facultad de Ingenieria','$'
linea3 db 'Escuela de Ciencias y Sistemas','$'
linea4 db 'Arquitectura de Computadores y Ensambladores 1','$'
linea5 db 'Seccion A','$'
linea6 db 'Primer Semestre 2021','$'
linea7 db 'Joel Rodriguez Santos','$'
linea8 db '201115018','$'
linea9 db 'Practica 4','$'
encabezado dw linea1,saltoLinea,linea2,saltoLinea,linea3,saltoLinea,linea4,saltoLinea,linea5,saltoLinea,linea6,saltoLinea,linea7,saltoLinea,linea8,saltoLinea,linea9



ingrese_velocidad db 0dh,0ah,'Ingrese la velocidad [0-9]','$'

orden_ord_texto db 0dh,0ah,'Ingrese el orden','$'
asc db 0dh,0ah, '1) Ascendente','$'
desc db 0dh,0ah, '2) Descendente','$'
ingrese_orden_ord dw orden_ord_texto,separacion,asc,desc,separacion

;Variables para guardar las opciones de ordenamiento
numeroEntrada dw 5 dup("$") ;Variable que guarda el numero ingresado
velocidad dw 2 dup('$') 
;velocidad dw '03$'
velocidad_numero dw 0
tipo_orden dw 2 dup('$') 
;tipo_orden dw '1$'
dir_orden dw 2 dup('$') 
;dir_orden dw '2$'



;Datos para manejar el tiempo 
minutosFin db 0
segundosFin db 0
millisFin db 0
tiempoTotalActual dw '00:00:00:$$'
tiempoTotalActual_reset dw '00:00:00:$$'
hora db 0
minutos db 0   
segundos db 0
millis db 0
horaIni db 0
minutosIni db 0
segundosIni db 0
millisIni db 0


;Datos para manejar la fecha
dia db 0
mes db 0
ano dw 0


;Variables para imprimir mensajes en modo video
quick db 'Quick  $'
bubble db 'Bubble  $'
shell db 'Shell  $'
orden db 'Or: $'
tiempo db 'T: $'
velocidad_texto db ' Vel: $' 


;Variables utilizadas en los calculos de las barras a pintar

anchoI dw 0
anchoF dw 0
alturaF dw 0
;color dw 2 dup('$')
color dw 0
auxiliar dw 0

;Otras variables utiles entre los mensajes
saltoLinea db 0ah, 0dh, "$"
eof db ';','$'
separacion db 0ah, 0dh, '-------------------------', '$'

numtemp dw 4 dup('$')
listatemp dw 34,41,80,1
maxtemp dw 80


;para ordenamiento bubble
i dw 0
j dw 0
valorTemp dw 0

;variables para xml
encabezadosAgregados db 0
posicionActualReporte dw 0
nombreXml db 'res.xml',0

;Etiquetas xml
Arqui_a db '<Arqui>$'
Arqui_c db 0ah,0dh,'</Arqui>$'
Encabezado_a db 0ah,0dh,'<Encabezado>$'
Encabezado_c db 0ah,0dh,'</Encabezado>$'
Universidad_a db 0ah,0dh,'<Universidad>$'
Universidad_c db '</Universidad>$'
Facultad_a db 0ah,0dh,'<Facultad>$'
Facultad_c db '</Facultad>$'
Escuela_a db 0ah,0dh,'<Escuela>$'
Escuela_c db '</Escuela>$'
Curso_a db 0ah,0dh,'<Curso>$'
Curso_c db '</Curso>$'
Nombre_a db 0ah,0dh,'<Nombre>$'
Nombre_c db '</Nombre>$'
Seccion_a db 0ah,0dh,'<Seccion>$'
Seccion_c db '</Seccion>$'
Ciclo_a db 0ah,0dh,'<Ciclo>$'
Ciclo_c db '</Ciclo>$'
Fecha_a db 0ah,0dh,'<Fecha>$'
Fecha_c db 0ah,0dh,'</Fecha>$'
Dia_a db 0ah,0dh,'<Dia>$'
Dia_c db '</Dia>$'
Mes_a db 0ah,0dh,'<Mes>$'
Mes_c db '</Mes>$'
Ano_a db 0ah,0dh,'<Ano>$'
Ano_c db '</Ano>$'
Hora_a db 0ah,0dh,'<Hora>$'
Hora_c db '</Hora>$'
Minutos_a db 0ah,0dh,'<Minutos>$'
Minutos_c db '</Minutos>$'
Segundos_a db 0ah,0dh,'<Segundos>$'
Segundos_c db '</Segundos>$'
Alumno_a db 0ah,0dh,'<Alumno>$'
Alumno_c db '</Alumno>$'
Carnet_a db 0ah,0dh,'<Carnet>$'
Carnet_c db '</Carnet>$'
Resultados_a db 0ah,0dh,'<Resultados>$'
Resultados_c db 0ah,0dh,'</Resultados>$'
Tipo_a db 0ah,0dh,'<Tipo>$'
Tipo_c db '</Tipo>$'
Lista_Entrada_a db 0ah,0dh,'<Lista_Entrada>$'
Lista_Entrada_c db '</Lista_Entrada>$'
Lista_Ordenada_a db 0ah,0dh,'<Lista_Ordenada>$'
Lista_Ordenada_c db '</Lista_Ordenada>$'
Ordenamiento_BubbleSort_a db 0ah,0dh,'<Ordenamiento_BubbleSort>$'
Ordenamiento_BubbleSort_c db 0ah,0dh,'</Ordenamiento_BubbleSort>$'
Ordenamiento_Quicksort_a db 0ah,0dh,'<Ordenamiento_Quicksort>$'
Ordenamiento_Quicksort_c db 0ah,0dh,'</Ordenamiento_Quicksort>$'
Ordenamiento_Shellsort_a db 0ah,0dh,'<Ordenamiento_Shellsort>$'
Ordenamiento_Shellsort_c db 0ah,0dh,'</Ordenamiento_Shellsort>$'
Tiempo_a db 0ah,0dh,'<Tiempo>$'
Tiempo_c db 0ah,0dh,'</Tiempo>$'
Milisegundos_a db 0ah,0dh,'<Milisegundos>$'
Milisegundos_c db '</Milisegundos>$'
Velocidad_a db 0ah,0dh,'<Velocidad>$'
Velocidad_c db '</Velocidad>$'
tipo_ascendente db 'Ascendente$'
tipo_descendente db 'Descendente$'

;VARIABLES USADAS PARA LA LECTURA DE UN ARCHIVO DE ENTRADA
ruta dw 20 dup('$') ;Variable que guarda la ruta ingresada por teclado
numero dw 2 dup("$") ;Variable para guardar las opciones numericas
letra db ?,"$" ;Variable que guarda el caracter leido en ese momento
lectura db 10 dup("$") ;Variable que guarda un conjunto de letras de entrada leidas
reporte dw 20000 dup("$") ;Variable que guarda el reporte de salida


sdatos ends
;db -> dato byte -> 8 bits
;dw -> dato word -> 16 bits
;dd -> doble word -> 32 bits
.code ;segmento de codigo
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
                
        limpiarConsola             
        imprimirArray encabezado, 17
        imprimirVariable saltoLinea
        esperarEnter
        limpiarConsola
        imprimirArray menuPrincipal, 4
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
                limpiarConsola
                leerArchivo manejadorEntrada,letra,lectura,listaNumerosIn,listaNumerosOut,contadorNumeros,valorMaximo
                cerrarArchivo manejadorEntrada ;Cerrar el archivo
                imprimirVariable archivoCargado ;Archivo cargado con éxito
                imprimirVariable saltoLinea ; Salto de línea
                esperarEnter
                limpiarConsola
                imprimirArray menuPrincipal 4
                imprimirVariable saltoLinea
                imprimirVariable ingreso 
                jmp leer

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
                        cmp encabezadosAgregados,1
                        je saltarEncabezado
                        push si
                        push ax
                        lea si,reporte
                        escribirEncabezadoParte1
                        escribirEncabezadoParte2 
                        mov posicionActualReporte,si
                        ;mov al,1
                        ;mov encabezadosAgregados, al
                        pop ax
                        pop si
                saltarEncabezado:
                        ejecutar 
                        push ax
                        mov al,1
                        mov encabezadosAgregados,al
                        pop ax
                        limpiarConsola
                        imprimirArray menuPrincipal 5
                        imprimirVariable ingreso 
                        limpiarVariableNumero tipo_orden,2
                        limpiarVariableNumero velocidad,2
                        limpiarVariableNumero dir_orden,2 
                        copiarVariable tiempoTotalActual_reset,tiempoTotalActual
                        jmp leer
                
        numeroTres:
                ;crear reporte
                push si
                mov si,posicionActualReporte
                xmlAgregarEtiqueta Resultados_c
                xmlAgregarEtiqueta Arqui_c
                mov posicionActualReporte,si
                pop si
                crearXml
                writeXml
                cerrarArchivo manejadorSalida
                ;Limpiar todas las variables
                limpiarVariableTexto reporte,20000
                limpiarVariableNumero listaNumerosIn,26
                limpiarVariableNumero listaNumerosOut,26
                limpiarConsola
                mov anchoI,0
                mov anchoF,0
                mov alturaF,0
                mov valorMaximo,0
                mov i,0
                mov j,0
                mov encabezadosAgregados,0
                mov posicionActualReporte,0
                mov contadorNumeros,0
                imprimirVariable reporteCreado
                esperarEnter
                limpiarConsola
                imprimirArray menuPrincipal 5
                imprimirVariable ingreso 
                jmp leer
        numeroCuatro:
                jmp salir        
        
        jmp salir      

        salir:     
        .exit
	main endp
end