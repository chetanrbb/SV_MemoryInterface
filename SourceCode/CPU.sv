`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2017 02:26:04 AM
// Design Name: 
// Module Name: CPU
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

import mcDefs::*;

module CPU(
    Processor_if PIF, 
    input RW, [BUSWIDTH-1:0]addr, 
    inout [BUSWIDTH-1:0]data
);
    
wire [BUSWIDTH-1:0]wData;

assign data = (RW)?(wData):('z);

    
always_comb
begin
if(RW == 0) // read 
    PIF.Proc_RdReq(addr, wData);
else
    PIF.Proc_WrReq(addr, data);
end    
endmodule
