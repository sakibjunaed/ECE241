//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//Sakib Junaed
//1007170589
//28-11-2021

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;//
   input wire [6:0] iXY_Coord;//
   input wire 	    iClock;//
   output wire [7:0] oX;    //     // VGA pixel coordinates
   output wire [6:0] oY;//
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable
   
	wire ld_x, ld_y, ld_c, blackEn;
	
	datapath D0(
		.clk(iClock),
		.resetn(iResetn),
		.ld_x(ld_x),
		.ld_y(ld_y),
		.ld_c(ld_c),
		.x(oX),
		.y(oY),
		.blackEn(iBlack),
		.data_in(iXY_Coord),
		.colour(oColour),
		.color_in(iColour)
	);
	
	control C0(
		.clk(iClock),
		.resetn(iResetn),
		.ld_x(ld_x),
		.ld_y(ld_y),
		.draw(iPlotBox),
		.ld(iLoadX),
		.writeEn(oPlot),
		.ld_c(ld_c),
		.blackEn(blackEn)
	);
   
endmodule 

module datapath(
    input clk,
    input resetn,
    input [6:0] data_in,
    input ld_x, ld_y, ld_c,
	input [2:0] color_in,
	input blackEn,
    output [2:0] colour,
	output [7:0] x,
	output [7:0] y
    );
    
	wire y_en;
	reg [7:0] x_old;
	reg [6:0] y_old;
	reg [2:0] color;
    reg [7:0] x_counter, y_counter;
    // Registers x, y, color
    always@(posedge clk) begin
        if(!resetn) begin
            x_old <= 8'b0;
			y_old <= 7'b0;
			color <= 3'b0; // black color
        end
		else if (blackEn) begin
		    x_old <= 8'b0;
			y_old <= 7'b0;
			color <= 3'b0;
		end
        else begin
            if(ld_x)
                x_old <= {1'b0, data_in};
            if(ld_y)
                y_old <= data_in;
            if(ld_c)
                color <= color_in;
        end
    end
	
	
 
    always @(posedge clk) begin
		if (!resetn)
			x_counter <= 2'b00;
		else if(blackEn) begin
			if(x_counter == 8'b10100000)
				x_counter <= 8'b0;
			else
				x_counter <= x_counter + 1'b1;
			end
		else begin
			if (x_counter == 2'b11)
				x_counter <= 2'b00;
			else
				x_counter <= x_counter + 1'b1;
		end
	end
	
	assign y_en = (x_counter == 2'b11) ? 1 : 0;

    always @(posedge clk) begin
		if (!resetn)
			y_counter <= 2'b00;
		else if (y_en && blackEn) begin
			if(y_counter != 7'b1111000)
				y_counter <= y_counter + 1'b1;
			else
				y_counter <= 7'b0;
			end
		else if (y_en) begin
			if (y_counter != 2'b11)
				y_counter <= y_counter + 1'b1;
			else 
				y_counter <= 2'b00;
		end
	end
	
	assign x = x_old + x_counter;
	assign y = y_old + y_counter;
	assign colour = color;
    
endmodule

module control(
    input clk,
    input resetn,
	 output reg writeEn,
	input ld,
    input draw,
	input black,
	output reg  ld_x, ld_y, ld_c, blackEn
    );

    reg [2:0] current_state, next_state; 
    
    localparam  S_LOAD_x        = 3'd0,
                S_LOAD_x_wait   = 3'd1,
                S_LOAD_y        = 3'd2,
                S_LOAD_y_wait   = 3'd3,
                Drawing			= 3'd4,
				S_Black_wait    = 3'd5,
				S_Black			= 3'd6;
    
    
    always@(*)
    begin: state_table 
            case (current_state)
                
				S_LOAD_x: 
				if(blackEn)
					next_state = S_Black_wait;
				else 
					next_state = ld ? S_LOAD_x_wait : S_LOAD_x;
				S_LOAD_x_wait: 
				if(blackEn)
					next_state = S_Black_wait;
				else
					next_state = ld ? S_LOAD_x_wait : S_LOAD_y;
				S_LOAD_y: 
				if(blackEn)
					next_state = S_Black_wait;
				else
					next_state = draw ? S_LOAD_y_wait : S_LOAD_y;
				S_LOAD_y_wait: 
				if(blackEn)
					next_state = S_Black_wait;
				else
					next_state = draw ? S_LOAD_y_wait : Drawing;
				Drawing: 
				if(blackEn)
					next_state = S_Black_wait;
				else
					next_state = ld ? S_LOAD_x : Drawing;
				S_Black_wait: next_state = black ? S_Black_wait : S_Black;
				S_Black: next_state = ld ? S_LOAD_x : S_Black;
				
        endcase
    end 
   

    
    always @(*)
    begin: enable_signals
        ld_x = 1'b0;
        ld_y = 1'b0;
		  ld_c = 1'b0;
		  blackEn = 1'b0;
		writeEn = 1'b0;
		
        case (current_state)
            S_LOAD_x: begin
                ld_x=1'b1;
				ld_c = 1'b0;
				end
            S_LOAD_x_wait: begin
                ld_x=1'b1;
				ld_c = 1'b0;
                end
            S_LOAD_y: begin
                ld_y=1'b1;
				ld_c = 1'b0;
                end
            S_LOAD_y_wait: begin
                ld_y=1'b1;
				ld_c = 1'b0;
                end
            Drawing: begin
				ld_c = 1'b1;
				writeEn = 1'b1;
				end
			S_Black: begin
				blackEn = 1'b1;
				end
			S_Black_wait: begin
				blackEn = 1'b1;
				end
		endcase
    end 
   
    
    always@(posedge clk)
    begin: state_FFs
        if(!resetn) begin
            current_state <= S_LOAD_x;
		end
        else
            current_state <= next_state;
    end 
endmodule