`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 05:51:57 PM
// Design Name: 
// Module Name: sim_tb_top
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


module sim_tb_top();
 	logic              APB_hbm_reset;
	logic              HBM_REF_CLK_0;
    logic             APB_0_PCLK;
    logic             AXI_ACLK;                                  // Clock signal
    logic             AXI_ARESET_N;                                  // Reset signal
	logic write_enable [16];
	logic read_enable [16];
	logic [255:0] write_data [16];
	logic [33:0] write_address [16];
	logic [33:0] read_address [16];	

int addr, i, j;
////////////////////////////////////////////////////////////////////////////////
// Generating 100MHz REF clock
////////////////////////////////////////////////////////////////////////////////
initial HBM_REF_CLK_0 = 1'b0;
always HBM_REF_CLK_0 = #5000.00 ~HBM_REF_CLK_0;

////////////////////////////////////////////////////////////////////////////////
// Generating 100MHz APB clock and Reset
////////////////////////////////////////////////////////////////////////////////
initial APB_0_PCLK = 1'b0;
always APB_0_PCLK = #(10000/2.0) ~APB_0_PCLK;
////////////////////////////////////////////////////////////////////////////////
// Generating AXI clock
////////////////////////////////////////////////////////////////////////////////
initial AXI_ACLK = 1'b0;
always AXI_ACLK = #(2222/2.0) ~AXI_ACLK;

initial begin
  APB_hbm_reset = 1'b0;
  #200ns;
  APB_hbm_reset = 1'b0;
  #4500ns;
  APB_hbm_reset = 1'b1;
end

initial begin
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b0;
      write_data[i] = '0;       
      write_address[i] = '0;   
      read_address[i] = '0;     
  end
  AXI_ARESET_N = 1'b0;
  #200ns;
  AXI_ARESET_N = 1'b0;
  #4500ns;
  AXI_ARESET_N = 1'b1;
  #55us;
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = '1;       
      write_address[i] = 34'h0_0000_0000 + (i * 34'h0_2000_0000);     
  end  
  #2222;
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4920;
      write_address[i] = 34'h0_0000_0020 + (i * 34'h0_2000_0000);
  end
  #2222;
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4921;
      write_address[i] = 34'h0_0000_0040 + (i * 34'h0_2000_0000);
  end
  #2222;
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4922;
      write_address[i] = 34'h0_0000_0060 + (i * 34'h0_2000_0000);
  end
  #2222;  
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4923;
      //write_address[i] = 34'h0_0000_0080 + (i * 34'h0_2000_0000);
  end
  #2222; 
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4924;
      write_address[i] = 34'h0_0000_00a0 + (i * 34'h0_2000_0000);
  end
  #2222;  
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4925;
      write_address[i] = 34'h0_0000_00c0 + (i * 34'h0_2000_0000);
  end
  #2222; 
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4926;
      write_address[i] = 34'h0_0000_00e0 + (i * 34'h0_2000_0000);
  end
  #2222;   
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4927;
      write_address[i] = 34'h0_0000_0100 + (i * 34'h0_2000_0000);
  end
  #2222;    
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4928;
      write_address[i] = 34'h0_0000_0120 + (i * 34'h0_2000_0000);
  end
  #2222;  
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4929;
      write_address[i] = 34'h0_0000_0140 + (i * 34'h0_2000_0000);
  end
  #2222;  
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4930;
      write_address[i] = 34'h0_0000_0160 + (i * 34'h0_2000_0000);
  end
  #2222;  
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4931;
      write_address[i] = 34'h0_0000_0180 + (i * 34'h0_2000_0000);
  end
  #2222;  
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4932;
      write_address[i] = 34'h0_0000_01a0 + (i * 34'h0_2000_0000);
  end
  #2222;
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4933;
      write_address[i] = 34'h0_0000_01c0 + (i * 34'h0_2000_0000);
  end
  #2222;    
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b1;
      write_data[i] = 256'h4934;
      write_address[i] = 34'h0_0000_01e0 + (i * 34'h0_2000_0000);
  end
  #2222;  
  for (i = 0; i < 16; i = i + 1) begin
      write_enable[i] = 1'b0;
  end      
  #(2222*17);
  for (i = 0; i < 16; i = i + 1) begin
      read_enable[i] = 1'b1;
      read_address[i] = 34'h0_0000_0000 + (i * 34'h0_2000_0000);    
  end        
  #2222;
  /*
  for (i = 0; i < 16; i = i + 1) begin
      read_enable[i] = 1'b1;
      read_address[i] = 34'h0_0000_0200 + (i * 34'h0_2000_0000);    
  end        
  #2222;  */
  for (i = 0; i < 16; i = i + 1) begin
      read_enable[i] = 1'b0;
  end      
  
  #2222;  
  #55us;
end

top top
(
    .APB_hbm_reset(APB_hbm_reset),
    .HBM_REF_CLK_0(HBM_REF_CLK_0),
    .APB_0_PCLK(APB_0_PCLK),
    .AXI_ACLK(AXI_ACLK),
    .AXI_ARESET_N(AXI_ARESET_N),
	.write_enable(write_enable),
	.read_enable(read_enable),
	.write_data(write_data),
	.write_address(write_address),
	.read_address(read_address)	
);
endmodule
