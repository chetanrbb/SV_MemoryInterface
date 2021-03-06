`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2017 04:12:48 PM
// Design Name: 
// Module Name: memory_if
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

// This interface connects the bus with the memory array interface
// The memory array interface (MIF) is used to connect the memory_interface with the memory
// MIF- controls the signal ADDR, DATAOUT, rdEN, wrEN
// MIF- receives the DATAIN from teh memory module 
// This interface is programmed to write/read only one data at a time

// The main bus interface is used to control the signals like ADDRDATA, RW, ADDRVALID, CLK, RESETH
// These signals are generated by the processor interface which controls the read and write 
// 
// MIF: ADDR, DATAOUT, DATAIN, RDEN, WREN
// BIF: ADDRDATA, RW, ADDRVALID, CLK, RESETH

interface memory_if #(parameter BURST_LEN = 4, parameter PAGE = 4'h2) 
          (main_bus_if.slave Bus_if, memArray_if MIF);

parameter ADDRWIDTH = 16, DATAWIDTH = 16;

// Enum 
enum logic [1:0]{
    IDLE  = 2'd0, 
    READ  = 2'd1, 
    WRITE = 2'd2
}state = IDLE, nextState = IDLE;    // Initialize the state variables 

// Variables 
logic rdEn = 0, wrEn = 0;                           // variables to store the read/write signals  
logic [ADDRWIDTH-1:0] addr = '0, baddr = '0;    // variable used to store the address received from the bus 
logic [DATAWIDTH-1:0] wData = '0;               // variable used to send data to memory from CPU
logic [BURST_LEN-1:0] cnt = '0;                 // variable for counting the burst length
logic                 wrEn, rdEn;               

// Assignment  
assign MIF.MemIF.DataIn = (MIF.wrEn == 1)?(wData):('z);     // Write- Write data from CPU to memory     
assign Bus_if.AddrData = (MIF.rdEn == 1)?(MIF.DataOut):('z);    // Read- Data from memory to CPU
assign MIF.MemIF.Addr = addr;
assign MIF.MemIF.rdEn = rdEn;
assign MIF.MemIF.wrEn = wrEn;

// Procedrual Block 
always_ff @(posedge Bus_if.clk, posedge Bus_if.resetH)
begin
	if(Bus_if.resetH == 1)		// on reset initialize all the registers to default values 
	begin
	  state <= IDLE;		// stay in the idle state and wait for the address and R/W# signal 
	  addr  <= 0;		// Clear the address on reset 
	  wData <= 0;		// Clear the contents of the data to be written in memory 
	end
	else
	begin
	  state <= nextState; 	// go to the next state 
	  addr  <= baddr;	// update the address 
	  wData <= Bus_if.AddrData;	// write the given data 
	end
end

always_comb
begin
	case(state)			// 
	IDLE: begin
		      rdEn = 0;		 
		      wrEn = 0;
		      if((Bus_if.AddrValid == 1) && (Bus_if.AddrData[15:12] == PAGE))	// the address is available
		      begin
		          baddr  = Bus_if.AddrData;	// read the address
		          nextState = (Bus_if.rw == 1) ? (READ) : (WRITE);	// 
		      end
		      else
		      begin
		          nextState = IDLE;	 
		          baddr = baddr;		
		      end
		  end

// the AddrData - addr is stored in the baddr 
// on the clock edge it is transferred to the addr 
// this address addr is then read
// Read the data sent req from the memory 
	READ:  begin
		       rdEn = 1;	// Set the read enable signal flag
		       baddr = MIF.MemIF.Addr;	// read from the given address 
		       baddr = baddr + 1;	// increment the address for the next read
		       if(cnt < BURST_LEN)    // check if the burst length is over or not 
		          nextState = READ;	// read the 2nd data
		       else
		          nextState = IDLE; 
		   end

    WRITE: begin
               wrEn = 1;
               baddr = MIF.MemIF.Addr;	// write in the given address location 
               baddr = baddr + 1;    // increment the address location for the next write
               if(cnt < BURST_LEN)  // check if the burst length is over or not 
                  nextState = WRITE;
               else
                  nextState = IDLE;
           end
    endcase 
end
endinterface
