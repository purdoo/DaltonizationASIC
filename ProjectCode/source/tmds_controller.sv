// $Id: $
// File name:   tmds_controller.sv
// Created:     9/15/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: TMDS Output Controller

module tmds_controller
(
	input wire clk,
	input wire n_rst,
	input wire data_ready,
	output reg count_enable,
	output reg shift_enable,
	output reg load_enable
);

	reg[2:0] state, n_state;
	
	reg [2:0] IDLE = 0'b001;
	reg [2:0] READY = 0'b010;
	reg [2:0] SHIFT = 0'b011;
	reg [2:0] COUNT = 0'b100;
	
	always @ (state, data_ready)
	begin : FSM
		IDLE:
			if(data_ready)
				n_state = READY;
			else
				n_state = IDLE;
		READY:
			n_state = SHIFT;
		SHIFT:
			n_state = COUNT;
		COUNT:
			n_state = COUNT;
		default:
			n_state = IDLE;
	end
	
	always @ (posedge clk, negedge n_rst)
		if(!n_rst)
			state <= IDLE;
		else
			state <= n_state;
	
	always @ (state)
	begin
		IDLE: begin
			count_enable = 0;
			shift_enable = 0;
			load_enable = 0;
		READY: begin
			count_enable = 0;
			shift_enable = 0;
			load_enable = 1;
		end
		SHIFT: begin
			count_enable = 0;
			shift_enable = 1;
			load_enable = 0;
		end
		COUNT: begin
			count_enable = 1;
			shift_enable = 1;
		end
		default: begin
			count_enable = 0;
			shift_enable = 0;
			load_enable = 0;
		end
	end