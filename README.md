Project Name: Calculator.xcodeproj
Name: Benedikt Lotter




Homework 01.c

Outside resources used:

- a lot of stack-overflow
- a high level description of the algorithm for infix parsing: 
http://www.smccd.net/accounts/hasson/C++2Notes/ArithmeticParsing.html
- piazza discussion of Stanford course "coding together for iOS"















Homework 01.a
Calculator Prep


Basic calculator specs:
• Supports inﬁx notation (see git.to/inﬁx).
• Supports addition, subtraction, multiplication, and division.
• Supports decimal numbers.
• Supports negative numbers.
• Abides by correct order of operations.
• Handles divide by zero elegantly (e.g. ∞, NaN).
• Allows user to clear their input.

Optional (Extra Credit)
• Supports parentheses for changing order of operations.
• Supports exponentiation.
• Supports input like π, e, etc.
• ... and whatever else you think would be useful!


The input that you will be handling is a string representing user input, such as the examples below.
“1 + 2”
“2 x 3 + 1”
“1 + 15 ÷ 4 – 3”
etc.
Your output should be the resulting number that corresponds to the computation expressed by the input 
string.
3
7
1.75
etc.









How to compute the output from the input:


Description of Implementation following the model view controller paradigm:

Model:

	- define a operation class with instance variables to store operands and operations: 

		- there are several possible data structures to store the operations and operands:

			- one option is to have two stacks, one with the operations and one with the operands:
			  once the input string has been parsed, one could look at the order of operations that are contained in the most recent statement and evaluate the statement accordingly by popping elements of the stack.
			  to evaluate the statement in the right order of operations, one could search through the input string to find the operand with the highest precedence of operations

	- the operation class also contains methods that determine the type of an inputted string (operand/operation), expose the availabes operations as a set and methods to enforce the constraints on the operations
		
	- some data structure needs to specify the order of operations of 1. multiplication/division and 2. addition/subtraction
	  this can be achieved by attaching numerical values to the different types of operations such as:

    7 for Operators with only 1 Operand (sin, cos, ...)
    6 for 1-operand-Operation x².
    5 for Operators with 2 Operands (/)
    4 for Operators with 2 Operands (*)
    3 for Operators with 2 Operands (-)
    2 for Operators with 2 Operands (+)
    1 - not returned here, reserved priority for leading "-" of a number
    0 for anything else (numbers, Pi, variables)

    - parentheses could be implemented by the following rule:

    Parentheses around child operation must be set, when the priority of the parent operator > priority of the child operator.
    Exception: "-"-Operator, Example: 5-(3-1) needs parentheses when both priorities are equal.


Controller:



	- the controller will be responsible for updating the view and parsing the input so that operations and operands and operations are stored, order of operations is conserved,  invalid inputs are detected

	- when updating the view and checking for the user's actions, the controller checks what type of input is currently given in. For instance, if the decimal point has been pressed the preceding and following string and following need to be processed (passed on to the model) as double. If the back button is pressed, the controller must also initiate the computations of all the inputted operands and operators.

	- these states about the view, which the controller observes should be passed on to the model, which then evaluates accordingly




View:

	- this is really just the rendering of the display, the buttons: these buttons are objects that have actions that trigger certain methods in the controller
	- the view also contains the display


	



























