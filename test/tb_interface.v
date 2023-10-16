`timescale 1ns / 100ps
module tb_interface;

wire rx_interface   ;
wire tx_interface   ;

reg  [7:0]  data_to_interface   ;  //datos que vamos a transmitir
reg         wr_uart             ;  // escribir en la uart tx

reg         rd_uart             ;   
wire [7:0]  data_from_interface ;  //datos que vamos a recibir de la interface
wire [7:0]  salida_leds         ; 

reg         clock               ;
reg         reset               ;


initial begin
    clock               = 0;
    reset               = 0;
    wr_uart             = 0;
    rd_uart             = 0;
    data_to_interface   = 8'd34;
    #2 reset= 1'b1;
    #2 reset= 1'b0;
    #2 wr_uart = 1'b1;
    #2 wr_uart = 1'b0;

    #104000;
    
    
    #2 data_to_interface = 8'd7;
    #2 wr_uart = 1'b1;
    #2 wr_uart = 1'b0;
    #104000;
    #2 data_to_interface = 8'd3;
    #2;
    #2 wr_uart = 1'b1;
    #2 wr_uart = 1'b0;
    #104000;

    #10;
    $finish;

end

always #1 clock = ~clock;


top
#(
    .DBIT    (8  ),
    .DVSR    (326), //163
    .SB_TICK (16 ),
    .FIFO_W  (2  ),
    .NB_OP   (6  )   //! Number of bits of the operation
)
   u_top
    (
        .clock  (clock       ),
        .RsRx   (rx_interface),
        .i_reset(reset       ),
        .RsTx   (tx_interface),
        .o_led  (salida_leds)
    );


UART
#(//19200 bauds, 8databit,1stopbit 2^2 FIFO
    .DBIT     (  8),      //! DATA BIT
    .SB_TICK  ( 16),      //! STICKS FOR STOP BITS
    .DVSR     (326),      //! baud rate divisor
    .DVSR_BIT (  9),      //! bits of divisor
    .FIFO_W   (  2)       //! FIFO width FIFO=2^FIFO_W
) 
   u_UART
    (
        .clk     (clock),  //! clock
        .reset   (reset),  //! reset
        .rd_uart (),  //! read uart
        .wr_uart (wr_uart           ),  //! write uart
        .rx      (tx_interface      ),  //! rx
        .w_data  (data_to_interface ),  //! data to write
        .tx_full (),  //! tx full
        .rx_empty(),  //! rx empty
        .tx      (rx_interface       ),  //! tx
        .r_data  (data_from_interface)   //! data to read
    );

endmodule
