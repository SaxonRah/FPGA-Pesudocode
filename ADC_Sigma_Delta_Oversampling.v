module sd_oversampling(
    input clk,
    input reset,
    input [23:0] analog_in,
    output reg [47:0] oversampled_out
);

reg [23:0] integrator;
reg [23:0] feedback;

parameter OSR = 64; // oversampling ratio

always @(posedge clk or posedge reset) begin
    if (reset) begin
        integrator <= 0;
        feedback <= 0;
        oversampled_out <= 0;
    end else begin
        // Oversampling loop
        for (integer i = 0; i < OSR; i = i + 1) begin
            integrator <= integrator + analog_in - feedback;
            feedback <= integrator > 0x7FFFFF ? 0xFFFFFF : 0;
        end
        oversampled_out <= {feedback, integrator};
    end
end
endmodule
