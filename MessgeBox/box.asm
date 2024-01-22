include \masm32\include\masm32rt.inc

.data
    msg db "Hello, MessageBox!", 0
    caption db "Custom Caption", 0

.code
main:
    push 3      ;(tham số 1) Gọi kiểu MessageBox mong muốn
    push offset caption   ;lpCaption(tham số 2): chuỗi tiêu đề
    push offset msg       ;lpText(tham số 3): chuỗi thông điệp
    push 0                ;hWnd (tham số 4): Cửa sổ cha
    call MessageBoxA      ;Gọi MessageBox

    invoke ExitProcess,0
end main
;MB_OK (0x00000000): Đây là giá trị mặc định khi không cung cấp tham số uType. Cửa sổ MessageBox chỉ hiển thị một nút "OK" và không có biểu tượng.

;MB_OKCANCEL (0x00000001): Cửa sổ MessageBox hiển thị hai nút "OK" và "Cancel".

;MB_ABORTRETRYIGNORE (0x00000002): Cửa sổ MessageBox hiển thị ba nút "Abort", "Retry" và "Ignore".

;MB_YESNO (0x00000004): Cửa sổ MessageBox hiển thị hai nút "Yes" và "No".

;MB_YESNOCANCEL (0x00000003): Cửa sổ MessageBox hiển thị ba nút "Yes", "No" và "Cancel".

;MB_RETRYCANCEL (0x00000005): Cửa sổ MessageBox hiển thị hai nút "Retry" và "Cancel".

;MB_ICONINFORMATION (0x00000040): Cửa sổ MessageBox hiển thị biểu tượng thông tin.

;MB_ICONWARNING (0x00000030): Cửa sổ MessageBox hiển thị biểu tượng cảnh báo.

;MB_ICONERROR (0x00000010): Cửa sổ MessageBox hiển thị biểu tượng lỗi.

;MB_ICONQUESTION (0x00000020): Cửa sổ MessageBox hiển thị biểu tượng câu hỏi.