# 0 "entry.S"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "entry.S"




# 1 "include/asm.h" 1
# 6 "entry.S" 2
# 1 "include/segment.h" 1
# 7 "entry.S" 2
# 1 "include/errno.h" 1
# 48 "include/errno.h"
# 1 "/usr/include/asm-generic/errno-base.h" 1 3 4
# 49 "include/errno.h" 2
# 8 "entry.S" 2
# 74 "entry.S"
.globl keyboard_handler; .type keyboard_handler, @function; .align 0; keyboard_handler:
 pushl %gs; pushl %fs; pushl %es; pushl %ds; pushl %eax; pushl %ebp; pushl %edi; pushl %esi; pushl %ebx; pushl %ecx; pushl %edx; movl $0x18, %edx; movl %edx, %ds; movl %edx, %es
 call keyboard_routine
    movb $0x20, %al ; outb %al, $0x20 ;

 popl %edx; popl %ecx; popl %ebx; popl %esi; popl %edi; popl %ebp; popl %eax; popl %ds; popl %es; popl %fs; popl %gs
 iret

.globl clock_handler; .type clock_handler, @function; .align 0; clock_handler:
 pushl %gs; pushl %fs; pushl %es; pushl %ds; pushl %eax; pushl %ebp; pushl %edi; pushl %esi; pushl %ebx; pushl %ecx; pushl %edx; movl $0x18, %edx; movl %edx, %ds; movl %edx, %es
 movb $0x20, %al ; outb %al, $0x20 ;
 call clock_routine
 popl %edx; popl %ecx; popl %ebx; popl %esi; popl %edi; popl %ebp; popl %eax; popl %ds; popl %es; popl %fs; popl %gs
 iret

.globl page_fault2_handler; .type page_fault2_handler, @function; .align 0; page_fault2_handler:
 call page_fault2_routine


.globl system_call_handler; .type system_call_handler, @function; .align 0; system_call_handler:
 pushl %gs; pushl %fs; pushl %es; pushl %ds; pushl %eax; pushl %ebp; pushl %edi; pushl %esi; pushl %ebx; pushl %ecx; pushl %edx; movl $0x18, %edx; movl %edx, %ds; movl %edx, %es
 cmpl $0, %EAX
 jl err
 cmpl $MAX_SYSCALL, %EAX
 jg err
 call *sys_call_table(, %EAX, 0x04)
 jmp fin
err:
 movl $-38, %EAX
fin:
 movl %EAX, 0x18(%esp)
 popl %edx; popl %ecx; popl %ebx; popl %esi; popl %edi; popl %ebp; popl %eax; popl %ds; popl %es; popl %fs; popl %gs
 iret

.globl writeMSR; .type writeMSR, @function; .align 0; writeMSR:
      pushl %ebp
      movl %esp, %ebp

      movl 8(%ebp), %ecx
      movl 12(%ebp), %eax
      movl $0, %edx
      wrmsr

      movl %ebp, %ebp
      popl %ebp
      ret

.globl syscall_handler_sysenter; .type syscall_handler_sysenter, @function; .align 0; syscall_handler_sysenter:
    pushl $0x2B
    pushl %ebp
    pushfl
    pushl $0x23
    pushl 4(%ebp)

    pushl %gs; pushl %fs; pushl %es; pushl %ds; pushl %eax; pushl %ebp; pushl %edi; pushl %esi; pushl %ebx; pushl %ecx; pushl %edx; movl $0x18, %edx; movl %edx, %ds; movl %edx, %es

    cmpl $0, %eax
    jl sysenter_err
    cmpl $MAX_SYSCALL, %eax
    jg sysenter_err

    call *sys_call_table(, %eax, 0x04)
    jmp sysenter_fin

sysenter_err:
    movl $-38, %eax

sysenter_fin:
    movl %eax, 0x18(%esp)

    popl %edx; popl %ecx; popl %ebx; popl %esi; popl %edi; popl %ebp; popl %eax; popl %ds; popl %es; popl %fs; popl %gs

    movl (%esp), %edx
    movl 12(%esp), %ecx
    sti
    sysexit


.globl get_ebp; .type get_ebp, @function; .align 0; get_ebp:
 movl %ebp, %eax
 ret

.globl task_switch; .type task_switch, @function; .align 0; task_switch:
 pushl %ebp
 movl %esp, %ebp
 pushl %esi
 pushl %edi
 pushl %ebx
 pushl 8(%ebp)
 call inner_task_switch
 addl $4, %esp
 popl %ebx
 popl %edi
 popl %esi
 popl %ebp
 ret


.globl task_switch43; .type task_switch43, @function; .align 0; task_switch43:
 pushl %ebp
 movl %esp, %ebp
 movl 8(%ebp), %eax
 movl %ebp, (%eax)
 movl 12(%ebp), %esp
 popl %ebp
 ret
