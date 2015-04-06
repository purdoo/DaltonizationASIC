// $Id: $
// File name:   encoder.sv
// Created:     11/25/2014
// Author:      Sam Schiferl
// Lab Section: 1
// Version:     1.0  Initial Design Entry
// Description: Encoder Module

module encoder
  (
  input wire clk,
  input wire [7:0] d_in,
  input wire disp_enable,
  input wire C0,
  input wire C1,
  output wire [9:0] q_out
  );
  
  reg [4:0] d_in_ones;
  reg [8:0] q_middle;
  reg [4:0] q_middle_ones;
  reg [4:0] q_middle_zeros;
  
  reg signed [16:0] prev_cnt;
  reg signed [8:0] diff_q_m;
  //reg signed [16:0] curr_cnt;
  
  reg [9:0] ff_q_out;
  
  reg d_in_parity;
  //reg q_middle_parity;
  
  //reg prev_parity;
  
  // Assign output to ff_q_out
  assign q_out = ff_q_out;
  
  // Add up ones from input
  assign d_in_ones = d_in[0]+d_in[1]+d_in[2]+d_in[3]+d_in[4]+d_in[5]+d_in[6]+d_in[7];
  assign q_middle_ones = q_middle[0]+q_middle[1]+q_middle[2]+q_middle[3]+q_middle[4]+q_middle[5]+q_middle[6]+q_middle[7];
  assign q_middle_zeros = 8 - q_middle_ones;
  assign diff_q_m = q_middle_ones - q_middle_zeros;
  
  // Determine parity of input
  always_comb
  begin: input_parity
    if(d_in_ones > 4 || (d_in_ones == 4 && d_in[0] == 0))
      d_in_parity <= 1'b1; // xnor
    else
      d_in_parity <= 1'b0; // xor
  end
  
  // Determine parity of middle
  /*always @(q_middle_ones)
  begin: middle_parity
    if(q_middle_ones > 4)
      q_middle_parity <= 1'b1;
    else
      q_middle_parity <= 1'b0;
  end */
  
  
  // Perform XOR/XNOR operations on input
  always @(d_in_parity, q_middle, d_in)
  begin: xor_xnor_operations
    if(d_in_parity == 1'b0)
      begin
        q_middle[0] = d_in[0];
        q_middle[1] = d_in[1] ^ q_middle[0];
        q_middle[2] = d_in[2] ^ q_middle[1];
        q_middle[3] = d_in[3] ^ q_middle[2];
        q_middle[4] = d_in[4] ^ q_middle[3];
        q_middle[5] = d_in[5] ^ q_middle[4];
        q_middle[6] = d_in[6] ^ q_middle[5];
        q_middle[7] = d_in[7] ^ q_middle[6];
        q_middle[8] = 1'b1;
      end
    else
      begin
        q_middle[0] = d_in[0];
        q_middle[1] = d_in[1] ~^ q_middle[0];
        q_middle[2] = d_in[2] ~^ q_middle[1];
        q_middle[3] = d_in[3] ~^ q_middle[2];
        q_middle[4] = d_in[4] ~^ q_middle[3];
        q_middle[5] = d_in[5] ~^ q_middle[4];
        q_middle[6] = d_in[6] ~^ q_middle[5];
        q_middle[7] = d_in[7] ~^ q_middle[6];
        q_middle[8] = 1'b0;
      end
  end
  
  // Perform inversion operations on input
  // Do on clock cycle to ensure algorithm has enough time to operate
  always @(posedge clk)
  begin: inversion_operations
    //d_in_ones = 0;
    if(disp_enable == 1'b1)
      begin
      if(prev_cnt == 0 || q_middle_ones == 4)
        begin
          ff_q_out[9] = ~q_middle[8];
          ff_q_out[8] = q_middle[8];
          ff_q_out[7:0] = q_middle[8]? q_middle[7:0]:~q_middle[7:0];
          if(q_middle[8]==0)
            begin
              prev_cnt = prev_cnt - diff_q_m;
            end
          else
            begin
              prev_cnt = prev_cnt + diff_q_m;
            end
        
        end
      else
        begin
          if((prev_cnt > 0 && q_middle_ones > q_middle_zeros) || (prev_cnt < 0 && q_middle_zeros > q_middle_ones))
            begin
              ff_q_out[9] = 1'b1;
              ff_q_out[8] = q_middle[8];
              ff_q_out[7:0]=~q_middle[7:0];
              if(q_middle[8] == 0)
                prev_cnt = prev_cnt - diff_q_m;
              else
                prev_cnt = prev_cnt - diff_q_m+2;
            end
          else
            begin
              ff_q_out[9] = 0;
              ff_q_out[8] = q_middle[8];
              ff_q_out[7:0]=q_middle[7:0];
              if(q_middle[8] == 0)
                prev_cnt = prev_cnt + diff_q_m - 2;
              else
                prev_cnt = prev_cnt + diff_q_m;
            end
        end
      end
  end
        
  
  
  
  // Calculate standard output based on control
  always @(disp_enable, C0, C1)
  begin: control_output
    if(disp_enable == 0)
      begin
        prev_cnt = 0;
        if(C1==0 && C0 == 0)
          ff_q_out <= 10'b1101010100;
        else if(C1 == 0 && C0==1)
          ff_q_out <= 10'b0010101011;
        else if(C1==1 && C0==0)
          ff_q_out <= 10'b0101010100;
        else
          ff_q_out <= 10'b1010101011;
      end
  end
  
  
endmodule