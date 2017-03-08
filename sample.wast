(module
  (table 0 anyfunc)
  (memory $0 1)
  (data (i32.const 12) "\00\00\00\00")
  (export "memory" (memory $0))
  (export "count" (func $count))
  (func $count (result i32)
    (local $0 i32)
    (i32.store offset=12
      (i32.const 0)
      (i32.add
        (tee_local $0
          (i32.load offset=12
            (i32.const 0)
          )
        )
        (i32.const 1)
      )
    )
    (get_local $0)
  )
)
