module uart_top(
    input logic         i_clk,
    input logic         i_rst_n,
    input logic  [7:0]  i_data,
    input logic         i_start_tx,

    output logic        o_uart_tx,
    output logic [7:0]  o_data,
    output logic        o_ready
);


uart_tx transmitter(
    .i_clk      (i_clk      ),
    .i_rst_n    (i_rst_n    ),
    .i_data     (i_data     ),
    .i_start_tx (i_start_tx ),
    .o_uart_tx  (o_uart_tx  )
);


uart_rx receiver(
    .i_clk      (i_clk      ),
    .i_rst_n    (i_rst_n    ),
    .o_uart_tx  (o_uart_rx  ),
    .o_data     (o_data     ),
    .o_ready    (o_ready    )
);

endmodule
