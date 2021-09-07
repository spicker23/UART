
module uart_rx (
    input   logic                   i_clk       ,
    input   logic                   i_rst_n     ,

    input   logic                   o_uart_rx   ,
    //input   logic                   i_start_tx  ,

    output  logic   [7 : 0]         o_data      ,
    output  logic                   o_ready
);

logic   [3 : 0]         cntr_ff     ;
logic   [3 : 0]         cntr_nxt    ;
logic                   cntr_upd    ;

logic   [7 : 0]         data_ff     ;
logic   [7 : 0]         data_nxt    ;
logic                   data_upd    ;

//------------------------------
// Counter logic
//------------------------------

always_comb begin
    cntr_upd = 1'b0;
    cntr_nxt = cntr_ff + 1'b1;
    if (cntr_ff == '0) begin
        cntr_upd = ~o_uart_rx;   //i_start_tx
    end else begin
        cntr_upd = 'b1;
        cntr_nxt = (cntr_ff == 'd9) ? '0 : cntr_ff + 1'b1;
    end
end

always_ff @(posedge i_clk, negedge i_rst_n) begin
    if (~i_rst_n) begin
        cntr_ff     <= '0;
    end else begin
        cntr_ff     <=  cntr_upd    ?   cntr_nxt    :   cntr_ff;
    end
end

//------------------------------
// uart RX logic
//------------------------------

always_comb begin
    data_nxt = data_ff;
    data_upd = 1'b0;

    if ((cntr_ff == '0) & (o_uart_rx == '0)) begin
        data_nxt = '0;
        data_upd = 1'b1;
    end else begin
        if (cntr_ff != '0) begin
            data_nxt = {o_uart_rx, data_ff[7 : 1]};
            data_upd = 1'b1;
        end
    end
end

always_ff @(posedge i_clk, negedge i_rst_n) begin
    if (~i_rst_n) begin
        data_ff <= '0;
    end else begin
        data_ff <=  data_upd ? data_nxt : data_ff;
    end
end

always_comb begin
    o_ready   = 1'b0;
    o_data    = '0;

    if (cntr_ff == 'd9) begin
        o_data = data_ff;
        o_ready = 1'b1;

    end
end
endmodule


