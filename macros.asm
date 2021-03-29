
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
entrarModoDatos macro sdatos
    push ax
    mov ax, @data
    ;mov ax, sdatos
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
sacarDePila
endm
;================================================================================


;======================blistaInicial==============================================
pintarLista macro contadorNumeros,anchoI,anchoF,alturaF,color,valorMaximo,listaNumerosIn,sdatos
local ciclo, fin, rojo, azul, verde, blanco, amarillo,continuar
    guardarEnPila
    limpiarRegistros
    ;La posición inical será x=40
    lea si, listaNumerosIn

    xor dx,dx
    mov ax,contadorNumeros
    mov bx,2
    div bx
    mov bx,ax

    mov ax, 240
    xor dx,dx
    div bx
    sub ax,3
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
            entrarModoDatos sdatos          
            add anchoF,3
            mov dx,anchoF
            mov anchoI,dx
            add anchoF,ax
            inc cx
            inc cx
            cmp cx,contadorNumeros
            jb ciclo
        fin:
    ;regresarAvideo
            sacarDePila
endm
;================================================================================


;======================bpintarMarco==============================================
pintarMarco macro left,right,up,down,color
local horizontal,vertical
    push si
    xor si,si
    mov si, left

    horizontal:
        pintarPixel up,si,color
        pintarPixel down,si,color
        inc si
        cmp si,right 
        jne horizontal

    xor si,si
    mov si,up
    vertical:
        pintarPixel si,right,color
        pintarPixel si,left,color
        inc si
        cmp si,down 
        jne vertical

    pop si
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
    limpiarRegistros

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
salirModoVideo macro sdatos
    push ax
    mov ax, 0003h
    int 10h
    mov ax, @data
    ;mov ax, sdatos
    mov ds, ax
    pop ax
endm
;================================================================================

