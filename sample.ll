; ModuleID = 'sample.c'
source_filename = "sample.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32"

@c = hidden global i32 0, align 4

; Function Attrs: noinline nounwind
define hidden i32 @count() #0 {
entry:
  %0 = load i32, i32* @c, align 4
  %inc = add nsw i32 %0, 1
  store i32 %inc, i32* @c, align 4
  ret i32 %0
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 5.0.0 (http://llvm.org/git/clang.git 2a2d4663e26ea46e348f21d7517191ed163d6bd5) (http://llvm.org/git/llvm.git c5bc6a63d2cfa31e363d1dae1bdd50d88c545bc0)"}
