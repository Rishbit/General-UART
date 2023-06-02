`timescale 1ns / 1ps

//discription:      The transmitter continues to transmit data if the data_valid signal is HIGH, even if the amount of data to transmit has excedded the value
//              defined by the bytes_to_tx signal.


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
