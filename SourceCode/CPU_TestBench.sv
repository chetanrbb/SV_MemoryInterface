`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2017 03:01:34 AM
// Design Name: 
// Module Name: CPU_TestBench
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

module CPU_TestBench();

logic clk = 0, resetH = 0, RW = 0;
logic [BUSWIDTH-1:0] data, addr;

initial
begin
    clk = 0;
    forever #5ns clk = ~clk;
end

initial
begin
    resetH = 1;
    data = '0;
    addr = '0;
    repeat (5) @ (posedge clk); resetH = 0;
    
    // read data from memory 
    addr = 16'h10;
    repeat (5) @ (posedge clk);
    $display("%d, %d", addr, data);
end

endmodule
