`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2017 06:06:05 PM
// Design Name: 
// Module Name: MemPkg
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


package MemPkg;

localparam ADDRWIDTH = $clog2(MEMDEPTH);
localparam DATAWIDTH = 16;

enum 
{
	IDLE,
	READ_D1,
	READ_D2, 
	READ_D3,
	READ_D4,
	WRITE_D1,
	WRITE_D2,
	WRITE_D3,
	WRITE_D4
};

endpackage
