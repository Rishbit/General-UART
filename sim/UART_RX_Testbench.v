`timescale 1ns / 1ps

module UART_RX_Testbench;
    
    reg        clock, serial_data_in;
    reg  [9:0] bytes_to_rx;
    
//    wire       rx_clk_ctr;
//    wire [1:0] rx_state;
//    wire [2:0] rx_bit_ctr;
//    wire [9:0] bytes_to_rx_reg;
//    wire [7:0] rx_data_byte_reg;
    
    wire       rx_data_valid;
    wire [7:0] rx_data_byte;
    
    
    UART_RX  uut (clock, bytes_to_rx, serial_data_in, /*rx_clk_ctr, rx_state, rx_bit_ctr, rx_data_byte_reg, bytes_to_rx_reg,*/ rx_data_valid, rx_data_byte);
    
    
    initial begin
        bytes_to_rx <= 3'b 011;
    end
    
    
    initial begin
        clock <= 1'b 1;
        forever begin
            #50 clock <= ~clock;
        end
    end
    
    
    initial begin
        repeat (1) begin
            serial_data_in <= 1'b 1; #400   // IDLE state.
            // Receiving Data Byte 1.
            serial_data_in <= 1'b 0; #100   // Transitioning to START_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving start bit in START_BIT state and transitioning to DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 1 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 2 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 3 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 4 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 5 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 6 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 7 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 8 in DATA_BIT state and transitioning to STOP_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving stop bit in STOP_BIT state.
            // Receiving Data Byte 2.
            //serial_data_in <= 1'b 0; #100   // Transitioning to START_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving start bit in START_BIT state and transitioning to DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 1 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 2 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 3 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 4 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 5 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 6 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 7 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 8 in DATA_BIT state and transitioning to STOP_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving stop bit in STOP_BIT state.
            // Receiving Data Byte 3.
            //serial_data_in <= 1'b 0; #100   // Transitioning to START_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving start bit in START_BIT state and transitioning to DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 1 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 2 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 3 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 4 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 5 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 6 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 7 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 8 in DATA_BIT state and transitioning to STOP_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving stop bit in STOP_BIT state.
            // Receiving Data Byte 4.
            //serial_data_in <= 1'b 0; #100   // Transitioning to START_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving start bit in START_BIT state and transitioning to DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 1 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 2 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 3 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 4 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 5 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 6 in DATA_BIT state.
            serial_data_in <= 1'b 1; #200   // Receiving data bit 7 in DATA_BIT state.
            serial_data_in <= 1'b 0; #200   // Receiving data bit 8 in DATA_BIT state and transitioning to STOP_BIT state.
            serial_data_in <= 1'b 1;        // Receiving stop bit in STOP_BIT state.
        end
    end
    
endmodule
