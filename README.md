# FPGA-Pesudocode
Verilog/HDL implementations of various circuits. These are all untested. Basically my workbook while I teach myself.

# Multislope ADC from HP
On Page 8 of the 1989 Vol.40 No.2 Hewlett-Packard Journal, there is an article by Wayne C. Goeke titled:
"An 8 1/2-Digit Integrating Analog-to-Digital Converter with 16-Bit, 100,000-Sample-perSecond Performance"
"This integrating-type ADC uses multislope runup, multislope rundown, and a two-input structure to achieve the required speed, resolution, and linearity."
https://archive.org/details/Hewlett-Packard_Journal_Vol._40_No._2_1989-04_Hewlett-Packard/page/n7

## ADC_3_State_Multislope.v
### Implements a simple multislope ADC that converts an analog input voltage into an 8-bit digital output. It operates by charging and discharging a capacitor to measure the input voltage.
It has three inputs and one output. The clk input is a clock signal used to synchronize the operations of the ADC. The start_conversion input is used to trigger the start of a conversion. The digital_output output is an 8-bit binary value that represents the digital equivalent of the input voltage.

The module has four internal registers: count, charge_value, discharge_value, and state. The count register keeps track of the number of clock cycles since the start of a conversion. The charge_value and discharge_value registers determine the time it takes to charge and discharge the capacitor, respectively. The state register represents the current state of the ADC.

The module has two wires, charge_complete and discharge_complete, that indicate when the charging and discharging processes are complete. 

The module has two always blocks that execute on each positive edge of the clk signal.

The first always block is used to control the operation of the ADC. If the start_conversion input is asserted, the count register is reset to 0 and the state register is set to the charge state. Otherwise, the ADC operates according to the current state. During the charge state, the count register is incremented on each clock cycle until the capacitor is fully charged, at which point the state register is set to the discharge state and the count register is reset. During the discharge state, the count register is again incremented until the capacitor is fully discharged, at which point the state register is set to the sample state, and the digital_output register is set to the current value of the count register. Finally, the state register is set back to the charge state to start the next conversion.

The second always block is used to set the charge_value and discharge_value registers based on the current state of the ADC. During the charge state, the charge_value register is set to the maximum value of 8'b11111111, representing the full-scale input voltage. During the discharge state, the discharge_value register is set to the current value of the digital_output register, which determines the time it takes to discharge the capacitor.

## ADC_5_State_Multislope.v
### A simple multislope ADC that uses a finite state machine to control the integration and comparison of an analog signal to determine a digital output value. 
It operates by integrating an analog signal over time, and then comparing it to a reference voltage to determine the digital output value.

The module has three inputs and one output: clk: the clock signal used to synchronize the operation of the ADC. start: a signal that starts the ADC operation. result: the output of the ADC, which is an 8-bit digital value.

The module also has several internal signals: counter: a counter that keeps track of the number of clock cycles that have elapsed. count_ref: a counter that keeps track of the number of clock cycles that have elapsed during the reference voltage phase. count_int: a counter that keeps track of the number of clock cycles that have elapsed during the integration phase. sum: a register that accumulates the analog signal value over time. avg: a register that stores the average value of the analog signal over the integration time. last_avg: a register that stores the previous value of avg. reference: a register that stores the reference voltage value. sample: a register that stores the last sample value.

It uses a case statement to implement a finite state machine that controls the operation of the ADC. The finite state machine has six states: 0: Idle state, waiting for the start signal to be asserted. 1: Reference state, measuring the reference voltage and accumulating noise. 2: Integration state, integrating the analog signal over time and accumulating noise. 3: Averaging state, waiting for the integration time to elapse and accumulating noise. 4: Comparison state, comparing the average value to the reference voltage and updating the output value. 5: Final state, waiting for the start signal to be deasserted.

When the start signal is asserted, the finite state machine transitions to the reference state (state=1). During the reference state, the ADC measures the reference voltage and accumulates noise by adding a random value to the sum register on each clock cycle. After the reference time elapses, the ADC transitions to the integration state (state=2), where it integrates the analog signal over time and accumulates noise in the same way. After the integration time elapses, the ADC transitions to the averaging state (state=3), where it waits for the reference time to elapse and accumulates noise. When the reference time elapses, the ADC transitions to the comparison state (state=4), where it compares the average value to the reference voltage and updates the output value accordingly. If the average value is greater than or equal to the reference voltage, the ADC transitions to the final state (state=5), where it waits for the start signal to be deasserted.  If the average value is less than the reference voltage, the ADC transitions back to the reference state to take another measurement.


# Pulse Width ADC from Solartron
On page 74 of the 1987 March issue of Electronics Today International, there is an article by ETI titled:
"SCRUTINY OF THE BENCH"
"Weighing up the evidence on the modern bench multimeter. Do they offer anything beyond the DMM you put in your pocket?"
https://archive.org/details/1987.03-eti/page/n73

## ADC_4_State_Pulse_Width.v
### The goal is to convert an analog signal into a digital signal using PWM, with the pulse width of the output signal proportional to the amplitude of the input signal.
The pwm adc module has an input clock (clk), a start conversion signal, an 8-bit analog input signal (analog_input), and an 8-bit digital output signal (digital_output).

Several registers track the state of the conversion process. A count register (count), which counts the number of clock cycles since the start of the conversion. Two registers for the positive peak (positive_peak) and negative peak (negative_peak) of the input signal. There is finally the state register (state), which keeps track of the current state of the conversion process.

The state machine has four states: State 00: Wait for next cycle. State 01: Record positive peak. State 10: Record negative peak. State 11: Output pulse width.

The pulse width is calculated as the difference between the positive peak and negative peak signals, and is assigned to the pulse_width signal using an assign statement. 

The always block in the module is triggered by the positive edge of the input clock signal, and controls the state machine. When the start_conversion signal is high, the state machine is reset to its initial state and the count, positive_peak, negative_peak, and last_pulse_width registers are set to zero. When start_conversion is low, the state machine transitions through the four states, recording the positive and negative peaks and calculating the pulse width. When the state machine enters the output pulse width state, the digital_output signal is updated with the current pulse width if it is larger than the previous pulse width (stored in the last_pulse_width register).


# Sigma Delta ADC
## ADC_Sigma_Delta.v
### The goal is to convert an analog input signal into a digital output signal with a high level of precision and accuracy.
This implementation assumes that the analog input is a 24-bit value and the digital output is a 33-bit value with 8 fractional bits. It's an 8th-order sigma-delta modulator with eight integrators and a feedback loop. The feedback loop generates a 1-bit signal that is used as the output. When the reset signal is high, all integrators and feedback signal are reset to zero. When reset is low, the integrators and feedback signal are updated on every positive edge of the clk signal. integrator1 through integrator8 are used to store the accumulated values of the analog input and feedback signal over time. The feedback signal is determined by comparing the value of the 8th integrator to a threshold value of 0x7FFFFF (the maximum value of a signed 24-bit number). If the value of the 8th integrator is greater than 0x7FFFFF, then the feedback signal is set to 0xFFFFFF (i.e., the output is high), otherwise the feedback signal is set to 0 (i.e., the output is low). The output of the ADC is a 33-bit value, with the first 25 bits representing the integer part of the ADC output and the last 8 bits representing the fractional part of the ADC output.


# Sigma Delta DMM812
## ADC_Sigma_Delta_DMM812.v
### The goal is to convert an analog input signal into a digital output signal with a high level of precision and accuracy.
This is an example of an 8 1/2 digit ADC. This module "ADC_Sigma_Delta_DMM812.v" includes the sd_oversampler, sd_digital_filter, sd_decimator, and sd_calibration modules. The analog_in input is oversampled using the sd_oversampler module, and the resulting signal is filtered using the sd_filter module. The filtered signal is then decimated using the sd_decimator module to produce the input to the sd_modulator which results in the final output value. Finally, the output is calibrated using the sd_calibration module to adjust for any gain or offset errors in the ADC. Note that the oversampling rate, filter coefficients, decimation factor, modulator gain used in this implementation are not specified, and would need to be chosen based on the specific requirements of the ADC design. Additionally, this implementation assumes that the input analog_in is a 24-bit signed value, and that the output digital_out is a 33-bit signed value.

## ADC_Sigma_Delta_DMM812_Oversampling.v
This sd_oversampler module uses a loop to oversample the input signal at a rate of OSR times the input frequency, where OSR is a parameter set to 64 in this example. The integrator and feedback registers are updated for each iteration of the loop. The output is a 48-bit signal that includes the feedback and integrator registers concatenated together.

## ADC_Sigma_Delta_DMM812_Digital_Filter.v
This sd_digital_filter module implements a 5th-order cascaded integrator-comb (CIC) filter, which is a commonly used filter in sigma-delta ADCs. The oversampled input signal is delayed and fed into a comb filter stage, which is implemented using a delay line and an accumulator. The comb filter output is fed into an integrator stage, which is implemented using a feedback loop and an integrator register. The filter output is a 48-bit signal that includes the feedback and integrator registers concatenated together.

## ADC_Sigma_Delta_DMM812_Decimation.v
This sd_decimator module implements a decimation filter that downsamples the filtered input signal by a factor of N. The input signal is accumulated over N clock cycles, and the feedback register is updated and outputted to produce a 33-bit digital output signal. The filter also includes a counter and accumulator to keep track of the input signal and control the decimation process.

## ADC_Sigma_Delta_DMM812_Modulator.v
This sd_modulator module implements a second-order sigma-delta modulator using two integrators and one comb filter, and produces a 1-bit output based on the quantization error. The module includes an input analog_in and an output quantized_out that are updated on each clock cycle. The filter parameters K and N can be adjusted to optimize the performance of the modulator.

## ADC_Sigma_Delta_DMM812_Calibration.v
This sd_calibration  module implements a second-order loop filter with a gain of K and an order of N.
 
