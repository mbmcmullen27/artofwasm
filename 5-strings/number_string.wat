(module 
    (import "env" "print_string" (func $print_string (param i32 i32)))
    (import "env" "buffer" (memory 1))

    (data (i32.const 128) "0123456789ABCDEF")

    (data (i32.const 256) "               0")
    (global $dec_string_len i32 (i32.const 16))
    (global $hex_string_len i32 (i32.const 16))     ;; hex char count
    (data (i32.const 384) "             0x0")       ;; hex string data

    (func $set_hex_string (param $num i32) (param $string_len i32)
        (local $index       i32)
        (local $digit_char  i32)
        (local $digit_val   i32)
        (local $x_pos       i32)

        global.get $hex_string_len
        local.set $index        ;; set the index to the number of hex characrters 

        (loop $digit_loop (block $break
            local.get $index
            i32.eqz
            br_if $break

            local.get $num
            i32.const 0xf       ;; last 4 bits are 1
            i32.and             ;; the offset into $digits is in the last 4 bits of number

            local.set $digit_val        ;; the digit value iss the last 4 bits
            local.get $num
            i32.eqz
            if                          ;; if $num == 0 
                local.get $x_pos
                i32.eqz
                if
                    local.get $index
                    local.set $x_pos    ;; position of 'x' in the '0x' hex prefix
                else
                    i32.const 32        ;; 32 is ascii space char
                    local.set $digit_char
                end
            else
                ;; load character from 128 + $digit_val
                (i32.load8_u offset=128 (local.get $digit_val))
                local.set $digit_char
            end

            local.get $index
            i32.const 1
            i32.sub
            local.tee $index            ;; $index = $index - 1
            local.get $digit_char

            ;; store $digit_char at location 384+$index
            i32.store8 offset=384

            local.get $num
            i32.const 4
            i32.shr_u                   ;; sshifts 1 hex  digit off $num
            local.set $num

            br $digit_loop                   
        ))

        local.get $x_pos
        i32.const 1
        i32.sub

        i32.const 120                   ;; ascii x
        i32.store8 offset=384           ;; store 'x' in string

        local.get $x_pos
        i32.const 2
        i32.sub

        i32.const 48                    ;; ascii 0
        i32.store8 offset=384           ;; store "0x" at the front of the string

    )

    (func $set_dec_string (param $num i32) (param $string_len i32)
        (local $index       i32)
        (local $digit_char  i32)
        (local $digit_val   i32)

        local.get $string_len
        local.set $index        ;; set $index to string length

        local.get $num
        i32.eqz                 ;; is $num equal to zero
        if                      ;; if the number is 0, remove spaces
            local.get $index
            i32.const 1
            i32.sub
            local.set $index    ;; index--

            ;; store ascii '0' to memory location 256 + $index
            (i32.store8 offset=256 (local.get $index) (i32.const 48))
        end

        (loop $digit_loop (block $break     ;; loop converts number to a string
            local.get $index                ;; set $index to end of string, decrement to 0
            i32.eqz                         ;; is $index 0?
            br_if $break                    ;; break the loop

            local.get $num
            i32.const 10
            i32.rem_u                       ;; decimal digit is remainder of divide by 10

            local.set $digit_val            ;; replaces call above
            local.get $num
            i32.eqz                         ;; check if $num is 0
            if
                i32.const 32                ;; 32 is ascii space character
                local.set $digit_char       ;; if $num is 0, left pad spaces
            else
                (i32.load8_u offset=128 (local.get $digit_val))
                local.set $digit_char       ;; set $digit_char to ascii digit
            end

            local.get $index
            i32.const 1
            i32.sub
            local.set $index
            ;; store ascii digit 256 + $index
            (i32.store8 offset=256 (local.get $index) ( local.get $digit_char))

            local.get $num
            i32.const 10
            i32.div_u
            local.set $num                  ;; remove last decimal digit, dividing by 10
            br $digit_loop                  ;; loop
        ))
    )

    (func (export "to_string") (param $num i32)
        (call $set_dec_string (local.get $num) (global.get $dec_string_len))
        (call $print_string (i32.const 256) (global.get $dec_string_len))

        (call $set_hex_string (local.get $num) (global.get $hex_string_len))
        (call $print_string (i32.const 384) (global.get $hex_string_len))
    )
)