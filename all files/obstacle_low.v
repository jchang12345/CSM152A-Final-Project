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
module obstacle_low #(
    H_HEIGHT=80,      // half square width (for ease of co-ordinate calculations)
    H_WIDTH=20,
    SPEED=1,
    SLOWNESS=1,
    BORDER=(2*H_WIDTH),
    IX=(D_WIDTH-H_WIDTH),         // initial horizontal position of square centre
    IY=(D_HEIGHT-H_HEIGHT-BORDER),         // initial vertical position of square centre
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
    (
    input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_animate,     // animate when input is high
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,  // square top edge
    output wire [11:0] o_y2   // square bottom edge
    );

    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre

    assign o_x1 = x - H_WIDTH;  // left: centre minus half horizontal size
    assign o_x2 = x + H_WIDTH;  // right
    assign o_y1 = y - H_HEIGHT;  // top
    assign o_y2 = y + H_HEIGHT;  // bottom

    //FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    reg [12:0] count;

    always @ (posedge i_clk)
    begin
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
        end
        if (i_animate && i_ani_stb)
        begin
            if(count == SLOWNESS) begin
                if(x > (H_WIDTH-SPEED)) begin
                    x <= x - SPEED;  // move left if positive x_dir
                end
                else begin
                    x <= IX;
                end
                count <= 0;
            end
            else begin
                count <= count + 1;
            end
        end
    end
endmodule