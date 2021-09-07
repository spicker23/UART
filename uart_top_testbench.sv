`timescale 1ns/1ns
module uart_top_testbench();
    logic i_clk;
    logic i_rst_n;
    logic [7:0] i_data;
    logic i_start_tx;
    logic o_uart_tx;
    logic [7:0] o_data;
    logic o_ready;

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


    $monitor ($time,   "i_clk = %b, i_rst_n = %b, i_data = %b, i_start_tx = %b, o_uart_tx = %b, o_data = %b, o_ready = %b",
                        i_clk, i_rst_n, i_data, i_start_tx, o_uart_tx, o_data, o_ready);

    repeat(100)
        @(posedge i_clk);
    $finish;
end

uart_top i_uart_top (
    i_clk,
    i_rst_n,
    i_data,
    i_start_tx,
	 o_uart_tx,
	 o_data,
	 o_ready
);

endmodule
