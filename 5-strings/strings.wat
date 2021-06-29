(module
    (import "env" "str_pos_len" (func $str_pos_len (param i32 i32)))
    (import "env" "null_str" (func $null_str (param i32)))
    (import "env" "len_prefix" (func $len_prefix (param i32)))
    (import "env" "buffer" (memory 1))

    (data (i32.const 0) "Null-terminating string\00")
    (data (i32.const 128) "Another null-terminating string\00")

    ;; 30 character string
    (data (i32.const 256) "Know the length of this string")
    ;; 35 characters
    (data (i32.const 384) "Also know the length of this string")

    ;; length of 22 in decimal is 16 in hex
    (data (i32.const 512) "\16length-prefixed string")
    ;; length of 30 is 1e in hex
    (data (i32.const 640) "\1eanother length-prefixed string")

    (func (export "main")
        (call $null_str (i32.const 0))
        (call $null_str (i32.const 128))

        ;; length of the first string is 30
        (call $str_pos_len (i32.const 256) (i32.const 30))
        ;; length of the first string is 35
        (call $str_pos_len (i32.const 384) (i32.const 35))

        (call $len_prefix (i32.const 512))
        (call $len_prefix (i32.const 640))
    )

    (func $byte_copy
        (param $source i32) (param $dest i32) (param $len i32)
        (local $last_source_byte i32)

        local.get $source
        local.get $len
        i32.add     ;; $source + $len

        local.set $last_source_byte             ;; $last_source_byte = $source + $len

        (loop $copy_loop (block $break
            local.get $dest ;; push $dest on stack for use in i32.store8 call
            (i32.load8_u (local.get $source))   ;; load a single byte from $source
            i32.store8                          ;; store a single byte in $dest

            local.get $dest
            i32.const 1
            i32.add
            local.set $dest                     ;; $dest = $dest + 1

            local.get $source
            i32.const 1
            i32.add
            local.tee $source                   ;; $source = $source + 1

            local.get $last_source_byte
            i32.eq
            br_if $break
            br $copy_loop
        ))
    )
    
    (func $byte_copy_i64
        (param $source i32) (param $dest i32) (param $len i32)
        (local $last_source_byte i32)

        local.get $source
        local.get $len
        i32.add

        local.set $last_source_byte

        (loop $copy_loop (block $break
            (i64.store (local.get$dest) (i64.load (local.get $source)))
            
            local.get $dest
            i32.const 8 
            i32.add
            local.set $dest                     ;; $dest = $dest + 8

            local.get $source
            i32.const 8
            i32.add
            local.set $source                   ;; $source = $source + 8

            local.get $last_source_byte
            i32.ge_u
            br_if $break
            br $copy_loop
        ))
    )
)