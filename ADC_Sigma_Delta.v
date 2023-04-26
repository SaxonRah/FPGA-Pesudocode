module sigma_delta_ADC(
    input clk,
    input reset,
    input [23:0] analog_in,
    output reg [32:0] digital_out
);

reg [23:0] integrator1;
reg [23:0] integrator2;
reg [23:0] integrator3;
reg [23:0] integrator4;
reg [23:0] integrator5;
reg [23:0] integrator6;
reg [23:0] integrator7;
reg [23:0] integrator8;
reg [23:0] feedback;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        integrator1 <= 0;
        integrator2 <= 0;
        integrator3 <= 0;
        integrator4 <= 0;
        integrator5 <= 0;
        integrator6 <= 0;
        integrator7 <= 0;
        integrator8 <= 0;
        feedback <= 0;
    end else begin
        integrator1 <= integrator1 + analog_in - feedback;
        integrator2 <= integrator2 + integrator1 - feedback;
        integrator3 <= integrator3 + integrator2 - feedback;
        integrator4 <= integrator4 + integrator3 - feedback;
        integrator5 <= integrator5 + integrator4 - feedback;
        integrator6 <= integrator6 + integrator5 - feedback;
        integrator7 <= integrator7 + integrator6 - feedback;
        integrator8 <= integrator8 + integrator7 - feedback;
        feedback <= integrator8 > 0x7FFFFF ? 0xFFFFFF : 0;
        digital_out <= {feedback, 8'b00000000};
    end
end
endmodule
