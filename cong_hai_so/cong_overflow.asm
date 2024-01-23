include C:\masm32\include\masm32rt.inc

.data
    msg1 db "Nhap so thu nhat: ", 0
    msg2 db "Nhap so thu hai: ", 0
    msg3 db "Ket qua: ", 0
    x db 22 dup(?)
    y db 22 dup(?)
    sum_result db 100 dup(0)
    sum db 100 dup(0)
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
    mov ebx, 10      ;Cho ebx=10 để thực hiện phép chia

    lap_string:
        cmp eax, 0        ;Kiểm tra nếu giá trị trong thanh ghi eax=0 thì kết thúc vòng lặp
        je out_string     

        mov edx, 0        ;Cho edx=0 để reset lại giá trị của edx sau khi chia
        div ebx           ;chia eax cho 10
        add dl, 48        ;chuyển giá trị trong dl(số dư sau khi chia) sang số dạng kí tự
        mov byte ptr [esi], dl   ;Chuyển kí tự trong dl vào địa chỉ của biến sum
        inc esi           ;Tăng esi 1 đơn vị để trỏ đến địa chỉ tiếp theo
        jmp lap_string

    out_string:
    call dao_nguoc      ;gọi hàm dao_nguoc để đưa về đúng kết quả
    pop edx       ;Trả lại các giá trị trong thanh ghi lúc đầu
    pop esi
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


start:
    ; Nhập số thứ nhất
    invoke StdOut,addr msg1
    push 22
    push offset x
    call StdIn

    mov eax, offset x
    call chuyen_sang_int 
    
    mov tmp, eax    ;cho tmp=eax để lưu trữ giá trị của x cho việc tính toán tiếp theo

   ; Nhập số thứ hai
    invoke StdOut, addr msg2
    push 22
    push offset y
    call StdIn
    mov eax, offset y
    call chuyen_sang_int
    
    mov edx,tmp
    add eax,edx
    call chuyen_sang_string

    ; Hiển thị kết quả
    invoke StdOut, addr msg3
    invoke StdOut, offset sum_result

    ; Exit the program
    invoke ExitProcess, 0

end start

