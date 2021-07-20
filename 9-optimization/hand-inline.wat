(func $add_three ;; function adds three numbers
    (param $a i32)
    (param $b i32)
    (param $c i32)
    (result i32)

    local.get $a
    local.get $b
    local.get $c
    i32.add
    i32.add
)

(func (export "inline_test") ;; I will inline functions in inline_test
    (param $p1 i32)
    (param $p2 i32)
    (param $p3 i32)
    (result i32)
    ;; (call $add_three (local.get $p1) (i32.const 2) (local.get $p2))
    ;; function above inlined in code below
    local.get $p1
    i32.const 2
    local.get $p2
    i32.add
    i32.add
    
    ;; (call $add_three (local.get $p3) (local.get $p1) (i32.const 13))
    local.get $p3
    local.get $p1
    i32.const 13
    i32.add
    i32.add
)