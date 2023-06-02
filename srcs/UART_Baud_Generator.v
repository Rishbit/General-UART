`timescale 1ns / 1ps

// Description:     1). General Description:
//                          This module is used to divide the system clock by a factor necessary to obtain the required parameter. The module uses two parameters 
//                      SYSTM_OPERN_FREQ and REQD_BAUD_RATE to calculate the division factor. Then the system clock is divided by the calculated factor and the
//                      output is provided to generate the baud clock. The division factor is calculateed in the local parameter CLOCK_DIV_COUNT. This count is
//                      stored in "baud_ctr", which is used to divide the input clock signal.
//                          The module only supports baud rates that make up an even division factor. Odd division factor producing baud rates produce an inverted
//                      clock, that could produce un-expected results. For 11059200 baudrate, which produces an odd division factor (division factor 1), there 
//                      exists a special case where the system clock signal is directly passed on to the output.
//                  2). Parameter Descriptions:
//                          The module receives two parameters viz., SYSTM_OPERN_FREQ, REQD_BAUD_RATE. These parameters are configured from the respective values 
//                      provided by the UART Top Module and their functionalities.
//                  3). Pin Descriptions:
//                      1). systm_clock_in : This is the input clock signal on which the driver system works.
//                      2). baud_clock_out : This is the output clock signal needed to generate the required baudrate.

module UART_Baud_Generator #(parameter SYSTM_OPERN_FREQ = 11059200, parameter REQD_BAUD_RATE = 9600) (systm_clock_in, baud_clock_out);
    
    input  systm_clock_in;
    output baud_clock_out;
    
    localparam  CLOCK_DIV_COUNT     = (SYSTM_OPERN_FREQ / REQD_BAUD_RATE) - 1;
    
    reg         baud_clock_out_reg  = 1'b 0;
    reg [12:0]  baud_ctr            = CLOCK_DIV_COUNT;
    
    
    always @(posedge systm_clock_in or negedge systm_clock_in) begin
        case (REQD_BAUD_RATE)
            11059200    :   baud_clock_out_reg <= systm_clock_in;
            default     :   begin
                                if (baud_ctr == 12'b 0) begin
                                    baud_ctr            <= CLOCK_DIV_COUNT;
                                    baud_clock_out_reg  <= ~baud_clock_out_reg;
                                end
                                else
                                    baud_ctr <= baud_ctr - 1'b 1;
                            end
        endcase
    end
    
    
    assign baud_clock_out = baud_clock_out_reg;
    
endmodule
