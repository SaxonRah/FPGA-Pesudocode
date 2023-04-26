module digital_filter(
    input clk,
    input reset,
    input [47:0] oversampled_in,
    output reg [47:0] filtered_out
);

reg [47:0] delay_line [0:4];
reg [63:0] acc;
reg [23:0] feedback;
reg [23:0] integrator;
reg [1:0] index;

parameter OSR = 64; // oversampling ratio
parameter COEFF = 3'h3; // filter coefficient

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (integer i = 0; i < 5; i = i + 1) begin
            delay_line[i] <= 0;
        end
        acc <= 0;
        feedback <= 0;
        integrator <= 0;
        index <= 0;
        filtered_out <= 0;
    end else begin
        // Update delay line and accumulator
        delay_line[index] <= oversampled_in - feedback;
        acc <= acc + delay_line[index] - delay_line[(index+2) % 5];

        // Update feedback and integrator registers
        feedback <= acc[41:18] ^ acc[17:0];
        integrator <= integrator + feedback - delay_line[(index+4) % 5][23:0];

        // Update output
        filtered_out <= {feedback, integrator};

        // Increment index
        index <= index + 1;
    end
end
endmodule
