------------------------
Lab 4: ASCII (HEX or 2SC) to Base 4CMPE 012 Winter 2019
Last Name, First Name
CruzID
-------------------------
------------------------
Lab 4: ASCII (HEX or 2SC) to Base 4
CMPE 012 Winter 2019
Cui, Yongsheng
1491148
-------------------------
What was your approach to converting each ASCII input to two’s complement form?
For binary just sets the first bit negative, multiply it by the appropriate power of 2 and continue with the rest of the bits. 
For hex, we know that the range for hex is -128 to 127, which means that any number over 127 is negative. So disregard whether or not the hex is positive and just get the actual decimal value. Then value you can check if its more than or less than 127. If it's more than 127, then subtract that value by 256. 
What did you learn in this lab?
I learn how to read program argument in mars and convert hex and binary to decimal in order to convert to base 4. And also learned how to load byte by using format lb. And program arguments store in a0 and address a1 as well.
Did you encounter any issues? Were there parts of this lab you foundenjoyable?
I did encounter how to read the second bit in order to determine it's hex or binary. And also for hex, I feel confuse to convert A-F to decimal. Moreover, convert decimal to base 4 is another challenge.
How would you redesign this lab to make it better?
I would more likely to use decimal convert to base 4 as first part, then use binary that convert to decimal then to base 4 because it's step by step to teach will be more clearly to understand how it work.
Did you collaborate with anyone on this lab? Please list who you collaborated with and the nature of your collaboration.
No. 


