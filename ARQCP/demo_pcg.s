.section .text
.global pcg32_random_r # uint32_t pcg32_random_r(void)

.section .data
.global state # uint64_t state
.global inc #uint64_t inc

pcg32_random_r:

	movq state(%rip), %rdi
	movq inc(%rip), %rsi

	movq %rdi, %r8		  #uint64_t oldstate = state
	
	movq $6364136223846793005, %rax
	
	pushq %r8
	mulq %r8 			# oldstate * 6364136223846793005ULL
	
	orq $1, %rsi  		# (inc|1)
	
	addq %rsi,%rax    # oldstate * 6364136223846793005ULL + (inc|1)
	
	movq %rax,state(%rip)    #state = oldstate * 6364136223846793005ULL + (inc|1)
	
	popq %r8
	
	movq %r8,%r9
	
	shrq $18, %r8
	xorq %r9, %r8
	
	shrq $27, %r8		# #uint32_t xorshifted = ((oldstate >> 18u) ^ oldstate) >> 27u
	
	shrq $59, %r9    #uint32_t rot = oldstate >> 59u
	
	movq %r9, %rcx
	
	rorl %ecx, %r8d
	
	movl %r8d, %eax
	
ret			
