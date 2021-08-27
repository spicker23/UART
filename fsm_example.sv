module fsm_example (
    input logic             i_clk,
    input logic             i_rst_n,

    input logic  [3 : 0]    i_example_bus,

    output logic [1 : 0]    o_ex_out
);

typedef enum logic [1 : 0]
{
    FSM_IDLE,
    FSM_STATE_1,
    FSM_STATE_2,
    FSM_DONE
} fsm_t;

fsm_t   fsm_ff;
fsm_t   fsm_nxt;
logic   fsm_upd;

always_comb begin
    fsm_upd = 1'b0;
    fsm_nxt = fsm_ff;

    case (fsm_ff)
        FSM_IDLE: begin
            if (i_example_bus == 4'd14) begin
                fsm_nxt = FSM_STATE_1;
                fsm_upd = 1'b1;
            end
        end

        FSM_STATE_1: begin
            if (i_example_bus == 4'd10) begin
                fsm_nxt = FSM_STATE_2;
                fsm_upd = 1'b1;
            end else begin
                if (i_example_bus = 4'd3) begin
                    fsm_nxt = FSM_DONE;
                    fsm_upd = 1'b1;
                end
            end
        end

        FSM_STATE_2: begin
            if (i_example_bus == 4'd1) begin
                fsm_nxt = FSM_STATE_1;
                fsm_upd = 1'b1;
            end else begin
                if (i_example_bus == 4'd7) begin
                    fsm_nxt = FSM_DONE;
                    fsm_upd = 1'b1;
                end
            end
        end

        FSM_DONE: begin
            fsm_nxt = FSM_IDLE;
            fsm_upd = 1'b1;
        end
    endcase
end

always_ff @(posedge i_clk, negedge i_rst_n) begin
    if (~i_rst_n) begin
        fsm_ff  <=  FSM_IDLE;
    end else begin
        fsm_ff  <=  (fsm_upd)   ?   fsm_nxt :   fsm_ff;
    end
end

always_comb begin
    o_ex_out = '0;

    case (fsm_ff)
        FSM_IDLE: o_ex_out = 2'd3;
        FSM_STATE_1: o_ex_out = 2'd1;
        FSM_STATE_2: o_ex_out = 2'd2;
        FSM_DONE: o_ex_out = 2'd0;
    endcase
end

endmodule
