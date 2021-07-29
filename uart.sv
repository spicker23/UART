module uart(
    input logic                     i_clk,
    input logic                     i_rstn,

    input logic                     i_data,
    output logic                    o_data
);

logic       my_ff;
logic       my_nxt;
logic       my_upd;

always_comb begin
    my_upd = 1'b0;
    my_nxt = my_ff;

    if (i_data) begin
        my_upd = 1'b1;
        my_nxt = ~my_ff;
    end
end

always_ff @(posedge i_clk, negedge i_rstn) begin
    if (~i_rstn) begin
        my_ff <= 1'b0;
    end else begin
        my_ff <= (my_upd) ? my_nxt : my_ff;
    end
end

assign o_data = my_ff;

endmodule
