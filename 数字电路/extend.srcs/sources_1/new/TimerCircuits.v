`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/22 17:50:28
// Design Name: 
// Module Name: TimerCircuits
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


module TimerCircuits(LongTrig, ShortTrig, PTrig, Clk, TS, TL, TP);
   input      LongTrig;     
   input      ShortTrig;
   input      PTrig;
   input      Clk;
   output  reg  TS;
   output  reg  TL;
   output  reg  TP;
   
   reg [4:0] SetCountLong;    
   reg [4:0] SetCountShort;
   reg [4:0] SetCountP;
   
   reg [4:0] count1;    
   reg [4:0] count2;
   reg [4:0] count3;
   
   
   initial 
       begin 
            SetCountLong<=25; SetCountShort<=4; SetCountP<=15;
            count1<=0; count2<=0; count3<=0;
            TS <= 0; TL <= 0; TP <= 0;
       end       
       always @( ShortTrig  or LongTrig or PTrig)
       begin   
            TS <=  ShortTrig & 1'b1; TL <=LongTrig & 1'b1; TP<=PTrig & 1'b1;
       end       
       always@(posedge  Clk  )
       begin    
            if( ShortTrig) 
                if(count1<SetCountShort)
                    count1 <= count1 + 1 ;
                else
                    begin   
                        count1 <= 0; TS <= 0;      
                    end     
            else if (LongTrig)
                 if(count2<SetCountLong)
                    count2 <= count2 + 1;
                 else
                     begin   
                         count2 <= 0; TL <= 0;      
                     end
             else if (PTrig)
                  if(count3<SetCountP)
                     count3 <= count3 + 1;
                  else
                      begin
                          count3 <= 0; TP <= 0;
                      end
        end         
endmodule
