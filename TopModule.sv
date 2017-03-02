`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2017 02:49:22 AM
// Design Name: 
// Module Name: TopModule
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

module TopModule();

logic [BUSWIDTH-1:0] addr;
logic [BUSWIDTH-1:0] data;
logic RW, resetH, clk;

memArray_if Memarrif();
main_bus_if Busif(.clk, .resetH);
memory_if Mif(.main_bus_if(Busif), .memArray_if(Memarrif));
//Processor_If PIF(.main_bus_if(BusIf.master));
//mem m1(.main_bus_if(BusIf), .memArray_if(MemArrIf));
//CPU cpu(.Processor_If(PIF), .RW, .addr, .data);

//CPU_TestBench cpuTb(.clk, .RW, .resetH, .data);


endmodule
