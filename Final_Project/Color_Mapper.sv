//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input              is_frog,            // Whether current pixel belongs to frog 
                       input					is_frog1, is_frog2, // <-- two player froggos
							  input					is_car,             //   or background (computed in frog.sv)
							  input					is_car_left,
							  input					is_car1, is_car2,
							  input					is_carleft1, is_carleft2,
							  input logic [7:0] RR, BB, GG,
                       input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    // Assign color based on is_frog signal
    always_comb
    begin
		 if ( ( (is_frog == 1'b1) || (is_frog1 == 1'b1) || (is_frog2 == 1'b1) ) && ( (is_car == 1'b1) || //collisions
																											(is_car1 == 1'b1)  || 
																											(is_car2 == 1'b1)  ||
																											(is_car_left == 1'b1) ||
																											(is_carleft1 == 1'b1) ||
																											(is_carleft2 == 1'b1) ) )
			begin
				Red = 255;
				Green = 0;
				Blue = 0;
			end
       else if (is_frog == 1'b1)
			begin
            // White frog
            Red = RR;
            Green = GG;
            Blue = BB;
			end
			
		 else if (is_frog1 == 1'b1)
			begin
            // White frog
            Red = RR;
            Green = GG;
            Blue = BB;
			end
		  
		 else if (is_frog2 == 1'b1)
			begin
            // White frog
            Red = RR;
            Green = GG;
            Blue = BB;
			end
		  
		  else if (is_car == 1'b1)
			begin
				Red = RR;
				Green = GG;
				Blue = BB;
			end
			
		  else if (is_car1 == 1'b1)
			begin
				Red = RR;
				Green = GG;
				Blue = BB;
			end
			
		 else if (is_car2 == 1'b1)
			begin
				Red = RR;
				Green = GG;
				Blue = BB;
			end
			
			else if (is_car_left == 1'b1)
			begin
            // White frog
            Red = RR;
            Green = GG;
            Blue = BB;
			end
			
			else if (is_carleft1 == 1'b1)
			begin
            // White frog
            Red = RR;
            Green = GG;
            Blue = BB;
			end
		
			else if (is_carleft2 == 1'b1)
			begin
            // White frog
            Red = RR;
            Green = GG;
            Blue = BB;
			end
		
        else 
			begin
            // Background with nice color gradient
            Red = 8'h3f; 
            Green = 8'h00;
            Blue = 8'h7f - {1'b0, DrawX[9:3]};
			end
    end 
    
endmodule
