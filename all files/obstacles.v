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
module obstacles #(
    SPEED=5,
    HEIGHT_L=40,      // half square width (for ease of co-ordinate calculations)
    HEIGHT_H=400,      // half square width (for ease of co-ordinate calculations)
    H_WIDTH=20,
    //IX=(D_WIDTH-H_WIDTH),         // initial horizontal position of square centre
    //IY=(D_HEIGHT-HEIGHT_H-BORDER),         // initial vertical position of square centre
    D_WIDTH=640,    // width of display
    D_HEIGHT=480,    // height of display
    BUFFER=D_WIDTH,
    RAND_WIDTH=8,
    OBSTACLES_PER_SCREEN=(D_WIDTH/(4*H_WIDTH)),
    OBSTACLES_PER_LEVEL=2* OBSTACLES_PER_SCREEN
    )
    (
    input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_animate,     // animate when input is high
    input wire i_pause,
    input wire adj,
    input wire [3:0] i_level,
    
    input wire done,
    input wire lose,
    output [31:0] lev,
    //output [31:0] score,
    output score,
    output color,
    
    output wire [11:0] o_x0l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x0r,  // square right edge
    output wire [11:0] o_y0t,  // square top edge
    output wire [11:0] o_y0b,   // square bottom edge
    
    output wire [11:0] o_x1l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x1r,  // square right edge
    output wire [11:0] o_y1t,  // square top edge
    output wire [11:0] o_y1b,   // square bottom edge
    
    output wire [11:0] o_x2l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2r,  // square right edge
    output wire [11:0] o_y2t,  // square top edge
    output wire [11:0] o_y2b,   // square bottom edge
    
    output wire [11:0] o_x3l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x3r,  // square right edge
    output wire [11:0] o_y3t,  // square top edge
    output wire [11:0] o_y3b,   // square bottom edge
    
    output wire [11:0] o_x4l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x4r,  // square right edge
    output wire [11:0] o_y4t,  // square top edge
    output wire [11:0] o_y4b,   // square bottom edge
    
    output wire [11:0] o_x5l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x5r,  // square right edge
    output wire [11:0] o_y5t,  // square top edge
    output wire [11:0] o_y5b,   // square bottom edge
    
    output wire [11:0] o_x6l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x6r,  // square right edge
    output wire [11:0] o_y6t,  // square top edge
    output wire [11:0] o_y6b,   // square bottom edge
    
    output wire [11:0] o_x7l,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x7r,  // square right edge
    output wire [11:0] o_y7t,  // square top edge
    output wire [11:0] o_y7b   // square bottom edge



//gotta make sure we can pause vga 
    //input pause
    );
//if in pause state, need to show it by stopping vga updates AND score/level updates. 
    reg [11:0] x [0:OBSTACLES_PER_SCREEN];   // horizontal position of square centr
    reg [1:0] s [0:OBSTACLES_PER_SCREEN];

    //reg [3:0] level;
    reg [31:0] lvl_obs_cnt;

    integer index;
   // for (index=0; index<2; index=index+1) begin
     // x[index] = (BUFFER+D_WIDTH+H_WIDTH+(index*4*H_WIDTH));
     // s[index] = 2'b01;
      //level = 4'b0001;
      //lvl_obs_cnt = (OBSTACLES_PER_LEVEL-OBSTACLES_PER_LEVEL);
   // end
    
    assign o_x0l = (s[0] == 0) ? D_WIDTH : ((x[0]<=(BUFFER+H_WIDTH)) ? 0:(x[0]-BUFFER - H_WIDTH));//(D_WIDTH+x[0]-BUFFER-H_WIDTH) : (x[0]-BUFFER - H_WIDTH));
    assign o_x0r = (s[0] == 0) ? 0 : ((x[0]<=(BUFFER-H_WIDTH)) ? 0 : (x[0]+H_WIDTH-BUFFER));
    assign o_y0t = (s[0] == 0) ? D_HEIGHT : ((s[0] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y0b = (s[0] == 0) ? 0 : ((s[0] == 1) ? D_HEIGHT : HEIGHT_H);

    assign o_x1l = (s[1] == 0) ? D_WIDTH : ((x[1]<=(BUFFER+H_WIDTH)) ?  0:(x[1]-BUFFER - H_WIDTH));//(D_WIDTH+x[1]-BUFFER-H_WIDTH) : (x[1]-BUFFER - H_WIDTH));
    assign o_x1r = (s[1] == 0) ? 0 : ((x[1]<=(BUFFER-H_WIDTH)) ? 0 : (x[1]+H_WIDTH-BUFFER));
    assign o_y1t = (s[1] == 0) ? D_HEIGHT : ((s[1] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y1b = (s[1] == 0) ? 0 : ((s[1] == 1) ? D_HEIGHT : HEIGHT_H);
    
    assign o_x2l = (s[2] == 0) ? D_WIDTH : ((x[2]<=(BUFFER+H_WIDTH)) ?  0:(x[2]-BUFFER - H_WIDTH));//(D_WIDTH+x[2]-BUFFER-H_WIDTH) : (x[2]-BUFFER - H_WIDTH));
    assign o_x2r = (s[2] == 0) ? 0 : ((x[2]<=(BUFFER-H_WIDTH)) ? 0 : (x[2]+H_WIDTH-BUFFER));
    assign o_y2t = (s[2] == 0) ? D_HEIGHT : ((s[2] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y2b = (s[2] == 0) ? 0 : ((s[2] == 1) ? D_HEIGHT : HEIGHT_H);
    
    assign o_x3l = (s[3] == 0) ? D_WIDTH : ((x[3]<=(BUFFER+H_WIDTH)) ?  0:(x[3]-BUFFER - H_WIDTH));//(D_WIDTH+x[3]-BUFFER-H_WIDTH) : (x[3]-BUFFER - H_WIDTH));
    assign o_x3r = (s[3] == 0) ? 0 : ((x[3]<=(BUFFER-H_WIDTH)) ? 0 : (x[3]+H_WIDTH-BUFFER));
    assign o_y3t = (s[3] == 0) ? D_HEIGHT : ((s[3] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y3b = (s[3] == 0) ? 0 : ((s[3] == 1) ? D_HEIGHT : HEIGHT_H);
    
    assign o_x4l = (s[4] == 0) ? D_WIDTH : ((x[4]<=(BUFFER+H_WIDTH)) ?  0:(x[4]-BUFFER - H_WIDTH));//(D_WIDTH+x[4]-BUFFER-H_WIDTH) : (x[4]-BUFFER - H_WIDTH));
    assign o_x4r = (s[4] == 0) ? 0 : ((x[4]<=(BUFFER-H_WIDTH)) ? 0 : (x[4]+H_WIDTH-BUFFER));
    assign o_y4t = (s[4] == 0) ? D_HEIGHT : ((s[4] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y4b = (s[4] == 0) ? 0 : ((s[4] == 1) ? D_HEIGHT : HEIGHT_H);
    
    assign o_x5l = (s[5] == 0) ? D_WIDTH : ((x[5]<=(BUFFER+H_WIDTH)) ?  0:(x[5]-BUFFER - H_WIDTH));//(D_WIDTH+x[5]-BUFFER-H_WIDTH) : (x[5]-BUFFER - H_WIDTH));
    assign o_x5r = (s[5] == 0) ? 0 : ((x[5]<=(BUFFER-H_WIDTH)) ? 0 : (x[5]+H_WIDTH-BUFFER));
    assign o_y5t = (s[5] == 0) ? D_HEIGHT : ((s[5] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y5b = (s[5] == 0) ? 0 : ((s[5] == 1) ? D_HEIGHT : HEIGHT_H);
    
    assign o_x6l = (s[6] == 0) ? D_WIDTH : ((x[6]<=(BUFFER+H_WIDTH)) ?  0:(x[6]-BUFFER - H_WIDTH));//(D_WIDTH+x[6]-BUFFER-H_WIDTH) : (x[6]-BUFFER - H_WIDTH));
    assign o_x6r = (s[6] == 0) ? 0 : ((x[6]<=(BUFFER-H_WIDTH)) ? 0 : (x[6]+H_WIDTH-BUFFER));
    assign o_y6t = (s[6] == 0) ? D_HEIGHT : ((s[6] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y6b = (s[6] == 0) ? 0 : ((s[6] == 1) ? D_HEIGHT : HEIGHT_H);
    
    assign o_x7l = (s[7] == 0) ? D_WIDTH : ((x[7]<=(BUFFER+H_WIDTH)) ?  0:(x[7]-BUFFER - H_WIDTH));//(D_WIDTH+x[7]-BUFFER-H_WIDTH) : (x[7]-BUFFER - H_WIDTH));
    assign o_x7r = (s[7] == 0) ? 0 : ((x[7]<=(BUFFER-H_WIDTH)) ? 0 : (x[7]+H_WIDTH-BUFFER));
    assign o_y7t = (s[7] == 0) ? D_HEIGHT : ((s[7] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y7b = (s[7] == 0) ? 0 : ((s[7] == 1) ? D_HEIGHT : HEIGHT_H);

    //wire [(RAND_WIDTH-1):0] rand_out;
    //random_num_gen rand(.clk(i_clk),.out(rand_out));

    

    
    //wire lvl_gap;
    //assign lvl_gap = (level_obs_cnt >= (OBSTACLES_PER_LEVEL-OBSTACLES_PER_LEVEL)) ? 0 : 1;
   // integer index;
   
    reg [31:0] lev_cnt;
    reg [31:0] lev;
    reg [2:0] alt;
    reg score;
    reg color;
//    reg [31:0] score;
    reg pause_state = 0;
    always @ (posedge i_clk)
    begin
        if(score == 1) begin
            score <= 0;
        end
        if(i_pause & ~adj) begin
            pause_state <= ~pause_state;
        end
        if (i_rst)  // on reset return to starting position
        begin
            pause_state <= 0;
    	    for (index=0; index<(OBSTACLES_PER_SCREEN+1); index=index+1) begin
      	        x[index] <= (BUFFER+D_WIDTH+H_WIDTH+(index*4*H_WIDTH));
                //lev <= 4'b0000;
      	        s[index] <= 2'b1;
                lev_cnt <= 0;
                alt <= 0;
                lev <= 1;
                score <= 0;
            end
        end

        if((pause_state & ~i_pause) | (~pause_state & i_pause) | adj)
        begin
            //do nothing? but still display ? or should we turn off display idk 
        end
        if ((~lose &((pause_state & i_pause) | (~pause_state & ~i_pause))&~adj) && i_animate && i_ani_stb)
        begin
            for (index=0; index<(OBSTACLES_PER_SCREEN+1); index=index+1) begin
      	        if (x[index] <= BUFFER-H_WIDTH) begin
                    x[index] <= x[index] + D_WIDTH + H_WIDTH;
                    if(lev_cnt >= ((OBSTACLES_PER_LEVEL-OBSTACLES_PER_SCREEN)-1)) begin
                        s[index] <= 0;
                        if(lev_cnt == (OBSTACLES_PER_LEVEL-1)) begin
                            lev_cnt <= 0; //so if this is working, then we should expct lvl_cnt to be like 10 if there r 10 obstacles. 
                            lev <= lev +1;
                        end
                        else begin
                            lev_cnt <= lev_cnt + 1;
                            score <= 1; //score should pulse high 10 times ?
                            color <= 1;
                        end
                    end
                    else begin
                        if (s[index] > 0) begin
                            lev_cnt <= lev_cnt + 1;
                            score <= 1;
                            color <= 1;
                        end
                        if(done) begin
                            s[index] <= 0;
                        end
                        else begin
                            alt <= alt + 1;
                            if(alt[2:0]==3'b000) begin
                                s[index] <= 1;
                            end
                            else if(alt[2:0]==3'b001) begin
                                s[index] <= 0;
                            end
                            else if(alt[2:0]==3'b010) begin
                                s[index] <= 2'b11;
                            end
                            else if(alt[2:0]==3'b011) begin
                                s[index] <= 2'b00;
                            end
                            else if(alt[2:0]==3'b100) begin
                                s[index] <= 1;
                            end
                            else if(alt[2:0]==3'b101) begin
                                s[index] <= 2'b00;
                            end
                            else if(alt[2:0]==3'b111) begin
                                s[index] <= 2'b1;
                            end
//                            //////
//                            else if(alt[2:0]==3'b001) begin
//                                s[index] <= 1;
//                            end
//                            else if(alt[2:0]==3'b010) begin
//                                s[index] <= 2'b10;
//                            end
//                            else if(alt[2:0]==3'b011) begin
//                                s[index] <= 2'b00;
//                            end
//                            else if(alt[2:0]==3'b100) begin
//                                s[index] <= 1;
//                            end
//                            else if(alt[2:0]==3'b101) begin
//                                s[index] <= 2'b11;
//                            end
//                            else if(alt[2:0]==3'b111) begin
//                                s[index] <= 2'b00;
//                            end
                        end
                    end
                //if(lvl_obs_cnt == OBSTACLES_PER_LEVEL
                end
                else begin
                    x[index] <= (x[index] - i_level);
                    if(color == 1) begin
                        color <= 0;
                    end
                end
             end  
             //end of for loop
		end
		

   	end
endmodule