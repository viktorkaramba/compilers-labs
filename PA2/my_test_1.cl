
class First {
	a_1 : Int    1 ;
	a_2 : Int <- 2 ;
	a_2   Int <- 3 ;
};


class Second {
	a_1 : Int <- 1;
	d():Int{1};
	m():Int{4;};
	y : Bool
	f : Int
};

class Third inherits IO{
	a_1 : String <- "some str";
	method_1(str : String): Object {
		out_string(a_1.concat(str))
	};
};

class Main {
	a_1 : Int <- 1;
	main(): Object {
		(new Third).method_1(" + str\n")	
	};
};
