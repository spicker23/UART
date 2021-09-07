`timescale 1ns/1ns
module rx_uart_testbench();
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


    $monitor ($time,   "i_clk = %b, i_rst_n = %b, o_uart_tx = %b, o_data = %b, o_ready = %b",
                        i_clk, i_rst_n, o_uart_tx, o_data, o_ready);

    repeat(100)
        @(posedge i_clk);
    $finish;
end

uart_rx i_uart_rx (
    i_clk,
    i_rst_n,
    o_uart_rx,
    o_data,
    o_ready
);

endmodule
