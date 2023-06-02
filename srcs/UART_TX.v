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
//                      REC_STATE_IDLE: The receiver is idle in this state, which means that no activities are being performed, and the receiver is awaiting a
//                                      data to receive. In order to begin transmission, the receiver line is first pulled LOW for one clock cycle. This puts
//                                      the UART in REC_STATE_STRT state, and the transmission begins.
//                      REC_STATE_STRT: This is the state where the reciver performs the reception of the start bit. If the serial data input data line is LOW for
//                                      two clock cycles after completing the IDLE state transition period (one clock cycle), the start bit is received, the 
//                                      transmission is confirmed and the device goes into the data reception state. If the data line is pulled HIGH again, it 
//                                      means that there is no data to receive and the device goes back to the idle state REC_STATE_IDLE.
//                      REC_STATE_DATA: This is the data reception state. Two clock cycles are required to receive every bit. After all 8 bits are received, the 
//                                      receiver goes into the REC_STATE_STOP, where it receives the stop bit.
//                      REC_STATE_STOP: The receiver receives the stop bit in this state. It requires the serial data line to stay HIGH for two clock cycles to 
//                                      receive the stop bit. After completing the reception of stop bit, the receiverr decides which state tomove to. If there are
//                                      more bytes to transfer, the receiver goes to REC_STATE_STRT, where it has to receive the start bit for next transmission.
//                                      If there are no more bytes to transfer, the receiver goes back to REC_STATE_IDLE state.
//                  3). Pin Descriptions:
//                        clock          : Input clock signal obtained from the UART_Baud_Generator module that operates the receiver with the specified baud rate.
//                        bytes_to_rx    : This is a 10-bit input array, used to configure the amount of bytes of data that has to be received from the UART 
//                                         module. This is configured in real time by the driving device.
//                        serial_data_in : This is the serial data input to the receiver.
//                        rx_data_valid  : This output signal indicates whether the received byte of data is valid for processing by the driving device. Any 
//                                         number of new bytes.
//                        rx_data_byte   : This is the byte of data received by the driving device.

module UART_TX (clock, bytes_to_tx, tx_data_byte, tx_data_valid, /*tx_clk_ctr, tx_state, tx_bit_ctr, bytes_to_tx_reg,*/ serial_data_out);
    
    input             clock;
    input       [9:0] bytes_to_tx;
    input       [7:0] tx_data_byte;
    input             tx_data_valid;
    
//    output reg       tx_clk_ctr = 1'b 0;
//    output reg [2:0] tx_state = 3'b 0;
//    output reg [2:0] tx_bit_ctr = 3'b 111;
//    output reg [9:0] bytes_to_tx_reg     = 10'b 0;
    
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
