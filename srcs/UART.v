`timescale 1ns / 1ps

// Description:     1). Pin Descriptions:
//                      The details of all the parameters and pins are provided in the README.md file. Please refer it to configure the UART for initialization in
//                      your design. The UART_Baud_Generator module is used to device the system clock with a factor to provide the required baud. The uart_clock is 
//                      an internal signal that is the output of the UART_Baud_Generator module used to drive the UART_TX & UART_RX modules.

module UART #(parameter SYSTM_OPERN_FREQ = 11059200, REQD_BAUD_RATE = 9600)
            (clock, tx_no_bytes, rx_no_bytes, tx_data_byte, rx_ser_data_in, tx_data_valid, rx_data_valid, tx_ser_data_out, rx_data_byte);
    
    // Clock Input Signal
    input        clock;
    // Transmitter Signals
    input  [9:0] tx_no_bytes;
    input  [7:0] tx_data_byte;
    input        tx_data_valid;
    output       tx_ser_data_out;
    // Receiver Signals
    input  [9:0] rx_no_bytes;
    input        rx_ser_data_in;
    output       rx_data_valid;
    output [7:0] rx_data_byte;
    
    wire         uart_clock;
    
    
    UART_Baud_Generator #(SYSTM_OPERN_FREQ, REQD_BAUD_RATE) UART_BGN (clock, uart_clock);
    UART_TX                                                 UART_TRM (uart_clock, tx_no_bytes, tx_data_byte, tx_data_valid, tx_ser_data_out);
    UART_RX                                                 UART_REC (uart_clock, rx_no_bytes, rx_ser_data_in, rx_data_valid, rx_data_byte);
    
endmodule
