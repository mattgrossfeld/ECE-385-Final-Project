module keycode_reader(
//Up arrow = 8'h52
//Down = 8'h51
//Left = 8'50
//Right = 8'4f
			input [31:0] keycode,
			output logic w_on, a_on, s_on, d_on, //Player 1
			output logic up_on, left_on, down_on, right_on); //Player 2

assign w_on = (keycode[31:24] == 8'h1A |
					keycode[23:16] == 8'h1A |
					keycode[15:8] == 8'h1A  |
					keycode[7:0] == 8'h1A);

assign a_on = (keycode[31:24] == 8'h04 |
					keycode[23:16] == 8'h04 |
					keycode[15:8] ==  8'h04 |
					keycode[7:0] ==   8'h04);

assign s_on = (keycode[31:24] == 8'h16 |
					keycode[23:16] == 8'h16 |
					keycode[15:8] == 	8'h16 |
					keycode[7:0] == 	8'h16);

assign d_on = (keycode[31:24] == 8'h07 |
					keycode[23:16] == 8'h07 |
					keycode[15:8] == 	8'h07 |
					keycode[7:0] == 	8'h07);

assign up_on = (keycode[31:24] == 8'h52 |
					 keycode[23:16] == 8'h52 |
					 keycode[15:8] ==  8'h52 |
					 keycode[7:0] == 	 8'h52);

assign left_on = (keycode[31:24] == 8'h50 |
					   keycode[23:16] == 8'h50 |
					   keycode[15:8] ==  8'h50 |
					   keycode[7:0] == 	8'h50);

assign down_on = (keycode[31:24] == 8'h51 |
					   keycode[23:16] == 8'h51 |
					   keycode[15:8] ==  8'h51 |
					   keycode[7:0] == 	8'h51);

assign right_on = (keycode[31:24] ==  8'h4F |
					     keycode[23:16] == 8'h4F |
					     keycode[15:8] ==  8'h4F |
					     keycode[7:0] ==   8'h4F);

endmodule