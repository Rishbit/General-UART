`timescale 1ns / 1ps

// Description  :   1). General Description:
//                          This is the receiver module for the N-Byte UART. It has the ability to receive a specified number of bytes from an external register.
//                      In order to recive N bytes, the user specifies an input as (N-1) to a seperate line, before transmitting data. The module has the ability
//                      to receive any number of bytes ranging from 1 to 1024. Followed by the start bit, M.S.B. is received first followed by other data bits 
//                      uptill the L.S.B. and the stop bit.
//                          It takes two clock cycles to receive a single bit of data. It takes an aditional one clock cycle to wake up the UART from idle state.
//                      The receiver can be woken up from idle state by pulling the line LOW for one clock cycle. This is followed by a start bit spanning for two
//                      clock cycles, followed by 8 data bits and the stop bit, marked by pulling the line HIGH for two clock cycles. If there are more bytes to
//                      be received, a start bit is sent again and the process continues until all the bytes are received. After all the bytes are receiveded, the
//                      receiver goes back to idle state.
//                  2). State Descriptions:
//                      REC_STATE_IDLE: The receiver is idle in this state, which means that no activities are being performed, and the receiver is awaiting a
//                                      data to receive. In order to begin transmission, the receiver line is first pulled LOW for one clock cycle. This puts the
//                                      UART in REC_STATE_STRT state, and the reception begins.
//                      REC_STATE_STRT: This is the state where the reciver performs the reception of the start bit. If the serial data input data line is LOW for
//                                      two clock cycles after completing the IDLE state transition period (one clock cycle), the start bit is received, the 
//                                      transmission is confirmed and the device goes into the data reception state. If the data line is pulled HIGH again, it 
//                                      means that there is no data to receive and the device goes back to the idle state REC_STATE_IDLE.
//                      REC_STATE_DATA: This is the data reception state. Two clock cycles are required to receive every bit. After all 8 bits are received, the 
//                                      receiver goes into the REC_STATE_STOP, where it receives the stop bit.
//                      REC_STATE_STOP: The receiver receives the stop bit in this state. It requires the serial data line to stay HIGH for two clock cycles to 
//                                      receive the stop bit. After completing the reception of stop bit, the receiverr decides which state tomove to. If there are
//                                      more bytes to receive, the receiver goes to REC_STATE_STRT, where it has to receive the start bit for next transmission.
//                                      If there are no more bytes to receive, the receiver goes back to REC_STATE_IDLE state.
//                  3). Pin Descriptions:
//                        clock          : Input clock signal obtained from the UART_Baud_Generator module that operates the receiver with the specified baud rate.
//                        bytes_to_rx    : This is a 10-bit input array, used to configure the amount of bytes of data that has to be received from the UART 
//                                         module. This is configured in real time by the driving device.
//                        serial_data_in : This is the serial data input to the receiver.
//                        rx_data_valid  : This output signal indicates whether the received byte of data is valid for processing by the driving device.
//                        rx_data_byte   : This is the byte of data received by the driving device.


module UART_RX (clock, bytes_to_rx, serial_data_in, rx_data_valid, rx_data_byte);
    
    input            clock;
    input      [9:0] bytes_to_rx;
    input            serial_data_in;
    
    output reg       rx_data_valid;
    output reg [7:0] rx_data_byte;
    
    localparam REC_STATE_IDLE = 2'b 00;
    localparam REC_STATE_STRT = 2'b 01;
    localparam REC_STATE_DATA = 2'b 10;
    localparam REC_STATE_STOP = 2'b 11;
    
    reg       rx_clk_ctr        = 1'b  0;
    reg [2:0] bytes_to_rx_reg   = 10'b 0;
    
    reg [1:0] rx_state          = REC_STATE_IDLE;
    reg [2:0] rx_bit_ctr        = 3'b 0;
    
    reg [1:0] rx_clk_div_ctr    = 2'b 0;
    reg [7:0] rx_data_byte_reg  = 8'b 0;
    
    
    always @(posedge clock) begin
        case (rx_state)
            REC_STATE_IDLE  :   begin
                                    rx_clk_ctr      <= 1'b 0;
                                    rx_bit_ctr      <= 3'b 111;
                                    rx_data_valid   <= 1'b 0;
                                    bytes_to_rx_reg <= bytes_to_rx;
                                    
                                    if (serial_data_in == 1'b 0)
                                        rx_state <= REC_STATE_STRT;
                                    else
                                        rx_state <= REC_STATE_IDLE;
                                end
            REC_STATE_STRT  :   begin
                                    rx_data_valid <= 1'b 0;
                                    
                                    if (rx_clk_ctr == 1'b 0) begin
                                        rx_clk_ctr <= rx_clk_ctr + 1'b 1;
                                        rx_state   <= REC_STATE_STRT;
                                    end
                                    else begin
                                        if (serial_data_in == 1'b 0) begin
                                            rx_clk_ctr  <= 1'b 0;
                                            rx_state    <= REC_STATE_DATA;
                                        end
                                        else
                                            rx_state <= REC_STATE_IDLE;
                                    end
                                end
            REC_STATE_DATA  :   begin
                                    rx_data_valid <= 1'b 0;
                                    
                                    if (rx_clk_ctr == 1'b 0) begin
                                        rx_clk_ctr <= rx_clk_ctr + 1'b 1;
                                        rx_state   <= REC_STATE_DATA;
                                    end
                                    else begin
                                        rx_clk_ctr                   <= 1'b 0;
                                        rx_data_byte_reg[rx_bit_ctr] <= serial_data_in;
                                        
                                        if (rx_bit_ctr > 3'b 000) begin
                                            rx_bit_ctr  <= rx_bit_ctr - 3'd 001;
                                            rx_state    <= REC_STATE_DATA;
                                        end
                                        else begin
                                            rx_bit_ctr   <= 3'b 111;
                                            rx_state     <= REC_STATE_STOP;
                                        end
                                    end
                                end
            REC_STATE_STOP  :   begin
                                    if (rx_clk_ctr == 1'b 0) begin
                                        rx_data_valid <= 1'b 0;
                                        rx_clk_ctr    <= rx_clk_ctr + 1'b 1;
                                        rx_state      <= REC_STATE_STOP;
                                    end
                                    else begin
                                        rx_data_byte  <= rx_data_byte_reg;
                                        rx_data_valid <= 1'b 1;
                                        rx_clk_ctr    <= 1'b 0;
                                        
                                        if ((bytes_to_rx_reg > 10'b 0) && (bytes_to_rx_reg <= bytes_to_rx)) begin
                                            bytes_to_rx_reg <= bytes_to_rx_reg - 3'b 001;
                                            rx_state        <= REC_STATE_STRT;
                                        end
                                        else
                                            rx_state        <= REC_STATE_IDLE;
                                    end
                                end
        endcase
    end
    
endmodule
