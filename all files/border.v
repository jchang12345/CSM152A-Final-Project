`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:35:51 11/20/2018 
// Design Name: 
// Module Name:    border 
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:22:25 11/19/2018 
// Design Name: 
// Module Name:    obstacle_low 
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
module border #(
    SIZE = 40,
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
    (
    input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_animate,     // animate when input is high
    output wire [11:0] o_l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_r,  // square right edge
    output wire [11:0] o_t,  // square top edge
    output wire [11:0] o_b   // square bottom edge
    );

    assign o_l = SIZE;  // left: centre minus half horizontal size
    assign o_r = D_WIDTH-SIZE;  // right
    assign o_t = SIZE;  // top
    assign o_b = D_HEIGHT-SIZE;  // bottom
endmodule