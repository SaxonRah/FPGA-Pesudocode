module pulse_width_conversion_adc (
  input clk,
  input start_conversion,
  input [7:0] analog_input,
  output reg [7:0] digital_output
);

reg [7:0] count;
reg [7:0] positive_peak;
reg [7:0] negative_peak;
reg [1:0] state;
reg [7:0] pulse_width;
reg [7:0] last_pulse_width;

assign pulse_width = positive_peak - negative_peak;

always @ (posedge clk) begin
  if (start_conversion) begin
    count <= 0;
    positive_peak <= 0;
    negative_peak <= 0;
    state <= 2'b00;
    last_pulse_width <= 0;
  end else begin
    case (state)
      2'b00: begin // Wait for next cycle
        count <= count + 1;
        if (count == 255) begin
          count <= 0;
          state <= 2'b01;
        end
      end
      2'b01: begin // Record positive peak
        count <= count + 1;
        if (analog_input > positive_peak) begin
          positive_peak <= analog_input;
        end
        if (count == 255) begin
          count <= 0;
          state <= 2'b10;
        end
      end
      2'b10: begin // Record negative peak
        count <= count + 1;
        if (analog_input < negative_peak) begin
          negative_peak <= analog_input;
        end
        if (count == 255) begin
          count <= 0;
          state <= 2'b11;
        end
      end
      2'b11: begin // Output pulse width
        last_pulse_width <= pulse_width;
        if (pulse_width > last_pulse_width) begin
          digital_output <= pulse_width;
        end else begin
          digital_output <= last_pulse_width;
        end
        state <= 2'b00;
      end
    endcase
  end
end

endmodule
