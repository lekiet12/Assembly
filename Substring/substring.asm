include \masm32\include\masm32rt.inc

.data
    msg1 db "Khong co substring",0
    string db 256 dup(?)
    substring db 256 dup(?)
    index_output DWORD 100 dup(0)
    index DWORD 100 dup(0)
    tmp DWORD ?
.code

compare_string proc
    push ebx     ;Đẩy giá trị các thanh ghi lên stack để bảo vệ nó
    push ecx
    push edx
    push esi

    lea ebx,substring     ;Trỏ ebx đến địa chỉ của substring
    lea esi,string        ;Trỏ esi đến địa chỉ của string
    mov ecx,0  ;giá trị cuối cùng của ecx là chỉ cần tìm
    lap_1:
        cmp byte ptr[esi],0    ;Kiểm tra giá trị tại địa chỉ esi có phải là NULL không.Nếu bằng thì trong vòng lặp ở dưới không được index của substring nên sẽ nhảy đến false
        je false
        mov eax,0     ;.Lúc đầu cho nó = 0 để bắt đầu chuỗi substring
        lap_2:
            xor edx,edx   ;Đưa thanh ghi edx trở về bằng 0
            cmp byte ptr[ebx+eax],0  ;Kiểm tra đã chuỗi kết thúc chưa.Nếu đã kết thúc thì nhảy đến break_lap2 để thực hiện chỉ số tiếp theo của string
            je break_lap2 
            mov dl,byte ptr[ebx+eax]   ;So sánh hai kí tự của string và substring 
            cmp byte ptr[esi+eax],dl
            jne  break_lap2     ;Nếu không bằng thì break khỏi vòng lặp thứ hai
            cmp byte ptr[ebx+eax+1],0  ;Kiểm tra kí tự kế tiếp có phải là NULL không nếu đúng thì có nghĩa là substring có trong string nên sẽ nhảy đến true để thoát khỏi vòng lặp  
            je true
            inc eax  ;tăng eax để trỏ đến kí tự tiếp theo của substring và string
            jmp lap_2 ;Nhảy đến lap_2
        break_lap2:
        inc ecx  ;tăng ecx lên 1 
        inc esi  ;tăng esi lên 1 để trỏ kí tự tiếp theo của string
        jmp lap_1
true:
    inc ecx     ;tăng ecx lên 1 để bằng với chỉ số chúng ta thường đọc
    mov eax,ecx ;cho eax=ecx
    jmp finish
false:
    mov eax,10000 ;cho eax=10000 để thực hiện kiểm tra sau khi thoát khỏi hàm
    jmp finish
finish:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
compare_string endp
;-----------------------
;-----------------------
chuyen_sang_string proc
    push ebx       ;Đẩy các giá trị lên stack để bảo vệ các thanh ghi
    push ecx
    push esi
    push edx
    lea esi, index     ;Trỏ esi đến địa chỉ của index
    mov ebx, 10      ;Cho ebx=10 để thực hiện phép chia

    lap_string:
        cmp eax, 0        ;Kiểm tra nếu giá trị trong thanh ghi eax=0 thì kết thúc vòng lặp
        je out_string     

        mov edx, 0        ;Cho edx=0 để reset lại giá trị của edx sau khi chia
        div ebx           ;chia eax cho 10
        add dl, 48        ;chuyển giá trị trong dl(số dư sau khi chia) sang số dạng kí tự
        mov byte ptr [esi], dl   ;Chuyển kí tự trong dl vào địa chỉ của biến index
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
    lea edx, index    ;Trỏ edx đến địa chỉ của biến index
    xor ecx, ecx    ;Đưa ecx về 0 để đếm trong biến index có bao nhiêu kí tự

    Nhan:
        cmp byte ptr [edx], 0   ;Kiểm tra xem đó có phải kí tự NULL không (kết thúc chuỗi) để kết thúc vòng lặp
        je break

        inc ecx     ;tăng ecx lên 1 đơn vị 
        inc edx     ;tăng edx lên 1 đơn vị để trỏ đến địa chỉ tiếp theo của biến index
        jmp Nhan

    break:
    lea ebx, index_output  ;trỏ ebx đến địa chỉ của 
    reverse:
        cmp ecx, 0     ;Kiểm tra đã hết kí tự chưa 
        je break_reverse  ;Nếu hết thì kết thúc vòng lặp
        dec edx  ;Vì ở trên edx(địa chỉ của biến index) đang trỏ đến kí tự NULL nên ta giảm 1 đon vị để trỏ đến kí tự trước đó 

        mov al, byte ptr [edx]  ;cho giá trị tại địa chỉ của ebx(index) bằng giá trị tại địa chỉ của ebx(index_output) 
        mov byte ptr [ebx], al

        dec ecx    ;giảm ecx 1 đơn vị
        inc ebx    ;tăng ebx lên 1 đơn vị để trỏ đến địa chỉ tiếp theo của index_output
        jmp reverse

    break_reverse:
    mov byte ptr [ebx], 0 ;cho giá trị tại địa chỉ ebx = 0(NULL) để kết thúc chuỗi

    pop ebx      ;Trả lại các giá trị trong thanh ghi lúc đầu
    pop ecx
    pop edx
    pop esi
    ret
dao_nguoc endp
;--------------------------
;--------------------------
main:
    ;Nhập vào chuỗi string
    push 256             ;Độ dài tối đa của chuỗi nhập vào
    push offset string   ;Đẩy địa chỉ của string lên ngăn xếp để sau đó thực hiện gọi hàm hệ thống
    call StdIn           ;Gọi StdIn để thực hiện nhập chuỗi từ bàn phím

    ;Nhập vào chuỗi substring
    push 256             ;Độ dài tối đa của chuỗi nhập vào
    push offset substring       ;Đẩy địa chỉ của string lên ngăn xếp để sau đó thực hiện gọi hàm hệ thống
    call StdIn           ;Gọi StdIn để thực hiện nhập chuỗi từ bàn phím   
    
    call compare_string  ;gọi hàm compare_string
    cmp eax,10000   ;so sánh eax(giá trị về sau khi gọi hàm compare_string) với 10000.Nếu bằng thì in ra chuỗi Khong co string
    je Khong_co_substring
    call chuyen_sang_string  ;Nếu như nó không bằng thì có nghĩa là đã tìm được chỉ số cần tìm.Nên ta chỉ việc in nó ra thôi
    invoke StdOut,offset index_output
    jmp Thoat
Khong_co_substring:
    invoke StdOut,offset msg1 
    jmp Thoat
Thoat:
    invoke ExitProcess,0

end main