module tff(input clock, input t, input clear, output reg q);
	always @ (posedge clock)	
	begin
		if(clear == 0)
		begin
		q <= 0;
		end

		else
		begin

		if(t)
			q <= ~q;
		else
			q <= q;
		end
	end
endmodule

module part1(input Clock, input Enable, 
input Clear_b, output [7:0] CounterValue);

wire connection1, connection2, connection3, connection4, connection5, connection6, connection7, connection8, connection9, connection10, connection11, connection12, connection13, connection14, connection15, connection16;

tff u1 (.clock(Clock), .t(Enable), .q(connection1), .clear(Clear_b));

assign connection2 = connection1 & Enable;

tff u2(.clock(Clock), .t(connection2), .q(connection3),.clear(Clear_b));

assign connection4 = connection2 & connection3;

tff u3(.clock(Clock), .t(connection4), .q(connection5),.clear(Clear_b));

assign connection6 = connection4 & connection5;

tff u4(.clock(Clock), .t(connection6), .q(connection7),.clear(Clear_b));

assign connection8 = connection6 & connection7;

tff u5(.clock(Clock), .t(connection8), .q(connection9),.clear(Clear_b));

assign connection10 = connection8 & connection9;

tff u6(.clock(Clock), .t(connection10), .q(connection11),.clear(Clear_b));

assign connection12 = connection10 & connection11;

tff u7(.clock(Clock), .t(connection12), .q(connection13),.clear(Clear_b));

assign connection14 = connection12 & connection13;

tff u8(.clock(Clock), .t(connection14), .q(connection15),.clear(Clear_b));

assign connection16 = connection14 & connection15;

assign CounterValue[0] = connection1;
assign CounterValue[1] = connection3;
assign CounterValue[2] = connection5;
assign CounterValue[3] = connection7;
assign CounterValue[4] = connection9;
assign CounterValue[5] = connection11;
assign CounterValue[6] = connection13;
assign CounterValue[7] = connection15;

endmodule




