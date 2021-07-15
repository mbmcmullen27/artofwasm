(module
    (global $cnvs_size      (import "env" "cnvs_size")      i32)
    
    (global $no_hit_color   (import "env" "no_hit_color")   i32)
    (global $hit_color      (import "env" "hit_color")      i32)
    (global $obj_start      (import "env" "obj_start")      i32)
    (global $obj_size       (import "env" "obj_size")       i32)
    (global $obj_cnt        (import "env" "obj_cnt")        i32)

    (global $x_offset       (import "env" "x_offset")       i32)    ;; bytes 00-03
    (global $y_offset       (import "env" "y_offset")       i32)    ;; bytes 04-07
    (global $xv_offset      (import "env" "xv_offset")      i32)    ;; bytes 08-11
    (global $yv_offset      (import "env" "yv_offset")      i32)    ;; bytes 12-15

    (import "env" "buffer" (memory 80))                             ;; canvas buffer

    ;; clear the canvas
    (func $clear_canvas
        (local $i           i32)
        (local $pixel_bytes i32)

        global.get $cnvs_size
        global.get $cnvs_size
        i32.mul                 ;; multiply $width and $height

        i32.const 4
        i32.mul                 ;; 4 bytes per pixel

        local.set $pixel_bytes  ;; $pixel_bytes = $width * $height * 4

        (loop $pixel_loop
            (i32.store (local.get $i) (i32.const 0xff_00_00_00))

            (i32.add (local.get $i) (i32.const 4))
            local.set $i        ;; $i =+ 4 (bytes per pixel)

            ;; if #i < $pixel_bytes
            (i32.lt_u (local.get $i) (local.get $pixel_bytes))
            br_if $pixel_loop ;; break loop if all pixel set
        )
    )

    ;; return the absolute value
    (func $abs
        (param $value   i32)
        (result         i32)

        (i32.lt_s (local.get $value) (i32.const 0)) ;; is $value negative?
        if ;; if $value is negative subtract it from 0 to get the positive value
            i32.const 0
            local.get $value
            i32.sub
            return
        end
        local.get $value ;; return original value
    )

    ;; this function sets a pixel at coordinats $x, $y to the color $c
    (func $set_pixel
        (param $x   i32)    ;; x coordinate
        (param $y   i32)    ;; y coordinate
        (param $c   i32)    ;; color value

        ;; is $x > $cnvs_size
        (i32.ge_u (local.get $x) (global.get $cnvs_size))
        if  ;; $x is outside the canvas bounds
            return
        end

        ;; is $y > $cnvs_size
        (i32.ge_u (local.get $y) (global.get $cnvs_size))
        if  ;; $y is outside the canvas bounds
            return
        end

        local.get $y
        global.get $cnvs_size
        i32.mul

        local.get $x
        i32.add         ;; $x + $y * $cnvs_size (get pixels into linear memory)

        i32.const 4
        i32.mul         ;; multiply byy 4 because each pixel is 4 bytes

        local.get $c    ;; load color value

        i32.store       ;; store color in memory location
    )

    ;; draw multi pixel object as a square given coordinates $x, $y, and color $c
    (func $draw_obj
        (param $x       i32)    ;; x coordinate
        (param $y       i32)    ;; y coordinate
        (param $c       i32)    ;; color value

        (local $max_x   i32)
        (local $max_y   i32)

        (local $xi      i32)
        (local $yi      i32)

        local.get $x
        local.tee $xi
        global.get $obj_size
        i32.add
        local.set $max_x        ;; $max_x = $x + $obj_size

        local.get $y
        local.tee $yi
        global.get $obj_size
        i32.add
        local.set $max_y        ;; $max_y = $y + $obj_size

        (block $break (loop $draw_loop
            local.get $xi
            local.get $yi
            local.get $c
            call $set_pixel     ;; set pixel at $xi, $yi to color $c

            local.get $xi
            i32.const 1
            i32.add
            local.tee $xi       ;; $xi++

            local.get $max_x
            i32.ge_u            ;; is $xi >= $max_x

            if
                local.get $x
                local.set $xi   ;; reset $xi to $x

                local.get $yi
                i32.const 1
                i32.add
                local.tee $yi   ;; $yi++

                local.get $max_y
                i32.ge_u        ;; is $yi >= $max_y
                br_if $break
            end
            br $draw_loop
        ))
    )

)