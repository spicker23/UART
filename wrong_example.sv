module asynch_sender(
	input clk,
	input [7:0] data,
	input Start,
	output reg D
);

	parameter Idle = 3'b000;
	parameter StartBit = 3'b001;
	parameter DataBit = 3'b010;
	parameter StopBit = 3'b100;

	parameter Divider = 16'd5208;  //9600 bit/s делитель счётчика, обеспечит нужную//2
											// передачи 50000000/5208
											// число импульсов в одном бите

	reg [3:0] state, next_state;
	reg [3:0] bitCount;
	reg [15:0] tickCount;

	initial begin           // не должно быть
		state = Idle;
		next_state = Idle;
		bitCount = 4'b0000;
		tickCount = 0;

	end

// сделать три блока always, always_comb(определяем некст), always_ff(защелкиваем следующий по сигалу апдейта), assign (вычисляем значение выходов)

	always @(posedge clk)
	begin
		state = next_state;
		case (state)
			Idle:
				begin
					D = 1'b1;
					if (Start == 1'b1)
						begin
							next_state = StartBit;
						end
						else begin
							next_state = state;
						end
				end

			StartBit:
				begin
					D = 1'b0;
					tickCount = tickCount + 1;
					if (tickCount == Divider)
					begin
						next_state = DataBit;
						tickCount = 0;
					end
					else next_state = state;
				end

			DataBit:
				begin
					tickCount = tickCount + 1;
					if (tickCount == Divider)
					begin
						tickCount = 0;
						bitCount = bitCount + 1;
						if (bitCount == 4'b1000)
							begin
								next_state = StopBit;
								bitCount = 4'b0000;
							end
					end
					else begin
						D = data[bitCount];
					end
				end

			StopBit:
				begin
					D = 1'b1;
					tickCount = tickCount + 1;
					if (tickCount == Divider)
					begin
						next_state = Idle;
						tickCount = 0;
					end else next_state = state;
				end
			default: next_state = Idle;
		endcase;
end
endmodule


//-------------------------------------------------

