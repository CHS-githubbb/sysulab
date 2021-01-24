`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/24 00:18:48
// Design Name: 
// Module Name: Selector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Selector(
        input CLK,
        input Reset,
        output reg[3:0] AN
    );
    parameter SETTIME = 100000;
    reg[16:0] counter;
    
    initial begin
        counter <= 0;
        AN      <= 4'b0111;
    end

    always@(posedge CLK)
        begin
        if(Reset == 1)
        begin
          counter <= 0;
          AN      <= 4'b0000;
        end else 
        begin
            counter <= counter + 1;
            if(counter == SETTIME)
                begin
                counter <= 0;
                case(AN)
                    4'b1110:    begin
                        AN <= 4'b1101;
                    end
                    4'b1101:    begin
                        AN <= 4'b1011;
                    end
                    4'b1011:    begin
                        AN <= 4'b0111;
                    end
                    4'b0111:    begin
                        AN <= 4'b1110;
                    end
                    4'b0000:    begin
                        AN <= 4'b0111;
                   end
                endcase
            end
        end
    end
endmodule
