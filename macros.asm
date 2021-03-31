
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
        je bDes
        cmp ax,'2'
        je bAsc
        bAsc:
            esperarEnter    
            entrarModoVideo 
            entrarModoDatos
            pintarlista bubble,listaNumerosIn
            ;salida en modo datos
            esperarEnter
            ord_bubble_asc 
            esperarEnter
            salirModoVideo
            jmp finalizar
        bDes:
            esperarEnter    
            entrarModoVideo 
            entrarModoDatos
            pintarlista bubble,listaNumerosIn
            ;salida en modo datos
            esperarEnter
            ord_bubble_des 
            esperarEnter
            salirModoVideo
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




;======================bescribirFin==============================================
escribirFin macro eof,manejador
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

;======================bgetColor============================================
getColor macro numero,color
local salir,rojo,azul,amarillo,verde,blanco
    cmp numero,20d
    jbe rojo
    cmp numero,40d
    jbe azul
    cmp numero,60d
    jbe amarillo
    cmp numero,80d
    jbe verde
    cmp numero,99d
    jbe blanco

    rojo:
        mov dx, 0ch
        jmp salir
    azul:
        mov dx, 09h
        jmp salir
    amarillo:
        mov dx, 0eh
        jmp salir
    verde:
        mov dx, 0ah
        jmp salir
    blanco:
        mov dx, 0fh
        jmp salir

    salir:
endm
;================================================================================


;======================bgetNumero================================================
getNumero macro entrada,salida
local ciclo, finalizar, fin, agregarMaximo
    
	guardarEnPila
    mov si, offset entrada
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
		mov salida,ax
        sacarDePila  
endm
;================================================================================

;======================btiempoTranscurrido=======================================
getTiempoTranscurrido macro
local ciclo, fin
    ;variables minutos,segundos
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
    posicionarCursor 28,0
    imprimirVariable orden 
    imprimirVariable tipo_ordenamiento
    imprimirVariable tiempo
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

            push ax
            push bx
            mov ax, dx
            aam
            add al, 30h
            add ah, 30h
            mov bl, al
            mov bh, ah
            mov al,bh
            mov ah,bl
            mov numtemp[0],ax
            mov numtemp[2],','
            imprimirVariable numtemp
            pop bx
            pop ax         

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

