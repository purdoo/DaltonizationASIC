// $Id: $
// File name:   tb_rcv_block-starter.sv
// Created:     2/5/2013
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: starter top level test bench provided for Lab 5

`timescale 1ns / 10ps

module tb_rcv_block();

	// Define parameters
	parameter CLK_PERIOD				= 2.5;
	parameter NORM_DATA_PERIOD	= (10 * CLK_PERIOD);
	
	localparam WORST_FAST_DATA_PERIOD = (NORM_DATA_PERIOD * 0.96);
	localparam WORST_SLOW_DATA_PERIOD = (NORM_DATA_PERIOD * 1.04);
	localparam NUM_TEST_CASES = 2;
	
	wire [7:0] tb_rx_data;
	wire tb_data_ready;
	wire tb_overrun_error;
	wire tb_framing_error;
	
	reg tb_clk;
	reg tb_n_rst;
	reg tb_serial_in;
	reg tb_data_read;
	reg tb_start_bit;
	reg tb_load_buffer;
	reg [2:0] tb_state;
	reg tb_shift_strobe;
	reg tb_packet_done;
	
	integer tb_test_case;
	reg [7:0] tb_test_data;
	
	integer test_case_num; // Only used during test vector creation
	reg [1:NUM_TEST_CASES][7:0] test_cases_data;
	reg [1:NUM_TEST_CASES] test_cases_stop_bit;
	time [1:NUM_TEST_CASES] test_cases_bit_period;
	reg [1:NUM_TEST_CASES] test_cases_data_ready;
	reg [1:NUM_TEST_CASES] test_cases_framing_error;
	
	task send_packet;
		input  [7:0] data;
		input  stop_bit;
		input  time data_period;
		
		integer i;
	
	begin
		// Send start bit
		tb_serial_in = 1'b0;
		#data_period;
		
		// Send data bits
		for(i = 0; i < 8; i = i + 1)
		begin
			tb_serial_in = data[i];
			#data_period;
		end
		
		// Send stop bit
		tb_serial_in = stop_bit;
		#data_period;
	end
	endtask
	
	rcv_block DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.serial_in(tb_serial_in),
		.data_read(tb_data_read),
		.rx_data(tb_rx_data),
		.data_ready(tb_data_ready),
		.overrun_error(tb_overrun_error),
		.framing_error(tb_framing_error),
		.state(tb_state)
	);
	
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2);
	end

	// Test vector population
	initial
	begin
		// First test case Normal packet
		test_case_num = 1;
		test_cases_data[test_case_num] = 8'b11010101;
		test_cases_stop_bit[test_case_num] = 1'b1;
		test_cases_bit_period[test_case_num] = NORM_DATA_PERIOD;
		test_cases_data_ready[test_case_num] = 1'b1;
		test_cases_framing_error[test_case_num] = 1'b0;
		
		// Second test case Normal packet with 4% faster bit periods
		test_case_num = test_case_num + 1;
		test_cases_data[test_case_num] = 8'b11010100;
		test_cases_stop_bit[test_case_num] = 1'b0;
		test_cases_bit_period[test_case_num] = WORST_FAST_DATA_PERIOD;
		test_cases_data_ready[test_case_num] = 1'b1;
		test_cases_framing_error[test_case_num] = 1'b1;
	end
	
	
	// Actual test bench process
	initial
	begin : TEST_PROC
		// Initilize all inputs
		tb_n_rst				= 1'b1; // Initially inactive
		tb_serial_in	= 1'b1; // Initially idle
		tb_data_read	= 1'b0; // Initially inactive
		
		// Get away from Time = 0
		#0.1; 
		
		for(tb_test_case = 1; tb_test_case <= NUM_TEST_CASES; tb_test_case++)
		begin
			// Chip reset
			// Activate reset
			tb_n_rst = 1'b0; 
			// wait for a few clock cycles
			@(posedge tb_clk);
			@(posedge tb_clk);
			// Release on falling edge to prevent hold time violation
			@(negedge tb_clk);
			// Release reset
			tb_n_rst = 1'b1; 
			// Add some space before starting the test case
			@(posedge tb_clk);
			@(posedge tb_clk);
		
			// Run test case
			// Update test data indicator signal
			tb_test_data = test_cases_data[tb_test_case];
			// Send packet
			send_packet(tb_test_data, test_cases_stop_bit[tb_test_case], test_cases_bit_period[tb_test_case]);
			// Wait for 2 data periods to allow DUT to finish processing the packet
			#(test_cases_bit_period[tb_test_case] * 2);
			
			// Check outputs
			assert(tb_test_data == tb_rx_data)
				$info("Test case %0d: Test data correctly received", tb_test_case);
			else
				$error("Test case %0d: Test data was not correctly received", tb_test_case);
			assert(test_cases_framing_error[tb_test_case] == tb_framing_error)
				$info("Test case %0d: DUT correctly shows no framing error", tb_test_case);
			else
				$error("Test case %0d: DUT incorrectly shows a framing error", tb_test_case);
			assert(test_cases_data_ready[tb_test_case] == tb_data_ready)
				$info("Test case %0d: DUT correctly asserted the data ready flag", tb_test_case);
			else
				$error("Test case %0d: DUT did not correctly assert the data ready flag", tb_test_case);
			assert(1'b0 == tb_overrun_error)
				$info("Test case %0d: DUT correctly shows no overrun error", tb_test_case);
			else
				$error("Test case %0d: DUT incorrectly shows an overrun error", tb_test_case);
			
			if(1'b1 == test_cases_data_ready[tb_test_case])
			begin
				// Test case was supposed to set the data ready to a '1' -> check that it clears properly
				// Activate the data read input and wait a clock cycle for the flag to clear
				tb_data_read = 1'b1;
				#(CLK_PERIOD);
				tb_data_read = 1'b0;
				
				// Check to see if the data ready flag cleared
				@(negedge tb_clk);
				assert(1'b0 == tb_data_ready)
					$info("Test case %0d: DUT correctly cleared the data ready flag", tb_test_case);
				else
					$error("Test case %0d: DUT did not correctly clear the data ready flag", tb_test_case);
			end
		end	
		
		// Add any special cases here (such as overrun case)
		
	end

endmodule
