
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

use16
org 7c00h

start:
    xor     ax, ax
    mov     ss, ax
    mov     sp, 7C00h
    sti
    push    ax
    pop     es
    push    ax
    pop     ds
    cld
    mov     si, 7C1Bh
    mov     di, 61Bh
    
    mov     cx, 1E5h
    rep movsb
    jmp 61Bh
    
write_start:
    mov ax, cs
    
    mov ds, ax     
    mov si, msg - 7600h
    mov ah, 0Eh 
    
write_ch:         

    lodsb
    test al, al
    jz get_pass
        
    int 10h
    
    jmp write_ch       
         
get_pass:
    mov cx, 4  
    mov di, buf - 7600h
    
    cycle:
        mov ah, 0
        
        int 16h
        
        stosb  
             
        mov ah, 0Eh
        mov al, 42
        
        int 10h
         
        
        loop cycle  
                      
check_pass:  
    mov di, buf - 7600h
    mov si, password - 7600h  
    mov cx, 4
    repe cmpsb
    jne bad_end
    
good_end:
    mov ch, 00h 
    mov cl, 02h    

    mov dh, 00h
    mov dl, 80h

    mov ax, cs
    mov es, ax
    
    mov bx, 7C00h

    mov ah, 02h 
    mov al, 01h      

    int 13h
    
    push 0
    push 7C00h
    retf

bad_end:   

    mov si, bad - 7600h
    mov ah, 0Eh 
    
    write:         

        lodsb
        test al, al
        jz $
    
        int 10h
    
        jmp write 

msg db 'Please, write the password!', 10, 0
bad db 'Incorrect password!', 0

buf db 4 dup(?), 0

password db '4321', 0

finish:
    times 1FEh-finish+start db 0
    db 55h, 0AAh