-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Sun Apr  3 13:30:35 2022
-- Host        : DESKTOP-C1SLL7G running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub d:/Projects/frame/frame.srcs/sources_1/ip/Track_ram/Track_ram_stub.vhdl
-- Design      : Track_ram
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu2cg-sbva484-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Track_ram is
  Port ( 
    clka : in STD_LOGIC;
    ena : in STD_LOGIC;
    wea : in STD_LOGIC_VECTOR ( 0 to 0 );
    addra : in STD_LOGIC_VECTOR ( 5 downto 0 );
    dina : in STD_LOGIC_VECTOR ( 23 downto 0 );
    clkb : in STD_LOGIC;
    enb : in STD_LOGIC;
    addrb : in STD_LOGIC_VECTOR ( 5 downto 0 );
    doutb : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );

end Track_ram;

architecture stub of Track_ram is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,ena,wea[0:0],addra[5:0],dina[23:0],clkb,enb,addrb[5:0],doutb[23:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;
