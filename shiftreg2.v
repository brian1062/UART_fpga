module shiftreg2
  #(
    parameter N_LEDS     = 4 ,
    parameter NB_SW      = 1       
    )
   (
    output [N_LEDS - 1 : 0] o_led_rgb ,
    
    input                   i_sw      ,
    input                   i_valid   , //Flag del contador
    input                   i_reset   ,
    input                   clock
    );


   // Vars
   reg  [N_LEDS   - 1 : 0]  shiftregister2 ;
   reg  [1 : 0]  shiftreg1 ;
   reg  [1 : 0]  shiftreg2 ;

   always@(posedge clock or posedge i_reset) begin
      //Si se resetea, se inicializa shiftregister en 4'b1001
      if (i_reset) begin
         shiftregister2 <= {1'b1, {N_LEDS-2{1'b0}}, 1'b1}; //1001
      end
      
      //Se detecta flag del contador
      else if(i_valid) 
      begin
        //shiftreg1 <= {shiftregister2[0], shiftregister2[(N_LEDS/2)-1:1]};
        //shiftreg2 <= {shiftregister2[(N_LEDS/2)-1:1], shiftregister2[0]};
        shiftreg1 <= {shiftregister2[0], shiftregister2[1:1]};
        shiftreg2 <= {shiftregister2[1:1], shiftregister2[0]};

        if (i_sw)
          shiftregister2 <= {shiftreg2,shiftreg1};
        else      
          shiftregister2 <= {shiftreg1,shiftreg2};  

      end
      //Se no hay flag del contador
      else begin
         shiftregister2 <= shiftregister2;
      end
   end


    assign o_led_rgb = shiftregister2;

endmodule 

