//-------------------------------------------------------------------------
//    car.sv 
//		Car movement
//		ECE 385 Fall 2017
//		For Final Project, Carger Game
//		Eric Mysliwiec & Matthew Grossfeld
//		emysliw2, grossfe2
//-------------------------------------------------------------------------


//REMEMBER TO CHANGE THE KEYCODE TO 32-BITS

module  modular_car #(Car_Start_X=10, Car_Start_Y=10, Car_Speed=10)
						( input     Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
				//	input [9:0]   Y_Grid,	    		 // Keycode for determining where Car moves.
               output logic  is_modular_car             // Whether current pixel belongs to Car or background
              );
    
    parameter [9:0] Car_X_Start=Car_Start_X;  // Start position on the X axis
    parameter [9:0] Car_Y_Start=Car_Start_Y;  // Start position on the Y axis
    parameter [9:0] Car_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Car_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Car_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Car_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Car_X_Step=Car_Speed;      // Step size on the X axis
    parameter [9:0] Car_Y_Step=0;      // Step size on the Y axis
    parameter [9:0] Car_Size=8;        // Car size
    
    logic [9:0] Car_X_Pos = Car_X_Start, Car_X_Motion = Car_X_Step, Car_Y_Pos = Car_Y_Start, Car_Y_Motion;
    logic [9:0] Car_X_Pos_in, Car_X_Motion_in, Car_Y_Pos_in, Car_Y_Motion_in;

    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Car_X_Pos;
    assign DistY = DrawY - Car_Y_Pos;
    assign Size = Car_Size;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update Car position and motion
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Car_X_Pos <= Car_X_Start;
            Car_Y_Pos <= Car_Y_Start;
            Car_X_Motion <= Car_X_Step;
            Car_Y_Motion <= 10'd0;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Car_X_Pos <= Car_X_Pos_in;
            Car_Y_Pos <= Car_Y_Pos_in;
            Car_X_Motion <= Car_X_Motion_in;
            Car_Y_Motion <= Car_Y_Motion_in;
        end
		  
		  if (Car_X_Pos + Car_Size >= Car_X_Max) //if Car is at right edge, go back to leftmost
			Car_X_Pos <= Car_X_Min - Car_Size;
        // By default, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin
		  //Car_X_Pos = Car_X_Start;
        //Car_Y_Pos = Car_Y_Start;
        // Update the Car's position with its motion
        Car_X_Pos_in = Car_X_Pos + Car_X_Motion;
        Car_Y_Pos_in = Car_Y_Pos + Car_Y_Motion;
    
        // By default, keep motion unchanged
        Car_X_Motion_in = Car_X_Motion;
        Car_Y_Motion_in = 10'd0;

        
        // Compute whether the pixel corresponds to Car or background
        if (( DistX*DistX + DistY*DistY) <= (Size * Size) ) //((DistX < 18) && (DistX > 18)) || ((DistY < 18) && (DistY > 18))) 
            is_modular_car = 1'b1;
        else
            is_modular_car = 1'b0;
        
        /* The Car's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
        
    end
    
endmodule

module  modular_carleft #(Car_Start_X=10, Car_Start_Y=10, Car_Speed=10)
						( input     Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
				//	input [9:0]   Y_Grid,	    		 // Keycode for determining where Car moves.
               output logic  is_modular_carleft             // Whether current pixel belongs to Car or background
              );
    
    parameter [9:0] Car_X_Start=Car_Start_X;  // Start position on the X axis
    parameter [9:0] Car_Y_Start=Car_Start_Y;  // Start position on the Y axis
    parameter [9:0] Car_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Car_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Car_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Car_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Car_X_Step=Car_Speed;      // Step size on the X axis
    parameter [9:0] Car_Y_Step=0;      // Step size on the Y axis
    parameter [9:0] Car_Size=8;        // Car size
    
    logic [9:0] Car_X_Pos = Car_X_Start, Car_X_Motion = ((~Car_X_Step)+1'b1), Car_Y_Pos = Car_Y_Start, Car_Y_Motion;
    logic [9:0] Car_X_Pos_in, Car_X_Motion_in, Car_Y_Pos_in, Car_Y_Motion_in;

    
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Car_X_Pos;
    assign DistY = DrawY - Car_Y_Pos;
    assign Size = Car_Size;
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed;
    logic frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
    end
    assign frame_clk_rising_edge = (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    // Update Car position and motion
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Car_X_Pos <= Car_X_Start;
            Car_Y_Pos <= Car_Y_Start;
            Car_X_Motion <= (~Car_X_Step)+1'b1;
            Car_Y_Motion <= 10'd0;
        end
        else if (frame_clk_rising_edge)        // Update only at rising edge of frame clock
        begin
            Car_X_Pos <= Car_X_Pos_in;
            Car_Y_Pos <= Car_Y_Pos_in;
            Car_X_Motion <= Car_X_Motion_in;
            Car_Y_Motion <= Car_Y_Motion_in;
        end
		  
		   if (Car_X_Pos - Car_Size <= Car_X_Min) //if Car is at right edge, go back to leftmost
			Car_X_Pos <= Car_X_Max - Car_Size;
        // By default, keep the register values.
    end
    
    // You need to modify always_comb block.
    always_comb
    begin
		  //Car_X_Pos = Car_X_Start;
        //Car_Y_Pos = Car_Y_Start;
        // Update the Car's position with its motion
        Car_X_Pos_in = Car_X_Pos + Car_X_Motion;
        Car_Y_Pos_in = Car_Y_Pos + Car_Y_Motion;
    
        // By default, keep motion unchanged
        Car_X_Motion_in = Car_X_Motion;
        Car_Y_Motion_in = 10'd0;

        
        // Compute whether the pixel corresponds to Car or background
        if (( DistX*DistX + DistY*DistY) <= (Size * Size) ) //((DistX < 18) && (DistX > 18)) || ((DistY < 18) && (DistY > 18))) 
            is_modular_carleft = 1'b1;
        else
            is_modular_carleft = 1'b0;
        
        /* The Car's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
        
    end
    
endmodule
