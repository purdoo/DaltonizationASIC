// $Id: $
// File name:   tb_encoder.sv
// Created:     11/25/2014
// Author:      Tessie McInerney
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Encoder test bench

`timescale 1ns / 10ps

module tb_encoder ();
  
  //Define local parameters
  localparam CLK_PERIOD				= 4;
  
  
  //Define DUT portmap signals
  reg tb_clk;
  reg tb_disp_enable;
  reg tb_C0;
  reg tb_C1;
  reg [7:0] tb_d_in;
  reg [9:0] tb_q_out;
  
  int test_case;
  
  reg [9:0] tb_q_out_tp; // third party output to compare against
  
 	// Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	
	//reg [9:0] expected_q_out;
	
	//DUT Port Map
	encoder DUT(.clk(tb_clk), 
	.data_enable(tb_disp_enable), 
	.C0(tb_C0), 
	.C1(tb_C1), 
	.d_in(tb_d_in), 
	.q_out(tb_q_out));
	
	// third-party encoder port map
	tmds_encoder DUT_TP (
	 .clk(tb_clk),
	 .disp_ena(tb_disp_enable),
	 .control({tb_C1,tb_C0}),
	 .d_in(tb_d_in),
	 .q_out(tb_q_out_tp)
	 );
	 
	
	//Testing
	initial 
	begin
	  /*
	  TEST CASE 1: 
	  d_in = 11101010
	  5 ones in d_in
	  q_m = 000001100
	  2 ones, 6 zeros
	  display enable = 0
	  control = 00
	  q_out = 1101010100
	  */
	  
	  @(negedge tb_clk)
	  tb_disp_enable = 1'b0;
	  
	  
	  @(negedge tb_clk);
	  tb_d_in = 8'b11101010;
	  tb_disp_enable = 1'b0;
	  tb_C0 = 1'b0;
	  tb_C1 = 1'b0;
	  
	  //expected_q_out = 10'b1101010100;
	  
	  @(negedge tb_clk);
	  test_case = 1;
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 1 Passed!");
	  end else begin
	    $error("Test Case 1 Failed!");
	  end
	        
	  /*
	  TEST CASE 2:
	  d_in = 00110100
	  3 ones in d_in & d_in[0] = 0
	  q_m = 110111001
	  5 ones, 3 zeros
	  display enable = 1
	  disparity = ??
	  */
	  
	  /*
	  TEST CASE 3:
	  d_in = 11111111
	  8 ones in d_in
	  q_m = 011111111
	  8 ones, 0 zeros
	  display enable = 0
	  control = 01
	  q_out = 0010101011
	  */
	  @(negedge tb_clk);
	  tb_d_in = 8'b11111111;
	  tb_disp_enable = 1'b0;
	  tb_C0 = 1'b1;
	  tb_C1 = 1'b0;
	  @(negedge tb_clk);
	  
	  //expected_q_out = 10'b0010101011;
	  test_case = 3;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 3 Passed!");
	  end else begin
	    $error("Test Case 3 Failed!");
	  end    
	  
	  /*
	  TEST CASE 4:
	  d_in = 00001111
	  4 ones & d_in[0] = 1
	  q_m = 101010000
	  2 ones, 6 zeros
	  display enable = 1
	  disparity = ??
	  */
	  
	  tb_disp_enable = 1'b1;
	  tb_d_in = 8'b10101010;
	  
	  @(negedge tb_clk)
	  
	  test_case = 4;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 4 Passed!");
	  end else begin
	    $error("Test Case 4 Failed!");
	  end
	  
	  
	  tb_d_in = 8'b01010101;
	  
	  @(negedge tb_clk)
	  
	  test_case = 5;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 5 Passed!");
	  end else begin
	    $error("Test Case 5 Failed!");
	  end
	  
	  tb_d_in = 8'b11110000;
	  
	  @(negedge tb_clk)
	  
	  test_case = 6;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 6 Passed!");
	  end else begin
	    $error("Test Case 6 Failed!");
	  end
	  
	  tb_d_in = 8'b10011001;
	  
	  @(negedge tb_clk)
	  
	  test_case = 7;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 7 Passed!");
	  end else begin
	    $error("Test Case 7 Failed!");
	  end
	  
	  tb_d_in = 8'b00000000;
	  
	  @(negedge tb_clk)
	  
	  test_case = 8;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 8 Passed!");
	  end else begin
	    $error("Test Case 8 Failed!");
	  end
	  
	  tb_d_in = 8'b11111111;
	  
	  @(negedge tb_clk)
	  
	  test_case = 9;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 9 Passed!");
	  end else begin
	    $error("Test Case 9 Failed!");
	  end
	  
	  tb_d_in = 8'b10100111;
	  
	  @(negedge tb_clk)
	  
	  test_case = 10;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 10 Passed!");
	  end else begin
	    $error("Test Case 10 Failed!");
	  end
	  
	  tb_d_in = 8'b00011000;
	  
	  @(negedge tb_clk)
	  
	  test_case = 11;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 11 Passed!");
	  end else begin
	    $error("Test Case 11 Failed!");
	  end
	  
	  tb_d_in = 8'b10101010;
	  
	  @(negedge tb_clk)
	  
	  test_case = 12;
	  
	  if(tb_q_out == tb_q_out_tp)
	  begin
	    $info("Test Case 12 Passed!");
	  end else begin
	    $error("Test Case 12 Failed!");
	  end
	  
	  
	  
 end
	  
endmodule
