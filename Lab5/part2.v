module countup4(clk, resetn, load, en, d, q);
input clk, resetn, load, en;
input [3:0] d;
output reg [3:0] q;

always @ (posedge clk)
begin
if(resetn == 1)
	q <= 0;
else if (load == 1)
	q <= d;
else if(q == 4'b1111)
	q <= 0;
else if (en == 1'b1)
	q <= q+1;
end
endmodule


module countdown4_enable(clk, resetn, load, en, d, enable_1sec, q);
input clk, resetn, load, en;
input [10:0] d;
output reg [10:0] q;
output enable_1sec;

always @ (posedge clk) begin
if (resetn == 1)
	q <= 0;
else if (load == 1)
	q <= d;
else if (q == 11'b00000000000)
	q <= d;
else
	q <= q-1;

end

assign enable_1sec = (q == 11'b00000000000)? 1'b1:1'b0;

endmodule



module rateDivider1(clk, reset, enable, q);
input clk, reset;
output reg [10:0] q;
output enable;
parameter dimmer1 = 11'b00111110011;

assign q = dimmer1;

always @ (posedge clk) begin
if (reset == 1)
	q <= 11'b00000000000;
else if (q == 11'b00000000000)
	q <= dimmer1;
else	
	q <= q-1;
end

assign enable = (q == 11'b00000000000)? 1'b1:1'b0;

endmodule

//////////////////////////////////////////////////////////////////////

module rateDivider2(clk, reset, enable, q);
input clk, reset;
output reg [10:0] q;
output enable;
parameter dimmer2 = 11'b01111100111;

assign q = dimmer2;

always @ (posedge clk) begin
if (reset == 1)
	q <= 11'b00000000000;
else if (q == 11'b00000000000)
	q <= dimmer2;
else	
	q <= q-1;
end

assign enable = (q == 11'b00000000000)? 1'b1:1'b0;

endmodule

//////////////////////////////////////////////////////////////////////

module rateDivider3(clk, reset, enable, q);
input clk, reset;
output reg [10:0] q;
output enable;
parameter dimmer3 = 11'b11111001111;

assign q = dimmer3;

always @ (posedge clk) begin
if (reset == 1)
	q <= 11'b00000000000;
else if (q == 11'b00000000000)
	q <= dimmer3;
else	
	q <= q-1;
end

assign enable = (q == 11'b00000000000)? 1'b1:1'b0;

endmodule

///////////////////////////////////////////////////////////////////////

module rateDivider4(clk, reset, enable, q);
input clk, reset;
output reg [10:0] q;
output enable;
parameter dimmer4 = 11'b00000000000;

assign q = dimmer4;

always @ (posedge clk) begin
if (reset == 1)
	q <= 11'b00000000000;
else if (q == 11'b00000000000)
	q <= dimmer4;
else	
	q <= q-1;
end

assign enable = (q == 11'b00000000000)? 1'b1:1'b0;

endmodule



module part2(ClockIn, Reset, Speed, CounterValue);
input ClockIn, Reset;
input [1:0] Speed;
output reg [3:0] CounterValue;

wire a1;
wire [10:0] a2;
wire b1;
wire [10:0] b2;
wire c1;
wire [10:0] c2;
wire d1;
wire [10:0] d2;

rateDivider1 a(ClockIn, Reset, a1, a2);
rateDivider2 b(ClockIn, Reset, b1, b2);
rateDivider3 c(ClockIn, Reset, c1, c2);
rateDivider4 d(ClockIn, Reset, d1, d2);


//countdown4_enable u1(ClockIn,Reset,1'b1,1'b1,11'b00111110011,connection1,connection2); //499
//countdown4_enable u5(ClockIn, Reset, 1'b0, 1'b1,connection2, a1, a2);

//countdown4_enable u2(ClockIn,Reset,1'b1,1'b1,11'b01111100111,connection3,connection4); //999
//countdown4_enable u6(ClockIn, Reset, 1'b0, 1'b1,connection4, b1, b2);


//countdown4_enable u3(ClockIn,Reset,1'b1,1'b1,11'b11111001111,connection5,connection6); //1999
//countdown4_enable u7(ClockIn, Reset, 1'b0, 1'b1,connection6, c1, c2);

//countdown4_enable u4(ClockIn,Reset,1'b1,1'b1,11'b00000000000,connection7,connection8); //0
//countdown4_enable u8(ClockIn, Reset, 1'b0, 1'b1,connection8, d1, d2);

wire [3:0] signala;
wire [3:0] signalb;
wire [3:0] signalc;
wire [3:0] signald;

countup4 v1(ClockIn,Reset,1'b0,d1,4'b000,signala);
countup4 v2(ClockIn,Reset,1'b0,a1,4'b000,signalb);
countup4 v3(ClockIn,Reset,1'b0,b1,4'b000,signalc);
countup4 v4(ClockIn,Reset,1'b0,c1,4'b000,signald);


always @ (Speed) begin
	case(Speed)
	2'b00: CounterValue = signala;
	2'b01: CounterValue = signalb;
	2'b10: CounterValue = signalc;
	2'b11: CounterValue = signald;
	
	endcase
	end
	endmodule
	