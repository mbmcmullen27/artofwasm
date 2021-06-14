(module
    (import "js" "tbl" (table $tbl 4 anyfunc))
    ;; import increment
    (import "js" "increment" (func $increment (result i32)))
    ;; import decrement
    (import "js" "decrement" (func $decrement (result i32)))

    ;; import wasm_increment function
    (import "js" "wasm_increment" (func $wasm_increment (result i32)))
    ;; import wasm_decrement function
    (import "js" "wasm_decrement" (func $wasm_decrement (result i32)))

    ;; table function type definitions all i32 and take no parameters
    (type $returns_i32 (func (result i32)))

    (global $inc_ptr i32 (i32.const 0)) ;; JS increment function table index
    (global $dec_ptr i32 (i32.const 1)) ;; JS decrement function table index

    (global $wasm_inc_ptr i32 (i32.const 2)) ;; WASM increment function table index
    (global $wasm_dec_ptr i32 (i32.const 3)) ;; WASM decrement function table index

    ;; Test performance of an indirect table call of JavaScript functions
    (func (export "js_table_test")
        (loop $inc_cycle
            ;; indirect call to JS incement function
            (call_indirect (type $returns_i32) (global.get $inc_ptr))
            i32.const 4_000_000
            i32.le_u ;; is the value returned by call to $inc_ptr <= 4,000,000?
            br_if $inc_cycle ;; if so, loop
        )
        
        (loop $dec_cycle
            ;; indirect call to JS incement function
            (call_indirect (type $returns_i32) (global.get $dec_ptr))
            i32.const 4_000_000
            i32.le_u ;; is the value returned by call to $dec_ptr <= 4,000,000?
            br_if $dec_cycle ;; if so, loop
        )
    )

    ;; Test performance of direct call to JS functions
    (func (export "js_import_test")
        (loop $inc_cycle
            ;; direct call to JS incement function
            call $increment
            i32.const 4_000_000
            i32.le_u ;; is the value returned by call to $increment <= 4,000,000?
            br_if $inc_cycle ;; if so, loop
        )
        
        (loop $dec_cycle
            ;; direct call to JS decrement function
            call $decrement
            i32.const 4_000_000
            i32.le_u ;; is the value returned by call to $decrement <= 4,000,000?
            br_if $dec_cycle ;; if so, loop
        )
    )

    ;; Test performance of an indirect table call to WWASM functions
    (func (export "wasm_table_test")
        (loop $inc_cycle
            ;; indirect call to WASM incement function
            (call_indirect (type $returns_i32) (global.get $wasm_inc_ptr))
            i32.const 4_000_000
            i32.le_u ;; is the value returned by call to $wasm_inc_ptr <= 4,000,000?
            br_if $inc_cycle ;; if so, loop
        )
        
        (loop $dec_cycle
            ;; indirect call to WASM decrement function
            (call_indirect (type $returns_i32) (global.get $wasm_dec_ptr))
            i32.const 4_000_000
            i32.le_u ;; is the value returned by call to $wasm_dec_ptr <= 4,000,000?
            br_if $dec_cycle ;; if so, loop
        )
    )

    ;; Test performance of direct call to WASM functions
    (func (export "wasm_import_test")
        (loop $inc_cycle
            ;; direct call to WASM incement function
            call $wasm_increment
            i32.const 4_000_000
            i32.le_u ;; is the value returned by call to $increment <= 4,000,000?
            br_if $inc_cycle ;; if so, loop
        )
        
        (loop $dec_cycle
            ;; direct call to WASM decrement function
            call $wasm_decrement
            i32.const 4_000_000
            i32.le_u ;; is the value returned by call to $decrement <= 4,000,000?
            br_if $dec_cycle ;; if so, loop
        )
    )

)