`timescale 1ns / 1ps

// Description :    1). General Description:
//                          This is the transmitter module for the N-Byte UART. It has the ability to transmit a specified number of bytes to an external register.
//                      In order to transmit N bytes, the user specifies an input as (N-1) to a seperate line, before transmitting data. The module has the ability
//                      to transmit any number of bytes ranging from 1 to 1024. Followed by the start bit, M.S.B. is transmitted first followed by other data bits 
//                      uptill the L.S.B. and the stop bit.
//                          It takes two clock cycles to transmit a single bit of data. It takes an aditional one clock cycle to wake up the UART from idle state.
//                      The transmitter can be woken up from idle state by pulling the line LOW for one clock cycle. This is followed by a start bit spanning for 
//                      two clock cycles, followed by 8 data bits and the stop bit, marked by pulling the line HIGH for two clock cycles. If there are more bytes 
//                      to be transmitted, a start bit is sent again and the process continues until all the bytes are transferred. After all the bytes are 
//                      transferred, the transmitter goes back to idle state.
//                  2). State Descriptions:
//                      TRM_STATE_IDLE: The transmitter is idle in this state, which means that no activities are being performed, and the transmitter is awaiting 
//                                      a data byte to transmit. Transmission begins when the "tx_data_valid" is HIGH, which puts the UART in TRM_STATE_STRT state,
//                                      and the transmission begins.
//                      TRM_STATE_STRT: This is the state where the transmitter performs the transmission of the start bit. The output serial tranmission data line
//                                      is pulled LOW for two clock cycles and the start bit is transmitted, the device then goes into the data transmission state
//                      TRM_STATE_DATA: This is the data transmission state. Two clock cycles are required to transmit every bit. After all 8 bits are transmitted,
//                                      the transmitter goes into the TRM_STATE_STOP, where it transits the stop bit.
//                      TRM_STATE_STOP: The transmitter transmits the stop bit in this state. The serial data line is pulled HIGH for two clock cycles to transmit
//                                      the stop bit. After completing the transmission of stop bit, the transmitter decides which state to move to. If there are
//                                      more bytes to transfer, the transmitter goes to TRM_STATE_STRT, where it has to transmit the start bit for next 
//                                      transmission. If there are no more bytes to transfer, the transmitter goes back to TRM_STATE_IDLE state.
//                  3). Pin Descriptions:
//                        clock           : Input clock signal obtained from the UART_Baud_Generator module that operates the transmitter with the specified 
//                                          baud rate.
//                        bytes_to_tx     : This is a 10-bit input array, used to configure the amount of bytes of data that has to be transmitted from the UART 
//                                          module. This is configured in real time by the driving device.
//                        tx_data_byte    : This is the byte of data to be transmitted, provided by the driving device.
//                        tx_data_valid   : This input signal indicates whether the byte of data provided is valid for transmission. Any number of new bytes, even
//                                          exceeding the amount provided by the bytes_to_tx signal can be tranmitted as long as this signal is high.
//                        serial_data_out : This is the serial data output from the transmitter.

module UART_TX (clock, bytes_to_tx, tx_data_byte, tx_data_valid, serial_data_out);
    
    input             clock;
    input       [9:0] bytes_to_tx;
    input       [7:0] tx_data_byte;
    input             tx_data_valid;
    
    output reg       serial_data_out;
    
    localparam TRM_STATE_IDLE = 2'b 00;
    localparam TRM_STATE_STRT = 2'b 01;
    localparam TRM_STATE_DATA = 2'b 10;
    localparam TRM_STATE_STOP = 2'b 11;
    
    reg       tx_clk_ctr          = 1'b 0;
    reg [9:0] bytes_to_tx_reg     = 10'b 0;
    
    reg [2:0] tx_state            = TRM_STATE_IDLE;
    reg [2:0] tx_bit_ctr          = 3'b 0;
    
    reg       serial_data_out_reg = 1'b 1;
    
    
    always @(posedge clock) begin
        case (tx_state)
            TRM_STATE_IDLE  :   begin
                                    tx_clk_ctr          <= 1'b 1;
                                    tx_bit_ctr          <= 3'b 111;
                                    bytes_to_tx_reg     <= bytes_to_tx;
                                    
                                    if (tx_data_valid == 1'b 1) begin
                                        serial_data_out <= 1'b 0;
                                        tx_state <= TRM_STATE_STRT;
                                    end
                                    else begin
                                        serial_data_out <= 1'b 1;
                                        tx_state <= TRM_STATE_IDLE;
                                    end
                                end
            TRM_STATE_STRT  :   begin
                                    if (tx_clk_ctr == 1'b 0) begin
                                        tx_clk_ctr <= tx_clk_ctr + 1'b 1;
                                        tx_state   <= TRM_STATE_STRT;
                                    end
                                    else begin
                                        tx_clk_ctr <= 1'b 0;
                                        serial_data_out <= 1'b 0;
                                        tx_state <= TRM_STATE_DATA;
                                    end
                                end
            TRM_STATE_DATA  :   begin
                                    if (tx_clk_ctr == 1'b 0) begin
                                        tx_clk_ctr <= tx_clk_ctr + 1'b 1;
                                        tx_state   <= TRM_STATE_DATA;
                                    end
                                    else begin
                                        tx_clk_ctr      <= 1'b 0;
                                        serial_data_out <= tx_data_byte[tx_bit_ctr];
                                        
                                        if (tx_bit_ctr > 3'b 000) begin
                                            tx_bit_ctr <= tx_bit_ctr - 3'b 001;
                                            tx_state   <= TRM_STATE_DATA;
                                        end
                                        else begin
                                            tx_bit_ctr <= 3'b 111;
                                            tx_state   <= TRM_STATE_STOP;
                                        end
                                    end
                                end
            TRM_STATE_STOP  :   begin
                                    if (tx_clk_ctr == 1'b 0) begin
                                        tx_clk_ctr <= tx_clk_ctr + 1'b 1;
                                        tx_state   <= TRM_STATE_STOP;
                                    end
                                    else begin
                                        serial_data_out <= 1'b 1;
                                        tx_clk_ctr      <= 1'b 0;
                                        
                                        if ((bytes_to_tx_reg > 10'b 0) && (bytes_to_tx_reg <= bytes_to_tx)) begin
                                            bytes_to_tx_reg <= bytes_to_tx_reg - 3'b 001;
                                            tx_state        <= TRM_STATE_STRT;
                                        end
                                        else
                                            tx_state        <= TRM_STATE_IDLE;
                                    end
                                end
        endcase
    end

endmodule
