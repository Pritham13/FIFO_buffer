module fifo #(
    parameter DEPTH = 16,
    parameter DATA_WIDTH = 8
) (
    input [DATA_WIDTH-1:0] data_in,
    input en_read,
    input en_write,
    input reset,
    input clk,
    output full,
    output empty,
    output reg [DATA_WIDTH-1:0] data_out
);
    reg [DATA_WIDTH-1:0] register[0:DEPTH-1];
    reg [$clog2(DEPTH)-1:0] ptr_wr;
    integer i;
    localparam count = 1;
		assign full = (ptr_wr == 0 );
		assign empty = (ptr_wr == (DEPTH-1));
    
    always @(posedge clk) begin
        if (reset) begin
					// cycles through all the registers and initialises them
            for (i = 0; i < DEPTH; i = i + count) begin
                register[i] <= 0;
            end
            data_out <= 0;
            ptr_wr <= DEPTH-1;
        end 
				else begin
					// simultaneous read and write operation 
						if(en_read && en_write) begin
								data_out <= register[DEPTH-1];
								for (i = DEPTH-1; i > 0; i = i - count) begin
										register[i] <= register[i-count];
								end
                register[ptr_wr] <= data_in;
							
						end
					// writes data into the pointer if write_en is HIGH
            if (en_write && ~en_read && !full) begin
                register[ptr_wr] <= data_in;
                ptr_wr <= ptr_wr - 1;
            end
           // Reads data from the  
            if (en_read && !en_write && !empty) begin
								data_out <= register[DEPTH-1];
								for (i = DEPTH-1; i > 0; i = i - count) begin
										register[i] <= register[i-count];
								end
								ptr_wr <= ptr_wr + 1;
            end 
        end
    end
endmodule
