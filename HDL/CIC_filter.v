// -------------------------------------------------------------
//
// Module: CIC_filter
// Generated by MATLAB(R) 9.13 and Filter Design HDL Coder 3.1.12.
// Generated on: 2023-12-01 18:42:56
// -------------------------------------------------------------

// -------------------------------------------------------------
// HDL Code Generation Options:
//
// TargetDirectory: D:\FPGA_MATLAB_Learning\CIC_Filter\HDL
// Name: CIC_filter
// TargetLanguage: Verilog
// TestBenchStimulus: step ramp chirp noise 

// -------------------------------------------------------------
// HDL Implementation    : Fully parallel
// -------------------------------------------------------------




`timescale 1 ns / 1 ns

module CIC_filter
               (
                clk,
                clk_enable,
                reset,
                filter_in,
                filter_out,
                ce_out
                );

  input   clk; 
  input   clk_enable; 
  input   reset; 
  input   signed [15:0] filter_in; //sfix16_En15
  output  signed [50:0] filter_out; //sfix51_En15
  output  ce_out; 

////////////////////////////////////////////////////////////////
//Module Architecture: CIC_filter
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  // Signals
  reg  [6:0] cur_count; // ufix7
  wire phase_1; // boolean
  reg  ce_out_reg; // boolean
  //   
  reg  signed [15:0] input_register; // sfix16_En15
  //   -- Section 1 Signals 
  wire signed [15:0] section_in1; // sfix16_En15
  wire signed [50:0] section_cast1; // sfix51_En15
  wire signed [50:0] sum1; // sfix51_En15
  reg  signed [50:0] section_out1; // sfix51_En15
  wire signed [50:0] add_cast; // sfix51_En15
  wire signed [50:0] add_cast_1; // sfix51_En15
  wire signed [51:0] add_temp; // sfix52_En15
  //   -- Section 2 Signals 
  wire signed [50:0] section_in2; // sfix51_En15
  wire signed [50:0] sum2; // sfix51_En15
  reg  signed [50:0] section_out2; // sfix51_En15
  wire signed [50:0] add_cast_2; // sfix51_En15
  wire signed [50:0] add_cast_3; // sfix51_En15
  wire signed [51:0] add_temp_1; // sfix52_En15
  //   -- Section 3 Signals 
  wire signed [50:0] section_in3; // sfix51_En15
  wire signed [50:0] sum3; // sfix51_En15
  reg  signed [50:0] section_out3; // sfix51_En15
  wire signed [50:0] add_cast_4; // sfix51_En15
  wire signed [50:0] add_cast_5; // sfix51_En15
  wire signed [51:0] add_temp_2; // sfix52_En15
  //   -- Section 4 Signals 
  wire signed [50:0] section_in4; // sfix51_En15
  wire signed [50:0] sum4; // sfix51_En15
  reg  signed [50:0] section_out4; // sfix51_En15
  wire signed [50:0] add_cast_6; // sfix51_En15
  wire signed [50:0] add_cast_7; // sfix51_En15
  wire signed [51:0] add_temp_3; // sfix52_En15
  //   -- Section 5 Signals 
  wire signed [50:0] section_in5; // sfix51_En15
  wire signed [50:0] sum5; // sfix51_En15
  reg  signed [50:0] section_out5; // sfix51_En15
  wire signed [50:0] add_cast_8; // sfix51_En15
  wire signed [50:0] add_cast_9; // sfix51_En15
  wire signed [51:0] add_temp_4; // sfix52_En15
  //   -- Section 6 Signals 
  wire signed [50:0] section_in6; // sfix51_En15
  reg  signed [50:0] diff1; // sfix51_En15
  wire signed [50:0] section_out6; // sfix51_En15
  wire signed [50:0] sub_cast; // sfix51_En15
  wire signed [50:0] sub_cast_1; // sfix51_En15
  wire signed [51:0] sub_temp; // sfix52_En15
  //   -- Section 7 Signals 
  wire signed [50:0] section_in7; // sfix51_En15
  reg  signed [50:0] diff2; // sfix51_En15
  wire signed [50:0] section_out7; // sfix51_En15
  wire signed [50:0] sub_cast_2; // sfix51_En15
  wire signed [50:0] sub_cast_3; // sfix51_En15
  wire signed [51:0] sub_temp_1; // sfix52_En15
  //   -- Section 8 Signals 
  wire signed [50:0] section_in8; // sfix51_En15
  reg  signed [50:0] diff3; // sfix51_En15
  wire signed [50:0] section_out8; // sfix51_En15
  wire signed [50:0] sub_cast_4; // sfix51_En15
  wire signed [50:0] sub_cast_5; // sfix51_En15
  wire signed [51:0] sub_temp_2; // sfix52_En15
  //   -- Section 9 Signals 
  wire signed [50:0] section_in9; // sfix51_En15
  reg  signed [50:0] diff4; // sfix51_En15
  wire signed [50:0] section_out9; // sfix51_En15
  wire signed [50:0] sub_cast_6; // sfix51_En15
  wire signed [50:0] sub_cast_7; // sfix51_En15
  wire signed [51:0] sub_temp_3; // sfix52_En15
  //   -- Section 10 Signals 
  wire signed [50:0] section_in10; // sfix51_En15
  reg  signed [50:0] diff5; // sfix51_En15
  wire signed [50:0] section_out10; // sfix51_En15
  wire signed [50:0] sub_cast_8; // sfix51_En15
  wire signed [50:0] sub_cast_9; // sfix51_En15
  wire signed [51:0] sub_temp_4; // sfix52_En15
  //   
  reg  signed [50:0] output_register; // sfix51_En15

  // Block Statements
  //   ------------------ CE Output Generation ------------------

  always @ (posedge clk or posedge reset)
    begin: ce_output
      if (reset == 1'b1) begin
        cur_count <= 7'b0000000;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (cur_count >= 7'b1111111) begin
            cur_count <= 7'b0000000;
          end
          else begin
            cur_count <= cur_count + 7'b0000001;
          end
        end
      end
    end // ce_output

  assign  phase_1 = (cur_count == 7'b0000001 && clk_enable == 1'b1) ? 1'b1 : 1'b0;

  //   ------------------ CE Output Register ------------------

  always @ (posedge clk or posedge reset)
    begin: ce_output_register
      if (reset == 1'b1) begin
        ce_out_reg <= 1'b0;
      end
      else begin
          ce_out_reg <= phase_1;
      end
    end // ce_output_register

  //   ------------------ Input Register ------------------

  always @ (posedge clk or posedge reset)
    begin: input_reg_process
      if (reset == 1'b1) begin
        input_register <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          input_register <= filter_in;
        end
      end
    end // input_reg_process

  //   ------------------ Section # 1 : Integrator ------------------

  assign section_in1 = input_register;

  assign section_cast1 = $signed({{35{section_in1[15]}}, section_in1});

  assign add_cast = section_cast1;
  assign add_cast_1 = section_out1;
  assign add_temp = add_cast + add_cast_1;
  assign sum1 = add_temp[50:0];

  always @ (posedge clk or posedge reset)
    begin: integrator_delay_section1
      if (reset == 1'b1) begin
        section_out1 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          section_out1 <= sum1;
        end
      end
    end // integrator_delay_section1

  //   ------------------ Section # 2 : Integrator ------------------

  assign section_in2 = section_out1;

  assign add_cast_2 = section_in2;
  assign add_cast_3 = section_out2;
  assign add_temp_1 = add_cast_2 + add_cast_3;
  assign sum2 = add_temp_1[50:0];

  always @ (posedge clk or posedge reset)
    begin: integrator_delay_section2
      if (reset == 1'b1) begin
        section_out2 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          section_out2 <= sum2;
        end
      end
    end // integrator_delay_section2

  //   ------------------ Section # 3 : Integrator ------------------

  assign section_in3 = section_out2;

  assign add_cast_4 = section_in3;
  assign add_cast_5 = section_out3;
  assign add_temp_2 = add_cast_4 + add_cast_5;
  assign sum3 = add_temp_2[50:0];

  always @ (posedge clk or posedge reset)
    begin: integrator_delay_section3
      if (reset == 1'b1) begin
        section_out3 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          section_out3 <= sum3;
        end
      end
    end // integrator_delay_section3

  //   ------------------ Section # 4 : Integrator ------------------

  assign section_in4 = section_out3;

  assign add_cast_6 = section_in4;
  assign add_cast_7 = section_out4;
  assign add_temp_3 = add_cast_6 + add_cast_7;
  assign sum4 = add_temp_3[50:0];

  always @ (posedge clk or posedge reset)
    begin: integrator_delay_section4
      if (reset == 1'b1) begin
        section_out4 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          section_out4 <= sum4;
        end
      end
    end // integrator_delay_section4

  //   ------------------ Section # 5 : Integrator ------------------

  assign section_in5 = section_out4;

  assign add_cast_8 = section_in5;
  assign add_cast_9 = section_out5;
  assign add_temp_4 = add_cast_8 + add_cast_9;
  assign sum5 = add_temp_4[50:0];

  always @ (posedge clk or posedge reset)
    begin: integrator_delay_section5
      if (reset == 1'b1) begin
        section_out5 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          section_out5 <= sum5;
        end
      end
    end // integrator_delay_section5

  //   ------------------ Section # 6 : Comb ------------------

  assign section_in6 = section_out5;

  assign sub_cast = section_in6;
  assign sub_cast_1 = diff1;
  assign sub_temp = sub_cast - sub_cast_1;
  assign section_out6 = sub_temp[50:0];

  always @ (posedge clk or posedge reset)
    begin: comb_delay_section6
      if (reset == 1'b1) begin
        diff1 <= 0;
      end
      else begin
        if (phase_1 == 1'b1) begin
          diff1 <= section_in6;
        end
      end
    end // comb_delay_section6

  //   ------------------ Section # 7 : Comb ------------------

  assign section_in7 = section_out6;

  assign sub_cast_2 = section_in7;
  assign sub_cast_3 = diff2;
  assign sub_temp_1 = sub_cast_2 - sub_cast_3;
  assign section_out7 = sub_temp_1[50:0];

  always @ (posedge clk or posedge reset)
    begin: comb_delay_section7
      if (reset == 1'b1) begin
        diff2 <= 0;
      end
      else begin
        if (phase_1 == 1'b1) begin
          diff2 <= section_in7;
        end
      end
    end // comb_delay_section7

  //   ------------------ Section # 8 : Comb ------------------

  assign section_in8 = section_out7;

  assign sub_cast_4 = section_in8;
  assign sub_cast_5 = diff3;
  assign sub_temp_2 = sub_cast_4 - sub_cast_5;
  assign section_out8 = sub_temp_2[50:0];

  always @ (posedge clk or posedge reset)
    begin: comb_delay_section8
      if (reset == 1'b1) begin
        diff3 <= 0;
      end
      else begin
        if (phase_1 == 1'b1) begin
          diff3 <= section_in8;
        end
      end
    end // comb_delay_section8

  //   ------------------ Section # 9 : Comb ------------------

  assign section_in9 = section_out8;

  assign sub_cast_6 = section_in9;
  assign sub_cast_7 = diff4;
  assign sub_temp_3 = sub_cast_6 - sub_cast_7;
  assign section_out9 = sub_temp_3[50:0];

  always @ (posedge clk or posedge reset)
    begin: comb_delay_section9
      if (reset == 1'b1) begin
        diff4 <= 0;
      end
      else begin
        if (phase_1 == 1'b1) begin
          diff4 <= section_in9;
        end
      end
    end // comb_delay_section9

  //   ------------------ Section # 10 : Comb ------------------

  assign section_in10 = section_out9;

  assign sub_cast_8 = section_in10;
  assign sub_cast_9 = diff5;
  assign sub_temp_4 = sub_cast_8 - sub_cast_9;
  assign section_out10 = sub_temp_4[50:0];

  always @ (posedge clk or posedge reset)
    begin: comb_delay_section10
      if (reset == 1'b1) begin
        diff5 <= 0;
      end
      else begin
        if (phase_1 == 1'b1) begin
          diff5 <= section_in10;
        end
      end
    end // comb_delay_section10

  //   ------------------ Output Register ------------------

  always @ (posedge clk or posedge reset)
    begin: output_reg_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (phase_1 == 1'b1) begin
          output_register <= section_out10;
        end
      end
    end // output_reg_process

  // Assignment Statements
  assign ce_out = ce_out_reg;
  assign filter_out = output_register;
endmodule  // CIC_filter
