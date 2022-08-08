// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Apr  3 18:16:05 2022
// Host        : DESKTOP-C1SLL7G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub D:/Projects/frame/frame.srcs/sources_1/ip/Xcorr_ram/Xcorr_ram_stub.v
// Design      : Xcorr_ram
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu2cg-sbva484-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module Xcorr_ram(clka, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[3:0],dina[23:0],clkb,enb,addrb[3:0],doutb[23:0]" */;
  input clka;
  input [0:0]wea;
  input [3:0]addra;
  input [23:0]dina;
  input clkb;
  input enb;
  input [3:0]addrb;
  output [23:0]doutb;
endmodule
