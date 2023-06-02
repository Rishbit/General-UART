`timescale 1ns / 1ps

module UART_TX_Testbench;
    
    reg       clock;
    reg [9:0] bytes_to_tx;
    reg [7:0] tx_data_byte;
    reg       tx_data_valid;
    
    wire      serial_data_out;
    
//    wire [9:0] bytes_to_tx_reg;
//    wire       tx_clk_ctr;
//    wire [2:0] tx_state;
//    wire [2:0] tx_bit_ctr;
    
    
    UART_TX uut (clock, bytes_to_tx, tx_data_byte, tx_data_valid, /*tx_clk_ctr, tx_state, tx_bit_ctr, bytes_to_tx_reg,*/ serial_data_out);
    
    
    initial begin
        bytes_to_tx <= 3'b 011;
    end
    
    
    initial begin
        tx_data_valid <= 1'b 0; #400
        tx_data_valid <= 1'b 1; #6000
        tx_data_valid <= 1'b 0;
    end
    
    
    initial begin
        clock <= 1'b 1;
        forever begin
            #50 clock <= ~clock;
        end
    end
    
    
    initial begin
        tx_data_byte <= 8'b 0;   #400
        tx_data_byte <= 8'h ee;  #2000
        tx_data_byte <= 8'h 93;  #2000
        tx_data_byte <= 8'h d7;  #2000
        tx_data_byte <= 8'h b2;
    end
    
endmodule
