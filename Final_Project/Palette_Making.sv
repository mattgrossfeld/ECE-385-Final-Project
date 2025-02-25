module Palette_Making(input logic Clk,
							 input logic [9:0] sprite_x,
							 input logic [3:0] data_Out,
							 output logic [7:0] RR, GG, BB);

	//determine whether to use upper byte or lower byte
	//based on whether we're to draw an odd indexed pixel
	//or even indexed pixel
	logic [4:0] colordata;
	logic [7:0] sprite_r, sprite_g, sprite_b;
	assign colordata = data_Out;
	assign RR = sprite_r;
	assign GG = sprite_g;
	assign BB = sprite_b;
	//color palette
	always_comb begin
			unique case(colordata)
	
						8'h00:begin//White
								sprite_r = 8'd255;
								sprite_g = 8'd255;
								sprite_b = 8'd255;
								end
								
						8'h01:begin//Yellow
								sprite_r = 8'd255;
								sprite_g = 8'd239;
								sprite_b = 8'd12;
								end
								
						8'h02:begin//Black
								sprite_r = 8'd98;
								sprite_g = 8'd187;
								sprite_b = 8'd249;
								end
								
						8'h03:begin//Green
								sprite_r = 8'd51;
								sprite_g = 8'd204;
								sprite_b = 8'd0;
								end
								
						8'h04:begin//Purple
								sprite_r = 8'd153;
								sprite_g = 8'd0;
								sprite_b = 8'd204;
								end
								
						8'h05:begin//Brown
								sprite_r = 8'd204;
								sprite_g = 8'd102;
								sprite_b = 8'd51;
								end
								
						8'h06:begin//Red
								sprite_r = 8'd255;
								sprite_g = 8'd000;
								sprite_b = 8'd000;
								end
								
						8'h07:begin//Grey-Purple
								sprite_r = 8'd96;
								sprite_g = 8'd70;
								sprite_b = 8'd87;
								end
								
						8'h08:begin//Cyan
								sprite_r = 8'd0;
								sprite_g = 8'd204;
								sprite_b = 8'd204;
								end
								
						8'h09:begin//Pink
								sprite_r = 8'd255;
								sprite_g = 8'd51;
								sprite_b = 8'd204;
								end
								
						8'h0a:begin//Blue-Purple
								sprite_r = 8'd108;
								sprite_g = 8'd0;
								sprite_b = 8'd204;
								end
								
						8'h0b:begin//Maroon
								sprite_r = 8'd204;
								sprite_g = 8'd0;
								sprite_b = 8'd51;
								end
								
						8'h0c:begin//Orange
								sprite_r = 8'd255;
								sprite_g = 8'd102;
								sprite_b = 8'd0;
								end
								
						8'h0d:begin//Blue
								sprite_r = 8'd51;
								sprite_g = 8'd153;
								sprite_b = 8'd204;
								end
								
			 endcase
		end
endmodule
