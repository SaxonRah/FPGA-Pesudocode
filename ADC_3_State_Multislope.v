module multislope_adc (
  input clk,
  input start_conversion,
  output reg [7:0] digital_output
);

reg [7:0] count;
reg [7:0] charge_value;
reg [7:0] discharge_value;
reg [2:0] state;
wire charge_complete;
wire discharge_complete;

assign charge_complete = (count == charge_value);
assign discharge_complete = (count == discharge_value);

always @ (posedge clk) begin
  if (start_conversion) begin
    count <= 0;
    state <= 3'b001;
  end else begin
    case (state)
      3'b001: begin // Charge capacitor
        count <= count + 1;
        if (charge_complete) begin
          state <= 3'b010;
          count <= 0;
        end
      end
      3'b010: begin // Discharge capacitor
        count <= count + 1;
        if (discharge_complete) begin
          state <= 3'b011;
          count <= 0;
        end
      end
      3'b011: begin // Sample output
        digital_output <= count;
        state <= 3'b001;
      end
    endcase
  end
end

always @ (posedge clk) begin
  if (state == 3'b001) begin
    charge_value <= 8'b11111111; // Set charge time for full-scale input
  end else if (state == 3'b010) begin
    discharge_value <= digital_output; // Set discharge time based on current count
  end
end

endmodule
