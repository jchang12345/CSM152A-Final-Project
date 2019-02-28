`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:20:32 11/14/2018 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
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
    input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset
	output wire [6:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	//output wire dp,			//7-segment display decimal point
    input wire pause,
    input wire chooselvl,
    input wire jump,
    input wire duck,
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync,			//vertical sync out



	input wire adj,	//adjust level signal
	input wire [2:0] num //num to adjust level to 
							//wire for levelscoring
    );
    
    //need some more btns, one for pause, and one for jump, one for duck
// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;


    clockdiv U1(
	.clk(clk),
	.clr(clr),
	.segclk(segclk),
	.dclk(dclk)
	);
    

//levelscore to feed into disp
wire unpaused;
wire [3:0] level10_in;
wire [3:0] level1_in;
wire [3:0] score10_in;
wire [3:0] score1_in;
wire unpausedo;
wire [3:0] level10_o;
wire [3:0] level1_o;
wire [3:0] score10_o;
wire [3:0] score1_o;

  	//debouncer pause_debouncer(clk,clk_db,clk_db_d,pause,pause_d);
  	//rdebouncer rst_debouncer(clk,rst,rst_d);


levelscore Uls(.clk(dclk), .unpaused_in(unpaused), .pause(pause_d), .adj(adj), .rst(clr), .num(num), .level10_in(level10_in), .level1_in(level1_in), .score10_in(score_10_in), .score1_in(score1_in), .unpaused_out(wire unpausedo), .level10_out(level10_o), .level1_out(level1_o), .score10_out(score10_o), .score1_out(score1_o));
    
// 7-segment display controller
SegDisp U2(
	.segclk(segclk),
	.clr(clr),
	.seg(seg),
	.an(an),


	.lvl10(level10_o),   
	.lvl1(level1_o),   //4 bit 
	.score10(score10_o),  //4 bit for score
	.score1(score1_o)
	);
    
VGADisplay U3(
	.dclk(dclk),
	.clr(clr),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
	);


endmodule
