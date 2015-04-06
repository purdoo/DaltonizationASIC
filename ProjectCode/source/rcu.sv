// $Id: $
// File name:   rcu.sv
// Created:     9/25/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Receiver Control Unit

module rcu
(
  input wire clk,
  input wire n_rst,
  input wire start_bit_detected,
  input wire packet_done,
  input wire framing_error,
  output reg sbc_clear,
  output reg sbc_enable,
  output reg load_buffer,
  output reg enable_timer,
  output reg [2:0] state
);

  parameter IDLE  = 3'b001;
  parameter CLEAR = 3'b010;
  parameter READ  = 3'b011;
  parameter WAIT  = 3'b100;
  parameter CHECK = 3'b101;
  parameter WRITE = 3'b110;
  
  //reg [2:0] state;
  reg [2:0] n_state;
  
  always @ (state, start_bit_detected, packet_done, framing_error)
  begin : FSM
    case (state)
      IDLE:
        if(start_bit_detected)
          n_state = CLEAR;
        else
          n_state = IDLE;
      CLEAR:
        n_state = READ;
      READ:
        if(packet_done)
          n_state = WAIT;
        else
          n_state = READ;
      WAIT:
        n_state = CHECK;
      CHECK:
        if(framing_error)
          n_state = IDLE;
        else
          n_state = WRITE;
      WRITE:
        n_state = IDLE;
      default:
        n_state = IDLE;
    endcase
  end
  
  always @ (posedge clk, negedge n_rst)
    if(!n_rst)
      state <= IDLE;
    else
      state <= n_state;
  
  always @ (state)
    case(state)
      IDLE: begin
        sbc_clear = 0;
        sbc_enable = 0;
        load_buffer = 0;
        enable_timer = 0;
      end
      CLEAR: begin
        sbc_clear = 1;
        sbc_enable = 0;
        load_buffer = 0;
        enable_timer = 0;
      end
      READ: begin
        sbc_clear = 0;
        sbc_enable = 0;
        load_buffer = 0;
        enable_timer = 1;
      end
      WAIT: begin
        sbc_clear = 0;
        sbc_enable = 1;
        load_buffer = 0;
        enable_timer = 0;
      end
      CHECK: begin
        sbc_clear = 0;
        sbc_enable = 1;
        load_buffer = 0;
        enable_timer = 0;
      end
      WRITE: begin
        sbc_clear = 0;
        sbc_enable = 0;
        load_buffer = 1;
        enable_timer = 0;
      end
      default: begin
        sbc_clear = 0;
        sbc_enable = 0;
        load_buffer = 0;
        enable_timer = 0;
      end
    endcase
endmodule
  