module uart_tx 
#(
    parameter    DBIT =  8,   //!Data bit
    parameter SB_TICK = 16    //! Sticks for stop bits
)
(
    input                    clk,
    input                  reset,
    input               tx_start,
    input                 s_tick,
    input [7:0]              din,
    output reg      tx_done_tick,
    output                    tx
);

// symbolic state declaration
localparam [1:0] idle  = 2'b00;
localparam [1:0] start = 2'b01;
localparam [1:0] data  = 2'b10;
localparam [1:0] stop  = 2'b11;

// signal declaration
reg     [1:0] state_reg     ;
reg     [1:0] state_next    ;
reg     [3:0] s_reg         ;
reg     [3:0] s_next        ;
reg     [2:0] n_reg         ;
reg     [2:0] n_next        ;
reg     [7:0] b_reg         ;
reg     [7:0] b_next        ;
reg           tx_reg        ;
reg           tx_next       ;

// FSMF state and data registers
always @(posedge clk, posedge reset) begin
    if (reset) begin
        state_reg <= idle;
        s_reg     <=    0;
        n_reg     <=    0;
        b_reg     <=    0;
        tx_reg    <= 1'b1;
    end
    else begin
        state_reg <= state_next;
        s_reg     <= s_next;
        n_reg     <= n_next;
        b_reg     <= b_next;
        tx_reg    <= tx_next;
    end
end

// FSMF next-state logic and funtional units
always @(*) begin
    state_next   = state_reg;
    tx_done_tick =      1'b0;
    s_next       =     s_reg;
    n_next       =     n_reg;
    b_next       =     b_reg;
    tx_next      =    tx_reg;
    case (state_reg)
        idle:
            begin
                tx_next = 1'b1;
                if (tx_start) begin
                    state_next = start;
                    s_next     =     0;
                    b_next     =   din;
                end
            end
        start:
            begin
                tx_next = 1'b0;
                if(s_tick)
                    if (s_reg==15) begin
                        state_next = data;
                        s_next     =    0;
                        n_next     =    0;
                    end
                    else
                        s_next = s_reg + 1;
            end
        data:
            begin
                tx_next = b_reg[0];
                if (s_tick) 
                    if (s_reg==15) begin
                        s_next =          0;
                        b_next = b_reg >> 1;
                        if (n_reg==(DBIT-1))
                            state_next = stop;
                        else
                            n_next = n_reg + 1;
                    end
                    else
                        s_next = s_reg + 1;
            end
        stop:
            begin
                tx_next = 1'b1;
                if (s_tick) 
                    if (s_reg==(SB_TICK-1)) begin
                        state_next   = idle;
                        tx_done_tick = 1'b1;
                    end
                    else
                        s_next = s_reg + 1;
            end
    endcase
end

assign tx = tx_reg;
    
endmodule