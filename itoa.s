                .global itoa

                .equ div10_magic, 0xcccccccd

                .text
@ itoa(buffer, n) -> number of bytes written
itoa:
                push    {r4,r5,r6,lr}
                @ r0: buffer
                @ r1: n
                @ r2: length of output
                @ r3: division magic number
                @ r4: digit
                @ r5: new n
                ldr     r3, =div10_magic
                mov     r2, #0
1:
                @ do a division by 10
                umull   r4, r5, r3, r1          @ multiply by magic number
                mov     r5, r5, lsr #3          @ shift: new_n is in r5
                add     r4, r5, r5, lsl #2      @ compute new_n*5
                sub     r4, r1, r4, lsl #1      @ remainder = n - new_n*5*2
                add     r4, r4, #'0'            @ convert to digit
                strb    r4, [r0, r2]             @ store in buffer
                add     r2, r2, #1              @ length++
                subs    r1, r5, #0              @ n = newn and compare with 0
                bgt     1b

                @ return number of bytes written
                mov	r0, r2
		pop	{r4,r5,r6,pc}