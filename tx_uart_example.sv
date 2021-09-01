
module uart_tx (
    input   logic                   i_clk       ,
    input   logic                   i_rst_n     ,

    input   logic   [7 : 0]         i_data      ,
    input   logic                   i_start_tx  ,

    output  logic                   o_uart_tx
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
        cntr_upd = i_start_tx;
    end else begin
        cntr_upd = 'b1;
        cntr_nxt = (cntr_ff == 'd9) ? '0 : cntr_ff + 1'b1;
 /*       if (cntr_ff == 'd10) begin
            cntr_nxt = 'b0;
        end else begin
        end*/
    end

   /* //if (((cntr_ff == '0) & (i_start_tx)) | cntr_ff) begin
        cntr_upd = 1'b1;
    end else begin
        if (cntr_ff == 'd10) begin
            cntr_upd = 1'b1;
            cntr_nxt = '0;
        end
    end*/
end

always_ff @(posedge i_clk, negedge i_rst_n) begin
    if (~i_rst_n) begin
        cntr_ff     <=  '0;
    end else begin
        cntr_ff     <=  cntr_upd    ?   cntr_nxt    :   cntr_ff;
    end
end

//------------------------------
// uart TX logic
//------------------------------

always_comb begin
    data_nxt = data_ff;
    data_upd = 1'b0;

    if ((cntr_ff == '0) & (i_start_tx)) begin
        data_nxt = i_data;
        data_upd = 1'b1;
    end else begin
        if (cntr_ff != '0) begin
            data_nxt = {1'b0, data_ff[7 : 1]};
            data_upd = 1'b1;
        end
    end
end

always_ff @(posedge i_clk, negedge i_rst_n) begin
    if (~i_rst_n) begin
        data_ff <=  '0;
    end else begin
        data_ff <=  data_upd ? data_nxt : data_ff;
    end
end

always_comb begin
    o_uart_tx   = 1'b1;

    if (i_start_tx) begin
        o_uart_tx   = 1'b0;
    end else begin
        if ((cntr_ff != '0) & (cntr_ff != 'd9)) begin
            o_uart_tx = data_ff[0];
        end
    end
end

endmodule
