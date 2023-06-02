`timescale 1ns / 1ps


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