//-------------------------------------------------------------------------
//    Frog.sv 
//		1 Player Frogger
//		Controls for Frog/Player 1                                                           	
//		ECE 385 Fall 2017
//		For Final Project, Frogger Game
//		Eric Mysliwiec & Matthew Grossfeld
//		emysliw2, grossfe2
//-------------------------------------------------------------------------


//REMEMBER TO CHANGE THE KEYCODE TO 32-BITS

module  frog #(Frog_Start_X=320, Frog_Start_Y=420) ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [31:0] keycode,			    // Keycode for determining where frog moves.
					input			  frog_enable,			 //enable frog 1
               output logic  is_frog             // Whether current pixel belongs to frog or background
              );
    
    parameter [9:0] Frog_X_Start=Frog_Start_X;  // Start position on the X axis
    parameter [9:0] Frog_Y_Start=Frog_Start_Y;  // Start position on the Y axis
    parameter [9:0] Frog_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Frog_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Frog_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Frog_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Frog_X_Step=3;      // Step size on the X axis
    parameter [9:0] Frog_Y_Step=3;      // Step size on the Y axis
    parameter [9:0] Frog_Size=10;        // Frog size
    
    logic [9:0] Frog_X_Pos = Frog_X_Start, Frog_X_Motion, Frog_Y_Pos = Frog_Y_Start, Frog_Y_Motion;
    logic [9:0] Frog_X_Pos_in, Frog_X_Motion_in, Frog_Y_Pos_in, Frog_Y_Motion_in;

	 logic w_on, a_on, s_on, d_on; //Player 1 keys
	 logic up_on, left_on, down_on, right_on; //Player 2 keys
    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Frog_X_Pos;
    assign DistY = DrawY - Frog_Y_Pos;
    assign Size = Frog_Size;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update frog position and motion
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Frog_X_Pos <= Frog_X_Start;
            Frog_Y_Pos <= Frog_Y_Start;
            Frog_X_Motion <= 10'd0;
            Frog_Y_Motion <= 10'd0;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Frog_X_Pos <= Frog_X_Pos_in;
            Frog_Y_Pos <= Frog_Y_Pos_in;
            Frog_X_Motion <= Frog_X_Motion_in;
            Frog_Y_Motion <= Frog_Y_Motion_in;
        end
        // By defualt, keep the register values.
		  
    end
    
    // You need to modify always_comb block.
    
	 keycode_reader keycode_read (.*, .w_on(w_on) , .a_on(a_on), .s_on(s_on), .d_on(d_on), 
												.up_on(up_on), .left_on(left_on), .down_on(down_on), .right_on(right_on));
	 
	 always_comb
    begin
		  //Frog_X_Pos = Frog_X_Start;
        //Frog_Y_Pos = Frog_Y_Start;
        // Update the frog's position with its motion
        Frog_X_Pos_in = Frog_X_Pos + Frog_X_Motion;
        Frog_Y_Pos_in = Frog_Y_Pos + Frog_Y_Motion;
    
        // By default, keep motion unchanged
        Frog_X_Motion_in = Frog_X_Motion;
        Frog_Y_Motion_in = Frog_Y_Motion;
 
        // Be careful when using comparators with "logic" datatype because compiler treats 
        //   both sides of the operator UNSIGNED numbers. (unless with further type casting)
        // e.g. Frog_Y_Pos - Frog_Size <= Frog_Y_Min 
        // If Frog_Y_Pos is 0, then Frog_Y_Pos - Frog_Size will not be -4, but rather a large positive number.
		  
		  
			if (w_on) //W pressed (up)
				begin
					Frog_X_Motion_in = 10'd0;
					if( Frog_Y_Pos + Frog_Size >= Frog_Y_Max )  // Frog is at the bottom edge, BOUNCE!
						Frog_Y_Motion_in = (~(Frog_Y_Step) + 1'b1);  // 2's complement.  
					else if ( Frog_Y_Pos <= Frog_Y_Min + Frog_Size )  // Frog is at the top edge, BOUNCE!
						Frog_Y_Motion_in = Frog_Y_Step;
					else
						Frog_Y_Motion_in = (~Frog_Y_Step) + 1'b1;
				end
				
			else if (s_on) //S pressed (down)
				begin
					Frog_X_Motion_in = 10'd0;
					if( Frog_Y_Pos + Frog_Size >= Frog_Y_Max )  // Frog is at the bottom edge, BOUNCE!
						Frog_Y_Motion_in = (~(Frog_Y_Step) + 1'b1);  // 2's complement.  
					else if ( Frog_Y_Pos <= Frog_Y_Min + Frog_Size )  // Frog is at the top edge, BOUNCE!
						Frog_Y_Motion_in = Frog_Y_Step;
					else 
						Frog_Y_Motion_in = Frog_Y_Step;
				end
				
			else if (a_on) //A pressed (left)
				begin
					Frog_Y_Motion_in = 10'd0;
					if( Frog_X_Pos + Frog_Size >= Frog_X_Max )  // Frog is at the bottom edge, BOUNCE!
						Frog_X_Motion_in = (~(Frog_X_Step) + 1'b1);  // 2's complement.  
					else if ( Frog_X_Pos <= Frog_X_Min + Frog_Size )  // Frog is at the top edge, BOUNCE!
						Frog_X_Motion_in = Frog_X_Step;
					else 
						Frog_X_Motion_in = (~Frog_X_Step) + 1'b1;
				end
				
			else if (d_on) //D pressed (right)
				begin
					Frog_Y_Motion_in = 10'd0;
					if( Frog_X_Pos + Frog_Size >= Frog_X_Max )  // Frog is at the bottom edge, BOUNCE!
						Frog_X_Motion_in = (~(Frog_X_Step) + 1'b1);  // 2's complement.  
					else if ( Frog_X_Pos <= Frog_X_Min + Frog_Size )  // Frog is at the top edge, BOUNCE!
						Frog_X_Motion_in = Frog_X_Step;
					else 
						Frog_X_Motion_in = Frog_X_Step;
				end
				
			else
				begin
					Frog_X_Motion_in = 10'd0;
					Frog_Y_Motion_in = 10'd0;
				end
			
        
        // Compute whether the pixel corresponds to frog or background
        if ( (( DistX*DistX + DistY*DistY) <= (Size * Size)) && frog_enable == 1'b1 ) //((DistX < 18) && (DistX > 18)) || ((DistY < 18) && (DistY > 18))) 
            is_frog = 1'b1;
        else
            is_frog = 1'b0;
        
        /* The frog's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
        
    end
    
endmodule
