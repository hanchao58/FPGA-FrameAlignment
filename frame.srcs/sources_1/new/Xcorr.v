`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/31 16:24:16
// Design Name: 
// Module Name: Xcorr
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


module Xcorr(
		input				Clk,
		input				Rst_n,
		input				Xcorr_en,
		input	[11:0]		Start_point,
		input				Data_valid,
		input	[11:0]		Data_inI,
		input	[11:0]		Data_inQ,
		
		output	reg			Xcorr_done,
		output	reg	[34:0]	Max_power,
		output	reg	[6:0]	Max_position
);

//parameter	PN1 = 64'b1000011000101001111010001110010010110111011001101010111111000000;
parameter	PN1 = 64'b0000001111110101011001101110110100100111000101111001010001100001;
//parameter	PN2 = 64'b1000010001011011111101011100011001110110000011110010010101001100;
parameter	PN2 = 64'b0011001010100100111100000110111001100011101011111101101000100001;



reg	[11:0]	Symbol_cnt;
reg	[1:0]	State;
reg	[6:0]	Wr_cnt;
reg			Wr_en0;
reg			Wr_en1;
reg			Wr_en2;
reg			Wr_en3;
reg			Wr_en4;
reg			Wr_en5;
reg			Wr_en6;
reg			Wr_en7;
reg	[3:0]	Wr_addr0;
reg	[3:0]	Wr_addr1;
reg	[3:0]	Wr_addr2;
reg	[3:0]	Wr_addr3;
reg	[3:0]	Wr_addr4;
reg	[3:0]	Wr_addr5;
reg	[3:0]	Wr_addr6;
reg	[3:0]	Wr_addr7;
reg			Rd_en;
reg			Rd_en_D0;
reg			Rd_en_D1;
reg			Rd_en_D2;
reg			Rd_en_D3;
reg			Rd_en_D4;
reg			Rd_en_D5;
reg	[2:0]	Rd_state;
reg	[2:0]	Rd_cnt;
reg	[3:0]	Rd_addr0;
reg	[3:0]	Rd_addr1;
reg	[3:0]	Rd_addr2;
reg	[3:0]	Rd_addr3;
reg	[3:0]	Rd_addr4;
reg	[3:0]	Rd_addr5;
reg	[3:0]	Rd_addr6;
reg	[3:0]	Rd_addr7;
reg	[5:0]	PN_cnt;
reg	[31:0]	Data_mult0;
reg	[31:0]	Data_mult1;
reg	[31:0]	Data_mult2;
reg	[31:0]	Data_mult3;
reg	[31:0]	Data_mult4;
reg	[31:0]	Data_mult5;
reg	[31:0]	Data_mult6;
reg	[31:0]	Data_mult7;
reg	[11:0]	PN1_mult0I;
reg	[11:0]	PN1_mult1I;
reg	[11:0]	PN1_mult2I;
reg	[11:0]	PN1_mult3I;
reg	[11:0]	PN1_mult4I;
reg	[11:0]	PN1_mult5I;
reg	[11:0]	PN1_mult6I;
reg	[11:0]	PN1_mult7I;
reg	[11:0]	PN1_mult0Q;
reg	[11:0]	PN1_mult1Q;
reg	[11:0]	PN1_mult2Q;
reg	[11:0]	PN1_mult3Q;
reg	[11:0]	PN1_mult4Q;
reg	[11:0]	PN1_mult5Q;
reg	[11:0]	PN1_mult6Q;
reg	[11:0]	PN1_mult7Q;
reg	[11:0]	PN2_mult0I;
reg	[11:0]	PN2_mult1I;
reg	[11:0]	PN2_mult2I;
reg	[11:0]	PN2_mult3I;
reg	[11:0]	PN2_mult4I;
reg	[11:0]	PN2_mult5I;
reg	[11:0]	PN2_mult6I;
reg	[11:0]	PN2_mult7I;
reg	[11:0]	PN2_mult0Q;
reg	[11:0]	PN2_mult1Q;
reg	[11:0]	PN2_mult2Q;
reg	[11:0]	PN2_mult3Q;
reg	[11:0]	PN2_mult4Q;
reg	[11:0]	PN2_mult5Q;
reg	[11:0]	PN2_mult6Q;
reg	[11:0]	PN2_mult7Q;
reg	[24:0]	PN1_I01;
reg	[24:0]	PN1_I23;
reg	[24:0]	PN1_I45;
reg	[24:0]	PN1_I67;
reg	[24:0]	PN1_I0123;
reg	[24:0]	PN1_I4567;
reg	[24:0]	PN1_I_reg;
reg	[24:0]	PN1_I;
reg	[24:0]	PN1_Q01;
reg	[24:0]	PN1_Q23;
reg	[24:0]	PN1_Q45;
reg	[24:0]	PN1_Q67;
reg	[24:0]	PN1_Q0123;
reg	[24:0]	PN1_Q4567;
reg	[24:0]	PN1_Q_reg;
reg	[24:0]	PN1_Q;
reg	[24:0]	PN2_I01;
reg	[24:0]	PN2_I23;
reg	[24:0]	PN2_I45;
reg	[24:0]	PN2_I67;
reg	[24:0]	PN2_I0123;
reg	[24:0]	PN2_I4567;
reg	[24:0]	PN2_I_reg;
reg	[24:0]	PN2_I;
reg	[24:0]	PN2_Q01;
reg	[24:0]	PN2_Q23;
reg	[24:0]	PN2_Q45;
reg	[24:0]	PN2_Q67;
reg	[24:0]	PN2_Q0123;
reg	[24:0]	PN2_Q4567;
reg	[24:0]	PN2_Q_reg;
reg	[24:0]	PN2_Q;
reg			Cmult_valid_D1;
reg			Cmult_valid_D2;
reg			Cmult_valid_D3;
reg			Cmult_valid_D4;
reg	[2:0]	Acc_cnt;
reg			Power_en;
reg			Power_en_D1;
reg			Power_en_D2;
reg			Power_en_D3;
reg			Power_en_D4;
reg			Power_en_D5;
reg			Power_en_D6;
reg	[34:0]	PN1_power;
reg	[34:0]	PN2_power;
reg	[6:0]	Cal_cnt;
reg	[34:0]	Max_power_reg;

wire	[23:0]	Rd_data0;
wire	[23:0]	Rd_data1;
wire	[23:0]	Rd_data2;
wire	[23:0]	Rd_data3;
wire	[23:0]	Rd_data4;
wire	[23:0]	Rd_data5;
wire	[23:0]	Rd_data6;
wire	[23:0]	Rd_data7;
wire			Cmult_valid;
wire	[63:0]	PN1_cmult_result0;
wire	[63:0]	PN1_cmult_result1;
wire	[63:0]	PN1_cmult_result2;
wire	[63:0]	PN1_cmult_result3;
wire	[63:0]	PN1_cmult_result4;
wire	[63:0]	PN1_cmult_result5;
wire	[63:0]	PN1_cmult_result6;
wire	[63:0]	PN1_cmult_result7;
wire	[63:0]	PN2_cmult_result0;
wire	[63:0]	PN2_cmult_result1;
wire	[63:0]	PN2_cmult_result2;
wire	[63:0]	PN2_cmult_result3;
wire	[63:0]	PN2_cmult_result4;
wire	[63:0]	PN2_cmult_result5;
wire	[63:0]	PN2_cmult_result6;
wire	[63:0]	PN2_cmult_result7;
wire	[49:0]	PN1_powerI;
wire	[49:0]	PN1_powerQ;
wire	[49:0]	PN2_powerI;
wire	[49:0]	PN2_powerQ;

always@(posedge Clk or negedge Rst_n)//计数
begin
	if(~Rst_n)
		Symbol_cnt <= 12'd0;
	else 
		begin
			if(Data_valid)
				begin
					if(Symbol_cnt == 12'd2143)
						Symbol_cnt <= 12'd0;
					else
						Symbol_cnt <= Symbol_cnt+12'd1;
				end
		end
end

always@(posedge Clk or negedge Rst_n)
begin
	if(~Rst_n)
		begin
			Xcorr_done <= 1'b0;
			Max_power <= 35'd0;
			Max_position <= 7'd0;
			State <= 2'b00;
			Wr_cnt <= 7'd0;
			Wr_en0 <= 1'b0;
			Wr_en1 <= 1'b0;
			Wr_en2 <= 1'b0;
			Wr_en3 <= 1'b0;
			Wr_en4 <= 1'b0;
			Wr_en5 <= 1'b0;
			Wr_en6 <= 1'b0;
			Wr_en7 <= 1'b0;
			Wr_addr0 <= 4'd0;
			Wr_addr1 <= 4'd0;
			Wr_addr2 <= 4'd0;
			Wr_addr3 <= 4'd0;
			Wr_addr4 <= 4'd0;
			Wr_addr5 <= 4'd0;
			Wr_addr6 <= 4'd0;
			Wr_addr7 <= 4'd0;
			Rd_en <= 1'b0;
			Rd_en_D0 <= 1'b0;
			Rd_en_D1 <= 1'b0;
			Rd_en_D2 <= 1'b0;
			Rd_en_D3 <= 1'b0;
			Rd_en_D4 <= 1'b0;
			Rd_en_D5 <= 1'b0;
			Rd_state <= 3'd0;
			Rd_cnt <= 3'd0;
			Rd_addr0 <= 4'd0;
			Rd_addr1 <= 4'd0;
			Rd_addr2 <= 4'd0;
			Rd_addr3 <= 4'd0;
			Rd_addr4 <= 4'd0;
			Rd_addr5 <= 4'd0;
			Rd_addr6 <= 4'd0;
			Rd_addr7 <= 4'd0;
			PN_cnt <= 6'd0;
			Data_mult0 <= 32'd0;
			Data_mult1 <= 32'd0;
			Data_mult2 <= 32'd0;
			Data_mult3 <= 32'd0;
			Data_mult4 <= 32'd0;
			Data_mult5 <= 32'd0;
			Data_mult6 <= 32'd0;
			Data_mult7 <= 32'd0;
			PN1_mult0I <= 12'd0;
			PN1_mult1I <= 12'd0;
			PN1_mult2I <= 12'd0;
			PN1_mult3I <= 12'd0;
			PN1_mult4I <= 12'd0;
			PN1_mult5I <= 12'd0;
			PN1_mult6I <= 12'd0;
			PN1_mult7I <= 12'd0;
			PN1_mult0Q <= 12'd0;
			PN1_mult1Q <= 12'd0;
			PN1_mult2Q <= 12'd0;
			PN1_mult3Q <= 12'd0;
			PN1_mult4Q <= 12'd0;
			PN1_mult5Q <= 12'd0;
			PN1_mult6Q <= 12'd0;
			PN1_mult7Q <= 12'd0;
			PN2_mult0I <= 12'd0;
			PN2_mult1I <= 12'd0;
			PN2_mult2I <= 12'd0;
			PN2_mult3I <= 12'd0;
			PN2_mult4I <= 12'd0;
			PN2_mult5I <= 12'd0;
			PN2_mult6I <= 12'd0;
			PN2_mult7I <= 12'd0;
			PN2_mult0Q <= 12'd0;
			PN2_mult1Q <= 12'd0;
			PN2_mult2Q <= 12'd0;
			PN2_mult3Q <= 12'd0;
			PN2_mult4Q <= 12'd0;
			PN2_mult5Q <= 12'd0;
			PN2_mult6Q <= 12'd0;
			PN2_mult7Q <= 12'd0;
			PN1_I01 <= 25'd0;
			PN1_I23 <= 25'd0;
			PN1_I45 <= 25'd0;
			PN1_I67 <= 25'd0;
			PN1_I0123 <= 25'd0;
			PN1_I4567 <= 25'd0;
			PN1_I_reg <= 25'd0;
			PN1_I <= 25'd0;
			PN1_Q01 <= 25'd0;
			PN1_Q23 <= 25'd0;
			PN1_Q45 <= 25'd0;
			PN1_Q67 <= 25'd0;
			PN1_Q0123 <= 25'd0;
			PN1_Q4567 <= 25'd0;
			PN1_Q_reg <= 25'd0;
			PN1_Q <= 25'd0;
			PN2_I01 <= 25'd0;
			PN2_I23 <= 25'd0;
			PN2_I45 <= 25'd0;
			PN2_I67 <= 25'd0;
			PN2_I0123 <= 25'd0;
			PN2_I4567 <= 25'd0;
			PN2_I_reg <= 25'd0;
			PN2_I <= 25'd0;
			PN2_Q01	<= 25'd0;
			PN2_Q23	<= 25'd0;
			PN2_Q45	<= 25'd0;
			PN2_Q67	<= 25'd0;
			PN2_Q0123 <= 25'd0;
			PN2_Q4567 <= 25'd0;
			PN2_Q_reg <= 25'd0;
			PN2_Q <= 25'd0;
			Cmult_valid_D1 <= 1'b0;
			Cmult_valid_D2 <= 1'b0;
			Cmult_valid_D3 <= 1'b0;
			Cmult_valid_D4 <= 1'b0;
			Acc_cnt <= 3'd0;
			Power_en <= 1'b0;
			Power_en_D1 <= 1'b0;
			Power_en_D2 <= 1'b0;
			Power_en_D3 <= 1'b0;
			Power_en_D4 <= 1'b0;
			Power_en_D5 <= 1'b0;
			Power_en_D6 <= 1'b0;
			PN1_power <= 35'd0;
			PN2_power <= 35'd0;
			Cal_cnt <= 7'd0;
			Max_power_reg <= 35'd0;
		end
	else
		begin
			case(State)
			2'b00:
			begin
				Xcorr_done <= 1'b0;
				Max_power <= 35'd0;
				Max_position <= 7'd0;
				State <= 2'b00;
				Wr_cnt <= 7'd0;
				Wr_en0 <= 1'b0;
				Wr_en1 <= 1'b0;
				Wr_en2 <= 1'b0;
				Wr_en3 <= 1'b0;
				Wr_en4 <= 1'b0;
				Wr_en5 <= 1'b0;
				Wr_en6 <= 1'b0;
				Wr_en7 <= 1'b0;
				Wr_addr0 <= 4'd0;
				Wr_addr1 <= 4'd0;
				Wr_addr2 <= 4'd0;
				Wr_addr3 <= 4'd0;
				Wr_addr4 <= 4'd0;
				Wr_addr5 <= 4'd0;
				Wr_addr6 <= 4'd0;
				Wr_addr7 <= 4'd0;
				Rd_en <= 1'b0;
				Rd_en_D0 <= 1'b0;
				Rd_en_D1 <= 1'b0;
				Rd_en_D2 <= 1'b0;
				Rd_en_D3 <= 1'b0;
				Rd_en_D4 <= 1'b0;
				Rd_en_D5 <= 1'b0;
				Rd_state <= 3'd0;
				Rd_cnt <= 3'd0;
				Rd_addr0 <= 4'd0;
				Rd_addr1 <= 4'd0;
				Rd_addr2 <= 4'd0;
				Rd_addr3 <= 4'd0;
				Rd_addr4 <= 4'd0;
				Rd_addr5 <= 4'd0;
				Rd_addr6 <= 4'd0;
				Rd_addr7 <= 4'd0;
				PN_cnt <= 6'd0;
				Data_mult0 <= 32'd0;
				Data_mult1 <= 32'd0;
				Data_mult2 <= 32'd0;
				Data_mult3 <= 32'd0;
				Data_mult4 <= 32'd0;
				Data_mult5 <= 32'd0;
				Data_mult6 <= 32'd0;
				Data_mult7 <= 32'd0;
				PN1_mult0I <= 12'd0;
				PN1_mult1I <= 12'd0;
				PN1_mult2I <= 12'd0;
				PN1_mult3I <= 12'd0;
				PN1_mult4I <= 12'd0;
				PN1_mult5I <= 12'd0;
				PN1_mult6I <= 12'd0;
				PN1_mult7I <= 12'd0;
				PN1_mult0Q <= 12'd0;
				PN1_mult1Q <= 12'd0;
				PN1_mult2Q <= 12'd0;
				PN1_mult3Q <= 12'd0;
				PN1_mult4Q <= 12'd0;
				PN1_mult5Q <= 12'd0;
				PN1_mult6Q <= 12'd0;
				PN1_mult7Q <= 12'd0;
				PN2_mult0I <= 12'd0;
				PN2_mult1I <= 12'd0;
				PN2_mult2I <= 12'd0;
				PN2_mult3I <= 12'd0;
				PN2_mult4I <= 12'd0;
				PN2_mult5I <= 12'd0;
				PN2_mult6I <= 12'd0;
				PN2_mult7I <= 12'd0;
				PN2_mult0Q <= 12'd0;
				PN2_mult1Q <= 12'd0;
				PN2_mult2Q <= 12'd0;
				PN2_mult3Q <= 12'd0;
				PN2_mult4Q <= 12'd0;
				PN2_mult5Q <= 12'd0;
				PN2_mult6Q <= 12'd0;
				PN2_mult7Q <= 12'd0;
				PN1_I01 <= 25'd0;
				PN1_I23 <= 25'd0;
				PN1_I45 <= 25'd0;
				PN1_I67 <= 25'd0;
				PN1_I0123 <= 25'd0;
				PN1_I4567 <= 25'd0;
				PN1_I_reg <= 25'd0;
				PN1_I <= 25'd0;
				PN1_Q01 <= 25'd0;
				PN1_Q23 <= 25'd0;
				PN1_Q45 <= 25'd0;
				PN1_Q67 <= 25'd0;
				PN1_Q0123 <= 25'd0;
				PN1_Q4567 <= 25'd0;
				PN1_Q_reg <= 25'd0;
				PN1_Q <= 25'd0;
				PN2_I01 <= 25'd0;
				PN2_I23 <= 25'd0;
				PN2_I45 <= 25'd0;
				PN2_I67 <= 25'd0;
				PN2_I0123 <= 25'd0;
				PN2_I4567 <= 25'd0;
				PN2_I_reg <= 25'd0;
				PN2_I <= 25'd0;
				PN2_Q01	<= 25'd0;
				PN2_Q23	<= 25'd0;
				PN2_Q45	<= 25'd0;
				PN2_Q67	<= 25'd0;
				PN2_Q0123 <= 25'd0;
				PN2_Q4567 <= 25'd0;
				PN2_Q_reg <= 25'd0;
				PN2_Q <= 25'd0;
				Cmult_valid_D1 <= 1'b0;
				Cmult_valid_D2 <= 1'b0;
				Cmult_valid_D3 <= 1'b0;
				Cmult_valid_D4 <= 1'b0;
				Acc_cnt <= 3'd0;
				Power_en <= 1'b0;
				Power_en_D1 <= 1'b0;
				Power_en_D2 <= 1'b0;
				Power_en_D3 <= 1'b0;
				Power_en_D4 <= 1'b0;
				Power_en_D5 <= 1'b0;
				Power_en_D6 <= 1'b0;
				PN1_power <= 35'd0;
				PN2_power <= 35'd0;
				Cal_cnt <= 7'd0;
				Max_power_reg <= 35'd0;
				if(Xcorr_en && Symbol_cnt == Start_point && Data_valid)//相关使能，计数位，数据进入。
					begin
						State <= 2'b01;
						Wr_en0 <= 1'b1;
					end
			end
			2'b01:
			begin
				if(Data_valid)
					begin
						if(Wr_cnt == 7'd127)//写入计数,共128，从0~7RAm中依次写入
							Wr_en0 <= 1'b0;
						else
							Wr_en0 <= Wr_en7;
						Wr_en1 <= Wr_en0;
						Wr_en2 <= Wr_en1;
						Wr_en3 <= Wr_en2;
						Wr_en4 <= Wr_en3;
						Wr_en5 <= Wr_en4;
						Wr_en6 <= Wr_en5;
						Wr_en7 <= Wr_en6;
						Wr_cnt <= Wr_cnt + 7'd1;
					end
				if(Wr_en0 && Data_valid)//写入地址
					Wr_addr0 <= Wr_addr0 + 4'd1;
				if(Wr_en1 && Data_valid)
					Wr_addr1 <= Wr_addr1 + 4'd1;
				if(Wr_en2 && Data_valid)
					Wr_addr2 <= Wr_addr2 + 4'd1;
				if(Wr_en3 && Data_valid)
					Wr_addr3 <= Wr_addr3 + 4'd1;
				if(Wr_en4 && Data_valid)
					Wr_addr4 <= Wr_addr4 + 4'd1;
				if(Wr_en5 && Data_valid)
					Wr_addr5 <= Wr_addr5 + 4'd1;
				if(Wr_en6 && Data_valid)
					Wr_addr6 <= Wr_addr6 + 4'd1;
				if(Wr_en7 && Data_valid)
					Wr_addr7 <= Wr_addr7 + 4'd1;
					
				if(Wr_cnt == 7'd127 && Data_valid)//切换状态
				     begin
						State <= 2'b10;
						Rd_en <= 1'd1; //读使能
						Rd_state <= 3'd0;//读取状态机
				     end
			end
			2'b10:
			begin//延时寄存器
				Rd_en_D0 <= Rd_en;
				Rd_en_D1 <= Rd_en_D0;
				Rd_en_D2 <= Rd_en_D1;
				Rd_en_D3 <= Rd_en_D2;
				Rd_en_D4 <= Rd_en_D3;
				Rd_en_D5 <= Rd_en_D4;
				if(Rd_en)//读计数
					Rd_cnt <= Rd_cnt + 3'd1;
				if(Rd_en && Rd_cnt == 3'd7)
					Rd_en <=1'd0;
					
				if(Rd_en)
					begin
						Rd_addr0 <= Rd_addr0 + 4'd1;
						Rd_addr1 <= Rd_addr1 + 4'd1;
						Rd_addr2 <= Rd_addr2 + 4'd1;
						Rd_addr3 <= Rd_addr3 + 4'd1;
						Rd_addr4 <= Rd_addr4 + 4'd1;
						Rd_addr5 <= Rd_addr5 + 4'd1;
						Rd_addr6 <= Rd_addr6 + 4'd1;
						Rd_addr7 <= Rd_addr7 + 4'd1;
					end
				if(Rd_en_D0)
					begin
						case(Rd_state)
						3'd0:
						begin  //补位符号位，低位Q，高位I
							Data_mult0 <= {{4{Rd_data0[11]}},Rd_data0[11:0],{4{Rd_data0[23]}},Rd_data0[23:12]};
							Data_mult1 <= {{4{Rd_data1[11]}},Rd_data1[11:0],{4{Rd_data1[23]}},Rd_data1[23:12]};
							Data_mult2 <= {{4{Rd_data2[11]}},Rd_data2[11:0],{4{Rd_data2[23]}},Rd_data2[23:12]};
							Data_mult3 <= {{4{Rd_data3[11]}},Rd_data3[11:0],{4{Rd_data3[23]}},Rd_data3[23:12]};
							Data_mult4 <= {{4{Rd_data4[11]}},Rd_data4[11:0],{4{Rd_data4[23]}},Rd_data4[23:12]};
							Data_mult5 <= {{4{Rd_data5[11]}},Rd_data5[11:0],{4{Rd_data5[23]}},Rd_data5[23:12]};
							Data_mult6 <= {{4{Rd_data6[11]}},Rd_data6[11:0],{4{Rd_data6[23]}},Rd_data6[23:12]};
							Data_mult7 <= {{4{Rd_data7[11]}},Rd_data7[11:0],{4{Rd_data7[23]}},Rd_data7[23:12]};
						end
						3'd1:
						begin
							Data_mult0 <= {{4{Rd_data1[11]}},Rd_data1[11:0],{4{Rd_data1[23]}},Rd_data1[23:12]};
							Data_mult1 <= {{4{Rd_data2[11]}},Rd_data2[11:0],{4{Rd_data2[23]}},Rd_data2[23:12]};
							Data_mult2 <= {{4{Rd_data3[11]}},Rd_data3[11:0],{4{Rd_data3[23]}},Rd_data3[23:12]};
							Data_mult3 <= {{4{Rd_data4[11]}},Rd_data4[11:0],{4{Rd_data4[23]}},Rd_data4[23:12]};
							Data_mult4 <= {{4{Rd_data5[11]}},Rd_data5[11:0],{4{Rd_data5[23]}},Rd_data5[23:12]};
							Data_mult5 <= {{4{Rd_data6[11]}},Rd_data6[11:0],{4{Rd_data6[23]}},Rd_data6[23:12]};
							Data_mult6 <= {{4{Rd_data7[11]}},Rd_data7[11:0],{4{Rd_data7[23]}},Rd_data7[23:12]};
							Data_mult7 <= {{4{Rd_data0[11]}},Rd_data0[11:0],{4{Rd_data0[23]}},Rd_data0[23:12]};
						end
						3'd2:
						begin
							Data_mult0 <= {{4{Rd_data2[11]}},Rd_data2[11:0],{4{Rd_data2[23]}},Rd_data2[23:12]};
							Data_mult1 <= {{4{Rd_data3[11]}},Rd_data3[11:0],{4{Rd_data3[23]}},Rd_data3[23:12]};
							Data_mult2 <= {{4{Rd_data4[11]}},Rd_data4[11:0],{4{Rd_data4[23]}},Rd_data4[23:12]};
							Data_mult3 <= {{4{Rd_data5[11]}},Rd_data5[11:0],{4{Rd_data5[23]}},Rd_data5[23:12]};
							Data_mult4 <= {{4{Rd_data6[11]}},Rd_data6[11:0],{4{Rd_data6[23]}},Rd_data6[23:12]};
							Data_mult5 <= {{4{Rd_data7[11]}},Rd_data7[11:0],{4{Rd_data7[23]}},Rd_data7[23:12]};
							Data_mult6 <= {{4{Rd_data0[11]}},Rd_data0[11:0],{4{Rd_data0[23]}},Rd_data0[23:12]};
							Data_mult7 <= {{4{Rd_data1[11]}},Rd_data1[11:0],{4{Rd_data1[23]}},Rd_data1[23:12]};
						end
						3'd3:
						begin
							Data_mult0 <= {{4{Rd_data3[11]}},Rd_data3[11:0],{4{Rd_data3[23]}},Rd_data3[23:12]};
							Data_mult1 <= {{4{Rd_data4[11]}},Rd_data4[11:0],{4{Rd_data4[23]}},Rd_data4[23:12]};
							Data_mult2 <= {{4{Rd_data5[11]}},Rd_data5[11:0],{4{Rd_data5[23]}},Rd_data5[23:12]};
							Data_mult3 <= {{4{Rd_data6[11]}},Rd_data6[11:0],{4{Rd_data6[23]}},Rd_data6[23:12]};
							Data_mult4 <= {{4{Rd_data7[11]}},Rd_data7[11:0],{4{Rd_data7[23]}},Rd_data7[23:12]};
							Data_mult5 <= {{4{Rd_data0[11]}},Rd_data0[11:0],{4{Rd_data0[23]}},Rd_data0[23:12]};
							Data_mult6 <= {{4{Rd_data1[11]}},Rd_data1[11:0],{4{Rd_data1[23]}},Rd_data1[23:12]};
							Data_mult7 <= {{4{Rd_data2[11]}},Rd_data2[11:0],{4{Rd_data2[23]}},Rd_data2[23:12]};
						end
						3'd4:
						begin
							Data_mult0 <= {{4{Rd_data4[11]}},Rd_data4[11:0],{4{Rd_data4[23]}},Rd_data4[23:12]};
							Data_mult1 <= {{4{Rd_data5[11]}},Rd_data5[11:0],{4{Rd_data5[23]}},Rd_data5[23:12]};
							Data_mult2 <= {{4{Rd_data6[11]}},Rd_data6[11:0],{4{Rd_data6[23]}},Rd_data6[23:12]};
							Data_mult3 <= {{4{Rd_data7[11]}},Rd_data7[11:0],{4{Rd_data7[23]}},Rd_data7[23:12]};
							Data_mult4 <= {{4{Rd_data0[11]}},Rd_data0[11:0],{4{Rd_data0[23]}},Rd_data0[23:12]};
							Data_mult5 <= {{4{Rd_data1[11]}},Rd_data1[11:0],{4{Rd_data1[23]}},Rd_data1[23:12]};
							Data_mult6 <= {{4{Rd_data2[11]}},Rd_data2[11:0],{4{Rd_data2[23]}},Rd_data2[23:12]};
							Data_mult7 <= {{4{Rd_data3[11]}},Rd_data3[11:0],{4{Rd_data3[23]}},Rd_data3[23:12]};
						end
						3'd5:
						begin
							Data_mult0 <= {{4{Rd_data5[11]}},Rd_data5[11:0],{4{Rd_data5[23]}},Rd_data5[23:12]};
							Data_mult1 <= {{4{Rd_data6[11]}},Rd_data6[11:0],{4{Rd_data6[23]}},Rd_data6[23:12]};
							Data_mult2 <= {{4{Rd_data7[11]}},Rd_data7[11:0],{4{Rd_data7[23]}},Rd_data7[23:12]};
							Data_mult3 <= {{4{Rd_data0[11]}},Rd_data0[11:0],{4{Rd_data0[23]}},Rd_data0[23:12]};
							Data_mult4 <= {{4{Rd_data1[11]}},Rd_data1[11:0],{4{Rd_data1[23]}},Rd_data1[23:12]};
							Data_mult5 <= {{4{Rd_data2[11]}},Rd_data2[11:0],{4{Rd_data2[23]}},Rd_data2[23:12]};
							Data_mult6 <= {{4{Rd_data3[11]}},Rd_data3[11:0],{4{Rd_data3[23]}},Rd_data3[23:12]};
							Data_mult7 <= {{4{Rd_data4[11]}},Rd_data4[11:0],{4{Rd_data4[23]}},Rd_data4[23:12]};
						end
						3'd6:
						begin
							Data_mult0 <= {{4{Rd_data6[11]}},Rd_data6[11:0],{4{Rd_data6[23]}},Rd_data6[23:12]};
							Data_mult1 <= {{4{Rd_data7[11]}},Rd_data7[11:0],{4{Rd_data7[23]}},Rd_data7[23:12]};
							Data_mult2 <= {{4{Rd_data0[11]}},Rd_data0[11:0],{4{Rd_data0[23]}},Rd_data0[23:12]};
							Data_mult3 <= {{4{Rd_data1[11]}},Rd_data1[11:0],{4{Rd_data1[23]}},Rd_data1[23:12]};
							Data_mult4 <= {{4{Rd_data2[11]}},Rd_data2[11:0],{4{Rd_data2[23]}},Rd_data2[23:12]};
							Data_mult5 <= {{4{Rd_data3[11]}},Rd_data3[11:0],{4{Rd_data3[23]}},Rd_data3[23:12]};
							Data_mult6 <= {{4{Rd_data4[11]}},Rd_data4[11:0],{4{Rd_data4[23]}},Rd_data4[23:12]};
							Data_mult7 <= {{4{Rd_data5[11]}},Rd_data5[11:0],{4{Rd_data5[23]}},Rd_data5[23:12]};
						end
						3'd7:
						begin
							Data_mult0 <= {{4{Rd_data7[11]}},Rd_data7[11:0],{4{Rd_data7[23]}},Rd_data7[23:12]};
							Data_mult1 <= {{4{Rd_data0[11]}},Rd_data0[11:0],{4{Rd_data0[23]}},Rd_data0[23:12]};
							Data_mult2 <= {{4{Rd_data1[11]}},Rd_data1[11:0],{4{Rd_data1[23]}},Rd_data1[23:12]};
							Data_mult3 <= {{4{Rd_data2[11]}},Rd_data2[11:0],{4{Rd_data2[23]}},Rd_data2[23:12]};
							Data_mult4 <= {{4{Rd_data3[11]}},Rd_data3[11:0],{4{Rd_data3[23]}},Rd_data3[23:12]};
							Data_mult5 <= {{4{Rd_data4[11]}},Rd_data4[11:0],{4{Rd_data4[23]}},Rd_data4[23:12]};
							Data_mult6 <= {{4{Rd_data5[11]}},Rd_data5[11:0],{4{Rd_data5[23]}},Rd_data5[23:12]};
							Data_mult7 <= {{4{Rd_data6[11]}},Rd_data6[11:0],{4{Rd_data6[23]}},Rd_data6[23:12]};
						end
						endcase // 映射
					end
				if(Rd_en_D1)
					begin
						if(PN1[PN_cnt]==1'b1)
							begin
								PN1_mult0I <= 12'd1414;
								PN1_mult0Q <= 12'd0-12'd1414;//负数
							end
						else
							begin
								PN1_mult0I <= 0-12'd1414;
								PN1_mult0Q <= 12'd1414;
							end
						if(PN1[PN_cnt+6'd1]==1'b1)
							begin
								PN1_mult1I <= 12'd1414;
								PN1_mult1Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN1_mult1I <= 0-12'd1414;
								PN1_mult1Q <= 12'd1414;
							end
						if(PN1[PN_cnt+6'd2]==1'b1)
							begin
								PN1_mult2I <= 12'd1414;
								PN1_mult2Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN1_mult2I <= 0-12'd1414;
								PN1_mult2Q <= 12'd1414;
							end
						if(PN1[PN_cnt+6'd3]==1'b1)
							begin
								PN1_mult3I <= 12'd1414;
								PN1_mult3Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN1_mult3I <= 0-12'd1414;
								PN1_mult3Q <= 12'd1414;
							end
						if(PN1[PN_cnt+6'd4]==1'b1)
							begin
								PN1_mult4I <= 12'd1414;
								PN1_mult4Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN1_mult4I <= 0-12'd1414;
								PN1_mult4Q <= 12'd1414;
							end
						if(PN1[PN_cnt+6'd5]==1'b1)
							begin
								PN1_mult5I <= 12'd1414;
								PN1_mult5Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN1_mult5I <= 0-12'd1414;
								PN1_mult5Q <= 12'd1414;
							end
						if(PN1[PN_cnt+6'd6]==1'b1)
							begin
								PN1_mult6I <= 12'd1414;
								PN1_mult6Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN1_mult6I <= 0-12'd1414;
								PN1_mult6Q <= 12'd1414;
							end
						if(PN1[PN_cnt+6'd7]==1'b1)
							begin
								PN1_mult7I <= 12'd1414;
								PN1_mult7Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN1_mult7I <= 0-12'd1414;
								PN1_mult7Q <= 12'd1414;
							end
						if(PN2[PN_cnt]==1'b1)//空白帧
							begin
								PN2_mult0I <= 12'd1414;
								PN2_mult0Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN2_mult0I <= 0-12'd1414;
								PN2_mult0Q <= 12'd1414;
							end
						if(PN2[PN_cnt+6'd1]==1'b1)
							begin
								PN2_mult1I <= 12'd1414;
								PN2_mult1Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN2_mult1I <= 0-12'd1414;
								PN2_mult1Q <= 12'd1414;
							end
						if(PN2[PN_cnt+6'd2]==1'b1)
							begin
								PN2_mult2I <= 12'd1414;
								PN2_mult2Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN2_mult2I <= 0-12'd1414;
								PN2_mult2Q <= 12'd1414;
							end
						if(PN2[PN_cnt+6'd3]==1'b1)
							begin
								PN2_mult3I <= 12'd1414;
								PN2_mult3Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN2_mult3I <= 0-12'd1414;
								PN2_mult3Q <= 12'd1414;
							end
						if(PN2[PN_cnt+6'd4]==1'b1)
							begin
								PN2_mult4I <= 12'd1414;
								PN2_mult4Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN2_mult4I <= 0-12'd1414;
								PN2_mult4Q <= 12'd1414;
							end
						if(PN2[PN_cnt+6'd5]==1'b1)
							begin
								PN2_mult5I <= 12'd1414;
								PN2_mult5Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN2_mult5I <= 0-12'd1414;
								PN2_mult5Q <= 12'd1414;
							end
						if(PN2[PN_cnt+6'd6]==1'b1)
							begin
								PN2_mult6I <= 12'd1414;
								PN2_mult6Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN2_mult6I <= 0-12'd1414;
								PN2_mult6Q <= 12'd1414;
							end
						if(PN2[PN_cnt+6'd7]==1'b1)
							begin
								PN2_mult7I <= 12'd1414;
								PN2_mult7Q <= 12'd0-12'd1414;
							end
						else
							begin
								PN2_mult7I <= 0-12'd1414;
								PN2_mult7Q <= 12'd1414;
							end
						PN_cnt <= PN_cnt + 6'd8;
					end
					PN1_I01 <= {{4{PN1_cmult_result0[24]}},PN1_cmult_result0[24:4]} + {{4{PN1_cmult_result1[24]}},PN1_cmult_result1[24:4]};
					PN1_I23 <= {{4{PN1_cmult_result2[24]}},PN1_cmult_result2[24:4]} + {{4{PN1_cmult_result3[24]}},PN1_cmult_result3[24:4]};
					PN1_I45 <= {{4{PN1_cmult_result4[24]}},PN1_cmult_result4[24:4]} + {{4{PN1_cmult_result5[24]}},PN1_cmult_result5[24:4]};
					PN1_I67 <= {{4{PN1_cmult_result6[24]}},PN1_cmult_result6[24:4]} + {{4{PN1_cmult_result7[24]}},PN1_cmult_result7[24:4]};
					PN1_I0123 <= PN1_I01 + PN1_I23;
					PN1_I4567 <= PN1_I45 + PN1_I67;
					PN1_I_reg = PN1_I0123 + PN1_I4567;
					if(Cmult_valid_D3)
						PN1_I = PN1_I + PN1_I_reg;
					
					PN1_Q01 <= {{4{PN1_cmult_result0[56]}},PN1_cmult_result0[56:36]} + {{4{PN1_cmult_result1[56]}},PN1_cmult_result1[56:36]};
					PN1_Q23 <= {{4{PN1_cmult_result2[56]}},PN1_cmult_result2[56:36]} + {{4{PN1_cmult_result3[56]}},PN1_cmult_result3[56:36]};
					PN1_Q45 <= {{4{PN1_cmult_result4[56]}},PN1_cmult_result4[56:36]} + {{4{PN1_cmult_result5[56]}},PN1_cmult_result5[56:36]};
					PN1_Q67 <= {{4{PN1_cmult_result6[56]}},PN1_cmult_result6[56:36]} + {{4{PN1_cmult_result7[56]}},PN1_cmult_result7[56:36]};
					PN1_Q0123 <= PN1_Q01 + PN1_Q23;
					PN1_Q4567 <= PN1_Q45 + PN1_Q67;
					PN1_Q_reg = PN1_Q0123 + PN1_Q4567;
					if(Cmult_valid_D3)
						PN1_Q = PN1_Q + PN1_Q_reg;
					
					PN2_I01 <= {{4{PN2_cmult_result0[24]}},PN2_cmult_result0[24:4]} + {{4{PN2_cmult_result1[24]}},PN2_cmult_result1[24:4]};
					PN2_I23 <= {{4{PN2_cmult_result2[24]}},PN2_cmult_result2[24:4]} + {{4{PN2_cmult_result3[24]}},PN2_cmult_result3[24:4]};
					PN2_I45 <= {{4{PN2_cmult_result4[24]}},PN2_cmult_result4[24:4]} + {{4{PN2_cmult_result5[24]}},PN2_cmult_result5[24:4]};
					PN2_I67 <= {{4{PN2_cmult_result6[24]}},PN2_cmult_result6[24:4]} + {{4{PN2_cmult_result7[24]}},PN2_cmult_result7[24:4]};
					PN2_I0123 <= PN2_I01 + PN2_I23;
					PN2_I4567 <= PN2_I45 + PN2_I67;
					PN2_I_reg = PN2_I0123 + PN2_I4567;
					if(Cmult_valid_D3)
						PN2_I = PN2_I + PN2_I_reg;
					
					PN2_Q01 <= {{4{PN2_cmult_result0[56]}},PN2_cmult_result0[56:36]} + {{4{PN2_cmult_result1[56]}},PN2_cmult_result1[56:36]};
					PN2_Q23 <= {{4{PN2_cmult_result2[56]}},PN2_cmult_result2[56:36]} + {{4{PN2_cmult_result3[56]}},PN2_cmult_result3[56:36]};
					PN2_Q45 <= {{4{PN2_cmult_result4[56]}},PN2_cmult_result4[56:36]} + {{4{PN2_cmult_result5[56]}},PN2_cmult_result5[56:36]};
					PN2_Q67 <= {{4{PN2_cmult_result6[56]}},PN2_cmult_result6[56:36]} + {{4{PN2_cmult_result7[56]}},PN2_cmult_result7[56:36]};
					PN2_Q0123 <= PN2_Q01 + PN2_Q23;
					PN2_Q4567 <= PN2_Q45 + PN2_Q67;
					PN2_Q_reg = PN2_Q0123 + PN2_Q4567;
					if(Cmult_valid_D3)
						PN2_Q = PN2_Q + PN2_Q_reg;
					//乘法延时
					Cmult_valid_D1 <= Cmult_valid;
					Cmult_valid_D2 <= Cmult_valid_D1;
					Cmult_valid_D3 <= Cmult_valid_D2;
					Cmult_valid_D4 <= Cmult_valid_D3;
					
					if(Cmult_valid_D4)//累加计数
						Acc_cnt <= Acc_cnt + 3'd1;
					
					if(Cmult_valid_D4 && Acc_cnt == 3'd7)
						Power_en <= 1'b1;
					else
						Power_en <= 1'b0;
					//能量乘法计算延时	
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
							Cal_cnt <= Cal_cnt + 7'd1;
						end
					if(Power_en_D5)
						begin
							if(PN1_power>=PN2_power)
								Max_power_reg <= PN1_power;
							else
								Max_power_reg <= PN2_power;
						end
					if(Power_en_D6)
						begin
							State <= 2'b11;//比较能量
							if(Max_power_reg >= Max_power)
								begin
									Max_power <= Max_power_reg;
									Max_position <= Cal_cnt;
								end
						end
			end
			2'b11:
			begin
				if(Cal_cnt == 7'd65)//计数完成复位
					begin
						Xcorr_done <= 1'b1;
						State <= 2'b00;
					end
				else
					begin //移位读取
						State <= 2'b10;
						Rd_en <= 1'b1;
						PN1_I <= 25'd0;
						PN1_Q <= 25'd0;
						PN2_I <= 25'd0;
						PN2_Q <= 25'd0;
						Rd_state <= Rd_state + 3'd1;
						case(Rd_state)
						3'b000:
						begin
							Rd_addr0 <= Rd_addr0-4'd7;
							Rd_addr1 <= Rd_addr1-4'd8;
							Rd_addr2 <= Rd_addr2-4'd8;
							Rd_addr3 <= Rd_addr3-4'd8;
							Rd_addr4 <= Rd_addr4-4'd8;
							Rd_addr5 <= Rd_addr5-4'd8;
							Rd_addr6 <= Rd_addr6-4'd8;
							Rd_addr7 <= Rd_addr7-4'd8;
						end
						3'b001:
						begin
							Rd_addr0 <= Rd_addr0-4'd8;
							Rd_addr1 <= Rd_addr1-4'd7;
							Rd_addr2 <= Rd_addr2-4'd8;
							Rd_addr3 <= Rd_addr3-4'd8;
							Rd_addr4 <= Rd_addr4-4'd8;
							Rd_addr5 <= Rd_addr5-4'd8;
							Rd_addr6 <= Rd_addr6-4'd8;
							Rd_addr7 <= Rd_addr7-4'd8;
						end
						3'b010:
						begin
							Rd_addr0 <= Rd_addr0-4'd8;
							Rd_addr1 <= Rd_addr1-4'd8;
							Rd_addr2 <= Rd_addr2-4'd7;
							Rd_addr3 <= Rd_addr3-4'd8;
							Rd_addr4 <= Rd_addr4-4'd8;
							Rd_addr5 <= Rd_addr5-4'd8;
							Rd_addr6 <= Rd_addr6-4'd8;
							Rd_addr7 <= Rd_addr7-4'd8;
						end
						3'b011:
						begin
							Rd_addr0 <= Rd_addr0-4'd8;
							Rd_addr1 <= Rd_addr1-4'd8;
							Rd_addr2 <= Rd_addr2-4'd8;
							Rd_addr3 <= Rd_addr3-4'd7;
							Rd_addr4 <= Rd_addr4-4'd8;
							Rd_addr5 <= Rd_addr5-4'd8;
							Rd_addr6 <= Rd_addr6-4'd8;
							Rd_addr7 <= Rd_addr7-4'd8;
						end
						3'b100:
						begin
							Rd_addr0 <= Rd_addr0-4'd8;
							Rd_addr1 <= Rd_addr1-4'd8;
							Rd_addr2 <= Rd_addr2-4'd8;
							Rd_addr3 <= Rd_addr3-4'd8;
							Rd_addr4 <= Rd_addr4-4'd7;
							Rd_addr5 <= Rd_addr5-4'd8;
							Rd_addr6 <= Rd_addr6-4'd8;
							Rd_addr7 <= Rd_addr7-4'd8;
						end
						3'b101:
						begin
							Rd_addr0 <= Rd_addr0-4'd8;
							Rd_addr1 <= Rd_addr1-4'd8;
							Rd_addr2 <= Rd_addr2-4'd8;
							Rd_addr3 <= Rd_addr3-4'd8;
							Rd_addr4 <= Rd_addr4-4'd8;
							Rd_addr5 <= Rd_addr5-4'd7;
							Rd_addr6 <= Rd_addr6-4'd8;
							Rd_addr7 <= Rd_addr7-4'd8;
						end
						3'b110:
						begin
							Rd_addr0 <= Rd_addr0-4'd8;
							Rd_addr1 <= Rd_addr1-4'd8;
							Rd_addr2 <= Rd_addr2-4'd8;
							Rd_addr3 <= Rd_addr3-4'd8;
							Rd_addr4 <= Rd_addr4-4'd8;
							Rd_addr5 <= Rd_addr5-4'd8;
							Rd_addr6 <= Rd_addr6-4'd7;
							Rd_addr7 <= Rd_addr7-4'd8;
						end
						3'b111:
						begin
							Rd_addr0 <= Rd_addr0-4'd8;
							Rd_addr1 <= Rd_addr1-4'd8;
							Rd_addr2 <= Rd_addr2-4'd8;
							Rd_addr3 <= Rd_addr3-4'd8;
							Rd_addr4 <= Rd_addr4-4'd8;
							Rd_addr5 <= Rd_addr5-4'd8;
							Rd_addr6 <= Rd_addr6-4'd8;
							Rd_addr7 <= Rd_addr7-4'd7;
						end
						endcase
					end
			end
			endcase
		end
end

Xcorr_ram u_xcorr_ram0( //深度16,输入高位I，低位Q
    .clka(Clk),
    .wea(Wr_en0 && Data_valid),
    .addra(Wr_addr0),
    .dina({Data_inI,Data_inQ}),
    .clkb(Clk),
    .enb(Rd_en),
    .addrb(Rd_addr0),
    .doutb(Rd_data0)
  );
  
Xcorr_ram u_xcorr_ram1(
    .clka(Clk),
    .wea(Wr_en1 && Data_valid),
    .addra(Wr_addr1),
    .dina({Data_inI,Data_inQ}),
    .clkb(Clk),
    .enb(Rd_en),
    .addrb(Rd_addr1),
    .doutb(Rd_data1)
  );
Xcorr_ram u_xcorr_ram2(
    .clka(Clk),
    .wea(Wr_en2 && Data_valid),
    .addra(Wr_addr2),
    .dina({Data_inI,Data_inQ}),
    .clkb(Clk),
    .enb(Rd_en),
    .addrb(Rd_addr2),
    .doutb(Rd_data2)
  );
  
Xcorr_ram u_xcorr_ram3(
    .clka(Clk),
    .wea(Wr_en3 && Data_valid),
    .addra(Wr_addr3),
    .dina({Data_inI,Data_inQ}),
    .clkb(Clk),
    .enb(Rd_en),
    .addrb(Rd_addr3),
    .doutb(Rd_data3)
  );
  
Xcorr_ram u_xcorr_ram4(
    .clka(Clk),
    .wea(Wr_en4 && Data_valid),
    .addra(Wr_addr4),
    .dina({Data_inI,Data_inQ}),
    .clkb(Clk),
    .enb(Rd_en),
    .addrb(Rd_addr4),
    .doutb(Rd_data4)
  );
 
Xcorr_ram u_xcorr_ram5(
    .clka(Clk),
    .wea(Wr_en5 && Data_valid),
    .addra(Wr_addr5),
    .dina({Data_inI,Data_inQ}),
    .clkb(Clk),
    .enb(Rd_en),
    .addrb(Rd_addr5),
    .doutb(Rd_data5)
  );
  
Xcorr_ram u_xcorr_ram6(
    .clka(Clk),
    .wea(Wr_en6 && Data_valid),
    .addra(Wr_addr6),
    .dina({Data_inI,Data_inQ}),
    .clkb(Clk),
    .enb(Rd_en),
    .addrb(Rd_addr6),
    .doutb(Rd_data6)
  );
  
Xcorr_ram u_xcorr_ram7(
    .clka(Clk),
    .wea(Wr_en7 && Data_valid),
    .addra(Wr_addr7),
    .dina({Data_inI,Data_inQ}),
    .clkb(Clk),
    .enb(Rd_en),
    .addrb(Rd_addr7),
    .doutb(Rd_data7)
  );
  //高位Q，低位I
Cmult_xcorr PN1_cmult0(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult0),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN1_mult0Q[11]}},PN1_mult0Q,{4{PN1_mult0I[11]}},PN1_mult0I}),
    .m_axis_dout_tvalid(Cmult_valid),
    .m_axis_dout_tdata(PN1_cmult_result0)
  );
  
Cmult_xcorr PN1_cmult1(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult1),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN1_mult1Q[11]}},PN1_mult1Q,{4{PN1_mult1I[11]}},PN1_mult1I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN1_cmult_result1)
  );
  
Cmult_xcorr PN1_cmult2(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult2),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN1_mult2Q[11]}},PN1_mult2Q,{4{PN1_mult2I[11]}},PN1_mult2I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN1_cmult_result2)
  );
  
Cmult_xcorr PN1_cmult3(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult3),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN1_mult3Q[11]}},PN1_mult3Q,{4{PN1_mult3I[11]}},PN1_mult3I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN1_cmult_result3)
  );
  
Cmult_xcorr PN1_cmult4(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult4),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN1_mult4Q[11]}},PN1_mult4Q,{4{PN1_mult4I[11]}},PN1_mult4I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN1_cmult_result4)
  );
  
Cmult_xcorr PN1_cmult5(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult5),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN1_mult5Q[11]}},PN1_mult5Q,{4{PN1_mult5I[11]}},PN1_mult5I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN1_cmult_result5)
  );
  
Cmult_xcorr PN1_cmult6(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult6),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN1_mult6Q[11]}},PN1_mult6Q,{4{PN1_mult6I[11]}},PN1_mult6I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN1_cmult_result6)
  );
  
Cmult_xcorr PN1_cmult7(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult7),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN1_mult7Q[11]}},PN1_mult7Q,{4{PN1_mult7I[11]}},PN1_mult7I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN1_cmult_result7)
  );
  
Cmult_xcorr PN2_cmult0(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult0),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN2_mult0Q[11]}},PN2_mult0Q,{4{PN2_mult0I[11]}},PN2_mult0I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN2_cmult_result0)
  );
  
Cmult_xcorr PN2_cmult1(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult1),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN2_mult1Q[11]}},PN2_mult1Q,{4{PN2_mult1I[11]}},PN2_mult1I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN2_cmult_result1)
  );
  
Cmult_xcorr PN2_cmult2(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult2),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN2_mult2Q[11]}},PN2_mult2Q,{4{PN2_mult2I[11]}},PN2_mult2I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN2_cmult_result2)
  );
  
Cmult_xcorr PN2_cmult3(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult3),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN2_mult3Q[11]}},PN2_mult3Q,{4{PN2_mult3I[11]}},PN2_mult3I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN2_cmult_result3)
  );
  
Cmult_xcorr PN2_cmult4(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult4),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN2_mult4Q[11]}},PN2_mult4Q,{4{PN2_mult4I[11]}},PN2_mult4I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN2_cmult_result4)
  );
  
Cmult_xcorr PN2_cmult5(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult5),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN2_mult5Q[11]}},PN2_mult5Q,{4{PN2_mult5I[11]}},PN2_mult5I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN2_cmult_result5)
  );
  
Cmult_xcorr PN2_cmult6(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult6),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN2_mult6Q[11]}},PN2_mult6Q,{4{PN2_mult6I[11]}},PN2_mult6I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN2_cmult_result6)
  );
  
Cmult_xcorr PN2_cmult7(
    .aclk(Clk),
    .s_axis_a_tvalid(Rd_en_D1),
    .s_axis_a_tdata(Data_mult7),
    .s_axis_b_tvalid(Rd_en_D1),
    .s_axis_b_tdata({{4{PN2_mult7Q[11]}},PN2_mult7Q,{4{PN2_mult7I[11]}},PN2_mult7I}),
    .m_axis_dout_tvalid(),
    .m_axis_dout_tdata(PN2_cmult_result7)
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
