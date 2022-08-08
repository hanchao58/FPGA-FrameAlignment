`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 13:56:48
// Design Name: 
// Module Name: Track
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Track(
	input						Clk,
	input						Rst_n,
	input 						Data_valid,
	input	signed	[11:0]		Data_inI,
	input 	signed	[11:0]		Data_inQ,
	input						Track_en,
	
	output	reg					Track_fail,
	output	reg		[34:0]		Max_power,
	output  reg		[1:0]	    Frame_State
    );
parameter	THREHOLD = 35'd2000000000;
parameter	PN1 = 64'b0000001111110101011001101110110100100111000101111001010001100001;
parameter	PN2 = 64'b0011001010100100111100000110111001100011101011111101101000100001;

reg	[6:0]	PN_cnt;
reg [1:0]	State;
reg	[31:0]	Data_mult0;
reg	[11:0]	PN1_multI;
reg	[11:0]	PN1_multQ;
reg	[11:0]	PN2_multI;
reg	[11:0]	PN2_multQ;
reg	[24:0]	PN1_I_reg;
reg	[24:0]	PN1_I;
reg	[24:0]	PN1_Q_reg;
reg	[24:0]	PN1_Q;
reg	[24:0]	PN2_I_reg;
reg	[24:0]	PN2_I;
reg	[24:0]	PN2_Q_reg;
reg	[24:0]	PN2_Q;
reg	[34:0]	Max_power_reg;
reg			Cmult_valid_D1;
reg			Cmult_valid_D2;
reg			Cmult_valid_D3;
reg			Cmult_valid_D4;
reg			Track_en_D0;
reg			Track_en_D1;
reg			Track_en_D2;
reg			Track_en_D3;
reg			Track_en_D4;
reg			Track_en_D5;
reg	[34:0]	PN1_power;
reg	[34:0]	PN2_power;
reg	[6:0]	Acc_cnt;
reg			Power_en;
reg			Power_en_D1;
reg			Power_en_D2;
reg			Power_en_D3;
reg			Power_en_D4;
reg			Power_en_D5;
reg			Power_en_D6;
//reg	[34:0]	Max_power_reg;

wire			Cmult_valid;
wire	[63:0]	PN1_cmult_result;
wire	[63:0]	PN2_cmult_result;
wire	[49:0]	PN1_powerI;
wire	[49:0]	PN1_powerQ;
wire	[49:0]	PN2_powerI;
wire	[49:0]	PN2_powerQ;

always@(posedge Clk or negedge Rst_n)
begin
	if(~Rst_n)
		begin
			Track_fail <=1'b0;
			PN_cnt <= 6'd0;
			Data_mult0 <= 32'd0;
			PN1_multI <= 12'd0;
			PN1_multQ <= 12'd0;
			PN2_multI <= 12'd0;
			PN2_multQ <= 12'd0;
			PN1_I_reg <= 25'd0;
			PN1_I <= 25'd0;
			PN1_Q_reg <= 25'd0;
			PN1_Q <= 25'd0;
			PN2_I_reg <= 25'd0;
			PN2_I <= 25'd0;
			PN2_Q_reg <= 25'd0;
			PN2_Q <= 25'd0;
			Cmult_valid_D1 <= 1'b0;
			Cmult_valid_D2 <= 1'b0;
			Cmult_valid_D3 <= 1'b0;
			Cmult_valid_D4 <= 1'b0;
			Acc_cnt <= 3'd0;
			Track_en_D0 <= 1'b0;
			Track_en_D1 <= 1'b0;
			Track_en_D2 <= 1'b0;
			Track_en_D3 <= 1'b0;
			Track_en_D4 <= 1'b0;
			Track_en_D5 <= 1'b0;
			Power_en <= 1'b0;
			Power_en_D1 <= 1'b0;
			Power_en_D2 <= 1'b0;
			Power_en_D3 <= 1'b0;
			Power_en_D4 <= 1'b0;
			Power_en_D5 <= 1'b0;
			Power_en_D6 <= 1'b0;
			PN1_power <= 35'd0;
			PN2_power <= 35'd0;
			State <= 2'b0;
			Frame_State <=2'b0;
			Max_power_reg <= 35'b0;
		end
	else
		begin
			case(State)
			2'b00:
			begin
				Track_fail <=1'b0;
				PN_cnt <= 6'd0;
				Data_mult0 <= 32'd0;
				PN1_multI <= 12'd0;
				PN1_multQ <= 12'd0;
				PN2_multI <= 12'd0;
				PN2_multQ <= 12'd0;
				PN1_I_reg <= 25'd0;
				PN1_I <= 25'd0;
				PN1_Q_reg <= 25'd0;
				PN1_Q <= 25'd0;
				PN2_I_reg <= 25'd0;
				PN2_I <= 25'd0;
				PN2_Q_reg <= 25'd0;
				PN2_Q <= 25'd0;
				Cmult_valid_D1 <= 1'b0;
				Cmult_valid_D2 <= 1'b0;
				Cmult_valid_D3 <= 1'b0;
				Cmult_valid_D4 <= 1'b0;
				Acc_cnt <= 3'd0;
				Track_en_D0 <= 1'b0;
				Track_en_D1 <= 1'b0;
				Track_en_D2 <= 1'b0;
				Track_en_D3 <= 1'b0;
				Track_en_D4 <= 1'b0;
				Track_en_D5 <= 1'b0;
				PN1_power <= 35'd0;
				PN2_power <= 35'd0;
				Max_power_reg <= 35'd0;
				Frame_State <= 2'd0;
				if(Track_en && Data_valid && ~Track_fail)//相关使能，计数位，数据进入�??
					begin
						State <= 2'b01;
					end
			end
			2'b01:
			begin
				Track_en_D0 <= Track_en;
				Track_en_D1 <= Track_en_D0;
				Track_en_D2 <= Track_en_D1;
				Track_en_D3 <= Track_en_D2;
				Track_en_D4 <= Track_en_D3;
				Track_en_D5 <= Track_en_D4;
				
				Cmult_valid_D1 <= Cmult_valid;
				Cmult_valid_D2 <= Cmult_valid_D1;
				Cmult_valid_D3 <= Cmult_valid_D2;
				Cmult_valid_D4 <= Cmult_valid_D3;
			if(Track_en)
				begin
					Data_mult0 <= {{4{Data_inQ[11]}},Data_inQ[11:0],{4{Data_inI[11]}},Data_inI[11:0]};
					if(PN1[PN_cnt]==1'b1)
						begin
							PN1_multI <= 12'd1414;
							PN1_multQ <= 12'd0-12'd1414;//负数
						end
					else
						begin
							PN1_multI <= 0-12'd1414;
							PN1_multQ <= 12'd1414;
						end
					if(PN2[PN_cnt]==1'b1)
						begin
							PN2_multI <= 12'd1414;
							PN2_multQ <= 12'd0-12'd1414;//负数
						end
					else
						begin
							PN2_multI <= 0-12'd1414;
							PN2_multQ <= 12'd1414;
						end
					PN_cnt <= PN_cnt + 6'd1;
					if(PN_cnt == 6'd63)
						PN_cnt <= 6'd0;
				end
				PN2_Q_reg <= {{4{PN2_cmult_result[56]}},PN2_cmult_result[56:36]};
				PN2_I_reg <= {{4{PN2_cmult_result[24]}},PN2_cmult_result[24:4]};
				PN1_Q_reg <= {{4{PN1_cmult_result[56]}},PN1_cmult_result[56:36]};
				PN1_I_reg <= {{4{PN1_cmult_result[24]}},PN1_cmult_result[24:4]};
				if(Cmult_valid && Acc_cnt <= 6'd63)
					begin
						PN1_Q = PN1_Q + PN1_Q_reg;
						PN1_I = PN1_I + PN1_I_reg;
						PN2_Q = PN2_Q + PN2_Q_reg;
						PN2_I = PN2_I + PN2_I_reg;
					end
				if(Cmult_valid_D1)
					Acc_cnt <= Acc_cnt +6'd1;
				if(Cmult_valid_D4 && Acc_cnt == 6'd63)	
						Power_en <= 1'b1;
					else
						Power_en <= 1'b0;
				Power_en_D1 <= Power_en;
				Power_en_D2 <= Power_en_D1;
				Power_en_D3 <= Power_en_D2;
				Power_en_D4 <= Power_en_D3;
				Power_en_D5 <= Power_en_D4;
				Power_en_D6 <= Power_en_D5;
				if(Power_en_D4)
			
					begin//控制数据大小,去掉预留符号位，截位
						PN1_power <= {PN1_powerI[49],PN1_powerI[47:14]} + {PN1_powerQ[49],PN1_powerQ[47:14]};
						PN2_power <= {PN2_powerI[49],PN2_powerI[47:14]} + {PN2_powerQ[49],PN2_powerQ[47:14]};
					end
				if(Power_en_D5)
					begin
						if(PN1_power>=PN2_power)
							begin
								Max_power_reg <= PN1_power;
								Max_power <= PN1_power;
								Frame_State <= 2'b01;
							end
						else
							begin
								Max_power_reg <= PN2_power;
								Max_power <= PN2_power;
								Frame_State <= 2'b10;
							end
					end
				if(Max_power_reg >= THREHOLD)
					begin
						Track_fail <= 1'b0;
						State <= 2'b00;
						//if(Track_en_D3)
						//Track_fail <= 1'b0;
					end
				else if(Power_en_D6)
					begin
						Track_fail <= 1'b1;
						State <= 2'b00;
					end
			end
			endcase
		end
end

Cmult_xcorr PN1_cmult(
    .aclk(Clk),
    .s_axis_a_tvalid(Track_en_D1),
    .s_axis_a_tdata(Data_mult0),
    .s_axis_b_tvalid(Track_en_D0),
    .s_axis_b_tdata({{4{PN1_multQ[11]}},PN1_multQ[11:0],{4{PN1_multI[11]}},PN1_multI[11:0]}),
    .m_axis_dout_tvalid(Cmult_valid),
    .m_axis_dout_tdata(PN1_cmult_result)
  );
  
Cmult_xcorr PN2_cmult(
    .aclk(Clk),
    .s_axis_a_tvalid(Track_en_D1),
    .s_axis_a_tdata(Data_mult0),
    .s_axis_b_tvalid(Track_en_D0),
    .s_axis_b_tdata({{4{PN2_multQ[11]}},PN2_multQ[11:0],{4{PN2_multI[11]}},PN2_multI[11:0]}),
    .m_axis_dout_tvalid(Cmult_valid),
    .m_axis_dout_tdata(PN2_cmult_result)
  );  
 
Xcorr_2525mult	PN1_Imult(
		.CLK(Clk),
		.A(PN1_I),
		.B(PN1_I),
		.P(PN1_powerI)
);

Xcorr_2525mult	PN1_Qmult(
		.CLK(Clk),
		.A(PN1_Q),
		.B(PN1_Q),
		.P(PN1_powerQ)
);

Xcorr_2525mult	PN2_Imult(
		.CLK(Clk),
		.A(PN2_I),
		.B(PN2_I),
		.P(PN2_powerI)
);

Xcorr_2525mult	PN2_Qmult(
		.CLK(Clk),
		.A(PN2_Q),
		.B(PN2_Q),
		.P(PN2_powerQ)
);
endmodule
