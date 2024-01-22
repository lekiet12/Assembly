include C:\masm32\include\masm32rt.inc

.data
    msg1 db "Nhap so thu nhat(dec): ", 0
    msg2 db "Nhap so thu hai(dec): ", 0
    msg3 db "Ket qua(hex): ", 0
    x db 20 dup(?)
    y db 20 dup(?)
    sum_result dd 100 dup(0)
    sum dd 100 dup(0)
    tmp dd ?

.code
;----------------------------
;Không được sử dụng thanh ghi edx để làm trung gian cho việc tính toán vì khi nhân thì thanh ghi edx sẽ thay nên việc tính toán sẽ sai nên việc sử dụng thanh ghi ebx hoặc ecx là tốt nhất cho việc chuyển đổi sang số nguyên
chuyen_sang_int proc
    push ebx   ;Đẩy các thanh ghi lên ngăn xếp để bảo vệ các thanh ghi sau khi thực hiện chương trình không bị thay đổi
    push ecx
    push edx
    push esi

    mov esi, eax ;Vì phép nhân thực hiện trên thanh ghi eax nên ta chuyển địa chỉ của số(được nhập vào trước đó) trong thanh ghi eax vào thanh ghi esi
    mov eax, 0   ;Cho eax=0 để bắt đầu chuyển số(string) sang số dạng integer

    lap:
        mov ebx,0               ;Đặt thanh ghi ebx bằng 0 sau mỗi lần lặp để tiếp tục cho việc chuyển đổi
        mov bl, byte ptr [esi]  ;Cho bl = giá trị tại địa chỉ esi. Sử dụng thanh ghi bl vì một ô nhớ là 1 byte.
        
        cmp bl, 48              ;Kiểm tra giá trị của bl trong bảng mã ascii có phải là một số ở dạng kí tự không
        jl finish               ;Nếu không phải thì kết thúc việc tính toán vì có như thế nào cũng sẽ in ra kết quả sai

        cmp bl, 57
        jg finish

        sub bl, 48              ;Khi qua được điều kiện sẽ thực hiện trừ đi 48 ('0') để chuyển thành số
        mov ecx, 10             ;Cho ecx=10 để thực hiện nhân eax=eax*10+bl
        mul ecx
        add eax, ebx            ;cộng bl vào eax
        inc esi                 ;tăng esi lên 1 để trỏ đến địa chỉ tiếp theo
        jmp lap
    finish:
        pop esi     ;Trả lại các giá trị thanh ghi lúc đầu
        pop edx
        pop ecx
        pop ebx

        ret
chuyen_sang_int endp
;------------------------------

;------------------------------
chuyen_sang_string proc
    push ebx       ;Đẩy các giá trị lên stack để bảo vệ các thanh ghi
    push ecx
    push esi
    push edx
    lea esi, sum     ;Trỏ esi đến địa chỉ của sum
    mov ebx, 16      ;Cho ebx=10 để thực hiện phép chia
    
    lap_string:
        cmp eax, 0        ;Kiểm tra nếu giá trị trong thanh ghi eax=0 thì kết thúc vòng lặp
        je out_string     

        mov edx, 0        ;Cho edx=0 để reset lại giá trị của edx sau khi chia
        div ebx           ;chia eax cho 10
        call chuyen_hex
        inc esi           ;Tăng esi 1 đơn vị để trỏ đến địa chỉ tiếp theo
        jmp lap_string

    out_string:

    pop edx  ;chuyển sang kí tự với phần bit lớn lưu trong edx sau khi nhân
    mov eax,edx
    lap_string_2:
        cmp eax, 0        ;Kiểm tra nếu giá trị trong thanh ghi eax=0 thì kết thúc vòng lặp
        je out_string_2     

        mov edx, 0        ;Cho edx=0 để reset lại giá trị của edx sau khi chia
        div ebx           ;chia eax cho 10
        call chuyen_hex
        inc esi           ;Tăng esi 1 đơn vị để trỏ đến địa chỉ tiếp theo
        jmp lap_string_2

    out_string_2:
    call dao_nguoc      ;gọi hàm dao_nguoc để đưa về đúng kết quả
            
    pop esi    ;Trả lại các giá trị trong thanh ghi lúc đầu
    pop ecx
    pop ebx
    ret
chuyen_sang_string endp
;---------------------------

;---------------------------
dao_nguoc proc
    push ebx        ;Đẩy các giá trị lên stack để bảo vệ các thanh ghi
    push ecx
    push edx
    push esi
    lea edx, sum    ;Trỏ edx đến địa chỉ của biến sum
    xor ecx, ecx    ;Đưa ecx về 0 để đếm trong biến sum có bao nhiêu kí tự

    Nhan:
        cmp byte ptr [edx], 0   ;Kiểm tra xem đó có phải kí tự NULL không (kết thúc chuỗi) để kết thúc vòng lặp
        je break

        inc ecx     ;tăng ecx lên 1 đơn vị 
        inc edx     ;tăng edx lên 1 đơn vị để trỏ đến địa chỉ tiếp theo của biến sum
        jmp Nhan

    break:
    lea ebx, sum_result  ;trỏ ebx đến địa chỉ của 
    reverse:
        cmp ecx, 0     ;Kiểm tra đã hết kí tự chưa 
        je break_reverse  ;Nếu hết thì kết thúc vòng lặp
        dec edx  ;Vì ở trên edx(địa chỉ của biến sum) đang trỏ đến kí tự NULL nên ta giảm 1 đon vị để trỏ đến kí tự trước đó 

        mov al, byte ptr [edx]  ;cho giá trị tại địa chỉ của ebx(sum) bằng giá trị tại địa chỉ của ebx(sum_result) 
        mov byte ptr [ebx], al

        dec ecx    ;giảm ecx 1 đơn vị
        inc ebx    ;tăng ebx lên 1 đơn vị để trỏ đến địa chỉ tiếp theo của sum_result
        jmp reverse

    break_reverse:
    mov byte ptr [ebx], 0 ;cho giá trị tại địa chỉ ebx = 0(NULL) để kết thúc chuỗi

    pop ebx      ;Trả lại các giá trị trong thanh ghi lúc đầu
    pop ecx
    pop edx
    pop esi
    ret
dao_nguoc endp
;------------------
;------------------
chuyen_hex proc
    cmp dl,0              ;so sánh lần lượt số dư với các số từ 0->15 nếu bằng cái nào thì chuyển sang số hệ 16 tương ứng
    jne next_1
    mov byte ptr[esi],48
    jmp continue
next_1:
    cmp dl,1
    jne next_2
    mov byte ptr[esi],49
    jmp continue
next_2:
    cmp dl,2
    jne next_3
    mov byte ptr[esi],50
    jmp continue
next_3:
    cmp dl,3
    jne next_4
    mov byte ptr[esi],51
    jmp continue
next_4:
    cmp dl,4
    jne next_5
    mov byte ptr[esi],52
    jmp continue
next_5:
    cmp dl,5
    jne next_6
    mov byte ptr[esi],53
    jmp continue
next_6:
    cmp dl,6
    jne next_7
    mov byte ptr[esi],54
    jmp continue
next_7:
    cmp dl,7
    jne next_8
    mov byte ptr[esi],55
    jmp continue
next_8:
    cmp dl,8
    jne next_9
    mov byte ptr[esi],56
    jmp continue
next_9:
    cmp dl,9
    jne next_10
    mov byte ptr[esi],57
    jmp continue
next_10:
    cmp dl,10
    jne next_11
    mov byte ptr[esi],97
    jmp continue
next_11:
    cmp dl,11
    jne next_12
    mov byte ptr[esi],98
    jmp continue
next_12:
    cmp dl,12
    jne next_13
    mov byte ptr[esi],99
    jmp continue
next_13:
    cmp dl,13
    jne next_14
    mov byte ptr[esi],100
    jmp continue
next_14:
    cmp dl,14
    jne next_15
    mov byte ptr[esi],101
    jne next_15
    jmp continue
next_15:
    mov byte ptr[esi],102
    jmp continue
    continue:
    ret
chuyen_hex endp
;---------------
start:
    ; Nhập số thứ nhất
    invoke StdOut,addr msg1
    push 20
    push offset x
    call StdIn

    mov eax, offset x
    call chuyen_sang_int 
    
    mov tmp, eax    ;cho tmp=eax để lưu trữ giá trị của x cho việc tính toán tiếp theo
    
   ; Nhập số thứ hai
    invoke StdOut, addr msg2
    push 20
    push offset y
    call StdIn
    mov eax, offset y
    call chuyen_sang_int
    
    mov ebx,tmp   ;Cho ebx=tmp để thực hiện phép nhân
    mul ebx       ;Nhân giá trị trong eax với ebx (=x*y)
    call chuyen_sang_string

    ; Hiển thị kết quả
    invoke StdOut, addr msg3
    invoke StdOut, offset sum_result
    ; Thoát chương trình
    invoke ExitProcess, 0

end start
