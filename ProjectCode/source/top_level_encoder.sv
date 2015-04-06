// $Id: $
// File name:   top_level_encoder.sv
// Created:     12/2/2014
// Author:      Sam Schiferl
// Lab Section: 1
// Version:     1.0  Initial Design Entry
// Description: Top Level Encoder file

module top_level_encoder
 (
	input wire clk,
	input wire [7:0] red_in,
	input wire [7:0] green_in,
	input wire [7:0] blue_in,
	input wire data_ready,
	input wire disp_enable,
	input wire C0,
	input wire C1,
	input wire n_rst,
	output wire tmds1_out,
	output wire tmds2_out,
	output wire tmds3_out,
	output wire tmds_clk
 );
  
	reg clear;
	reg [4:0] count_out;
	reg rollover_flag;
	reg [9:0] red_out, green_out, blue_out;
	reg shift_enable, load_enable
	
      
	assign tmds_clk = (count_out % 5 == 0)? tmds_clk ^ 1: tmds_clk;
  
	encoder RED_DUT (
		.clk(clk),
		.d_in(red_in),
		.disp_enable(disp_enable),
		.C0(C0),
		.C1(C1),
		.q_out(red_out)
	);
  
	encoder GREEN_DUT (
		.clk(clk),
		.d_in(green_in),
		.disp_enable(disp_enable),
		.C0(C0),
		.C1(C1),
		.q_out(green_out)
	);
  
	encoder BLUE_DUT (
		.clk(clk),
		.d_in(blue_in),
		.disp_enable(disp_enable),
		.C0(C0),
		.C1(C1),
		.q_out(blue_out)
	);
  
	flex_counter COUNTER_DUT (
		.clk(clk),
		.n_rst(n_rst),
		.clear(clear),
		.count_enable(count_enable),
		.rollover_val(10),
		.count_out(count_out),
		.rollover_flag(load_enable)
	);

	tmds_controller CONTROLLER_DUT (
		.clk(clk),
		.n_rst(n_rst),
		.data_ready(data_ready),
		.count_enable(count_enable),
		.shift_enable(shift_enable),
		.load_enable(load_enable)
	);
	
  //Parallel to Serial TMDS Shift Registers
	flex_pts_sr
	(
		NUM_BITS = 11
	)
	TMDS_RED (
		.clk(clk),
		.n_rst(n_rst),
		.shift_enable(shift_enable),
		.load_enable(load_enable),
		.parallel_in(red_out),
		.serial_out(tmds1_out)
	);
  
	flex_pts_sr 
	(
		NUM_BITS = 11
	)
	TMDS_GREEN (
		.clk(clk),
		.n_rst(n_rst),
		.shift_enable(shift_enable),
		.load_enable(load_enable),
		.parallel_in(green_out),
		.serial_out(tmds2_out)
	);

	flex_pts_sr 
	(
		NUM_BITS = 11
	)
	TMDS_BLUE (
		.clk(clk),
		.n_rst(n_rst),
		.shift_enable(shift_enable),
		.load_enable(load_enable),
		.parallel_in(blue_out),
		.serial_out(tmds3_out)
	);
endmodule  
  