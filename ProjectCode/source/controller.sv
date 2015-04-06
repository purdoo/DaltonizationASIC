// $Id: $
// File name:   controller.sv
// Created:     12/02/2014
// Author:      Austin Nobis
// Lab Section: 337-01
// Version:     1.0  Initial Design Entry
// Description: Controller Block

module controller
(
  input wire clk,
  input wire n_rst,
  input wire [7:0] rx_data,
  input wire data_ready,
  input wire overrun_error,
  input wire framing_error,
  input wire comp_done,
  output reg start_comp,
  output reg shift_enable,
  output reg [1:0] mode
);

  reg [3:0] state, n_state;
  
  reg [3:0] IDLE      = 4'b0001;
  reg [3:0] CHKERROR  = 4'b0010;
  reg [3:0] START     = 4'b0011;
  reg [3:0] MODEENC   = 4'b0100;
  reg [3:0] DALTON    = 4'b0101;
  reg [3:0] BLKWHT    = 4'b0110;
  reg [3:0] NEGATIVE  = 4'b0111;
  reg [3:0] COMP      = 4'b1000;
  reg [3:0] TDONE     = 4'b1001;
  reg [3:0] EIDLE     = 4'b1010;
  
  always @ (state, rx_data, data_ready, overrun_error, framing_error, comp_done, data_ready)
  begin : FSM
    case(state)
      IDLE:
        if(data_ready)
          n_state = CHKERROR;
        else
          n_state = IDLE;
      CHKERROR:
        if(framing_error)
          n_state = EIDLE;
        else if(overrun_error)
          n_state = EIDLE;
        else
          n_state = START;
      START:
        n_state = MODEENC;
      MODEENC:
        if(rx_data == 8'b00000111)
          n_state = DALTON;
        else if(rx_data == 8'b00000011)
          n_state = BLKWHT;
        else if(rx_data == 8'b00000001)
          n_state = NEGATIVE;
        else
          n_state = EIDLE;
      DALTON:
        n_state = COMP;
      BLKWHT:
        n_state = COMP;
      NEGATIVE:
        n_state = COMP;
      COMP:
        if(comp_done)
          n_state = TDONE;
        else
          n_state = COMP;
      TDONE:
        n_state = IDLE;
      EIDLE:
        n_state = IDLE;
      default:
        n_state = IDLE;
    endcase
  end
  
  
  always @ (posedge clk, negedge n_rst)
    if(!n_rst)
      state <= IDLE;
    else
      state = n_state;
    
      
  always @ (state)
  begin
    case(state)
      IDLE: begin
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 0;
      end
      CHKERROR: begin
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 0;
      end
      START: begin
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 0;
      end
      MODEENC: begin;
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 0;
      end
      DALTON: begin
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 3;
      end
      BLKWHT: begin
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 2;
      end
      NEGATIVE: begin
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 1;
      end
      COMP: begin
        start_comp    = 1;
        shift_enable  = 0;
      end
      TDONE: begin
        start_comp    = 0;
        shift_enable  = 1;
        mode          = 0;
      end
      EIDLE: begin
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 0;
      end
      default: begin
        start_comp    = 0;
        shift_enable  = 0;
        mode          = 0;
      end
    endcase
  end
endmodule