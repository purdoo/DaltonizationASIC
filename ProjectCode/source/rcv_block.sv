// $Id: $
// File name:   rcv_block.sv
// Created:     9/25/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Receiver Block

module rcv_block
(
  input wire clk,
  input wire n_rst,
  input wire serial_in,
  input wire data_read,
  output wire [7:0] rx_data,
  output wire data_ready,
  output wire overrun_error,
  output wire framing_error
);

  reg [2:0] state;
  reg start_bit;
  reg load_buffer;
  reg shift_strobe;
  reg packet_done;
  reg en_timer;
  reg sbc_clear;
  reg sbc_enable;
  reg stop_bit;
  reg f_error;
  
  assign framing_error = f_error;
  
  reg [7:0] packet_data;
  
  start_bit_det S0
  (
    .clk(clk),
	  .n_rst(n_rst),
	  .serial_in(serial_in),
	  .start_bit_detected(start_bit)
  );
  
  stop_bit_chk S1
  (
 	  .clk(clk),
	  .n_rst(n_rst),
	  .sbc_clear(sbc_clear),
	  .sbc_enable(sbc_enable),
	  .stop_bit(stop_bit),
	  .framing_error(f_error)
  );
  
  timer T0
  (
    .clk(clk),
    .n_rst(n_rst),
    .enable_timer(en_timer),
    .shift_strobe(shift_strobe),
    .packet_done(packet_done)
  );
  
  sr_9bit S2
  (
    .clk(clk),
    .n_rst(n_rst),
    .shift_strobe(shift_strobe),
    .serial_in(serial_in),
    .packet_data(packet_data),
    .stop_bit(stop_bit)
  );
  
  rcu R0
  (
    .clk(clk),
    .n_rst(n_rst),
    .start_bit_detected(start_bit),
    .packet_done(packet_done),
    .framing_error(f_error),
    .sbc_clear(sbc_clear),
    .sbc_enable(sbc_enable),
    .load_buffer(load_buffer),
    .enable_timer(en_timer),
    .state(state)
  );

  rx_data_buff R1
  (
 	  .clk(clk),
	  .n_rst(n_rst),
	  .load_buffer(load_buffer),
	  .packet_data(packet_data),
	  .data_read(data_read),
	  .rx_data(rx_data),
	  .data_ready(data_ready),
	  .overrun_error(overrun_error)
  );

endmodule
