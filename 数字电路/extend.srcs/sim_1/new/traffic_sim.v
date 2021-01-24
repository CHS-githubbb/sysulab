`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/22 21:16:38
// Design Name: 
// Module Name: traffic_sim
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


module traffic_sim(

    );
    reg VSin, Pin, Nin, Ein, Clksys; 
    wire MR,MY,MG,SR,SY,SG;
    //TrafficLights(VSin, Pin, Nin, Ein, Clkin, MR, SR, MY, SY, MG, SG);
    TrafficLights  TrafficLights (.VSin(VSin),.Pin(Pin),.Nin(Nin),.Ein(Ein),.Clkin(Clksys),.MR(MR),.SR(SR),.MY(MY),.SY(SY),.MG(MG),.SG(SG));
    initial 
        begin 
            Clksys=0; VSin=0; Pin=0; Nin=0; Ein=0;
        end
    always @(*)
        #10  Clksys <=~Clksys;
    always @(*)
        #8000 Ein<=~Ein;   
    always @(*)
        #3000 VSin<=~VSin;
    always @(*)
        #5000 Pin<=~Pin;

     
endmodule
