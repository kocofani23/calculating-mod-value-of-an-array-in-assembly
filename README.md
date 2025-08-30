ASM Program for Calculating Mode

This project is an EXE-type assembly program that calculates the most frequently occurring value (mode) of an integer sequence of length 10 or less.

📌 Project Description

The program stores up to 10 integers received as input from the user in an array named NUMBERS. The MODE subroutine then calculates the number of occurrences of the numbers in the array, finding the most frequently occurring value (mode) and printing it to the screen.

The program uses:

A macro to receive user input,

A subroutine to perform the mode calculation,

A stack structure to transfer parameters between the macro and the subroutine.

📂 Structure

NUMBERS: An integer array with a maximum of 10 elements

INPUT_ARRAY: A macro that populates the array by taking user input

MOD: A subroutine that calculates the mod value

Main Program: Coordinates operations by calling the macro and subroutine

⚙️ Operating Logic

The user enters the length of the array (which can be less than 10) and its elements.

The INPUT_ARRAY macro stores these values ​​in the NUMBERS array.

The main program analyzes the array by calling the MOD subroutine.

MOD counts the frequency of occurrence of each number and finds the value with the highest frequency.

The found mod value is stored in a variable and displayed as output.
