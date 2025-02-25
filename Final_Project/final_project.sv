//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------

//NEED TO INSTANTIATE 2 PLAYER FROGGER
//KEYCODE MUST BE 32-BITS NOW.

module final_project( input               CLOCK_50,
							 input        [3:0]  KEY,          //bit 0 is set up as Reset
							 output logic [6:0]  HEX0, HEX1,
							 // VGA Interface 
							 output logic [7:0]  VGA_R,        //VGA Red
														VGA_G,        //VGA Green
														VGA_B,        //VGA Blue
							 output logic        VGA_CLK,      //VGA Clock
														VGA_SYNC_N,   //VGA Sync signal
														VGA_BLANK_N,  //VGA Blank signal
														VGA_VS,       //VGA virtical sync signal
														VGA_HS,       //VGA horizontal sync signal
							 // CY7C67200 Interface
							 inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
							 output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
							 output logic        OTG_CS_N,     //CY7C67200 Chip Select
														OTG_RD_N,     //CY7C67200 Write
														OTG_WR_N,     //CY7C67200 Read
														OTG_RST_N,    //CY7C67200 Reset
							 input               OTG_INT,      //CY7C67200 Interrupt
							 // SDRAM Interface for Nios II Software
							 output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
							 inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
							 output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
							 output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
							 output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
														DRAM_CAS_N,   //SDRAM Column Address Strobe
														DRAM_CKE,     //SDRAM Clock Enable
														DRAM_WE_N,    //SDRAM Write Enable
														DRAM_CS_N,    //SDRAM Chip Select
														DRAM_CLK      //SDRAM Clock
							 	 );
    
    logic Reset_h, one_player, two_player, Clk;
    logic [31:0] keycode;
	 logic [9:0] sprite_x, sprite_y;
	 logic [18:0] SRAM_addr;
	 logic [3:0] data_Out;
	 logic [7:0] RR, GG, BB;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  one_player <= ~(KEY[1]);		 // Choose one player
		  two_player <= ~(KEY[2]);		 // Choose two player
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs;
	 logic [9:0] DrawX, DrawY;
	 logic is_frog, is_car, is_car_left;
	 logic is_frog1, is_frog2;
	 logic is_car1, is_car2, is_carleft1, is_carleft2; //TWO CARS ON SAME ROW.
	 logic collision; // if car and frog collide, turns on.
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),    
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_out_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w)
    );
  
     //Use PLL to generate the 25MHZ VGA_CLK. Do not modify it.
   //  vga_clk vga_clk_instance(
   //      .clk_clk(Clk),
   //      .reset_reset_n(1'b1),
   //      .altpll_0_c0_clk(VGA_CLK),
   //      .altpll_0_areset_conduit_export(),    
   //      .altpll_0_locked_conduit_export(),
   //      .altpll_0_phasedone_conduit_export()
   //  );
	
	logic frog_enable, frog_enable_1, frog_enable_2, frog_enable_in = 1'b1, frog_enable_in2 = 1'b0; //frog enablers
	assign frog_enable = frog_enable_in;
	assign frog_enable_1 = frog_enable_in2;
	assign frog_enable_2 = frog_enable_in2;
	parameter [9:0] Single_Frog_Start_X = 320; //Default 1-player frog start X position
	parameter [9:0] Single_Frog_Start_Y = 460; //Default 1-player frog start Y position
	parameter [9:0] one_frog_start_X = 160; //Default Player 1 frog X position.
	parameter [9:0] two_frog_start_X = 480; //Default player 2 frog X position
	
	always_comb
		begin
			if (one_player) //enable froggo 1
				begin
					frog_enable_in = 1'b1;
					frog_enable_in2 = 1'b0;
		//			frog_enable_1 = 1'b0;
		//			frog_enable_2 = 1'b0;
				end
			else if (two_player) //enable froggos 1 and 2
				begin
					frog_enable_in = 1'b0;
					frog_enable_in2 = 1'b1;
		//			frog_enable_1 = 1'b1;
		//			frog_enable_2 = 1'b1;
				end
			else
				begin
					frog_enable_in = frog_enable;
					frog_enable_in2 = frog_enable_1;
		//			frog_enable_1 = 1'b0;
		//			frog_enable_2 = 1'b0;
				end
		end
	
	
    always_ff @ (posedge Clk) begin
        if(Reset_h)
            VGA_CLK <= 1'b0;
		  else
            VGA_CLK <= ~VGA_CLK;
		  
    end
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.*, .Reset (Reset_h));
    
    // Which signal should be frame_clk?
	 modular_car #(.Car_Start_X(8), .Car_Start_Y(300), .Car_Speed(5)) car1 (.*, .Reset (Reset_h), .frame_clk(VGA_VS), .is_modular_car(is_car1)); //First car on same row.
	 modular_car #(.Car_Start_X(108), .Car_Start_Y(300), .Car_Speed(5)) car2 (.*, .Reset (Reset_h), .frame_clk(VGA_VS), .is_modular_car(is_car2)); //Second car on same row.

	 modular_carleft #(.Car_Start_X(8), .Car_Start_Y(320), .Car_Speed(5)) carleft1 (.*, .Reset (Reset_h), .frame_clk(VGA_VS), .is_modular_carleft(is_carleft1)); //Second car on same row.
	 modular_carleft #(.Car_Start_X(108), .Car_Start_Y(320), .Car_Speed(5)) carleft2 (.*, .Reset (Reset_h), .frame_clk(VGA_VS), .is_modular_carleft(is_carleft2)); //Second car on same row.

	 car car_instance(.*, .Reset (Reset_h), .frame_clk (VGA_VS));
	 car_left car_left_instance(.*, .Reset (Reset_h), .frame_clk (VGA_VS));
	 
	 //FROG INSTANTIATIONS
		/* 1P */		
		frog #(.Frog_Start_X(Single_Frog_Start_X), .Frog_Start_Y(Single_Frog_Start_Y)) player_one_1(.*, .Reset (Reset_h), .frame_clk (VGA_VS));
		/* 2P */
		frog #(.Frog_Start_X(one_frog_start_X), .Frog_Start_Y(Single_Frog_Start_Y)) player_one (.*, .Reset (Reset_h), .frog_enable(frog_enable_1), .frame_clk (VGA_VS), .is_frog(is_frog1));
		frog_two #(.Frog_Start_X(two_frog_start_X), .Frog_Start_Y(Single_Frog_Start_Y)) player_two (.*, .Reset (Reset_h), .frame_clk (VGA_VS), .is_frog(is_frog2));

    color_mapper color_instance(.*);
    
	 Address_Computing add_comp(.*);
	 	 
	 Palette_Making pm(.*);
	 
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
    

endmodule
