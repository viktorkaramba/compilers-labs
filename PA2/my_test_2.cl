class Base inherits A2I {
	num_1 : Int;
	num_2 : Int;
	
	input_num_1(): Int{{
		num_1 <- a2i((new IO).in_string());
		num_1;
	}};

	input_num_2(): Int{{
		num_2 <- a2i((new IO).in_string());
		num_2;
	}};
	
	print_num_1(): Object{
		(new IO).out_string(i2a(num_1).concat("\n"))
	};

	print_num_2(): Object{
		(new IO).out_string(i2a(num_2).concat("\n"))
	};
};

class Arithmetic inherits Base {
	sum_result : Int;
	sub_result : Int;
	mul_result : Int;
	div_result : Int;

	sum_method(): Int {{
		sum_result <- num_1 + num_2;
		sum_result;
	}};

	sub_method(): Int {{
		sub_result <- num_1 - num_2;
		sub_result;
	}};

	mul_method(): Int {{
		mul_result <- num_1 * num_2;
		mul_result;
	}};

	div_method(): Int {{
		div_result <- num_1 / num_2;
		div_result;
	}};

	print_sum(): Object {
		(new IO).out_string(i2a(sum_method()).concat("\n"))
	};

	print_sub(): Object {
		(new IO).out_string(i2a(sub_method()).concat("\n"))
	};

	print_mul(): Object {
		(new IO).out_string(i2a(mul_method()).concat("\n"))
	};

	print_div(): Object {
		(new IO).out_string(i2a(div_method()).concat("\n"))
	};

	menu(): Object {
		while true loop
		let operator : Int <- a2i((new IO).in_string()) in 
		  if operator = 1 then print_sum() else 
		  if operator = 2 then print_sub() else 
		  if operator = 3 then print_mul() else 
 		  if operator = 4 then print_div() else 
		  (new IO).out_string("Error operation\n")
		  fi fi fi fi 
		 pool
	};
};

class Main {
	arithm: Arithmetic <- new Arithmetic;
	main(): Object {{
		arithm.input_num_1();
		arithm.input_num_2();
		arithm.print_num_1();
		arithm.print_num_2();
		arithm.menu();
	}};
};