module sd_modulator(
    input clk,
    input reset,
    input signed [7:0] analog_in,
    output reg quantized_out
);

parameter K = 2; // Loop filter gain
parameter N = 2; // Order of the modulator

reg signed [7:0] e1;
reg signed [7:0] e2;
reg [N-1:0] d1;
reg [N-1:0] d2;
reg signed [7:0] y;
reg [N-1:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        e1 <= 0;
        e2 <= 0;
        d1 <= 0;
        d2 <= 0;
        y <= 0;
        q <= 0;
        quantized_out <= 0;
    end else begin
        // Calculate the error term
        e1 <= analog_in - y;

        // Calculate the quantization error
        q <= e1 - e2 + K * (d1 - d2);

        // Quantize the error term
        if (q[N-1] == 1'b0) begin
            y <= y + (1 << (N-1));
        end else begin
            y <= y - (1 << (N-1));
        end

        // Update the delay lines
        d2 <= d1;
        d1 <= q;

        e2 <= e1;

        // Output the quantized bit
        quantized_out <= q[N-1];
    end
end
endmodule
