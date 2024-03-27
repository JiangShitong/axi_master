module axi_master_control_16 (
    input  AXI_ACLK,                                  // Clock signal
    input  AXI_ARESET_N,                                  // Reset signal
    output logic [33:0] AXI_ARADDR [16],            // Read data addresses
    output logic [1:0] AXI_ARBURST [16],            // Read burst types
    output logic [5:0] AXI_ARID [16],               // Read IDs
    output logic [3:0] AXI_ARLEN [16],              // Read transfer lengths
    output logic [2:0] AXI_ARSIZE [16],             // Read transfer sizes
    output logic AXI_ARVALID [16],                  // Read address valid signals
    output logic [33:0] AXI_AWADDR [16],            // Write data addresses
    output logic [1:0] AXI_AWBURST [16],            // Write burst types
    output logic [5:0] AXI_AWID [16],               // Write IDs
    output logic [3:0] AXI_AWLEN [16],              // Write transfer lengths
    output logic [2:0] AXI_AWSIZE [16],             // Write transfer sizes
    output logic AXI_AWVALID [16],                  // Write address valid signals
    output logic AXI_RREADY [16],                   // Read response ready signals
    output logic AXI_BREADY [16],                   // Write response ready signals
    output logic [255:0] AXI_WDATA [16],             // Write data
    output logic [31:0] AXI_WSTRB [16],              // Write byte enables
    output logic AXI_WLAST [16],                    // Write last transfer cycles
    output logic [31:0] AXI_WDATA_PARITY [16],             // Write data parity
    output logic AXI_WVALID [16],                   // Write data valid signals	
    input  AXI_ARREADY [16],                 // Read address ready signals
    input  AXI_AWREADY [16],                 // Write address ready signals
	input  AXI_WREADY [16],
    input  [255:0] AXI_RDATA [16],            // Read data
    input  [1:0] AXI_RRESP [16],             // Read responses
    input  AXI_RLAST [16],                   // Read last transfer cycles
    input  AXI_RVALID [16],                  // Read data valid signals
    input  [5:0] AXI_RID [16],               // Read IDs
    input  [5:0] AXI_BID [16],              // Write IDs
    input  [1:0] AXI_BRESP [16],             // Write responses
    input  AXI_BVALID [16],                   // Write data valid signals
	
	input write_enable [16],
	input read_enable [16],
	input [255:0] write_data [16],
	input [33:0] write_address [16],
	input [33:0] read_address [16]
);

// Define states for the state machine
typedef enum logic [2:0] {
    IDLE,
    WRITE_ADDRESS,
    WRITE_DATA,
    READ_ADDRESS,
    READ_DATA
} state_t[16];

// Internal signals
state_t state;
logic [4:0] write_count[16];
logic [33:0] waddr_reg[16];
logic [33:0] raddr_reg[16];
logic [255:0] data_reg[16];

genvar i;
// State machine
generate
    for (i = 0; i < 16; i++) begin
        always_ff @(posedge AXI_ACLK, negedge AXI_ARESET_N) begin
            if (!AXI_ARESET_N) begin
                state[i] <= IDLE;
                write_count[i] <= '0;
            end else begin
                case(state[i])
                    IDLE:                    
                        if (write_enable[i]) begin
                            state[i] <= WRITE_ADDRESS;
                            write_count[i] <= write_count[i] + 5'd1;
                        end 
                        else if (read_enable[i]) begin
                            state[i] <= READ_ADDRESS;
                        end
                        else write_count[i] <= '0;
                    WRITE_ADDRESS:
                        if (AXI_AWREADY[i]) begin
                            if(write_enable[i]) begin 
                            state[i] <= WRITE_ADDRESS;
                            write_count[i] <= write_count[i] + 5'd1;
                            end                                
                            else state[i] <= IDLE;                       
                        end
                    WRITE_DATA:
                        if (AXI_WREADY[i]) begin
                            state[i] <= IDLE;
                        end
                    READ_ADDRESS:
                        if (read_enable[i]) begin
                            state[i] <= READ_ADDRESS;
                        end else state[i] <= IDLE;
                    READ_DATA:
                        if (AXI_RVALID[i] && AXI_RLAST[i]) begin
                            state[i] <= IDLE;
                        end
                endcase
            end
        end
    end		
endgenerate	

generate
    for (i = 0; i < 16; i++) begin
        always_ff @(posedge AXI_ACLK, negedge AXI_ARESET_N) begin
            if (!AXI_ARESET_N) begin    
                waddr_reg[i] <= '0;
                data_reg[i] <= '0; 
                raddr_reg[i] <= '0;   
            end
            else begin
                waddr_reg[i] <= write_address[i];
                data_reg[i] <= write_data[i];
                raddr_reg[i] <= read_address[i];                
            end
        end                    
    end
endgenerate    

generate
    for (i = 0; i < 16; i++) begin
        // Assign output signals based on the state machine
		assign AXI_AWID[i] = 6'd0; // ID set to 0
		assign AXI_AWADDR[i] = waddr_reg[i];
		assign AXI_AWBURST[i] = 2'd1;
		assign AXI_AWLEN[i] = 4'd15; 
		assign AXI_AWSIZE[i] = 3'd5;
		assign AXI_AWVALID[i] = (state[i] == WRITE_ADDRESS);
		
		assign AXI_BREADY[i] = 1'b1;
		assign AXI_RREADY[i] = 1'b1;
		
		assign AXI_WLAST[i] = state[i] == WRITE_ADDRESS; // Single transfer
		assign AXI_WDATA[i] = data_reg[i];		
		assign AXI_WSTRB[i] = '1; // All bytes are valid
		assign AXI_WVALID[i] = (state[i] == WRITE_ADDRESS);
		
		assign AXI_ARADDR[i] = raddr_reg[i];
		assign AXI_ARBURST[i] = 2'h1;
		assign AXI_ARID[i] = '0; // ID set to 0
		assign AXI_ARLEN[i] = 4'd15; // Single transfer
		assign AXI_ARSIZE[i] = 3'd5;
		assign AXI_ARVALID[i] = (state[i] == READ_ADDRESS);
    end
endgenerate	


////////////////////////////////////////////////////////////////////////////////
// Calculating Write Data Parity
////////////////////////////////////////////////////////////////////////////////
generate
    for (i = 0; i < 16; i++) begin
    always_comb AXI_WDATA_PARITY[i] = {{^(AXI_WDATA[i][255:248])},{^(AXI_WDATA[i][247:240])},{^(AXI_WDATA[i][239:232])},{^(AXI_WDATA[i][231:224])},
                              {^(AXI_WDATA[i][223:216])},{^(AXI_WDATA[i][215:208])},{^(AXI_WDATA[i][207:200])},{^(AXI_WDATA[i][199:192])},
                              {^(AXI_WDATA[i][191:184])},{^(AXI_WDATA[i][183:176])},{^(AXI_WDATA[i][175:168])},{^(AXI_WDATA[i][167:160])},
                              {^(AXI_WDATA[i][159:152])},{^(AXI_WDATA[i][151:144])},{^(AXI_WDATA[i][143:136])},{^(AXI_WDATA[i][135:128])},
                              {^(AXI_WDATA[i][127:120])},{^(AXI_WDATA[i][119:112])},{^(AXI_WDATA[i][111:104])},{^(AXI_WDATA[i][103:96])},
                              {^(AXI_WDATA[i][95:88])},  {^(AXI_WDATA[i][87:80])},  {^(AXI_WDATA[i][79:72])},  {^(AXI_WDATA[i][71:64])},
                              {^(AXI_WDATA[i][63:56])},  {^(AXI_WDATA[i][55:48])},  {^(AXI_WDATA[i][47:40])},  {^(AXI_WDATA[i][39:32])},
                              {^(AXI_WDATA[i][31:24])},  {^(AXI_WDATA[i][23:16])},  {^(AXI_WDATA[i][15:8])},   {^(AXI_WDATA[i][7:0])}};
    end
endgenerate	

endmodule

