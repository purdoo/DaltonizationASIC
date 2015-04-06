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
  input wire uart_in,
  input wire data_read,
  input wire [7:0] r_in,
  input wire [7:0] b_in,
  input wire [7:0] g_in,
  output wire shift_enable,
  output reg [7:0] r_out,
  output reg [7:0] g_out,
  output reg [7:0] b_out
);

  reg [1:0] mode;
  reg start_comp;
  reg comp_done;
  reg rx_data;
  reg framing_error;
  reg overrun_error;
  reg data_ready;
  
  controller C0
  (
    .clk(clk),
    .n_rst(n_rst),
    .rx_data(rx_data),
    .data_ready(data_ready),
    .overrun_error(overrun_error),
    .framing_error(framing_error),
    .comp_done(comp_done),
    .start_comp(start_comp),
    .shift_enable(shift_enable),
    .mode(mode)
  );

  comp C1
  (
    .clk(clk),
    .n_rst(n_rst),
    .r_in(r_in),
    .b_in(b_in),
    .g_in(g_in),
    .mode(mode),
    .start_comp(start_comp),
    .r_out(r_out),
    .b_out(b_out),
    .g_out(g_out),
    .comp_done(comp_done)
  );

  rcv_block R0
  (
    .clk(clk),
    .n_rst(n_rst),
    .serial_in(uart_in),
    .data_read(data_read),
    .rx_data(rx_data),
    .data_ready(data_ready),
    .overrun_error(overrun_error),
    .framing_error(framing_error)
  );

endmodule