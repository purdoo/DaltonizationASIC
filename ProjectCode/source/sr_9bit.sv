// $Id: $
// File name:   sr_9bit.sv
// Created:     9/25/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: 9-bit Shift Register

module sr_9bit
(
  input wire clk,
  input wire n_rst,
  input wire shift_strobe,
  input wire serial_in,
  output wire [7:0] packet_data,
  output wire stop_bit
);
  reg [1:0] q;
  
  assign stop_bit = q[0];
  
  flex_stp_sr 
  #(
  .NUM_BITS(10),
  .SHIFT_MSB(0)
  )
  EZ 
  (
    .clk(clk), 
    .n_rst(n_rst), 
    .shift_enable(shift_strobe),
    .serial_in(serial_in),
    .parallel_out({q, packet_data})
  );

  

endmodule