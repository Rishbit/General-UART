`timescale 1ns / 1ps

// Description          :     The BaudGenerator.v is used to divide the system clock by a factor necessary to obtain the required parameter. The module uses two parameters
//              SYSTM_OPERN_FREQ and REQD_BAUD_RATE to calculate the division factor. Then the system clock is divided by the calculated factor and the output is
//              provided to generate the baud clock.
// Parameter Description:
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
