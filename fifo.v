module fifo #(ADDR_WIDTH = 5,
             DATA_WIDTH =8)
  (input [DATA_WIDTH-1:0] data_in,
  
   output reg [DATA_WIDTH-1:0] data_out,
   input clk_read,
   input rst,
   input clk_write,
   input Read_enable,
   input Wr_enable,
   output empty_flag,
  output   full_flag
  );
  wire empty_flag,full_flag;
  reg [ADDR_WIDTH:0] write_ptr;
  reg [ADDR_WIDTH:0] read_ptr,read_syn1,read_syn2,write_syn1,write_syn2;
  wire [ADDR_WIDTH:0] read_ptr_grey,read_ptr_binary;
  wire [ADDR_WIDTH:0] write_ptr_grey,write_ptr_binary;

  reg [DATA_WIDTH-1:0] mem [(2**(ADDR_WIDTH )-1):0];  
 
  always @(posedge clk_write or negedge rst) begin
      if(!rst) begin
        write_ptr=0;
      end
      else begin
          if( Wr_enable == 1 && full_flag != 1'b1 ) begin
              mem[write_ptr[ADDR_WIDTH-1:0]] <= data_in;
              write_ptr <= write_ptr+1;
            end
           
            else 
                write_ptr <= write_ptr;
      end          
  end
  always @(posedge clk_read or negedge rst) begin
      if(!rst) begin
        read_ptr=0;
      end
      else begin
          
        if( Read_enable == 1 && empty_flag != 1'b1 ) begin
          data_out <= mem[read_ptr[ADDR_WIDTH-1:0]];
          read_ptr <= read_ptr+1;
        end
        
        else
            read_ptr <= read_ptr;
      end      
  end
  
  // read pointer synchronizer
  always @(clk_read) begin
    read_syn1<= read_ptr_grey;
    read_syn2<=read_syn1;   
    
  end
  // read pointer synchronizer
  always @(clk_write) begin
    write_syn1<= write_ptr_grey;
    write_syn2<=write_syn1;   
    
  end
  
  
  //binary to grey code
  assign read_ptr_grey = read_ptr^(read_ptr >>1);
  assign write_ptr_grey = write_ptr ^(write_ptr >>1);
  
  
  
  // grey to binary
  assign read_ptr_binary = read_syn2 ^(read_syn2>>1) ^ (read_syn2 >>2) ^ (read_syn2>>3) ^ (read_syn2 >>4); 
  assign write_ptr_binary = write_syn2 ^(write_syn2>>1) ^ (write_syn2 >>2) ^ (write_syn2>>3) ^ (write_syn2 >>4);
  
  //full and empty flags
  assign full_flag = ((write_ptr[ADDR_WIDTH] !=  read_ptr_binary[ADDR_WIDTH]) && 
                      (write_ptr[ADDR_WIDTH-1:0] ==  read_ptr_binary[ADDR_WIDTH-1:0]))? 1:0;
  assign empty_flag = (read_ptr == write_ptr_binary)? 1:0;
  
  
  
  
endmodule  