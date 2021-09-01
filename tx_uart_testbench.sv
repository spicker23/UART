`timescale 1ns/1ns
module tx_uart_testbench();
    logic i_clk;
    logic i_rst_n;
    logic [7:0] i_data;
    logic i_start_tx;
    logic o_uart_tx;

initial begin
    i_clk = '0;
    forever begin
        i_clk = ~i_clk;
        #5;
    end
end

initial begin
    i_rst_n = 0;
    @(posedge i_clk);
    i_rst_n = 1;
end

initial begin
    i_data      = 0;
    i_start_tx  = 0;
    do
        @(posedge i_clk);
    while (~i_rst_n);

    //i_data      = 8'hAA;
    i_data      = 8'h55;
    i_start_tx  = 1;

    @(posedge i_clk);
    i_start_tx  = 0;


    $monitor ($time,   "i_clk = %b, i_rst_n = %b, i_data = %b, i_start_tx = %b, o_uart_tx = %b",
                        i_clk, i_rst_n, i_data, i_start_tx, o_uart_tx);

    repeat(100)
        @(posedge i_clk);
    $finish;
end

uart_tx i_uart_tx (
    i_clk,
    i_rst_n,
    i_data,
    i_start_tx,
    o_uart_tx
);

endmodule
