(module
    ;; this is the original function we wrote
    (func (export "pow2")
        (param $p1 i32)
        (param $p2 i32)
        (result i32)
        local.get $p1
        i32.const 16
        i32.mul
        local.get $p2
        i32.const 8
        i32.div_u
        i32.add
    )

    ;; was-opt placed the div before mul
    (func (export "pow2_reverse")
        (param $p1 i32)
        (param $p2 i32)
        (result i32)
        local.get $p2
        i32.const 8
        i32.div_u
        local.get $p1
        i32.const 16
        i32.mul
        i32.add    
    )

    ;; replace mul with shift
    (func (export "pow2_mul_shift")
        (param $p1 i32)
        (param $p2 i32)
        (result i32)
        local.get $p1
        i32.const 16
        i32.shl
        local.get $p2
        i32.const 8
        i32.div_u
        i32.add
    )

    ;; change multiply and divide to shifts
    (func (export "pow2_mul_div_shift")
        (param $p1 i32)
        (param $p2 i32)
        (result i32)
        local.get $p2
        i32.const 3
        i32.shr_u
        local.get $p1
        i32.const 4
        i32.shl
        i32.add
    )

    ;; use shifts with original order
    (func (export "pow2_mul_div_nor")
        (param $p1 i32)
        (param $p2 i32)
        (result i32)
        local.get $p1
        i32.const 4
        i32.shl
        local.get $p2
        i32.const 3
        i32.shr_u
        i32.add
    )

    ;; generated by wasm-opt
    (func (export "pow2_opt")
        (param i32 i32)
        (result i32)
        local.get 1
        i32.const 8
        i32.div_u
        local.get 0
        i32.const 4
        i32.shl
        i32.add
    
    )
)