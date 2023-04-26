module decimation(
    input clk,
    input reset,
    input [47:0] filtered_in,
    output reg [32:0] digital_out
);

reg [9:0] counter;
reg [47:0] acc;
reg [23:0] feedback;

parameter OSR = 64; // oversampling ratio
parameter N = 4; // decimation factor

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        acc <= 0;
        feedback <= 0;
        digital_out <= 0;
    end else begin
        // Update accumulator and counter
        acc <= acc + filtered_in;
        counter <= counter + 1;

        if (counter == N) begin
            // Update feedback register and output
            feedback <= acc[41:18] ^ acc[17:0];
            digital_out <= {feedback, 8'b00000000};

            // Reset accumulator and counter
            acc <= 0;
            counter <= 0;
        end
    end
end
endmodule
