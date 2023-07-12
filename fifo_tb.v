`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2023 10:33:18 AM
// Design Name: 
// Module Name: fifo_tb
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


module fifo_tb;
	parameter ADDR_WIDTH = 5;
    parameter DATA_WIDTH =8;
  	reg [DATA_WIDTH-1:0] data_in;
  	reg clk_read,clk_write,Read_enable,Wr_enable,rst;
    wire [DATA_WIDTH-1:0] data_out;
    wire empty_flag,full_flag;
    fifo dut(.data_in(data_in),.data_out(data_out),.rst(rst),.clk_read(clk_read),.clk_write(clk_write)
           ,.Read_enable(Read_enable),.empty_flag(empty_flag),.full_flag(full_flag),.Wr_enable(Wr_enable));
  
  integer i ;
    
 

initial begin
      clk_write=0;
      clk_read=0;
      Wr_enable=0;
      Read_enable=0;
      rst=1; #5;
      rst=0; #5;
      rst= 1; #5;
end
  
  always begin
        #4;	clk_write <= ~clk_write; 
    end
	always begin
      	clk_read <= ~clk_read;  #5;
    end
 
initial begin

  	
  	/*Reading while the fifo is empty*/ 
  	 Read_enable =1 ; #8;
  	 Read_enable =0;  
  	/*writing 2 words then reading them*/
     Wr_enable =1;  
  	 data_in =8;   #8;  //#5;
     Wr_enable =0;  #8;  
     Wr_enable =1;  
  	 data_in = 9;   #8;//#5;
     Wr_enable =0;  #8;  
     Read_enable =1 ; #24;
     Read_enable =0;
  	 for( i =0; i<(2**(ADDR_WIDTH )) ; i=i+1) begin
  	    Wr_enable =1;  
  	    data_in = i;   #8;
        Wr_enable =0;  #8; 
  	end
  	    
           Read_enable =1 ; #500;
 
 $finish;
end





endmodule