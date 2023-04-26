# FPGA-Pesudocode
Verilog/HDL implementations of various circuits. These are all untested. Basically my workbook while I teach myself.

# Multislope ADC from HP
On Page 8 of the 1989 Vol.40 No.2 Hewlett-Packard Journal, there is an article by Wayne C. Goeke titled:
"An 8 1/2-Digit Integrating Analog-to-Digital Converter with 16-Bit, 100,000-Sample-perSecond Performance"
"This integrating-type ADC uses multislope runup, multislope rundown, and a two-input structure to achieve the required speed, resolution, and linearity."
https://archive.org/details/Hewlett-Packard_Journal_Vol._40_No._2_1989-04_Hewlett-Packard/page/n7


# Pulse Width ADC from Solartron
On page 74 of the 1987 March issue of Electronics Today International, there is an article by ETI titled:
"SCRUTINY OF THE BENCH"
"Weighing up the evidence on the modern bench multimeter. Do they offer anything beyond the DMM you put in your pocket?"
https://archive.org/details/1987.03-eti/page/n73

The goal is to convert an analog signal into a digital signal using PWM, with the pulse width of the output signal proportional to the amplitude of the input signal.

The pwm adc module has an input clock (clk), a start conversion signal, an 8-bit analog input signal (analog_input), and an 8-bit digital output signal (digital_output). Several registers track the state of the conversion process. A count register (count), which counts the number of clock cycles since the start of the conversion. Two registers for the positive peak (positive_peak) and negative peak (negative_peak) of the input signal.

There is finally the state register (state), which keeps track of the current state of the conversion process. The state machine has four states: State 00: Wait for next cycle. State 01: Record positive peak. State 10: Record negative peak. State 11: Output pulse width. The pulse width is calculated as the difference between the positive peak and negative peak signals, and is assigned to the pulse_width signal using an assign statement. The always block in the module is triggered by the positive edge of the input clock signal, and controls the state machine. When the start_conversion signal is high, the state machine is reset to its initial state and the count, positive_peak, negative_peak, and last_pulse_width registers are set to zero. When start_conversion is low, the state machine transitions through the four states, recording the positive and negative peaks and calculating the pulse width. When the state machine enters the output pulse width state, the digital_output signal is updated with the current pulse width if it is larger than the previous pulse width (stored in the last_pulse_width register).
