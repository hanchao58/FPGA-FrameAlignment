`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/31 16:24:16
// Design Name: 
// Module Name: Frame_det_top
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


module Frame_det_top(
	input						Clk,
	input						Rst_n,
	input						Data_valid,
	input	signed	[11:0]		Data_inI,
	input	signed	[11:0]		Data_inQ,
	input 						Track_fail,//跟踪失败
	
	output	reg					Det_done,
	output	reg		[11:0]		Det_position,
	output	reg					Frame_start
);
parameter	THREHOLD = 35'd2000000000;

reg	[11:0]	Symbol_cnt;
reg	[2:0]	State;
reg			Xcorr_en;
reg	[11:0]	Start_point;
reg	[34:0]	Max_power_reg;
reg	[6:0]	Max_position_reg;
reg	[6:0]	Max_position0;
reg	[6:0]	Max_position1;
reg	[6:0]	Max_position2;
reg	[6:0]	Minus_0;
reg	[6:0]	Minus_1;
reg	[6:0]	Minus_2;
reg	[1:0]	Det_cnt;

wire	[34:0]	Max_power;
wire	[6:0]	Max_position;
wire	[11:0]	Det_position_wire;

assign Det_position_wire = Start_point + {5'd0,Max_position1};

always@(posedge Clk or negedge Rst_n)
if(~Rst_n || Track_fail)
	Symbol_cnt <= 12'd0;
else
begin
	if(Data_valid == 1'b1)
	begin
		if(Symbol_cnt == 12'd2143)
			Symbol_cnt <= 12'd0;
		else
			Symbol_cnt <= Symbol_cnt+12'd1;
	end
end

always@(posedge Clk or negedge Rst_n)
begin
	if(~Rst_n || Track_fail)
		begin
			Det_done <= 1'b0;
			Det_position <= 12'd0;
			Frame_start <= 1'b0;
			State <= 3'b000;
			Xcorr_en <= 1'b1;
			Start_point <= 12'd0;
			Max_power_reg <= 35'd0;
			Max_position_reg <= 7'd0;
			Max_position0 <= 7'd0;
			Max_position1 <= 7'd0;
			Max_position2 <= 7'd0;
			Minus_0 <= 7'd0;
			Minus_1 <= 7'd0;
			Minus_2 <= 7'd0;
			Det_cnt <= 2'd0;
		end
	else
		begin
			case(State)
			3'b000: //状态0，若相关完成输出位置和能量，跳转状态1
			begin
				if(Xcorr_done)
				begin
					Max_power_reg <= Max_power;
					Max_position_reg <= Max_position;
					State <= 3'b001;
				end
			end
			3'b001://状态1
			begin
				if(Max_power_reg >= THREHOLD) //能量大于门限值，进行窗移动
				    begin
						Max_position0 <= Max_position_reg;
						Max_position1 <= Max_position0;
						Max_position2 <= Max_position1;
						if(Max_position0 >= Max_position_reg)
							Minus_0 <= Max_position0 - Max_position_reg;
						else
							Minus_0 <= Max_position_reg - Max_position0;
						if(Max_position1 >= Max_position_reg)
							Minus_1 <= Max_position1 - Max_position_reg;
						else
							Minus_1 <= Max_position_reg - Max_position1;
						if(Max_position1 >= Max_position0)
							Minus_2 <= Max_position1 - Max_position0;
						else
							Minus_2 <= Max_position0 - Max_position1;
						Det_cnt = Det_cnt + 2'd1;
						State <= 3'b010;
					end
				   else
					begin
						Det_cnt <= 2'd0;
						State <= 3'b011;
					end
			end
			3'b010://同步成功，输出
			begin
				if(Det_cnt == 2'd3)
				begin
					if(Minus_0 <= 7'd1 && Minus_1 <= 7'd1 && Minus_2 <= 7'd1)
						begin
							Det_done <= 1'b1;
							if(Det_position_wire <= 12'd2143)
								Det_position <= Det_position_wire;
							else
								Det_position <= Det_position_wire-12'd2144;
							State <= 3'b100;
						end
					else
						begin
							State <= 3'b101;
						end
				end
				else
					State <= 3'b000;
			end
			3'b011:// 第一次同步失败，重新选择位置同步，返回状态1
			begin
				State <= 3'b000;
				if(Start_point <= 12'd2078)
					Start_point <= Start_point + 12'd65;
				else
					Start_point <= Start_point - 12'd2079; 
			end
			3'b100:
			begin
				Xcorr_en <= 1'b0;
				Det_done <= 1'b0;
				if(Symbol_cnt == Det_position && Data_valid)
					Frame_start <= 1'b1;
				else
					Frame_start <= 1'b0;
			end
			default:
			begin
				Det_done <= 1'b0;
				Det_position <= 12'd0;
				Frame_start <= 1'b0;
				State <= 3'b000;
				Xcorr_en <= 1'b1;
				Start_point <= 12'd0;
				Max_power_reg <= 35'd0;
				Max_position_reg <= 7'd0;
				Max_position0 <= 7'd0;
				Max_position1 <= 7'd0;
				Max_position2 <= 7'd0;
				Minus_0 <= 7'd0;
				Minus_1 <= 7'd0;
				Minus_2 <= 7'd0;
				Det_cnt <= 2'd0;
			end
			endcase
		end
end

Xcorr		u_Xcorr(
		.Clk			(Clk),
		.Rst_n 			(Rst_n && ~Track_fail),
		.Xcorr_en		(Xcorr_en),
		.Start_point	(Start_point),
		.Data_valid		(Data_valid),
		.Data_inI		(Data_inI),
		.Data_inQ		(Data_inQ),
		
		.Xcorr_done		(Xcorr_done),
		.Max_power		(Max_power),
		.Max_position	(Max_position)
);

endmodule