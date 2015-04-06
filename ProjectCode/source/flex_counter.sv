// $Id: $
// File name:   flex_counter.sv
// Created:     9/15/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Flexible Counter

module flex_counter
#(
  parameter NUM_CNT_BITS = 4
)
(
  input wire clk,
  input wire n_rst,
  input wire clear,
  input wire count_enable,
  input wire [(NUM_CNT_BITS-1):0] rollover_val,
  output wire rollover_flag
);
  reg [(NUM_CNT_BITS-1):0] q1;
  reg [(NUM_CNT_BITS-1):0] q2;
  reg rollover;
   
  assign rollover_flag = rollover;
  assign q2 = q1 + 1;
  
  initial
    q1 <= 0;

  always @ (posedge clk, negedge n_rst)
    if(!n_rst)
      q1 <= 0;
    else if( clear )
      q1 <= 0;
    else if( rollover_flag )
      q1 <= 1;
    else if( count_enable )
      q1 <= q2;
     
  always @ (posedge clk, negedge n_rst)
   if(!n_rst)
     rollover <= 0;
   else if( clear || rollover )
     rollover <= 0;
   else if( (q2 == rollover_val) && count_enable)
     rollover <= 1;    
    
endmodule
  