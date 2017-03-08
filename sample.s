	.text
	.file	"sample.ll"
	.hidden	count
	.globl	count
	.type	count,@function
count:                                  # @count
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push4=, c($pop5)
	tee_local	$push3=, $0=, $pop4
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop3, $pop1
	i32.store	c($pop0), $pop2
	copy_local	$push6=, $0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	count, .Lfunc_end0-count

	.hidden	c                       # @c
	.type	c,@object
	.bss
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 5.0.0 (http://llvm.org/git/clang.git 2a2d4663e26ea46e348f21d7517191ed163d6bd5) (http://llvm.org/git/llvm.git c5bc6a63d2cfa31e363d1dae1bdd50d88c545bc0)"
