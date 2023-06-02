`timescale 1ns / 1ps

module UART_Testbench;
    
    // Clock Input Signal
    reg clock;
    // Transmitter Signals
    reg  [9:0] tx_no_bytes;
    reg  [7:0] tx_data_byte;
    reg        tx_data_valid;
    wire       tx_ser_data_out;
    // Receiver Signals
    reg  [9:0] rx_no_bytes;
    reg        rx_ser_data_in;
    wire       rx_data_valid;
    wire [7:0] rx_data_byte;
    
    
    UART  #(11059200, 11059200/1) 
            uut (clock, tx_no_bytes, rx_no_bytes, tx_data_byte, rx_ser_data_in, tx_data_valid, rx_data_valid, tx_ser_data_out, rx_data_byte);
    
    
    initial begin
        clock <= 1'b 0;
        forever begin
            #50 clock <= ~clock;
        end
    end
    
    
    initial begin
        tx_no_bytes <= 3'b 001;
        rx_no_bytes <= 3'b 011;
    end
    
    
    initial begin
        tx_data_valid <= 1'b 0; #450
        tx_data_valid <= 1'b 1; #8000
        tx_data_valid <= 1'b 0;
    end
    
    
    initial begin
        tx_data_byte <= 8'b 00;  #450
        tx_data_byte <= 8'h ee;  #2000
        tx_data_byte <= 8'h 93;  #2000
        tx_data_byte <= 8'h d7;  #2000
        tx_data_byte <= 8'h b2;  #2000
        tx_data_byte <= 8'h a2;  #2000
        tx_data_byte <= 8'h 00;
    end
    
    
    initial begin
        repeat (1) begin
            rx_ser_data_in <= 1'b 1; #450   // IDLE state.
            rx_ser_data_in <= 1'b 0; #100   // Transitioning to START_BIT state.
            // Receiving Data Byte 1.
            rx_ser_data_in <= 1'b 0; #200   // Receiving start bit in START_BIT state and transitioning to DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 1 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 2 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 3 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 4 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 5 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 6 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 7 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 8 in DATA_BIT state and transitioning to STOP_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving stop bit in STOP_BIT state.
            // Receiving Data Byte 2.
            rx_ser_data_in <= 1'b 0; #200   // Receiving start bit in START_BIT state and transitioning to DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 1 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 2 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 3 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 4 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 5 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 6 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 7 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 8 in DATA_BIT state and transitioning to STOP_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving stop bit in STOP_BIT state.
            // Receiving Data Byte 3.
            rx_ser_data_in <= 1'b 0; #200   // Receiving start bit in START_BIT state and transitioning to DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 1 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 2 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 3 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 4 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 5 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 6 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 7 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 8 in DATA_BIT state and transitioning to STOP_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving stop bit in STOP_BIT state.
            // Receiving Data Byte 4.
            rx_ser_data_in <= 1'b 0; #200   // Receiving start bit in START_BIT state and transitioning to DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 1 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 2 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 3 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 4 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 5 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 6 in DATA_BIT state.
            rx_ser_data_in <= 1'b 1; #200   // Receiving data bit 7 in DATA_BIT state.
            rx_ser_data_in <= 1'b 0; #200   // Receiving data bit 8 in DATA_BIT state and transitioning to STOP_BIT state.
            rx_ser_data_in <= 1'b 1;        // Receiving stop bit in STOP_BIT state.
        end
    end

endmodule
