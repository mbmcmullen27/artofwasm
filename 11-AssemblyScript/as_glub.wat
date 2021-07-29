(module
 (type $i32_=>_none (func (param i32)))
 (type $i32_i32_i32_i32_=>_none (func (param i32 i32 i32 i32)))
 (type $none_=>_none (func))
 (import "as_glub" "console_log" (func $as_glub/console_log (param i32)))
 (import "env" "abort" (func $~lib/builtins/abort (param i32 i32 i32 i32)))
 (global $~lib/memory/__stack_pointer (mut i32) (i32.const 16460))
 (memory $0 1)
 (data (i32.const 12) "<")
 (data (i32.const 24) "\01\00\00\00\1e\00\00\00g\00l\00u\00b\00.\00.\00.\00 \00g\00l\00u\00b\00.\00.\00.")
 (export "glubGlub" (func $as_glub/glubGlub))
 (export "memory" (memory $0))
 (func $as_glub/glubGlub
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  global.get $~lib/memory/__stack_pointer
  i32.const 76
  i32.lt_s
  if
   i32.const 16480
   i32.const 16528
   i32.const 1
   i32.const 1
   call $~lib/builtins/abort
   unreachable
  end
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  global.get $~lib/memory/__stack_pointer
  i32.const 32
  i32.store
  i32.const 32
  call $as_glub/console_log
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
)
