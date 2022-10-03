module fulladder(a,b,cin,s,cout);
	input a, b, cin;
	output s, cout;
	
	assign s = cin ^ (a ^ b);
	assign cout = (b & ~(a^b)) | (cin & (a^b));
	
endmodule

module ripple(a, b, cin, s, cout);
	input [3:0]a, b; 
	input cin;
	output [3:0]s, cout;
	
	wire [2:0] connection;
	
	fulladder u0(
	.a(a[0]),
	.b(b[0]),
	.cin(cin),
	.s(s[0]),
	.cout(connection[0])
	);
	
	assign cout[0] = connection[0];
	
	fulladder u1(
	.a(a[1]),
	.b(b[1]),
	.cin(connection[0]),
	.s(s[1]),
	.cout(connection[1])
	);
	
	assign cout[1] = connection[1];
	
	fulladder u2(
	.a(a[2]),
	.b(b[2]),
	.cin(connection[1]),
	.s(s[2]),
	.cout(connection[2])
	);

	assign cout[2] = connection[2];	
	
	fulladder u3(
	.a(a[3]),
	.b(b[3]),
	.cin(connection[2]),
	.s(s[3]),
	.cout(cout[3])
	);
	
endmodule

module sext(input signed [3:0] in, output signed [7:0] out);

    assign out = in;

endmodule

module option(a, b, out);
input [3:0] a,b;
output reg [7:0] out;
 
always @(*) begin

if (a[0] | a[1] | a[2] | a[3] | b[0] | b[1] | b[2] | b[3] == 1'b1)
begin
out[7:0] = 8'b00000001;
end

else
begin
out[7:0] = 8'b00000000;
end
end
endmodule


module option2(input [3:0] a, input[3:0] b, output reg [7:0] out);
always @(*) begin

if (a[0] & a[1] & a[2] & a[3] & b[0] & b[1] & b[2] & b[3] == 1'b1)
begin
out[7:0] = 8'b00000001;
end

else
begin
out[7:0] = 8'b00000000;
end
end
endmodule


module part3(A, B, Function, ALUout);

input [3:0] A, B;
input [2:0] Function;
output reg [7:0] ALUout;

wire [7:0] output1, output2, output3, output4;
ripple v1(
								.a(A[3:0]),
								.b(B[3:0]),
								.cin(1'b0),
								.s(output1[3:0]),
								.cout(output1[7:4])
								);

sext v2(
								.in(B[3:0]),
								.out(output2[7:0])
								);
option v3(.a(A[3:0]), .b(B[3:0]), .out(output3[7:0]));
option2 v4(.a(A[3:0]), .b(B[3:0]), .out(output4[7:0]));



always @ (*)
begin
	case(Function[2:0])
	3'b000: ALUout[7:0] = output1[7:0];
	3'b001: ALUout[7:0] = {A+B};
	3'b010: ALUout[7:0] = output2[7:0];
	3'b011: ALUout[7:0] = output3[7:0];
	3'b100: ALUout[7:0] = output4[7:0];
	3'b101: ALUout[7:0] = {A[3:0],B[3:0]};
	default: ALUout[7:0] = 8'b00000000;
	endcase
end
endmodule

