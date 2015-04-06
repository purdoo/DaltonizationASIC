// $Id: $
// File name:   computational.sv
// Created:     12/02/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Computational Block

module comp
(
  input wire clk,
  input wire n_rst,
  input wire [7:0] r_in,
  input wire [7:0] b_in,
  input wire [7:0] g_in,
  input wire [1:0] mode,
  input wire start_comp,
  output reg [7:0] r_out,
  output reg [7:0] b_out,
  output reg [7:0] g_out,
  output reg comp_done
);

  reg [13:0] tmp1, tmp2, tmp3, tmp4;

  
  always @ (posedge start_comp) begin
    if(mode == 2'b11) begin
      r_out <= r_in;
    
      tmp1 = (23 * r_in) >> 6; 
      tmp2 = (47 * g_in) >> 64;
      g_out <= tmp1[7:0] + tmp2[7:0] + (b_in >> 7);
    
      tmp3 = (29 * r_in) >> 6;
      tmp4 = (27 * g_in) >> 6;
      b_out <= tmp3[7:0] + tmp4[7:0] + b_in;
    end
    else if(mode == 2'b10) begin
      tmp1 = 0.21 * r_in; 
      tmp2 = 0.72 * g_in;
      tmp3 = 0.07 * b_in;
      tmp4 = tmp1 + tmp2 + tmp3;
    
      r_out <= tmp4[7:0];
      b_out <= tmp4[7:0];
      g_out <= tmp4[7:0];
    end
    else if(mode == 2'b01) begin
      r_out = 255 - r_in;
      b_out = 255 - b_in;
      g_out = 255 - g_in;
    end
    comp_done <= 1'b1;
  end
endmodule
    
    