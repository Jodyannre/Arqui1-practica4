
;=====================================AAAA===========================================================

;======================babrirArchivo=============================================
abrirArchivo macro ruta, manejador
    push ax
    push dx
    mov ah, 3Dh ;Mover función para abrir archivo
    mov al, 02h ;Modo de permiso
    lea dx, ruta ;Nombre del fichero a leer
    int 21h ;Ejecutar instrucción
    mov manejador, ax ;Guardar el manejador
    pop dx
    pop ax
endm
;================================================================================

;=====================================BBBB===========================================================


;======================bborrarBarra=============================================
borrarBarra macro lugar,contadorNumeros,anchoI,anchoF,sdatos
local buscarPosicion, salir    
    ;Posición más alta es 30
    ;Posición más baja es 179
    guardarEnPila
    limpiarRegistros
    ;Calcular ancho
    mov ax,contadorNumeros
    mov bx,2
    div bx
    mov bx,ax
    mov ax, 240
    xor dx,dx
    div bx
    sub ax,3
	;mov ax,1
    xor cx,cx
    mov cx,1
    mov anchoI,40
    mov anchoF,40
    add anchoF,ax
    cmp cx,lugar
    jb buscarPosicion
    jmp salir

    buscarposicion:
        add anchoF,3
        mov dx,anchoF
        mov anchoI,dx
        add anchoF,ax
        inc cx
        cmp cx,lugar
        jb buscarPosicion
        jmp salir

    salir:
        pintarBarra anchoI,anchoF,30d,00h,sdatos
        ;Salida con video
        sacarDePila
endm
;================================================================================


;=====================================CCCC===========================================================

;======================bcalcularAltura============================================
calcularAltura macro valorMaximo,alturaF
    guardarEnPila
    mov ax, [si]
    mov bx, 149d
    ;getColor ax ;dx guarda el color
    ;mov color,dx
    mul bx
    mov bx,valorMaximo
    xor dx,dx ;Para evitar el overflow
    div bx
    xor bx,bx
    mov bx,179d
    sub bx,ax
    mov alturaF, bx
    sacarDePila
endm
;================================================================================


;======================bcalcularAltura2============================================
calcularAltura2 macro valorMaximo,alturaF
    guardarEnPila
    mov bx, 149d
    ;getColor ax ;dx guarda el color
    ;mov color,dx
    mul bx
    mov bx,valorMaximo
    xor dx,dx ;Para evitar el overflow
    div bx
    xor bx,bx
    mov bx,179d
    sub bx,ax
    mov alturaF, bx
    sacarDePila
endm
;================================================================================


;======================bcerrarArchivo============================================
cerrarArchivo macro manejador
    push ax
    push bx
    mov ah, 3Eh
    mov bx, manejador
    int 21h
    pop bx
    pop ax
endm
;================================================================================




;======================bConvertirAnumero=========================================

convertirAnumero macro lectura, listaNumeros, contadorNumeros, valorMaximo
local ciclo, finalizar, fin, agregarMaximo
    guardarEnPila
    mov si, offset lectura
    mov ax,0
    mov cx,10

    ;Conseguir decimal en formato hex
    ciclo:
        mul cx
        mov bx,ax  
        xor ax,ax
        mov al, [si]
        sub al,48
        add ax,bx
        inc si
        cmp [si],'$'
        je finalizar
        jne ciclo

    finalizar:  
        ;Guardar el número en la lista
        mov di,contadorNumeros
        mov listaNumeros[di],ax
        inc contadorNumeros
        inc contadorNumeros 
        mov bx, valorMaximo
        cmp ax,bx
        jg agregarMaximo
        jmp fin
    agregarMaximo:
        mov valorMaximo,ax          
    fin: 
        sacarDePila     
endm
;================================================================================


;======================bcopiarLista==============================================
copiarLista macro manejador, fuente,destino,contadorNumeros
local ciclo,fin
    guardarEnPila
    
    lea si, fuente
    lea di, destino
    mov cx, 0
    mov bx, contadorNumeros
    add bx,2

    ciclo:
        cmp cx,bx
        je fin
        mov ax,[si]
        mov [di],ax
        inc si
        inc si
        inc di
        inc di
        inc cx
        inc cx
        jmp ciclo

    fin:
        sacarDePila
endm
;================================================================================



;======================bcrearXml=================================================
crearXml macro
    local error, fin
    lea dx, nombreXml
    mov cx,0
    ;Crear el archivo
    mov ah, 3ch
    int 21h
    mov manejadorSalida,ax
    jc error
    ;Cerrar el archivo
    ;mov ah, 3Eh
    ;mov bx, manejador
    ;int 21h
    jmp fin
    error:
        ;imprimirArchivo errorCreacion
        esperarEnter
        ;Rutina para terminar programa
        ;mov ax, 4c00h
        ;int 21h
    fin:
endm

;================================================================================




;=====================================DDDD===========================================================


;======================bDelay====================================================
delay macro retraso
local ret1,ret2,finRet
    guardarEnPila
    limpiarRegistros
    mov ax, retraso
    ret2:
        dec ax
        jz finRet
        mov bx, retraso
        ret1:
            dec bx
        jnz ret1
    jmp ret2
    finRet:
        sacarDePila
endm
;================================================================================


;======================bgetNumerosGrandes========================================
getNumerosGrandes macro iteracion
    local conseguido, fin, dividir  
    push dx
    push cx
    push ax
    push bx
    
    mov bx,10
    mov cx,1

    dividir:
        xor dx,dx
        div bx
        push dx
        cmp ax,10
        jb conseguido
        jmp dividir
    conseguido:
        aam
        add al,30h 
        mov [si],al
        inc si
        inc cx       
        cmp cx,iteracion
        je fin
        pop dx
        mov al,dl
        jne conseguido
    fin:
        pop bx
        pop ax
        pop cx
        pop dx
endm

;================================================================================


;======================bgetNumerosPequenos=======================================

getNumerosPequenos macro ultimo
    local esCero,verificarUltimo, menor,agregarPuntos,fin
    push ax
    push bx
    push cx
    push dx
    cmp al,0
    je esCero
    cmp al,10
    jb menor
    xor dx,dx
    ;xor bx,bx
    mov bx,10
    div bx
    aam
    add al,30h 
    mov [si],al
    inc si
    mov al,dl
    aam
    add al,30h
    mov [si],al
    inc si
    jmp verificarUltimo

    menor:
        mov [si],30h
        inc si    
        aam
        add al, 30h    
        mov [si], al
        inc si
        jmp verificarUltimo
    esCero:
        mov [si],30h
        inc si
        mov [si],30h
        inc si

    verificarUltimo:
        mov al, ultimo
        cmp al,1
        je fin
        jne agregarPuntos

    agregarPuntos:
        mov [si],':'
        inc si
    fin:
        pop dx
        pop cx
        pop bx
        pop ax
endm
;================================================================================


;=====================================EEEE===========================================================


;======================bejecutar=================================================
ejecutar macro
local ciclo_bubble,bAsc,bDes,quick,qAsc,qDes,shell,sAsc,sDes,finalizar
    guardarEnPila
    limpiarRegistros   
    ;Evaluar el tipo de orden, dirección del orden y la velocidad 
    ;Variables tipo_orden,dir_orden,velocidad
    
    ;Conseguir velocidad para el delay
    mov ax,velocidad
    mov bx,220
    mul bx
    mov velocidad_numero,ax

    ;velocidad_numero con la velocidad de delay
    limpiarRegistros

    mov ax,tipo_orden
    cmp ax,'1'
    je ciclo_bubble
    cmp ax,'2'
    je ciclo_quick
    cmp ax,'3'
    je ciclo_shell

    ciclo_bubble:
        xor ax,ax
        mov ax,dir_orden
        cmp ax,'1'
        je bAsc
        cmp ax,'2'
        je bDes
        bAsc:
            getHora
            mov al,minutos
            mov minutosini,al
            mov al,segundos
            mov segundosini,al
            mov al,millis
            mov millisIni,al
            xor al,al
            esperarEnter    
            entrarModoVideo 
            entrarModoDatos
            pintarlista bubble,listaNumerosIn
            ;salida en modo datos
            esperarEnter
            ord_bubble_asc 
            esperarEnter
            salirModoVideo
            ;escribirEncabezadoParte3 tipoDeDireccion,nombreOrdenamiento_a,nombreOrdenamiento_c
            escribirEncabezadoParte3 tipo_ascendente,Ordenamiento_BubbleSort_a,Ordenamiento_BubbleSort_c
            jmp finalizar
        bDes:
            getHora
            mov al,minutos
            mov minutosini,al
            mov al,segundos
            mov segundosini,al
            mov al,millis
            mov millisIni,al
            xor al,al
            esperarEnter    
            entrarModoVideo 
            entrarModoDatos
            pintarlista bubble,listaNumerosIn
            ;salida en modo datos
            esperarEnter
            ord_bubble_des 
            esperarEnter
            salirModoVideo
            escribirEncabezadoParte3 tipo_descendente,Ordenamiento_BubbleSort_a,Ordenamiento_BubbleSort_c
            jmp finalizar
    ciclo_quick:
        xor ax,ax
        mov ax,dir_orden
        cmp ax,'1'
        je qDes
        cmp ax,'2'
        je qAsc
        qAsc:
            jmp finalizar
        qDes:
            jmp finalizar
    ciclo_shell:
        xor ax,ax
        mov ax,dir_orden
        cmp ax,'1'
        je sDes
        cmp ax,'2'
        je sAsc
        sAsc:
            jmp finalizar
        sDes:
            jmp finalizar

    finalizar:

    sacarDePila
endm
;================================================================================

;======================bentrarModoVideo==========================================
entrarModoVideo macro
    push ax
    mov ax, 0013h
    int 10h
    mov ax, 0A000h
    mov ds, ax
    pop ax
endm
;================================================================================

;======================bentrarModoDatos==========================================
entrarModoDatos macro
    push ax
    ;mov ax, @data
    mov ax, sdatos
    mov ds, ax
    pop ax
endm
;================================================================================

;======================bEscribirArchivo==========================================
escribirArchivo macro contenido,manejador,error_escritura
    push ax
    push bx
    push dx

    mov ah,40h
    mov bx,manejador
    getArraySize contenido
    lea dx,contenido
    int 21h

    pop dx
    pop bx
    pop ax    
endm
;================================================================================

;======================bEscribirEncabezadoParte1=================================
escribirEncabezadoParte1 macro
    xmlAgregarEtiqueta Arqui_a	
    ;Agregando encabezado
    xmlAgregarEtiqueta Encabezado_a
    xmlAgregarEtiqueta Universidad_a
    xmlAgregarEtiqueta linea1
    xmlAgregarEtiqueta Universidad_c
    xmlAgregarEtiqueta Facultad_a
    xmlAgregarEtiqueta linea2
    xmlAgregarEtiqueta Facultad_c
    xmlAgregarEtiqueta Escuela_a
    xmlAgregarEtiqueta linea3
    xmlAgregarEtiqueta Escuela_c
    xmlAgregarEtiqueta Curso_a
    xmlAgregarEtiqueta Nombre_a
    xmlAgregarEtiqueta linea4
    xmlAgregarEtiqueta Nombre_c
    xmlAgregarEtiqueta Seccion_a
    xmlAgregarEtiqueta linea5
    xmlAgregarEtiqueta Seccion_c
    xmlAgregarEtiqueta Curso_c
    xmlAgregarEtiqueta Ciclo_a
    xmlAgregarEtiqueta linea6
    xmlAgregarEtiqueta Ciclo_c
endm
;================================================================================

;======================bEscribirEncabezadoParte2=================================
escribirEncabezadoParte2 macro
    ;Agregando fecha
    getFecha
    xmlAgregarEtiqueta Fecha_a
    xmlAgregarEtiqueta Dia_a
    ;Calcular dia
    xor ax,ax
    mov al,dia
    getNumerosPequenos 1
    xmlAgregarEtiqueta Dia_c
    xmlAgregarEtiqueta Mes_a
    ;calcular mes
    xor ax,ax
    mov al,mes
    getNumerosPequenos 1
    xmlAgregarEtiqueta Mes_c
    xmlAgregarEtiqueta Ano_a
    ;calcular ano
    xor ax,ax
    mov ax,ano
    getNumerosGrandes 5
    xmlAgregarEtiqueta Ano_c	
    xmlAgregarEtiqueta Fecha_c

    getHora
    ;Agregando Hora
    xmlAgregarEtiqueta Hora_a
    xmlAgregarEtiqueta Hora_a
    ;calcular hora
    xor ax,ax
    mov al,hora
    getNumerosPequenos 1
    xmlAgregarEtiqueta Hora_c
    xmlAgregarEtiqueta Minutos_a
    ;calcular minutos
    xor ax,ax
    mov al,minutos
    getNumerosPequenos 1
    xmlAgregarEtiqueta Minutos_c
    xmlAgregarEtiqueta Segundos_a
    ;calcular segundos
    xor ax,ax
    mov al,segundos
    getNumerosPequenos 1
    xmlAgregarEtiqueta Segundos_c
    xmlAgregarEtiqueta Hora_c

    ;Agregando alumno
    xmlAgregarEtiqueta Alumno_a
    xmlAgregarEtiqueta Nombre_a
    xmlAgregarEtiqueta linea7
    xmlAgregarEtiqueta Nombre_c
    xmlAgregarEtiqueta Carnet_a
    xmlAgregarEtiqueta linea8
    xmlAgregarEtiqueta Carnet_c
    xmlAgregarEtiqueta Alumno_c
            
    ;Finaliza encabezado
    xmlAgregarEtiqueta Encabezado_c
    xmlAgregarEtiqueta Resultados_a
endm
;================================================================================


;======================bEscribirEncabezadoParte3=================================
escribirEncabezadoParte3 macro tipoDeDireccion,nombreOrdenamiento_a,nombreOrdenamiento_c
local encabezadoYaAgregado
            ;Agregar resultados al xml
            guardarEnPila
            limpiarRegistros
            mov si,posicionActualReporte
            mov bl,encabezadosAgregados
            cmp bl,1
            je encabezadoYaAgregado
                xmlAgregarEtiqueta Tipo_a
                xmlAgregarEtiqueta tipoDeDireccion
                xmlAgregarEtiqueta Tipo_c
                xmlAgregarEtiqueta Lista_Entrada_a
                ;agregar lista inicial
                mov posicionActualReporte,si
                xmlAgregarLista listaNumerosIn
                mov si,posicionActualReporte
                xmlAgregarEtiqueta Lista_Entrada_c
                xmlAgregarEtiqueta Lista_Ordenada_a
                ;agregar lista ordenada
                mov posicionActualReporte,si
                xmlAgregarLista listaNumerosOut
                mov si,posicionActualReporte
                xmlAgregarEtiqueta Lista_Ordenada_c

            encabezadoYaAgregado:
                xmlAgregarEtiqueta nombreOrdenamiento_a
                xmlAgregarEtiqueta Velocidad_a
                ;Agregar el valor de la velocidad
                xmlAgregarEtiqueta velocidad
                xmlAgregarEtiqueta Velocidad_c
                xmlAgregarEtiqueta Tiempo_a
                xmlAgregarEtiqueta Minutos_a
                ;calcular minutos
                xor ax,ax
                mov al,minutosFin
                getNumerosPequenos 1
                xmlAgregarEtiqueta Minutos_c
                xmlAgregarEtiqueta Segundos_a
                ;calcular segundos
                xor ax,ax
                mov al,segundosFin
                getNumerosPequenos 1
                xmlAgregarEtiqueta Segundos_c
                xmlAgregarEtiqueta Milisegundos_a
                ;calcular millis
                xor ax,ax
                mov al,millisFin
                getNumerosPequenos 1
                xmlAgregarEtiqueta Milisegundos_c
                xmlAgregarEtiqueta Tiempo_c
                xmlAgregarEtiqueta nombreOrdenamiento_c
                mov posicionActualReporte,si
                sacarDePila
endm

;================================================================================

;======================bescribirFin==============================================
escribirFin macro manejador,eof
    push ax
    push bx
    push cx
    push dx

;POSICIONAR CURSOR
    mov ah, 42h
    mov al, 02h
    mov bx, manejador
    mov cx, 0
    mov dx, 0
    int 21h

;ESCRIBIR EN ARCHIVO
    mov ah, 40h
    mov bx, manejador
    mov cx, 1
    lea dx, eof
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
endm
;================================================================================

;======================bEsperarEnter=============================================
esperarEnter macro
local pedir, fin_pedir   
    push ax
    push si

    pedir:
        mov ah, 01H
        int 21h
        cmp al, 0Dh
        je fin_pedir
        mov [si], al
        inc si
        jmp pedir
    fin_pedir:  

        pop si
        pop ax    
endm


;================================================================================


;======================bEsperarEsc=============================================
esperarEsc macro
local pedir, fin_pedir    
    push ax
    push si
  
    pedir:
        mov ah, 01H
        int 21h
        cmp al, 1Bh
        je fin_pedir
        mov [si], al
        inc si
        jmp pedir
    fin_pedir:  
        
        pop si
        pop ax    
endm


;================================================================================

;======================bEsperarSpace=============================================
esperarSpace macro
local pedir, fin_pedir
    push ax
    push si
   
    pedir:
        mov ah, 01H
        int 21h
        cmp al, 20h
        je fin_pedir
        mov [si], al
        inc si
        jmp pedir
    fin_pedir:  
     
        pop si
        pop ax    
endm


;================================================================================


;======================bextensionCorrecta========================================
extensionCorrecta macro ruta,extension,extension_valida
local ciclo,siguiente,preComparacion,comparar, noEsIgual,esIgual,fin
    guardarEnPila
    limpiarRegistros
    lea si,ruta
    lea di,extension
    ciclo:
        cmp [si],'.'
        jne siguiente
        jmp preComparacion

    siguiente:
        inc si
        jmp ciclo


    preComparacion:
        inc si
    comparar:
        mov al, [si]
        mov bl, [di]
        cmp bl,'$'
        je esIgual       
        cmp bl,al
        jne noEsIgual
        inc si
        inc di
        jmp comparar
    noEsIgual:
        mov ax,0
        mov extension_valida, ax
        jmp fin

    esIgual:
        mov ax,1
        mov extension_valida, ax
        jmp fin

    fin:
    sacarDePila
endm
;================================================================================


;=====================================GGGG===========================================================

;======================bgetArraySize============================================
getArraySize macro array
local ciclo, fin
    push si 
    push ax
    mov cx,0
    lea si,array
    ciclo:
        mov al, [si]
        cmp al,'$'
        je fin
        inc si
        inc cx
        jmp ciclo
    fin:
        pop ax
        pop si
endm
;================================================================================

;======================bgetFecha=================================================
getFecha macro
    guardarEnPila
    limpiarRegistros
    mov ah, 2ah
    int 21h
    ;Aqui se consigue la hora y los registros quedan así:
    ;CX = año
    ;DH = mes
    ;DL = dia
    ;Mando un número para decirle que es el último
    mov bx,cx
    mov ano, bx
    mov mes, dh
    mov dia, dl
    sacarDePila
endm
;================================================================================


;======================bgetHora==================================================
getHora macro
    guardarEnPila
    limpiarRegistros
    mov ah, 2ch
    int 21h
    ;Aqui se consigue la hora y los registros quedan así:
    ;Ch = hora
    ;Cl = minuto
    ;Dh = segundo
    ;DL = Centisegundos 1/100
    ;Mando un número para decirle que es el último
    mov hora,ch
    mov minutos,cl
    mov segundos,dh
    mov millis,dl
    sacarDePila
endm
;================================================================================


;======================bgetTiempoTranscurrido=======================================
getTiempoTranscurrido macro
local cicloMillis,contarMillis,sumarUnSegundo,preCicloSegundos,preCicloSegundos2,cicloSegundos,contarSegundos,sumarUnMinuto,preCicloMinutos,preCicloMinutos2,cicloMinutos,contarMinutos,llenarVariable,millisMayorA99,fin
guardarEnPila
limpiarRegistros
    ;variables minutos,segundos -> tiempoTotalActual
    ;Guardar Tiempo anterior
    mov ch,minutosIni
    mov cl,segundosIni
    mov bl,millisIni
    getHora
    mov dl,0 ;Contador para siguientes
    mov dh,0 ;Contador de tiempo transcurrido
    ;Guardar tiempo actual

    cicloMillis:
        cmp bl,millis
        je preCicloSegundos
        jmp contarMillis    

    contarMillis:
        inc bl
        inc dh
        cmp bl,100
        jne cicloMillis
        je sumarUnSegundo

    sumarUnSegundo:
        inc dl ;Sumar un segundo
        mov bl,0 ;Reinicar millis
        jmp cicloMillis
        
    preCicloSegundos:
        mov bl,dh
        mov dh,0
        add cl,dl
        mov dl,0
        cmp cl,60
        jge preCicloSegundos2
        jmp cicloSegundos

    preCicloSegundos2:
        sub cl,60 ;Reiniciar segundos
        mov dl,1 ;Sumar un minuto


    cicloSegundos:
        cmp cl,segundos
        je preCicloMinutos
        jmp contarSegundos
    
    contarSegundos:
        inc cl
        inc dh
        cmp cl,60
        jne cicloSegundos
        je sumarUnMinuto

    sumarUnMinuto:
        inc dl
        mov cl,0
        jmp cicloSegundos

    preCicloMinutos:
        mov cl,dh
        mov dh,0
        add ch,dl
        mov dl,0
        cmp ch,60
        jge preCicloMinutos2  
        jmp cicloMinutos      

    preCicloMinutos2:
        sub ch,60 ;Reiniciar segundos
        mov dl,1 ;Sumar un minuto  



    cicloMinutos:
        cmp ch,minutos
        je llenarVariable
        jmp contarMinutos  

    contarMinutos:
        inc ch
        inc dh
        cmp ch,60
        jne cicloMinutos             

    ;ch minutos
    ;cl segundos
    ;bl millis
    ;retornar valores a variables
    
    
    
    llenarVariable:
        mov ch,dh
        lea si,tiempoTotalActual
        xor ax,ax
        mov minutosFin,ch
        mov al,ch
        getNumerosPequenos 0
        xor ax,ax
        mov segundosFin,cl
        mov al,cl
        getNumerosPequenos 0
        xor ax,ax
        mov millisFin,bl
        mov al,bl
        cmp al,99
        jg millisMayorA99
        getNumerosPequenos 0
        jmp fin
    millisMayorA99:
        getNumerosGrandes 4
    fin:
sacarDePila
endm
;================================================================================



;======================bguardarEnPila============================================
guardarEnPila macro
    push si
    push di
    push ax
    push bx
    push cx
    push dx
endm
;================================================================================


;=====================================IIII===========================================================


;======================bimprimirEtiqueta=========================================
imprimirEtiqueta macro
        push ax
        push dx
        XOR ax, ax
        XOR dx, dx
		mov ah, 09h  
	    mov dx, si ;Get la dirección de la variable a imprimir
	    int 21h ;Ejecutar la impresión
        pop dx
        pop ax
endm
;================================================================================



;======================bimprimirVariable=========================================
imprimirVariable macro direccion
        push ax
        push dx
        XOR ax, ax
        XOR dx, dx
		mov ah, 09h  
	    mov dx, offset direccion ;Get la dirección de la variable a imprimir
	    int 21h ;Ejecutar la impresión
        pop dx
        pop ax
endm
;================================================================================





;======================bimprimirVariable=========================================
imprimirArray macro matriz, size
local loopImprimir
    push SI
    push DI
    push AX
    push BX
    push CX
    push DX
    LEA SI, matriz ;Offset del array menu
    MOV CX, size ;Tamaño del array

    ;Imprimiendo el texto inicial recorriendo el array
    loopImprimir:
        MOV DX, [SI]
        MOV AH, 9
        int 21h
        INC SI
        INC SI
    LOOP loopImprimir

    ;Recuperación de los valores originales de los registros y el index
    pop DX
    pop CX
    pop BX
    pop AX
    pop DI
    pop SI
endm
;================================================================================


;=====================================LLLL===========================================================

;======================bleerArchivo==============================================
leerArchivo macro manejador,letra,lectura,listaNumerosIn,listaNumerosOut,contadorNumeros,valorMaximo
local ciclo, finCiclo, getNumero, verificarNumero, probableNumero
    mov di, offset lectura
    ciclo:
        ;Conseguir caracter de entrada, 1 x 1
        imprimirVariable lectura
        imprimirVariable saltoLinea
        mov ah, 3Fh
        mov bx, manejador
        mov cx, 1
        lea dx, letra
        int 21h

        ;Verificar si se llego al final del archivo
        cmp letra, ';'
        je finCiclo

        ;Verificar si se cerró una operación y ver si hay algún número para guardar
        cmp letra, '<'
        je verificarNumero

        ;Verificar que sea mayor o igual a 0
        cmp letra, '0'
        jae probableNumero
        jmp ciclo
        
        ;Verificar que sea menor o igual a 9
        probableNumero:
            cmp letra, '9'
            jbe getNumero
        jmp ciclo

        ;Agrego número a lectura
        getNumero:
            mov cl, letra
            mov [di],cl
            inc di
            jmp ciclo

        ;Verificar si hay un número guardado en lectura, convertirlo y guardarlo
        verificarNumero:
            cmp lectura[0],'$'
            je ciclo
            convertirAnumero lectura, listaNumerosIn, contadorNumeros,valorMaximo
            limpiarVariableTexto lectura, 10
            lea di, lectura
            jmp ciclo

    finCiclo:
        copiarLista manejador listaNumerosIn,listaNumerosOut,contadorNumeros
endm
;================================================================================







;======================blimpiarConsola===========================================
limpiarConsola macro
    push ax
    mov ah,00
    mov al,02
    int 10h
    pop ax
endm
;================================================================================


;======================blimpiarRuta==============================================
limpiarRuta macro variable
local limpiando,fin
    guardarEnPila
    limpiarRegistros
    lea si, variable
    limpiando:
        cmp [si],'$'
        je fin
        cmp [si],0
        je fin
        mov [si], 00h
        inc si
        jmp limpiando
    fin:
    sacarDePila
endm
;================================================================================


;======================blimpiarRegistros=========================================
limpiarRegistros macro
    XOR ax,ax
    XOR bx,bx
    XOR cx,cx
    XOR dx,dx
    XOR si,si
    XOR di,di
endm
;================================================================================


;======================blimpiarVariableNumero====================================
limpiarVariableNumero macro lectura,cantidad
local limpiar
    push si
    push bx
    push cx
    push dx  

    lea si, lectura
    mov cl,0
    mov dx,0
    limpiar:
        mov [si],cl
        inc si
        inc dx
        cmp dx,cantidad
        jne limpiar

    pop dx
    pop cx
    pop bx
    pop si
endm
;================================================================================



;======================blimpiarVariableTexto=====================================
limpiarVariableTexto macro lectura,cantidad
local limpiar
    push si
    push bx
    push cx
    push dx

    

    lea si, lectura
    mov cl,'$'
    mov dx,0
    limpiar:
        mov [si],cl
        inc si
        inc dx
        cmp dx,cantidad
        jne limpiar

    pop dx
    pop cx
    pop bx
    pop si
endm
;================================================================================


;======================blimpiarVideo===========================================
limpiarVideo macro
    push ax
    push bx
    push cx
    mov ah,09h
    mov al,4
    mov bh,00h
    mov bl,00h
    mov cx,64000
    int 10h
    pop cx
    pop bx
    pop ax
endm
;================================================================================

;=====================================OOOO===========================================================

;======================bord_bubble_asc===========================================
ord_bubble_asc macro
local for1,for2,finalizar,aumentarI,aumentarJ,cambiarValores,continuarFor2,comparacionFor2
guardarEnPila
limpiarRegistros
    mov cx,0
    mov i,0
    mov j,0
    ;mov valorTemp,0
    lea si,listaNumerosOut
    for1:
        mov dx,cx
        inc dx
        inc dx
        inc i
		mov ax,i
        mov j,ax
        inc j
        mov di,si ;Copiar lugar actual del contador i
        inc di ;Ir al siguiente número de la lista
        inc di
		cmp dx,contadorNumeros
		je finalizar
        cmp cx,contadorNumeros
        jb for2
        jmp finalizar

    for2:
		mov bx,[di]
        cmp [si],bx
        jg cambiarValores
        continuarFor2:
			jmp aumentarJ
		comparacionFor2:
            cmp dx,contadorNumeros
            je aumentarI
			jmp for2

    aumentarI:
        inc cx
        inc cx
        inc si
        inc si
        jmp for1
    aumentarJ:
        inc dx
        inc dx
        inc di
        inc di
        inc j
        jmp comparacionFor2

    cambiarValores:
		mov ax,[si]
        ;mov valorTemp, ax
		mov bx,[di]
        mov [si],bx
        mov [di],ax
		esperarEnter
		regresarAvideo
		limpiarVideo
		entrarModoDatos
		pintarLista bubble,listaNumerosOut
		esperarEnter
		;esperarEnter
        ;borrarBarra i,contadorNumeros,anchoI,anchoF,sdatos
		;salida en video
        ;esperarEnter
        ;entrarModoDatos sdatos
        ;repintarBarra [si],i,contadorNumeros,anchoI,anchoF,alturaF,valorMaximo,sdatos
		;salida en video
        ;esperarEnter
        ;entrarModoDatos sdatos
        ;borrarBarra j,contadorNumeros,anchoI,anchoF,sdatos
        ;esperarEnter
        ;entrarModoDatos sdatos
        ;repintarBarra [di],j,contadorNumeros,anchoI,anchoF,alturaF,valorMaximo,sdatos
        ;esperarEnter
        ;entrarModoDatos sdatos
        jmp continuarFor2
    finalizar:




sacarDePila
endm
;================================================================================


;======================bord_bubble_des===========================================
ord_bubble_des macro
local for1,for2,finalizar,aumentarI,aumentarJ,cambiarValores,continuarFor2,comparacionFor2
guardarEnPila
limpiarRegistros
    mov cx,0
    mov i,0
    mov j,0
    ;mov valorTemp,0
    lea si,listaNumerosOut
    for1:
        mov dx,cx
        inc dx
        inc dx
        inc i
		mov ax,i
        mov j,ax
        inc j
        mov di,si ;Copiar lugar actual del contador i
        inc di ;Ir al siguiente número de la lista
        inc di
		cmp dx,contadorNumeros
		je finalizar
        cmp cx,contadorNumeros
        jb for2
        jmp finalizar

    for2:
		mov bx,[di]
        cmp [si],bx
        jl cambiarValores
        continuarFor2:
			jmp aumentarJ
		comparacionFor2:
            cmp dx,contadorNumeros
            je aumentarI
			jmp for2

    aumentarI:
        inc cx
        inc cx
        inc si
        inc si
        jmp for1
    aumentarJ:
        inc dx
        inc dx
        inc di
        inc di
        inc j
        jmp comparacionFor2

    cambiarValores:
		mov ax,[si]
        ;mov valorTemp, ax
		mov bx,[di]
        mov [si],bx
        mov [di],ax
		esperarEnter
		regresarAvideo
		limpiarVideo
		entrarModoDatos
		pintarLista bubble,listaNumerosOut
		esperarEnter
		;esperarEnter
        ;borrarBarra i,contadorNumeros,anchoI,anchoF,sdatos
		;salida en video
        ;esperarEnter
        ;entrarModoDatos sdatos
        ;repintarBarra [si],i,contadorNumeros,anchoI,anchoF,alturaF,valorMaximo,sdatos
		;salida en video
        ;esperarEnter
        ;entrarModoDatos sdatos
        ;borrarBarra j,contadorNumeros,anchoI,anchoF,sdatos
        ;esperarEnter
        ;entrarModoDatos sdatos
        ;repintarBarra [di],j,contadorNumeros,anchoI,anchoF,alturaF,valorMaximo,sdatos
        ;esperarEnter
        ;entrarModoDatos sdatos
        jmp continuarFor2
    finalizar:
sacarDePila
endm
;================================================================================






;=====================================PPPP===========================================================


;======================bpedirPorTeclado==========================================
pedirPorTeclado macro rutaPorTeclado
local pedir, fin_pedir
    push si
    push ax

    
    lea si, rutaPorTeclado
    pedir:
        mov ah, 01H
        int 21h
        cmp al, 0Dh
        je fin_pedir
        mov [si], al
        inc si
        jmp pedir
    fin_pedir:
    mov [si],0
    pop ax
    pop si
endm
;================================================================================


;======================bpintarBarra==============================================
pintarBarra macro anchoI,anchoF,alturaF,color,sdatos
local ciclo1,ciclo2
guardarEnPila
    mov si, anchoI ;Posicion inicial ancho
    mov bx, anchoF
    mov ax, alturaF
    xor dx,dx
    ;mov dx, color
    regresarAvideo
    ciclo1:
        xor cx, cx
        mov cx, 179d ;Posicion inicial altura
        ciclo2:
            pintarPixel cx, si, color
            ;pintarPixel macro fila,columna,color
            dec cx
            cmp cx,ax ;Posición final altura
            jnz ciclo2
            inc si
            cmp si, bx ; Posicion final ancho
            jne ciclo1
    ;entrarModoDatos 0
    ;entrarModoDatos sdatos
	;salida con video
sacarDePila
endm
;================================================================================


;======================bpintarLista==============================================
pintarLista macro tipo_ordenamiento,listaApintar
local ciclo, fin, rojo, azul, verde, blanco, amarillo,continuar
    guardarEnPila
    limpiarRegistros
	;pintarMarco macro left,right,up,down,color,sdatos
	pintarMarco 20d,299d,30d,180d,10d,sdatos
    ;salida en datos
    getTiempoTranscurrido
    posicionarCursor 28,0
    imprimirVariable orden 
    imprimirVariable tipo_ordenamiento
    imprimirVariable tiempo
    imprimirVariable tiempoTotalActual
    imprimirVariable velocidad_texto
    imprimirVariable velocidad
    posicionarCursor 49,0
    ;La posición inical será x=40
    lea si, listaApintar

    xor dx,dx
    mov ax,contadorNumeros
    mov bx,2
    div bx
    mov bx,ax

    mov ax, 240
    xor dx,dx
    div bx
    sub ax,3
	;mov ax,1
    xor cx,cx
    mov cx,0
    mov anchoI,40
    mov anchoF,40
    add anchoF,ax
        ciclo:
            calcularAltura valorMaximo,alturaF
            ;Entra en modo datos
            mov dx,[si]
            inc si
            inc si
            cmp dx,20d
            jbe rojo
            cmp dx,40d
            jbe azul
            cmp dx,60d
            jbe amarillo
            cmp dx,80d
            jbe verde
            cmp dx,99d
            jbe blanco

            rojo:
                pintarBarra anchoI,anchoF,alturaF,0ch,sdatos ;Salida con video
                jmp continuar
            azul:
                pintarBarra anchoI,anchoF,alturaF,09h,sdatos ;Salida con video
                jmp continuar
            amarillo:
                pintarBarra anchoI,anchoF,alturaF,0eh,sdatos ;Salida con video
                jmp continuar
            verde:
                pintarBarra anchoI,anchoF,alturaF,0ah,sdatos ;Salida con video
                jmp continuar
            blanco:
                pintarBarra anchoI,anchoF,alturaF,0fh,sdatos ;Salida con video
                jmp continuar


        continuar:
            ;pintarBarra anchoI,anchoF,alturaF,0ah,sdatos ;Salida con video
            ;pintarBarra anchoI,anchoF,0,sdatos
            entrarModoDatos

            ;Imprimir numeros solo funciona hasta 8 numeros
            ;push ax
            ;push bx
            ;mov ax, dx
            ;aam
            ;add al, 30h
            ;add ah, 30h
            ;mov bl, al
            ;mov bh, ah
            ;mov al,bh
            ;mov ah,bl
            ;mov numtemp[0],ax
            ;mov numtemp[2],','
            ;imprimirVariable numtemp
            ;pop bx
            ;pop ax         

            add anchoF,3
            mov dx,anchoF
            mov anchoI,dx
            add anchoF,ax
            inc cx
            inc cx
            cmp cx,contadorNumeros
            jb ciclo
        fin:
		;salida en modo datos
            sacarDePila
endm
;================================================================================


;======================bpintarMarco==============================================
pintarMarco macro left,right,up,down,color,sdatos
local horizontal,vertical
    guardarEnPila
	limpiarRegistros
	mov ax, left
    mov si, ax
	mov di, up
	mov cx, down
    horizontal:
		regresarAvideo
        pintarPixel di,si,color
        pintarPixel cx,si,color
		entrarModoDatos
        inc si
        cmp si,right 
        jne horizontal

    limpiarRegistros
	mov ax,up
    mov si,ax
	mov di,right
	mov cx,left
    vertical:
		regresarAvideo
        pintarPixel si,di,color
        pintarPixel si,cx,color
		entrarModoDatos
        inc si
        cmp si,down 
        jne vertical

	sacarDePila
endm
;================================================================================


;======================bpintarPixel==============================================
pintarPixel macro fila,columna,color
    guardarEnPila
    ;limpiarRegistros
    mov ax, 320d
    mov bx, fila
    mul bx
    add ax,columna
    mov di,ax
    mov cx,color
    mov [di],cx
    sacarDePila
endm
;================================================================================


;======================bposicionarCursor==============================================
posicionarCursor macro fila,columna
    guardarEnPila
    limpiarRegistros
    ;mov cx, columna
    mov ah, 02h
    mov bh, 00h
    mov dh, fila ;23 filas total
    mov dl, columna ;118 columnas total
    int 10h
    sacarDePila
endm
;================================================================================

;=====================================RRRR===========================================================

;======================bregresarAvideo===========================================
regresarAvideo macro
    push ax
    mov ax, 0A000h
    mov ds, ax
    pop ax
endm
;================================================================================


;======================brepintarBarra===========================================
repintarBarra macro numero,lugar,contadorNumeros,anchoI,anchoF,alturaF,valorMaximo,sdatos
local buscarPosicion, salir, alturaYcolor, rojo,azul,amarillo,verde,blanco    
    ;Posición más alta es 30
    ;Posición más baja es 179
    guardarEnPila
    ;limpiarRegistros

    ;Calcular ancho
        alturaYcolor:
            mov ax, numero
            calcularAltura2 valorMaximo,alturaF
            ;calcularAltura2 macro valorMaximo,alturaF,color
            ;Entra en modo datos
            mov dx,numero
            inc si
            inc si
            cmp dx,20d
            jbe rojo
            cmp dx,40d
            jbe azul
            cmp dx,60d
            jbe amarillo
            cmp dx,80d
            jbe verde
            cmp dx,99d
            jbe blanco

            rojo:
                pintarBarra anchoI,anchoF,alturaF,0ch,sdatos ;Salida con video
                jmp salir
            azul:
                pintarBarra anchoI,anchoF,alturaF,09h,sdatos ;Salida con video
                jmp salir
            amarillo:
                pintarBarra anchoI,anchoF,alturaF,0eh,sdatos ;Salida con video
                jmp salir
            verde:
                pintarBarra anchoI,anchoF,alturaF,0ah,sdatos ;Salida con video
                jmp salir
            blanco:
                pintarBarra anchoI,anchoF,alturaF,0fh,sdatos ;Salida con video
                jmp salir

    salir:
        ;pintarBarra anchoI,anchoF,30d,00h,sdatos
        ;Salida con video
        sacarDePila
endm
;================================================================================


;=====================================SSSS===========================================================

;======================bsacarDePila==============================================
sacarDePila macro
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop si
endm
;================================================================================

;======================bsalirModoVideo==========================================
salirModoVideo macro
    push ax
    mov ax, 0003h
    int 10h
    ;mov ax, @data
    mov ax, sdatos
    mov ds, ax
    pop ax
endm
;================================================================================

;=====================================WWWW===========================================================

;======================bwriteXml=================================================
writeXml macro
    mov ah,40h
    mov bx,manejadorSalida
    getArraySize reporte
    lea dx,reporte
    int 21h    
    ;cerrarArchivo manejador
endm
;================================================================================



;=====================================XXXX===========================================================

;======================bxmlAgregarLista==========================================
xmlAgregarLista macro dato
local while,fin,while2,siguienteLista
guardarEnPila
limpiarRegistros
mov si,posicionActualReporte
lea di,dato
mov ax,[di]
    while:    
        cmp ax,0
        je fin
        getNumerosPequenos 1
        inc di
        inc di
        mov ax,[di]
        cmp ax,0
        je fin
        mov [si],','
        inc si
        jmp while   
    fin:
        mov posicionActualReporte,si
        sacarDePila
endm
;================================================================================


;======================bxmlAgregarEtiqueta=======================================
xmlAgregarEtiqueta macro etiqueta
local while,fin
push di
push ax
xor ax,ax
xor di,di
    lea di,etiqueta
    while:
        cmp [di],'$'
        je fin
        mov al, [di]
        mov [si],al
        inc si
        inc di
        jmp while
    fin:
pop ax
pop di
endm

;================================================================================




