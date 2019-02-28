`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:13 11/19/2018 
// Design Name: 
// Module Name:    top 
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
//////////////////////////////////////////////////////////////////////////////////module top(
module top(
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,         // reset button
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output wire [2:0] VGA_R,    // 4-bit VGA red output
    output wire [2:0] VGA_G,    // 4-bit VGA green output
    output wire [1:0] VGA_B,     // 4-bit VGA blue output
    
    
    
    output [6:0] seg,
    output [3:0] an,
    input wire pause,
    input wire chooselvl,
    input wire jump,
    input wire duck,
    
    input wire adj, //adjust level signal
    input wire [2:0] num //num to adjust level to 
    );

    //wire [2:0] level;
    wire score;
    wire color;
    //wire [31:0] score;
    
    wire ob0;
    wire ob1;
    wire ob2;//, brdr_o;
    wire ob3;
    wire ob4;
    wire ob5;
    wire ob6;
    wire ob7;
    wire [11:0] o_x0l;
    wire [11:0] o_x0r;
    wire [11:0] o_y0t;
    wire [11:0] o_y0b;
    wire [11:0] o_x1l;
    wire [11:0] o_x1r;
    wire [11:0] o_y1t;
    wire [11:0] o_y1b;
    wire [11:0] o_x2l;
    wire [11:0] o_x2r;
    wire [11:0] o_y2t;
    wire [11:0] o_y2b;  // 12-bit values: 0-4095 
    //wire [11:0] brdr_l, brdr_r, brdr_t, brdr_b;
    wire [11:0] o_x3l;
    wire [11:0] o_x3r;
    wire [11:0] o_y3t;
    wire [11:0] o_y3b;
    wire [11:0] o_x4l;
    wire [11:0] o_x4r;
    wire [11:0] o_y4t;
    wire [11:0] o_y4b;
    wire [11:0] o_x5l;
    wire [11:0] o_x5r;
    wire [11:0] o_y5t;
    wire [11:0] o_y5b;
    wire [11:0] o_x6l;
    wire [11:0] o_x6r;
    wire [11:0] o_y6t;
    wire [11:0] o_y6b;
    wire [11:0] o_x7l;
    wire [11:0] o_x7r;
    wire [11:0] o_y7t;
    wire [11:0] o_y7b;
    wire hl;
    wire hr;
    wire lr;
    wire ll;
    wire body;
    wire head;
    wire [11:0] o_hl_x1;
    wire [11:0] o_hl_x2;
    wire [11:0] o_hl_y1;
    wire [11:0] o_hl_y2;
    wire [11:0] o_hr_x1;
    wire [11:0] o_hr_x2;
    wire [11:0] o_hr_y1;
    wire [11:0] o_hr_y2;
    wire [11:0] o_lr_x1;
    wire [11:0] o_lr_x2;
    wire [11:0] o_lr_y1;
    wire [11:0] o_lr_y2;
    wire [11:0] o_ll_x1;
    wire [11:0] o_ll_x2;
    wire [11:0] o_ll_y1;
    wire [11:0] o_ll_y2;
    wire [11:0] o_body_x1;
    wire [11:0] o_body_x2;
    wire [11:0] o_body_y1;
    wire [11:0] o_body_y2;
    wire [11:0] o_head_x1;
    wire [11:0] o_head_x2;
    wire [11:0] o_head_y1;
    wire [11:0] o_head_y2;   // square bottom edge
    
    wire any_obj;
    assign any_obj = (ob0 | ob1 | ob2 | ob3 | ob4 | ob5 | ob6 | ob7);
    wire any_char;
    assign any_char = (lr | ll | body | head);


    //if any_obj && any_char ->bind that to a new wire called like , lose state, and toggle that to somehting somehow?

    wire rst_d_real;// = rst;
    assign rst_d_real = RST_BTN;
    wire pause_d;// = pause;
    // wire rst = RST_BTN;  // reset is active high on Basys3 (BTNC)

    assign pause_d = pause;
  //rdebouncer pause_debouncer(CLK,pause,pause_d);
  //rdebouncer rst_debouncer(CLK,RST_BTN,rst_d_real);

    wire rst_d;
    assign rst_d = rst_d_real | (any_obj && any_char);
       // reset is active low on Arty & Nexys Video
    wire lose_pulse;
    assign lose_pulse = (any_obj && any_char);
    reg lose_r = 0;
//    always @ (posedge lose_pulse) begin
//        lose_r <= 1;
//    end
    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing

    // generate a 25 MHz pixel strobe
//    reg [15:0] cnt = 0;
    reg  cnt = 0;
    reg pix_stb = 0;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 1;//16'h8000;  // divide by 4: (2^16)/4 = 0x4000

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst_d),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y),
        .o_animate(animate)
    );


// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;

wire dbclk;
wire dbclkd;


    clockdiv U1(
    .clk(CLK),
    .clr(rst_d),
    .segclk(segclk),
    .dclk(dclk),
    .clk_db(dbclk),
    .clk_db_d(dbclkd)
    );
    
wire unpausedo;

wire [3:0] level10_o;
wire [3:0] level1_o;
wire [3:0] score10_o;
wire [3:0] score1_o;
wire [3:0] level10_i;
wire [3:0] level1_i;
wire [3:0] score10_i;
wire [3:0] score1_i;



   

wire [3:0] lvl10;
wire [3:0] lvl1;
wire [3:0] score10;
wire [3:0] score1;

// 7-segment display controller
//SegDisp U2(
    //.segclk(dclk),
    //.clr(RST_BTN),
/// .seg(seg),
//  .an(an),


    //.lvl10(level10_o),   
    //.lvl1(level1_o),   //4 bit 
    //.score10(score10_o),  //4 bit for score
    //.score1(score1_o)
    //);
  wire [3:0] digs [0:3]; 

   // wire unpaused;
 
  
    wire tick;
    wire blink;
    wire disp_cycle;
    wire clk_db;
    wire clk_db_d;
    
    wire up;
  //counter cwnt(.clk(CLK), 
  //.tick(tick), 
  //.unpaused_in(unpaused), 
  //.pause(pause), 
  //.rst(RST_BTN), 
  //.adj(adj), 
  //.num(num), 
  //.sel(sel), .min10_in(digs[3]), .min1_in(digs[2]),
  //.sec10_in(digs[1]), 
  //.sec1_in(digs[0]), 
  //.unpaused_out(up), 
  //.min10_out(digs[3]),
  //.min1_out(digs[2]),
  //.sec10_out(digs[1]), 
  //.sec1_out(digs[0]));
  
  //counter cnt(.clk(clk), .tick(tick), .unpaused_in(unpaused), .pause(pause_d), .rst(rst_d), .adj(adj), .num(num), .sel(sel), .min10_in(digs[3]), .min1_in(digs[2]), .sec10_in(digs[1]), .sec1_in(digs[0]), .unpaused_out(unpaused), .min10_out(digs[3]), .min1_out(digs[2]), .sec10_out(digs[1]), .sec1_out(digs[0]));
  
 // full_display fd(rst_d,CLK, adj, blink, sel, disp_cycle, digs[3], digs[2], digs[1], digs[0], seg,an);

//levelscore lUls(.clk(dclk), .unpaused_in(unpaused), .pause(pause), .adj(adj), 
//.rst(RST_BTN), .num(num), .level10_in(digs[3]), .level1_in(digs[2]),
// .score10_in(digs[1]), .score1_in(digs[0]), .unpaused_out(unpausedo), 
//.level10_out(digs[3]), .level1_out(digs[2]), .score10_out(digs[1]), .score1_out(digs[0]));

//debouncers
//rdebouncer
   //wire clk_db;
  // wire clk_db_d;

    

  //lets just fking use digs lol

wire done;
wire lose = lose_r;

levelscore lUls(.clk(CLK), .score(score), .i_pause(pause_d), .adj(adj), 
.rst(rst_d), .num(num), .level10_in(digs[3]), .level1_in(digs[2]),
 .score10_in(digs[1]), .score1_in(digs[0]), 
.level10_out(digs[3]), .level1_out(digs[2]), .score10_out(digs[1]), .score1_out(digs[0]), .done(done), .lose(lose));


//level_connector lvl_cnctr(.level10(digs[3]),.level1(digs[2]),.level_out(level));
  //levelscore uls(dclk, unpaused, pause_d, adj, rst_d, num, sel, level10_in, level1_in, score10_in, score1_in, unpaused_out, level10_out, level1_out, score10_out, score1_out);

  altfull_display altfd(rst_d,CLK, segclk,adj, digs[3], digs[2], digs[1], digs[0], seg, an);

//altfull_display saltfd(rst_d,CLK,adj, blink, sel, digs[3], digs[2], digs[1], digs[0], seg, an);



    
//    wire ob0;
//    wire ob1;
//    wire ob2;//, brdr_o;
//    wire ob3;
//    wire ob4;
//    wire ob5;
//    wire ob6;
//    wire ob7;
//    wire [11:0] o_x0l;
//    wire [11:0] o_x0r;
//    wire [11:0] o_y0t;
//    wire [11:0] o_y0b;
//    wire [11:0] o_x1l;
//    wire [11:0] o_x1r;
//    wire [11:0] o_y1t;
//    wire [11:0] o_y1b;
//    wire [11:0] o_x2l;
//    wire [11:0] o_x2r;
//    wire [11:0] o_y2t;
//    wire [11:0] o_y2b;  // 12-bit values: 0-4095 
//    //wire [11:0] brdr_l, brdr_r, brdr_t, brdr_b;
//    wire [11:0] o_x3l;
//    wire [11:0] o_x3r;
//    wire [11:0] o_y3t;
//    wire [11:0] o_y3b;
//    wire [11:0] o_x4l;
//    wire [11:0] o_x4r;
//    wire [11:0] o_y4t;
//    wire [11:0] o_y4b;
//    wire [11:0] o_x5l;
//    wire [11:0] o_x5r;
//    wire [11:0] o_y5t;
//    wire [11:0] o_y5b;
//    wire [11:0] o_x6l;
//    wire [11:0] o_x6r;
//    wire [11:0] o_y6t;
//    wire [11:0] o_y6b;
//    wire [11:0] o_x7l;
//    wire [11:0] o_x7r;
//    wire [11:0] o_y7t;
//    wire [11:0] o_y7b;
//    wire hl;
//    wire hr;
//    wire lr;
//    wire ll;
//    wire body;
//    wire head;
//    wire [11:0] o_hl_x1;
//    wire [11:0] o_hl_x2;
//    wire [11:0] o_hl_y1;
//    wire [11:0] o_hl_y2;
//    wire [11:0] o_hr_x1;
//    wire [11:0] o_hr_x2;
//    wire [11:0] o_hr_y1;
//    wire [11:0] o_hr_y2;
//    wire [11:0] o_lr_x1;
//    wire [11:0] o_lr_x2;
//    wire [11:0] o_lr_y1;
//    wire [11:0] o_lr_y2;
//    wire [11:0] o_ll_x1;
//    wire [11:0] o_ll_x2;
//    wire [11:0] o_ll_y1;
//    wire [11:0] o_ll_y2;
//    wire [11:0] o_body_x1;
//    wire [11:0] o_body_x2;
//    wire [11:0] o_body_y1;
//    wire [11:0] o_body_y2;
//    wire [11:0] o_head_x1;
//    wire [11:0] o_head_x2;
//    wire [11:0] o_head_y1;
//    wire [11:0] o_head_y2;   // square bottom edge
    

    parameter obstacle_width = 40;
    parameter obstacle_height = 160;
    parameter border_size = obstacle_width;

//    border #(.SIZE(border_size)) brdr(
//    .i_clk(CLK),
//    .i_ani_stb(pix_stb),
//    .i_rst(rst),
//    .i_animate(animate),
//    .o_l(brdr_l),
//    .o_r(brdr_r),
//    .o_t(brdr_t),
//    .o_b(brdr_b)
//    );

    obstacles #(.SPEED(5)) obs(
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_rst(rst_d),
        .i_animate(animate),
        .i_pause(pause_d),
        .adj(adj),
        .i_level(digs[2]),
        .done(done),
        .lose(lose),
        
        .lev(level),
        .score(score),
        .color(color),
        
        .o_x0l(o_x0l),  // square left edge: 12-bit value: 0-4095
        .o_x0r(o_x0r),  // square right edge
        .o_y0t(o_y0t),  // square top edge
        .o_y0b(o_y0b),
        
        .o_x1l(o_x1l),  // square left edge: 12-bit value: 0-4095
        .o_x1r(o_x1r),  // square right edge
        .o_y1t(o_y1t),  // square top edge
        .o_y1b(o_y1b),
        
        .o_x2l(o_x2l),  // square left edge: 12-bit value: 0-4095
        .o_x2r(o_x2r),  // square right edge
        .o_y2t(o_y2t),  // square top edge
        .o_y2b(o_y2b),
        
        .o_x3l(o_x3l),  // square left edge: 12-bit value: 0-4095
        .o_x3r(o_x3r),  // square right edge
        .o_y3t(o_y3t),  // square top edge
        .o_y3b(o_y3b),
        
        .o_x4l(o_x4l),  // square left edge: 12-bit value: 0-4095
        .o_x4r(o_x4r),  // square right edge
        .o_y4t(o_y4t),  // square top edge
        .o_y4b(o_y4b),
        
        .o_x5l(o_x5l),  // square left edge: 12-bit value: 0-4095
        .o_x5r(o_x5r),  // square right edge
        .o_y5t(o_y5t),  // square top edge
        .o_y5b(o_y5b),
        
        .o_x6l(o_x6l),  // square left edge: 12-bit value: 0-4095
        .o_x6r(o_x6r),  // square right edge
        .o_y6t(o_y6t),  // square top edge
        .o_y6b(o_y6b),
        
        .o_x7l(o_x7l),  // square left edge: 12-bit value: 0-4095
        .o_x7r(o_x7r),  // square right edge
        .o_y7t(o_y7t),  // square top edge
        .o_y7b(o_y7b)
    );

//wire jump;




character mycharacters(//input wire 
.i_clk(CLK),         // base clock
    //input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    //input wire 
    .i_rst(rst_d),         // reset: returns animation to starting position
    //input wire 
    .i_duck(duck),
    .i_jump(jump),
    //input wire 
    .i_animate(animate),     // animate when input is high
    .i_pause(paused),   //debnc pause
    .adj(adj),
    .done(done),
    .lose(lose),

    //left hand
    //output wire [11:0] 
    .hl_x1(o_hl_x1),
    .hl_x2(o_hl_x2),
    .hl_y1(o_hl_y1),
    .hl_y2(o_hl_y2),
//    
    .hr_x1(o_hr_x1),
    .hr_x2(o_hr_x2),
    .hr_y1(o_hr_y1),
    .hr_y2(o_hr_y2),
    
    .lr_x1(o_lr_x1),
    .lr_x2(o_lr_x2),
    .lr_y1(o_lr_y1),
    .lr_y2(o_lr_y2),
    
    .ll_x1(o_ll_x1),
    .ll_x2(o_ll_x2),
    .ll_y1(o_ll_y1),
    .ll_y2(o_ll_y2),
    
    .body_x1(o_body_x1),
    .body_x2(o_body_x2),
    .body_y1(o_body_y1),
    .body_y2(o_body_y2),
    
    .head_x1(o_head_x1),
    .head_x2(o_head_x2),
    .head_y1(o_head_y1),
    .head_y2(o_head_y2)   // square bottom edge
    );


//    obstacle_low #(.H_HEIGHT(obstacle_height/2), .H_WIDTH(obstacle_width/2), .SPEED(obstacle_width),.SLOWNESS(obstacle_width/2), .BORDER(border_size)) ob_l_1 (
//        .i_clk(CLK), 
//        .i_ani_stb(pix_stb),
//        .i_rst(rst),
//        .i_animate(animate),
//        .o_x1(ob_l_1_x1),
//        .o_x2(ob_l_1_x2),
//        .o_y1(ob_l_1_y1),
//        .o_y2(ob_l_1_y2)
//    );

    assign ob0 = (o_x0l < o_x0r) ? (((x > o_x0l) & (y > o_y0t) &
        (x < o_x0r) & (y < o_y0b)) ? 1 : 0)
        : 0;//((((x > o_x0l) | (x < o_x0r)) & (y > o_y0t) &
          //(y < o_y0b)) ? 1 : 0);
    assign ob1 = (o_x1l < o_x1r) ? (((x > o_x1l) & (y > o_y1t) &
        (x < o_x1r) & (y < o_y1b)) ? 1 : 0)
        : 0;//((((x > o_x1l) | (x < o_x1r)) & (y > o_y1t) &
          //(y < o_y1b)) ? 1 : 0);
    assign ob2 = (o_x2l < o_x2r) ? (((x > o_x2l) & (y > o_y2t) &
        (x < o_x2r) & (y < o_y2b)) ? 1 : 0)
        : 0;//((((x > o_x2l) | (x < o_x2r)) & (y > o_y2t) &
          //(y < o_y2b)) ? 1 : 0);
    assign ob3 = (o_x3l < o_x3r) ? (((x > o_x3l) & (y > o_y3t) &
        (x < o_x3r) & (y < o_y3b)) ? 1 : 0)
        : 0;//((((x > o_x3l) | (x < o_x3r)) & (y > o_y3t) &
          //(y < o_y3b)) ? 1 : 0);
    assign ob4 = (o_x4l < o_x4r) ? (((x > o_x4l) & (y > o_y4t) &
        (x < o_x4r) & (y < o_y4b)) ? 1 : 0)
        : 0;//((((x > o_x4l) | (x < o_x4r)) & (y > o_y4t) &
          //(y < o_y4b)) ? 1 : 0);
    assign ob5 = (o_x5l < o_x5r) ? (((x > o_x5l) & (y > o_y5t) &
        (x < o_x5r) & (y < o_y5b)) ? 1 : 0)
        : 0;//((((x > o_x5l) | (x < o_x5r)) & (y > o_y5t) &
          //(y < o_y5b)) ? 1 : 0);
    assign ob6 = (o_x6l < o_x6r) ? (((x > o_x6l) & (y > o_y6t) &
        (x < o_x6r) & (y < o_y6b)) ? 1 : 0)
        : 0;//((((x > o_x6l) | (x < o_x6r)) & (y > o_y6t) &
          //(y < o_y6b)) ? 1 : 0);
    assign ob7 = (o_x7l < o_x7r) ? (((x > o_x7l) & (y > o_y7t) &
        (x < o_x7r) & (y < o_y7b)) ? 1 : 0)
        : 0;//((((x > o_x7l) | (x < o_x7r)) & (y > o_y7t) &
          //(y < o_y7b)) ? 1 : 0);
    
    assign hl = ((x > o_hl_x1) & (y > o_hl_y2) &
        (x < o_hl_x2) & (y < o_hl_y1)) ? 1 : 0;
    assign hr = ((x > o_hr_x1) & (y > o_hr_y2) &
        (x < o_hr_x2) & (y < o_hr_y1)) ? 1 : 0;
    assign ll = ((x > o_ll_x1) & (y > o_ll_y2) &
        (x < o_ll_x2) & (y < o_ll_y1)) ? 1 : 0;
    assign lr = ((x > o_lr_x1) & (y > o_lr_y2) &
        (x < o_lr_x2) & (y < o_lr_y1)) ? 1 : 0;
    assign head = ((x > o_head_x1) & (y > o_head_y2) &
        (x < o_head_x2) & (y < o_head_y1)) ? 1 : 0;
    assign body = ((x > o_body_x1) & (y > o_body_y2) &
        (x < o_body_x2) & (y < o_body_y1)) ? 1 : 0;

    //assign VGA_R[2:0] = brdr_o ? 3'b111 : 3'b000;
    //assign VGA_G[2:0] = (~brdr_o & ob_l_1_o) ? 3'b111 : 3'b000;
    //assign VGA_B[1:0] = 2'b00;

    assign VGA_R[2:0] = (body) ? (color ? 3'b111 : 3'b000) : 3'b000;
    assign VGA_G[2:0] = (ob0 | ob1 | ob2 | ob3 | ob4 | ob5 | ob6 | ob7) ? 3'b111 : 3'b000;
    assign VGA_B[1:0] = (ll | lr | head | body|hl|hr) ? 2'b11 : 2'b00;
 



endmodule