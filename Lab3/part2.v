module fulladder(a,b,cin,s,cout);
	input a, b, cin;
	output s, cout;
	
	assign s = cin ^ (a ^ b);
	assign cout = (b & ~(a^b)) | (cin & (a^b));
	
endmodule

module part2(a, b, c_in, s, c_out);
	input [3:0]a, b; 
	input c_in;
	output [3:0]s, c_out;
	
	wire [2:0] connection;
	
	fulladder u0(
	.a(a[0]),
	.b(b[0]),
	.cin(c_in),
	.s(s[0]),
	.cout(connection[0])
	);
	
	assign c_out[0] = connection[0];
	
	fulladder u1(
	.a(a[1]),
	.b(b[1]),
	.cin(connection[0]),
	.s(s[1]),
	.cout(connection[1])
	);
	
	assign c_out[1] = connection[1];
	
	fulladder u2(
	.a(a[2]),
	.b(b[2]),
	.cin(connection[1]),
	.s(s[2]),
	.cout(connection[2])
	);

	assign c_out[2] = connection[2];	
	
	fulladder u3(
	.a(a[3]),
	.b(b[3]),
	.cin(connection[2]),
	.s(s[3]),
	.cout(c_out[3])
	);

endmodule
	
