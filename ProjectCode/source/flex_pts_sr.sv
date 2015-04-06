// $Id: $
// File name:   flex_pts_sr.sv
// Created:     9/15/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Flexible Parallel To Serial Shift Register

module flex_pts_sr
#(
	parameter NUM_BITS = 4,
	parameter SHIFT_MSB = 0
)
(
	input wire clk,
	input wire n_rst,
	input wire shift_enable,
	input wire load_enable,
	input wire [(NUM_BITS-2):0] parallel_in,
	output wire serial_out
);
	
	reg [(NUM_BITS-1):0] q;
	
	if(SHIFT_MSB == 0)
		assign serial_out = q[0];
	else
		assign serial_out = q[(NUM_BITS-1)];
		
	always @ (posedge clk or negedge n_rst) begin
		if(!n_rst)
			q <= {NUM_BITS{1'b1}};
		else if(load_enable == 1) begin
			if(shift_enable == 1) begin
				if(SHIFT_MSB == 0)
					q = q >> 1;
				else
					q = q << 1;
			end
			
			q[10:1] <= parallel_in;
		end
		else if(shift_enable == 1) begin
			if(SHIFT_MSB == 0)
				q <= q >> 1;
			else
				q <= q << 1;
		end
	end
	
endmodule