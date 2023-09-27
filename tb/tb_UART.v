module tb_UART 
(
    input                    clk,
    input                  reset,
    input                   i_rx,
    input    [2:0]         i_btn,
    output                  o_tx,
    output   [3:0]          o_an,
    output   [7:0]         o_led,
    output   [7:0]        o_sseg
);

//signal declaration
wire                     tx_full;
wire                    rx_empty;
wire                    btn_tick;
wire        [7:0]       rec_data;
wire        [7:0]      rec_data1;

//body
UART
#(//19200 bauds, 8databit,1stopbit 2^2 FIFO
    .DBIT     (8  ),      //! DATA BIT
    .SB_TICK  (16 ),      //! STICKS FOR STOP BITS
    .DVSR     (163),      //! baud rate divisor
    .DVSR_BIT (8  ),      //! bits of divisor
    .FIFO_W   (2  )         //! FIFO width FIFO=2^FIFO_W
) 
  u_UART
(
    .clk     (clk       ),  //! clock
    .reset   (reset     ),  //! reset
    .rd_uart (btn_tick  ),  //! read uart
    .wr_uart (btn_tick  ),  //! write uart
    .rx      (rx        ),  //! rx
    .w_data  (rec_data1 ),  //! data to write
    .tx_full (tx_full   ),  //! tx full
    .rx_empty(rx_empty  ),  //! rx empty
    .tx      (tx        ),  //! tx
    .r_data  (rec_data  )  //! data to read
);

debounce
 u_debounce
(
    .clk     (clk          ), 
    .reset   (reset        ),
    .sw      (i_btn[0]     ),
    .db_level(), 
    .db_tick (btn_tick     )
);

assign rec_data1 = rec_data+1;
assign o_led     = rec_data;
assign o_an      = 4'b1110;
assign o_sseg    = {1'b1, ~tx_full, 2'b11, ~rx_empty, 3'b111};
endmodule