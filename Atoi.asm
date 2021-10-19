#convert string number to int number
#Tristan Chilvers | Alex Muse

.text #text section
.globl main #call main by SPIM

main:
    # PRINT ASK TEXT
    li $v0, 4                   # system call code for printing string (command 4)
    la $a0, ask_text            # load address of string to be printed into $a0
    syscall

    # USER INPUT
    li $v0, 8                   # read in string input from user (command 8)
    la $a0, buffer              # load the byte space into a0 (address of input buffer)
    li $a1, 10                  # when string is finished, 10 is to mark the end. This register will be used later for exiting the loop
    move $s0, $a0               # save string in s0
    syscall

    # CONVERT STRING TO INT
    li $s1, 0                   # stores final converted string as int

    lbu $t0, ($s0)              # read byte from string
    addi $t0, $t0, -48          # Subtract 48 to convert ASCII to INT value
    add $s1, $s1, $t0           # store byte in s1
    addi $s0, $s0, 1            # pointer + 1  (pointer for where in string the computer is at)
    lbu $t0, ($s0)              # read byte from string

    jal convert                 # call the convert function

    # PRINT ANSWER TEXT
    li $v0, 4                   # system call code for printing string (command 4)
    la $a0, answer_text         # load address of string to be printed into $a0
    syscall

    # PRINT CONVERTED STRING AS INT
    move $a0, $s1               # move final int to a0 for system call
    li $v0, 1                   # system call to read int at a0
    syscall

    # END PROGRAM
    li $v0, 10                  # terminate program
    syscall

    #===========================================================================
    #===========================================================================
    # FUNCTION: int toInt(string num)
    # Arguments stored in $s0
    # Return value stored in $s1
    # Return address stored in $ra (done by jal function)
convert:
    beq $t0, $a1, exit          # if value in string is equal to 10 (end of string), then exit
    addi $t0, $t0, -48          # Subtract 48 to convert ASCII to INT value
    mul $t2, $s1, 10            # multiply by 10 (to correctly "append" the next value in the string to the converted int)
    add $s1, $t2, $t0           # add the current value to the already added values
    addi $s0 $s0, 1             # pointer + 1
    lbu $t0, ($s0)              # read next byte from string

    j convert                   # repeat

exit:
    jr $ra


.data #data section
buffer: .space 8
ask_text: .asciiz "\nPlease enter a number of 8 places or less: "
answer_text: .asciiz "\nConverted: "
