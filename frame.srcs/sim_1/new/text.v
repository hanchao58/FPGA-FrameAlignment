`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/03 14:45:17
// Design Name: 
// Module Name: text
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


module text(

    );
reg Clk = 1'b0;
reg 				Rden;
reg					Rden_D1;
reg					Rden_D2;
reg					Rst_n;
reg					wea;
reg   signed	    [11:0]	data_InI;
reg   signed	    [11:0]	data_InQ;
reg					state;
reg			[11:0]	addra;
reg			[11:0]	addra_D;
reg					data_invalid;
wire		[1:0]	Frame_Sype;
wire				Frame_state;
wire   signed	    [11:0]	Data_outI;
wire   signed	    [11:0]	Data_outQ;
localparam  startaddra = 12'd0;
//assign data_outI = data_outI;
//assign data_outQ = data_outQ;
always	#5		Clk=~Clk;
always@(posedge Clk or negedge Rst_n)
begin
	if(~Rst_n)
		begin
			Rden <= 1'b0;
			wea <= 1'b0;
			addra_D <= 12'd0;
			addra <= 12'd0;
			data_InI <= 12'd0;
			data_InQ <= 12'd0;
			Rden_D1 <= 1'b0;
			Rden_D2 <= 1'b0;
			state <= 1'b0;
		end
	else
		begin
		case(state)
		1'b0:
			begin					
				Rden <= 1'b1;
				state <= 1'b1;
			end
		1'b1:
		begin
				Rden_D1 <= Rden;
				Rden_D2 <= Rden_D1;
				if(addra == 12'd0)
					begin
						data_invalid <= 1'b1;
					end
				if(Rden && addra <= 12'd2142)
					begin
						addra <= addra + 12'd1;
						data_InI <= Data_outI;
						data_InQ <= Data_outQ;
					end
				else
					 begin 
						 if(addra >= 12'd2142)
							   addra <= 12'd0;

		end		 	end
		endcase
		end
		
	
end
initial
begin
			Rst_n = 0;
			//data_invalid = 1;
	#1 		Rst_n = 1;
//			data_invalid = 1;
	//#3000	data_invalid = 0;
	//#100 reset = 1;
	//#1028     $stop;
end
Top text(
	.Clk(Clk),
	.Rst_n(Rst_n),
	.Data_valid(data_invalid),
	.Data_inI(data_InI),
	.Data_inQ(data_InQ),
	.Frame_state(Frame_state),
	.Frame_Sype(Frame_Sype)
    );
text_ram text_data_I(
  .clka		(Clk),
  .ena		(Rden),
  .addra	(addra),
  .wea		(wea),
  .douta	(Data_outI)
);
text_ramQ text_data_Q(
  .clka		(Clk),
  .ena		(Rden),
  .addra	(addra),
  .wea		(wea),
  .douta	(Data_outQ)
);
endmodule
