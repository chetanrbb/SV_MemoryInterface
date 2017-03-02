`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2017 10:19:21 PM
// Design Name: 
// Module Name: Processor_If
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

// This interface connects the CPU with the BUS 
// This is responsible to generate the appropriate read/write signals on the bus
// 


interface Processor_If(main_bus_if.master MBif);

localparam BUSWIDTH = 16;
localparam DATAWIDTH = 16;
localparam BURST_LEN = 4;

enum bit
{
    S0,
    S1
}state = S0, nextState;

enum bit 
{
    WRITE = 0, 
    READ
}opr;

task Proc_WrReq (input bit [BUSWIDTH-1:0] addr, 
                       bit [DATAWIDTH-1:0] data);
    
    bit [3:0]  page;
    bit [11:0] baseAddr;
    logic [1:0] cnt;
    
    assign {page, baseAddr} = addr;
     
    case(state)
    S0: begin                        
        MBif.AddrData = {page, baseAddr};
        MBif.rw = WRITE;
        state = S1;
        end
        
    S1: @ (posedge MBif.clk)
        begin
            MBif.rw = READ;     // write pulse generated for one clock cycle
            MBif.AddrData = data;
            if(cnt < BURST_LEN)
                cnt++;
            else
            begin
                cnt = 0;
                state = S0;
            end               
        end    
    endcase                                         
endtask
                 
automatic task Proc_RdReq (input bit [BUSWIDTH-1:0] addr,  
                 output bit [DATAWIDTH-1:0]data);
    
     bit [3:0]page; 
    bit [11:0]baseAddr;
    
    assign {page, baseAddr} = addr;
    //logic state = '0;
    //logic [2:0] cnt = '0;
    
    //unique case(state) 
    //S0: begin
            MBif.AddrData = {page, baseAddr};
            MBif.rw = READ;     // read the data from the address mentioned
            //state = S1; 
    //    end
    //S1: begin
            repeat (BURST_LEN) @ (posedge MBif.clk)
                data = MBif.AddrData;       // read the data sent from the memory
//            if(cnt < BURST_LEN)
//                cnt++;
//                state = S1;
//            else 
//            begin
//                cnt = 0;
//                state = S0;
//            end 
      //  end 
    //endcase                                    
endtask                

endinterface 
