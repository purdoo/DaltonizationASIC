// $Id: $
// File name:   timer.sv
// Created:     9/25/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Timing Controller

module timer
(
  input wire clk,
  input wire n_rst,
  input wire enable_timer,
  output wire shift_strobe,
  output wire packet_done
);
  reg clear;
  
  flex_counter C0
  (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(enable_timer),
    .rollover_val(4'b1010),
    .rollover_flag(shift_strobe),
    .clear(clear)
  );
  
  flex_counter C1
  (
    .clk(clk),
    .n_rst(n_rst),
    .count_enable(shift_strobe),
    .rollover_val(4'b1010),
    .rollover_flag(packet_done),
    .clear(clear)
  );
  
  assign clear = packet_done;
  

endmodule