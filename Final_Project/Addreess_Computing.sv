module Address_Computing(input logic Clk,
                         input logic [9:0] DrawX,DrawY,
                         //output logic [9:0] sprite_x, sprite_y,
								 output logic [18:0] SRAM_addr);

//...

logic [9:0] sprite_x, sprite_y;

  always_comb
  begin: sprite_address_arbitor
//  
//    case(which_sprite_to_Draw)
  	
//    Draw_BIRD:
//    begin
//      sprite_x = DrawX+30+18;
//      sprite_y = DrawY-490+18;
//      end
//	
//...
	
  begin
        SRAM_addr = (DrawX + (DrawY << 9));//(sprite_x + 12 + ((sprite_y+472) << 9));
  end 
 end
//...  

endmodule
