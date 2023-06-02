`timescale 1ns / 1ps

// Description  :   1). General Description:
//                          This is the receiver module for the N-Byte UART. It has the ability to receive a specified number of bytes from an external
//                      register. In order to recive N bytes, the user specifies an input as (N-1) to a seperate line, before transmitting data. The module
//                      has the ability to receive any number of bytes ranging from 1 to 1024. Followed by the start bit, M.S.B. is received first followed by
//                      other data bits uptill the L.S.B. and the stop bit.
//                          It takes two clock cycles to receive a single bit of data. It takes an aditional one clock cycle to wake up the UART from idle
//                      state. The receiver can be woken up from idle state by pulling the line LOW for one clock cycle. This is followed by a start bit
//                      spanning for two clock cycles, followed by 8 data bits and the stop bit, marked by pulling the line HIGH for two clock cycles. If
//                      there are more bytes to be received, a start bit is sent again and the process continues until all the bytes are transferred. After
//                      all the bytes are transferred, the receiver goes back to idle state.
//                  1). State Descriptions:
//                      REC_STATE_IDLE: The receiver is idle in this state, which means that no activities are being performed, and the receiver is awaiting a
//                                      data to receive. In order to begin transmission, the receiver line is first pulled LOW for one clock cycle. This puts
//                                      the UART in REC_STATE_STRT state, and the transmission begins.
//                      REC_STATE_STRT: 
//                      REC_STATE_DATA:
//                      REC_STATE_STOP:
// Revision     :   1). Designed the core functionlity of the UART's receiver. This revision simply receives the 8-bit data, with no start/stop bits.
//                  2). Added the start and stop bit functinalities using the F.S.M. approach.
//                  3). Made an upgrade to the revision 2 UART_RX itself, in order to enable the UART to receive any number of desired bytes, rather than
//                      creating the simple 8-bit UART_RX and making it run for the desired number of bytes from the top module.
// Further Work :   1). Add the functionalities of start and stop bits to the design. (DONE).
//                  2). Work on the UART_TX module in the similar fashion.
// Path         :       Create an F.S.M. to add the IDLE, START, DATA and STOP states. Every data bit is maintained for 2 clock cycles to
//                      ensure correct receipt


module UART_RX (clock, bytes_to_rx, serial_data_in, /*rx_clk_ctr, rx_state, rx_bit_ctr, rx_data_byte_reg, bytes_to_rx_reg,*/ rx_data_valid, rx_data_byte);
    
    input            clock;
    input      [9:0] bytes_to_rx;
    input            serial_data_in;
    
//    output reg       rx_clk_ctr        = 1'b 0;
//    output reg [1:0] rx_state          = 1'b 0;
//    output reg [2:0] rx_bit_ctr        = 3'b 0;
//    output reg [9:0] bytes_to_rx_reg   = 10'b 0;
//    output reg [7:0] rx_data_byte_reg  = 8'b 0;
    
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
