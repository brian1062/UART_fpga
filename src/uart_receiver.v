module uart_receiver
#(
    parameter     DBIT    =    8,
    parameter     DVSR    =  326, //163
    parameter    SB_TICK  =   16,
    parameter    FIFO_W   =    2,
    parameter     NB_OP   =    6  //! Number of bits of the operation
)
(
    input                clock,
    input                 RsRx,
    input              i_reset,
    output [DBIT-1:0]    o_led
);

wire                        tick;
wire                rx_done_tick;
wire [DBIT-1:0]      rx_data_out;
wire                    rx_empty;
wire [DBIT-1:0]           r_data;
     
reg                      rd_uart;

reg  [DBIT-1:0]          reg_led;

//ALU
reg signed  [DBIT-1  : 0]             a_data;  //! First operand
reg signed  [DBIT-1  : 0]             b_data;  //! Second operand
reg signed  [NB_OP-1  : 0]          operation;  //! Operation code

//vio logic  
wire     [1:0]            sw_vio; //0:VIO/HW , 1:ResetVio
assign reset = (sw_vio[0]) ? sw_vio[1] : i_reset;
//--------------------------------------------

reg      [1:0]         rx_status;

always @(posedge clock) begin
    if(reset)begin
        //reg_led <= 8'b00000000;
        rd_uart   <=      1'b0;
        rx_status <=     2'b00;
        a_data    <=   { DBIT{1'b0}};
        b_data    <=   { DBIT{1'b0}};
        operation <=   {NB_OP{1'b0}};
    end
    if(~rx_empty && ~rd_uart)begin
        if(rx_status==2'b00)begin
            operation <= r_data[NB_OP-1  : 0];
        end
        if(rx_status==2'b01)begin
            a_data    <= r_data;
        end
        if (rx_status==2'b10) begin
            b_data    <= r_data;
        end
        rx_status <= (rx_status==2'b10) ? 2'b00 : rx_status + 1'b1;
        //reg_led <= r_data;
        rd_uart <= 1'b1;
    end
    else begin
        rd_uart <= 1'b0;
    end
end

//assign o_led = reg_led;


baud_rate_gen 
#( 
    .NB(9),  // number of bits in counter 
    .M (DVSR)   // mod-M 
)
  u_baud_rate_gen
    ( 
    .clk     (clock  ),
    .reset   (reset), 
    .max_tick(tick   ), 
    .q       (       )  
    );

fifo
#(
    .B(DBIT     ), //number bits in a word
    .W(FIFO_W   )  //number of address bits
)
  u_fifo_rx
(
    .clk   (clock       ),
    .reset (reset     ),
    .rd    (rd_uart     ),
    .wr    (rx_done_tick),
    .w_data(rx_data_out ),
    .empty (rx_empty    ),
    .full  (            ),
    .r_data(r_data      )
);

uart_rx
#(
    .DBIT    (DBIT   ),  // # data bit 
    .SB_TICK (SB_TICK)   // # ticks for stop bits
)
  u_uart_rx
    (
    .clk         (clock         ), 
    .reset       (reset         ),
    .rx          (RsRx          ), 
    .s_tick      (tick          ),
    .rx_done_tick(rx_done_tick  ),
    .dout        (rx_data_out   )
    );

ALU
#(
    .NB_OP (NB_OP),  //! Number of bits of the operation
    .NB_AB (DBIT )   //! Number of bits of the operands

)
   u_ALU
    (
        .i_operation(operation      ), //! Operation code
        .i_Adata    (a_data         ), //! First operand   
        .i_Bdata    (b_data         ), //! Second operand
        .o_result   (o_led          )  //! Result of the operation
    );    
    
vio
    u_vio
   (.clk_0       (clock),
    .probe_in0_0 (o_led),
    .probe_out0_0(sw_vio)
    ); 
 
endmodule