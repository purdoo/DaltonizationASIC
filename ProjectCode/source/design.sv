// $Id: $
// File name:   controller.sv
// Created:     12/02/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Controller Block

module ip_block
(
	input wire clk,
	input wire n_rst,
	input wire v_sync,
	input wire h_sync,
	input wire data_enable,
	input wire [7:0] r_in,
	input wire [7:0] b_in,
	input wire [7:0] g_in,
	output reg tmds1
	output reg tmds2,
	output reg tmds3,
	output reg tmds_clk
);

	reg [7:0] r_tmp, g_tmp, b_tmp;

	module ip_block
	(
	  .clk(clk),
	  .n_rst(n_rst),
	  .uart_in(uart_in),
	  .data_read(data_read),
	  .r_in(r_in),
	  .b_in(b_in),
	  .g_in(g_in),
	  .shift_enable,
	  .r_out(r_tmp),
	  .g_out(g_tmp),
	  .b_out(b_tmp)
	);
	
	module top_level_encoder
	(
		clk(clk),
		red_in(r_tmp),
		green_in(g_tmp),
		blue_in(b_tmp),
		data_ready(shift_enable),
		disp_enable(data_enable),
		C0(v_sync),
		C1(h_sync),
		n_rst(n_rst),
		tmds1_out(tmds1),
		tmds2_out(tmds2),
		tmds3_out(tmds3),
		tmds_clk(tmds_clk)
	);

endmodule