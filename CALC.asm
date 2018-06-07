
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

use16
org 7c00h 

ADRESS_NUM1 EQU 600h
ADRESS_NUM2 EQU 800h
ADRESS_SUM EQU 0A00h
ADRESS_SUB EQU 0C00h
ADRESS_MUL EQU 0E00h

start:    
mov ch, 00h 
mov cl, 02h    

mov dh, 00h
mov dl, 80h

mov ax, cs
mov es, ax

mov bx, ADRESS_NUM1

mov ah, 02h 
mov al, 01h      

int 13h

mov cl, 03h

mov bx, ADRESS_NUM2 

mov ah, 02h
mov al, 01h

int 13h

addition: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


mov si, 511
clc 

loop1: 
    mov al, [ADRESS_NUM1 + si]
    adc al, [ADRESS_NUM2 + si]
    mov [ADRESS_SUM + si], al 
    jc with_c
    
    cmp si, 0  
    jz subtraction
    dec si
    clc
    jmp loop1
       
    with_c: 
    cmp si, 0
    jz subtraction
    dec si 
    stc
    jmp loop1    
    
    
    
subtraction: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


mov si, 511
clc 

loop2: 
    mov al, [ADRESS_NUM1 + si]
    sbb al, [ADRESS_NUM2 + si]
    mov [ADRESS_SUB + si], al 
    jc with_c2
    
    cmp si, 0  
    jz multiplication
    dec si
    clc
    jmp loop2
       
    with_c2: 
    cmp si, 0
    jz multiplication
    dec si 
    stc
    jmp loop2
                                                                                  
                                                                                  
multiplication: ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


mov si, 511 ;counter for bytes in number1  
clc
mov dh, 0
hehh:  

    mov bx, 511  ;counter for bytes in number2
    g:  ;start of multiplication number2 with byte of number1 (number1[si])  
      mov cx, 511
      sub cx, bx  ;offset relatively to the end
      
      mov al, [ADRESS_NUM1 + si] 
      mov di, bx    
      mov bh, [ADRESS_NUM2 + di]
      mul bh
      mov bx, di      
            
      mov di, si
      add di, 512
      sub di, cx  ;index of byte in result
      
      add  [ADRESS_MUL + di], al   
      dec di
      adc [ADRESS_MUL + di], ah
      mov ah, 0
      jnc ac
      add ah, 1
      ac:
      add [ADRESS_MUL + di], dh
      jnc ab
      add ah, 1
      ab:
      mov dh, ah
      
      cmp bx, 0
      jz t
       
      dec bx
      jmp g 
    
    t: cmp si, 0
    jz write_on_disk
    dec si
    jmp hehh   
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     
write_on_disk:               
    mov cl, 04h
    mov ch, 00h
    mov dl, 80h
    mov dh, 00h
    
    mov ax, cs
    mov es, ax
    
    mov bx, ADRESS_SUM
    
    mov ah, 03h
    mov al, 01h
    
    int 13h ;write sum in sector4  
     
    mov ax, cs
    mov es, ax
    
    mov bx, ADRESS_SUB
    mov cl, 05h    
    
    mov ah, 03h
    mov al, 01h
    
    int 13h ;write substraction in sector5  
    
    mov ax, cs
    mov es, ax
    
    mov bx, ADRESS_MUL
    mov cl, 06h    
    mov al, 01h  
    
    mov ah, 03h
    
    int 13h ;write the part of result of muiltiplication in sector 6      
    
    mov ax, cs
    mov es, ax
    
    mov bx, ADRESS_MUL + 200h
    mov cl, 07h    
    mov al, 01h  
    
    mov ah, 03h    
    
    int 13h ; write another part in sector7  
    
    mov ax, cs
    
    mov ds, ax     
    mov si, msg
    mov ah, 0Eh 
    
write_ch:         

    lodsb
    test al, al
    jz $
        
    int 10h
    
    jmp write_ch 
        
ret 

msg db 'Completed!', 10, 0

finish:
    times 1FEh-finish+start db 0
    db 55h, 0AAh