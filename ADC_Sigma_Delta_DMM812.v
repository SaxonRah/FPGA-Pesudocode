module sd_DMM812(
    input clk,
    input reset,
    input [23:0] analog_in,
    output reg [32:0] digital_out
);

reg [15:0] oversampled_in;
reg [15:0] filtered_in;
reg [15:0] decimated_out;
reg [15:0] modulated_out;
reg [32:0] calibrated_out;

sd_oversampler oversampler(
    .clk(clk),
    .reset(reset),
    .analog_in(analog_in),
    .oversampled_out(oversampled_in)
);

sd_digital_filter filter(
    .clk(clk),
    .reset(reset),
    .oversampled_in(oversampled_in),
    .filtered_out(filtered_in)
);

sd_decimator decimator(
    .clk(clk),
    .reset(reset),
    .filtered_in(filtered_in),
    .decimated_out(decimated_out)
);

sd_modulator modulator(
    .clk(clk),
    .reset(reset),
    .analog_in(decimated_out),
    .quantized_out(modulated_out)
);

sd_calibration calibration(
    .clk(clk),
    .reset(reset),
    .adc_in(modulated_out),
    .calibrated_out(calibrated_out)
);

assign digital_out = calibrated_out;

endmodule
