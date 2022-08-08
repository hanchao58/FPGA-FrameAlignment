`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 16:08:02
// Design Name: 
// Module Name: Top
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


module Top(
	input						Clk,
	input						Rst_n,
	input						Data_valid,
	input	signed	[11:0]		Data_inI,
	input	signed	[11:0]		Data_inQ,
	
	output	reg					Frame_state,
	output	reg	[1:0]			Frame_Sype
    );
parameter	THREHOLD = 35'd2000000000;

reg				Track_fail_reg;
reg		[11:0]	Symbol_cnt;
reg		[1:0]	State;
reg				Track_en;
reg				Frame_state;
reg		signed	[11:0]		Data_inI_D;
reg     signed	[11:0]		Data_inQ_D;
reg		signed	[11:0]		Data_inI_D1;
reg     signed	[11:0]		Data_inQ_D1;
reg		signed	[11:0]		Data_inI_D2;
reg     signed	[11:0]		Data_inQ_D2;
reg				Det_done;
reg				Data_valid_D1;
reg				Data_valid_D2;
reg				Data_valid_D3;
reg		[34:0]	Max_power;

//reg				Wr_en;
//reg		[5:0]	Wr_addr;
//reg				Rd_en;
//reg		[5:0]	Rd_addr;
//reg		[23:0]	Rd_data;


wire		    Det_done_wire;
wire			Frame_start;
wire			Track_fail;
wire	[1:0]	Frame_Sype_wire;
wire	[34:0]	Max_power_wire;
always@(posedge Clk or negedge Rst_n)
begin
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
end
always@(posedge Clk or negedge Rst_n)
if(~Rst_n)
	begin
	Frame_Sype <= 2'b0;
	Track_fail_reg <=1'b0;
	Track_en <= 1'b0;
	Det_done <= 1'b0;
	Data_valid_D1 <= 1'b0;
	Data_valid_D2 <= 1'b0;
	Data_valid_D3 <= 1'b0;
	State <= 2'b0;
	Data_inI_D <= 12'd0;
	Data_inQ_D <= 12'd0;
	Data_inI_D1 <= 12'd0;
	Data_inQ_D1 <= 12'd0;
	Max_power <= 35'd0;
	//Wr_en <= 1'b0;
	//Wr_addr <= 6'd0;
	//Rd_en <= 1'b0;
	//Rd_addr <= 6'd0;
	//Rd_data <= 24'd0;
	end
else
	begin
		case(State)
		2'b00:
			begin
				if(Data_valid)
					begin
						Frame_Sype <= 2'b0;
						Track_fail_reg <=1'b0;
						Track_en <= 1'b0;
						Max_power <= 35'd0;
						Data_valid_D1 <= Data_valid;
						Data_valid_D2 <= Data_valid_D1;
						Data_valid_D3 <= Data_valid_D2;
						Det_done <= Det_done_wire;
						//Wr_en <= 1'b0;
						//Wr_addr <= 6'd0;
						//Rd_en <= 1'b0;
						//Rd_addr <= 6'd0;
						//Rd_data <= 24'd0;
						Track_fail_reg <= Track_fail;
						if(~Track_fail_reg && Det_done)//�?测到帧头脉冲�?始跟�?
							begin
								State <= 2'b01;
							end
					end
			end
		2'b01:
			begin
				Data_inI_D <= Data_inI;
				Data_inQ_D <= Data_inQ;
				Data_inI_D1 <= Data_inI_D;
				Data_inQ_D1 <= Data_inQ_D;
				Data_inI_D2 <= Data_inI_D1;
				Data_inQ_D2 <= Data_inQ_D1;
				Max_power <= Max_power_wire;
				Frame_Sype <= Frame_Sype_wire;	
				if(Data_valid && Frame_start)
					Track_en <= 1'b1;
				if(Track_fail_reg)// 跟踪失败
					begin
						Track_en <= 1'b0;
						State <= 2'b00;
					end
				else if(Frame_Sype !=2'd0)
				begin
					Track_en <= 1'b0;
					State <= 2'b10;
				end
				
				
			end
		2'b10:
			begin
				Data_inI_D <= Data_inI;
				Data_inQ_D <= Data_inQ;
				Data_inI_D2 <= Data_inI_D;
				Data_inQ_D2 <= Data_inQ_D;
				Frame_Sype <= Frame_Sype_wire;				
				if(Data_valid && Frame_start)
					Track_en <= 1'b1;
					
				if(Track_fail_reg)// 跟踪失败
					begin
						Track_en <= 1'b0;
						State <= 2'b00;
					end
				else if(Frame_Sype !=2'd0)
				begin
					Track_en <= 1'b0;
				end
			end
		endcase	
	end
Frame_det_top u_Frame_det_top(
	.Clk(Clk),
	.Rst_n(Rst_n),
	.Data_valid(Data_valid_D1),
	.Data_inI(Data_inI),
	.Data_inQ(Data_inQ),
	.Track_fail(Track_fail),
	.Det_done(Det_done_wire),
	.Frame_start(Frame_start)
);
 Track u_Track(
	.Clk(Clk),
	.Rst_n(Rst_n || Track_fail_reg),
	.Data_valid(Rst_n),
	.Data_inI(Data_inI_D2),
	.Data_inQ(Data_inQ_D2),
	.Track_en(Track_en),

	.Track_fail(Track_fail),
	.Frame_State(Frame_Sype_wire),
	.Max_power(Max_power_wire)
    );
//Track_ram u_Track_ram(
//    .clka(Clk),
//    .wea(Wr_en && Data_valid),
//    .addra(Wr_addr),
//    .dina({Data_inI,Data_inQ}),
//    .clkb(Clk),
//    .enb(Rd_en),
//    .addrb(Rd_addr),
//    .doutb(Rd_data)
//  );
endmodule
