module characters #(
    SPEED=5,
    HEIGHT_L=60,      // half square width (for ease of co-ordinate calculations)
    HEIGHT_H=300,      // half square width (for ease of co-ordinate calculations)
    H_WIDTH=80,
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
    output wire [11:0] o_y2b   // square bottom edge
    );
//if in pause state, need to show it by stopping vga updates AND score/level updates. 
    reg [11:0] x [0:OBSTACLES_PER_SCREEN];   // horizontal position of square centr
    reg [1:0] s [0:OBSTACLES_PER_SCREEN];

    reg [3:0] level;
    reg [31:0] lvl_obs_cnt;

    integer index;
   // for (index=0; index<2; index=index+1) begin
     // x[index] = (BUFFER+D_WIDTH+H_WIDTH+(index*4*H_WIDTH));
     // s[index] = 2'b01;
      //level = 4'b0001;
      //lvl_obs_cnt = (OBSTACLES_PER_LEVEL-OBSTACLES_PER_LEVEL);
   // end
    
    assign o_x0l = (s[0] == 0) ? D_WIDTH : ((x[0]<=(BUFFER+H_WIDTH)) ? 0 : (x[0]-BUFFER - H_WIDTH));
    assign o_x0r = (s[0] == 0) ? 0 : ((x[0]<=(BUFFER-H_WIDTH)) ? 0 : (x[0]+H_WIDTH-BUFFER));
    assign o_y0t = (s[0] == 0) ? D_HEIGHT : ((s[0] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y0b = (s[0] == 0) ? 0 : ((s[0] == 1) ? D_HEIGHT : HEIGHT_H);

    assign o_x1l = (s[1] == 0) ? D_WIDTH : ((x[1]<=(BUFFER+H_WIDTH)) ? 0 : (x[1]-BUFFER - H_WIDTH));
    assign o_x1r = (s[1] == 0) ? 0 : ((x[1]<=(BUFFER-H_WIDTH)) ? 0 : (x[1]+H_WIDTH-BUFFER));
    assign o_y1t = (s[1] == 0) ? D_HEIGHT : ((s[1] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y1b = (s[1] == 0) ? 0 : ((s[1] == 1) ? D_HEIGHT : HEIGHT_H);
    
    assign o_x2l = (s[2] == 0) ? D_WIDTH : ((x[2]<=(BUFFER+H_WIDTH)) ? 0 : (x[2]-BUFFER - H_WIDTH));
    assign o_x2r = (s[2] == 0) ? 0 : ((x[2]<=(BUFFER-H_WIDTH)) ? 0 : (x[2]+H_WIDTH-BUFFER));
    assign o_y2t = (s[2] == 0) ? D_HEIGHT : ((s[2] == 1) ? (D_HEIGHT-HEIGHT_L) : 0);
    assign o_y2b = (s[2] == 0) ? 0 : ((s[2] == 1) ? D_HEIGHT : HEIGHT_H);

    //wire [(RAND_WIDTH-1):0] rand_out;
    //random_num_gen rand(.clk(i_clk),.out(rand_out));

    

    
    //wire lvl_gap;
    //assign lvl_gap = (level_obs_cnt >= (OBSTACLES_PER_LEVEL-OBSTACLES_PER_LEVEL)) ? 0 : 1;
   // integer index;
   
    reg [31:0] lev_cnt;
    reg [31:0] lev;
    reg [31:0] alt;
    always @ (posedge i_clk)
    begin
        if (i_rst)  // on reset return to starting position
        begin
           
    	    for (index=0; index<(OBSTACLES_PER_SCREEN+1); index=index+1) begin
      	        x[index] <= (BUFFER+D_WIDTH+H_WIDTH+(index*4*H_WIDTH));
                level <= 4'b0000;
      	        s[index] <= 2'b1;
                lev_cnt <= 0;
                alt <= 0;
                lev <= 1;
            end
        end
 //       if (i_animate && i_ani_stb)
 //       begin
 //           for (index=0; index<(OBSTACLES_PER_SCREEN+1);
 // index=index+1) begin
  //    	        if (x[index] <= BUFFER-H_WIDTH) begin
  //                  x[index] <= x[index] + D_WIDTH + (4*H_WIDTH);
  //                  if(lev_cnt >= 
  //((OBSTACLES_PER_LEVEL-OBSTACLES_PER_SCREEN)-1)) begin
   //                     s[index] <= 0;
    //                    if(lev_cnt == (OBSTACLES_PER_LEVEL-1)) begin
     //                       lev_cnt <= 0;
      //                      lev <= lev +1;
       //                 end
        //                else begin
        //                   lev_cnt <= lev_cnt + 1;
         //               end
         //           end
          //          else begin
          //              if (s[index] > 0) begin
          ///                  lev_cnt <= lev_cnt + 1;
           //             end
            //            alt <= alt + 1;
             //           s[index] <= alt[0]+1;
             //       end
                //if(lvl_obs_cnt == OBSTACLES_PER_LEVEL
            //    end
            //    else begin
              //      x[index] <= (x[index] - lev);
              //  end
          //   end
		//end
		

   	end
endmodule
    
parameter VERT=0;




//thinking abt doing character actually as multiple blocks, so it has 2 arms , 2 feet, 1 body, 1 head
//each "block" should be different based on starting locations which is passed in and changed as a parameter.
//idk if i can change size actually i can just depends on how "big" the x and y are when passing in as pixels. 

module character(input wire i_clk,         // base clock
    //input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_jump,
    input wire i_duck,
    input wire i_animate,     // animate when input is high

    input wire i_pause,
    input wire adj,
    input wire done,
    input wire lose,



    //ducking

    
    
    //left hand
    output wire [11:0] hl_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] hl_x2,  // square right edge
    output wire [11:0] hl_y1,   // square bottom edge
    output wire [11:0] hl_y2,   // square bottom edge

        //right hand
    output wire [11:0] hr_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] hr_x2,  // square right edge
    output wire [11:0] hr_y1,   // square bottom edge
    output wire [11:0] hr_y2,   // square bottom edge

    //right leg
    output wire [11:0] lr_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] lr_x2,  // square right edge
    output wire [11:0] lr_y1,   // square bottom edge
    output wire [11:0] lr_y2,   // square bottom edge

     //left leg
    output wire [11:0] ll_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] ll_x2,  // square right edge
    output wire [11:0] ll_y1,   // square bottom edge
    output wire [11:0] ll_y2,  // square bottom edge

         //body
    output wire [11:0] body_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] body_x2,  // square right edge
    output wire [11:0] body_y1,   // square bottom edge
    output wire [11:0] body_y2,   // square bottom edge

         //head
    output wire [11:0] head_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] head_x2,  // square right edge
    output wire [11:0] head_y1,   // square bottom edge
    output wire [11:0] head_y2   // square bottom edge
    );

//reg pause_state = 0;
//always @ (posedge(i_clk)) begin
  //  if(i_pause) begin
    //    pause_state <= ~pause_state;
    //end
    //if pause_state , jump and duck are at 0. 
    //if(pause_state)
    //begin
    //end
// end

//wire animate_p = i_animate && ~((pause_state & ~i_pause) | (~pause_state & i_pause));
//wire jump_p = i_jump && ~((pause_state & ~i_pause) | (~pause_state & i_pause));
//wire duck_p = i_duck && ~((pause_state & ~i_pause) | (~pause_state & i_pause));



characterpartshl handsleft(i_clk,i_rst,i_jump,i_duck,i_animate,i_pause,adj,done,lose,hl_x1,hl_x2,hl_y1,hl_y2);
characterpartshr handsright(i_clk,i_rst,i_jump,i_duck,i_animate,i_pause,adj,done,lose,hr_x1,hr_x2,hr_y1,hr_y2);
characterpartslr footright(i_clk,i_rst,i_jump,i_duck,i_animate,i_pause,adj,done,lose,lr_x1,lr_x2,lr_y1,lr_y2);
characterpartsll footleft(i_clk,i_rst,i_jump,i_duck,i_animate,i_pause,adj,done,lose,ll_x1,ll_x2,ll_y1,ll_y2);
characterpartsbody body(i_clk,i_rst,i_jump,i_duck,i_animate,i_pause,adj,done,lose,body_x1,body_x2,body_y1,body_y2);
characterpartshead head(i_clk,i_rst,i_jump,i_duck,i_animate,i_pause,adj,done,lose,head_x1,head_x2,head_y1,head_y2);


endmodule


module characterpartshl(input wire i_clk,         // base clock
    //input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_jump,
    input wire i_duck,
    input wire i_animate,
    input wire i_pause,
    input wire adj,
    input wire done,
    input wire lose,
    // animate when input is high
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,   // square bottom edge
    output wire [11:0] o_y2   // square bottom edge

    //turn the paramter to whatever the inputs are so we can have variable input oh so thats what gilbert ross alex was doing 
    //or i can just lol create 6 diff modules... that probably easier to rep

    );
    parameter H_WIDTH=5;      // half square width (for ease of co-ordinate calculations)
    parameter H_HEIGHT=5;      // half square width (for ease of co-ordinate calculations)   //also going to spawn it not that much higher but higher. blk+10
    



    parameter IX=(5+H_WIDTH);         // initial horizontal position of square centre , -5 from low blk width 
    parameter IY=(D_HEIGHT-H_HEIGHT-70);         // initial vertical position of square centre +30 from low blk
    parameter IX_DIR=0;       // initial horizontal direction: 1 is right, 0 is left
    parameter IY_DIR=1;       // initial vertical direction: 1 is down, 0 is up
    parameter VERT = IY-45;//(120+30+H_HEIGHT)
    parameter DOWN = IY+25;
    parameter D_WIDTH=640;    // width of display
    parameter D_HEIGHT=480;    // height of display
    

    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    reg x_dir = IX_DIR;  // horizontal animation direction
    reg y_dir = IY_DIR;  // vertical animation direction

    assign o_x1 = x - H_WIDTH;  // left: centre minus half horizontal size
    assign o_x2 = x + H_WIDTH;  // right
    assign o_y1 = y + H_HEIGHT;  // bottom
    assign o_y2 = y - H_HEIGHT;  // top
    reg pause_state = 0;
    always @ (posedge i_clk)
    begin
        
        if  (i_pause) begin
            pause_state <= ~pause_state;
        end
        
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
            x_dir <= IX_DIR;
            y_dir <= IY_DIR;
            pause_state <= 0;
        end


        if((pause_state & ~i_pause) | (~pause_state & i_pause))
        begin
            //do nothing? but still display ? or should we turn off display idk 
        end
        if (~lose & ~done & ~adj &((pause_state & i_pause) | (~pause_state & ~i_pause)) && i_animate)// && i_ani_stb)
        begin
//            if(i_jump) begin
//                y <= VERT;  // move left if positive x_dir
//            end
//            else begin
//                y <= IY;
//            end
            
            
            if(i_jump && ~i_duck) begin
                y <= VERT;  // move left if positive x_dir
            end
            else if (i_duck && ~i_jump) begin
                y <= DOWN;
            end
            else begin
                y <= IY;
            end//y <= (y_dir) ? y + 1 : y - 1;  // move down if positive y_dir
        end
            //if (x <= H_SIZE + 1)  // edge of square is at left of screen
            //   x_dir <= 1;  // change direction to right
            //if (x >= (D_WIDTH - H_SIZE - 1))  // edge of square at right
            //    x_dir <= 0;  // change direction to left          
            //if (y <= H_SIZE + 1)  // edge of square at top of screen
            //    y_dir <= 1;  // change direction to down
            //if (y >= (D_HEIGHT - H_SIZE - 1))  // edge of square at bottom
            //    y_dir <= 0;  // change direction to up              
        
    end
endmodule


module characterpartshr(input wire i_clk,         // base clock
    //input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_jump,
    input wire i_duck,
    input wire i_animate,     // animate when input is high
    input wire i_pause,
    input wire adj,
    input wire done,
    input wire lose,
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,   // square bottom edge
    output wire [11:0] o_y2   // square bottom edge

    //turn the paramter to whatever the inputs are so we can have variable input oh so thats what gilbert ross alex was doing 
    //or i can just lol create 6 diff modules... that probably easier to rep

    );
    parameter H_WIDTH=5;      // half square width (for ease of co-ordinate calculations)
    parameter H_HEIGHT=5;      // half square width (for ease of co-ordinate calculations)
    

//25 and 30. but each width is 20? 

    parameter IX=(30+H_WIDTH);         // initial horizontal position of square centre , should be fine if +25?
    parameter IY=(D_HEIGHT-H_HEIGHT-70);         // initial vertical position of square centre //want it at 15
    parameter IX_DIR=0;       // initial horizontal direction: 1 is right, 0 is left
    parameter IY_DIR=1;       // initial vertical direction: 1 is down, 0 is up
parameter VERT = IY-45;//(120+30+H_HEIGHT)
    parameter DOWN = IY+25;
    parameter D_WIDTH=640;    // width of display
    parameter D_HEIGHT=480;    // height of display
    

    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    reg x_dir = IX_DIR;  // horizontal animation direction
    reg y_dir = IY_DIR;  // vertical animation direction

    assign o_x1 = x - H_WIDTH;  // left: centre minus half horizontal size
    assign o_x2 = x + H_WIDTH;  // right
    assign o_y1 = y + H_HEIGHT;  // bottom
    assign o_y2 = y - H_HEIGHT;  // top
    reg pause_state = 0;

    always @ (posedge i_clk)
    begin
        if  (i_pause) begin
            pause_state <= ~pause_state;
        end
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
            x_dir <= IX_DIR;
            y_dir <= IY_DIR;
            pause_state <= 0;
        end
        if((pause_state & ~i_pause) | (~pause_state & i_pause))
        begin
            //do nothing? but still display ? or should we turn off display idk 
        end
        if (~lose & ~adj & ~done & ((pause_state & i_pause) | (~pause_state & ~i_pause)) && i_animate)
        //if (~lose & ~adj & ~done & ((pause_state) | (~pause_state)) && i_animate)
        begin
//            if(i_jump) begin
//                y <= VERT;  // move left if positive x_dir
//            end
//            else begin
//                y <= IY;
//            end
            
            
            if(i_jump && ~i_duck) begin
                y <= VERT;  // move left if positive x_dir
            end
            else if (i_duck && ~i_jump) begin
                y <= DOWN;
            end
            else begin
                y <= IY;
            end//y <= (y_dir) ? y + 1 : y - 1;  // move down if positive y_dir

            //if (x <= H_SIZE + 1)  // edge of square is at left of screen
            //   x_dir <= 1;  // change direction to right
            //if (x >= (D_WIDTH - H_SIZE - 1))  // edge of square at right
            //    x_dir <= 0;  // change direction to left          
            //if (y <= H_SIZE + 1)  // edge of square at top of screen
            //    y_dir <= 1;  // change direction to down
            //if (y >= (D_HEIGHT - H_SIZE - 1))  // edge of square at bottom
            //    y_dir <= 0;  // change direction to up              
        end
    end
endmodule




module characterpartsll(input wire i_clk,         // base clock
    //input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_jump,
    input wire i_duck,
    input wire i_animate,     // animate when input is high
    input wire i_pause,
    input wire adj,
    input wire done,
    input wire lose,
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,   // square bottom edge
    output wire [11:0] o_y2   // square bottom edge

    //turn the paramter to whatever the inputs are so we can have variable input oh so thats what gilbert ross alex was doing 
    //or i can just lol create 6 diff modules... that probably easier to rep

    );
    parameter H_WIDTH=4;      // half square width (for ease of co-ordinate calculations)
    parameter H_HEIGHT=25;      // half square width (for ease of co-ordinate calculations)  //so minus 60 of the hands 
    



    parameter IX=(10+H_WIDTH);         // initial horizontal position of square centre
    parameter IY=(D_HEIGHT-H_HEIGHT);         // initial vertical position of square centre
    parameter IX_DIR=0;       // initial horizontal direction: 1 is right, 0 is left
    parameter IY_DIR=1;       // initial vertical direction: 1 is down, 0 is up
    parameter VERT = IY-45;//(120+30+H_HEIGHT)
    parameter DOWN = IY+25;
    parameter D_WIDTH=640;    // width of display
    parameter D_HEIGHT=480;    // height of display
    

    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    reg x_dir = IX_DIR;  // horizontal animation direction
    reg y_dir = IY_DIR;  // vertical animation direction

    assign o_x1 = x - H_WIDTH;  // left: centre minus half horizontal size
    assign o_x2 = x + H_WIDTH;  // right
    assign o_y1 = y + H_HEIGHT;  // bottom
    assign o_y2 = y - H_HEIGHT;  // top
    reg pause_state = 0;

    always @ (posedge i_clk)
    begin
        if  (i_pause) begin
            pause_state <= ~pause_state;
        end
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
            x_dir <= IX_DIR;
            y_dir <= IY_DIR;
            pause_state <= 0;
        end
        if((pause_state & ~i_pause) | (~pause_state & i_pause))
        begin
            //do nothing? but still display ? or should we turn off display idk 
        end
        if (~lose & ~adj & ~done & ((pause_state & i_pause) | (~pause_state & ~i_pause)) && i_animate)
        begin
            if(i_jump && ~i_duck) begin
                y <= VERT;  // move left if positive x_dir
            end
            else if (i_duck && ~i_jump) begin
                y <= DOWN;
            end
            else begin
                y <= IY;
            end//y <= (y_dir) ? y + 1 : y - 1;  // move down if positive y_dir

            //if (x <= H_SIZE + 1)  // edge of square is at left of screen
            //   x_dir <= 1;  // change direction to right
            //if (x >= (D_WIDTH - H_SIZE - 1))  // edge of square at right
            //    x_dir <= 0;  // change direction to left          
            //if (y <= H_SIZE + 1)  // edge of square at top of screen
            //    y_dir <= 1;  // change direction to down
            //if (y >= (D_HEIGHT - H_SIZE - 1))  // edge of square at bottom
            //    y_dir <= 0;  // change direction to up              
        end
    end
endmodule




module characterpartslr(input wire i_clk,         // base clock
    //input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_jump,
    input wire i_duck,
    input wire i_animate,     // animate when input is high
    input wire i_pause,
    input wire adj,
    input wire done,
    input wire lose,
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,   // square bottom edge
    output wire [11:0] o_y2   // square bottom edge

    //turn the paramter to whatever the inputs are so we can have variable input oh so thats what gilbert ross alex was doing 
    //or i can just lol create 6 diff modules... that probably easier to rep

    );
    parameter H_WIDTH=4;      // half square width (for ease of co-ordinate calculations)
    parameter H_HEIGHT=25;      // half square width (for ease of co-ordinate calculations)  //10 is just experimental b/c other is at 60 + 
    



    parameter IX=(22+H_WIDTH);         // initial horizontal position of square centre
    parameter IY=(D_HEIGHT-H_HEIGHT);         // initial vertical position of square centre minus 25 to keep close to leg space to body
    parameter IX_DIR=0;       // initial horizontal direction: 1 is right, 0 is left
    parameter IY_DIR=1;       // initial vertical direction: 1 is down, 0 is up
    parameter VERT = IY-45;//(120+30+H_HEIGHT) //vert is in animate so kinda useless rn 
    parameter DOWN = IY+25;
    parameter D_WIDTH=640;    // width of display
    parameter D_HEIGHT=480;    // height of display
    

    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    reg x_dir = IX_DIR;  // horizontal animation direction
    reg y_dir = IY_DIR;  // vertical animation direction

    assign o_x1 = x - H_WIDTH;  // left: centre minus half horizontal size
    assign o_x2 = x + H_WIDTH;  // right
    assign o_y1 = y + H_HEIGHT;  // bottom
    assign o_y2 = y - H_HEIGHT;  // top
    reg pause_state = 0;

    always @ (posedge i_clk)
    begin
        if  (i_pause) begin
            pause_state <= ~pause_state;
        end
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
            x_dir <= IX_DIR;
            y_dir <= IY_DIR;
            pause_state <= 0;
        end
        if (~lose & ~adj & ~done & ((pause_state & i_pause) | (~pause_state & ~i_pause)) && i_animate)
        begin
            if(i_jump && ~i_duck) begin
                y <= VERT;  // move left if positive x_dir
            end
            else if (i_duck && ~i_jump) begin
                y <= DOWN;
            end
            else begin
                y <= IY;
            end//y <= (y_dir) ? y + 1 : y - 1;  // move down if positive y_dir

            //if (x <= H_SIZE + 1)  // edge of square is at left of screen
            //   x_dir <= 1;  // change direction to right
            //if (x >= (D_WIDTH - H_SIZE - 1))  // edge of square at right
            //    x_dir <= 0;  // change direction to left          
            //if (y <= H_SIZE + 1)  // edge of square at top of screen
            //    y_dir <= 1;  // change direction to down
            //if (y >= (D_HEIGHT - H_SIZE - 1))  // edge of square at bottom
            //    y_dir <= 0;  // change direction to up              
        end
    end
endmodule




module characterpartsbody(input wire i_clk,         // base clock
    //input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_jump,
    input wire i_duck,
    input wire i_animate,     // animate when input is high
    input wire i_pause,
    input wire adj,
    input wire done,
    input wire lose,
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,   // square bottom edge
    output wire [11:0] o_y2   // square bottom edge

    //turn the paramter to whatever the inputs are so we can have variable input oh so thats what gilbert ross alex was doing 
    //or i can just lol create 6 diff modules... that probably easier to rep

    );
    parameter H_WIDTH=10;      // half square width (for ease of co-ordinate calculations)  //should def make the width of this bigger like reasonably bigger
    parameter H_HEIGHT=20;      // half square width (for ease of co-ordinate calculations) //40? 
    
//25 and 85, midpt is 55=width
//h is the problem now, 10, 70 so midpt is 40 

    parameter IX=(10+H_WIDTH);         // initial horizontal position of square centre //
    parameter IY=(D_HEIGHT-H_HEIGHT-50);         // initial vertical position of square centre ,so at pos 20 now 
    parameter IX_DIR=0;       // initial horizontal direction: 1 is right, 0 is left
   parameter IY_DIR=1;       // initial vertical direction: 1 is down, 0 is up
    parameter VERT = IY-45;//(120+30+H_HEIGHT)
    parameter DOWN = IY+25;
    parameter D_WIDTH=640;    // width of display
    parameter D_HEIGHT=480;    // height of display
    

    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    reg x_dir = IX_DIR;  // horizontal animation direction
    reg y_dir = IY_DIR;  // vertical animation direction

    assign o_x1 = x - H_WIDTH;  // left: centre minus half horizontal size
    assign o_x2 = x + H_WIDTH;  // right
    assign o_y1 = y + H_HEIGHT;  // bottom
    assign o_y2 = y - H_HEIGHT;  // top
    reg pause_state = 0;

    always @ (posedge i_clk)
    begin
        if  (i_pause) begin
            pause_state <= ~pause_state;
        end
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
            x_dir <= IX_DIR;
            y_dir <= IY_DIR;
            pause_state <= 0;
        end
        if((pause_state & ~i_pause) | (~pause_state & i_pause))
        begin
            //do nothing? but still display ? or should we turn off display idk 
        end
        if (~lose & ~adj & ~done & ((pause_state & i_pause) | (~pause_state & ~i_pause)) && i_animate)
        begin
            if(i_jump && ~i_duck) begin
                y <= VERT;  // move left if positive x_dir
            end
            else if (i_duck && ~i_jump) begin
                y <= DOWN;
            end
            else begin
                y <= IY;
            end//y <= (y_dir) ? y + 1 : y - 1;  // move down if positive y_dir

            //if (x <= H_SIZE + 1)  // edge of square is at left of screen
            //   x_dir <= 1;  // change direction to right
            //if (x >= (D_WIDTH - H_SIZE - 1))  // edge of square at right
            //    x_dir <= 0;  // change direction to left          
            //if (y <= H_SIZE + 1)  // edge of square at top of screen
            //    y_dir <= 1;  // change direction to down
            //if (y >= (D_HEIGHT - H_SIZE - 1))  // edge of square at bottom
            //    y_dir <= 0;  // change direction to up              
        end
    end
endmodule




module characterpartshead(input wire i_clk,         // base clock
    //input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_rst,         // reset: returns animation to starting position
    input wire i_jump,
    input wire i_duck,
    input wire i_animate,     // animate when input is high
    input wire i_pause,
    input wire adj,
    input wire done,
    input wire lose,
    output wire [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output wire [11:0] o_x2,  // square right edge
    output wire [11:0] o_y1,   // square bottom edge
    output wire [11:0] o_y2   // square bottom edge

    //turn the paramter to whatever the inputs are so we can have variable input oh so thats what gilbert ross alex was doing 
    //or i can just lol create 6 diff modules... that probably easier to rep

    );
    parameter H_WIDTH=5;      // half square width (for ease of co-ordinate calculations)
    parameter H_HEIGHT=5;      // half square width (for ease of co-ordinate calculations)
    

//body is at 55,20. want this to be at total of 85+5,

    parameter IX=(15+H_WIDTH);         // initial horizontal position of square centre
    parameter IY=(D_HEIGHT-H_HEIGHT-90);         // initial vertical position of square centre  //at h=40 is not bad 
    parameter IX_DIR=0;       // initial horizontal direction: 1 is right, 0 is left
    parameter IY_DIR=1;       // initial vertical direction: 1 is down, 0 is up
   parameter VERT = IY-45;//(120+30+H_HEIGHT)
    parameter DOWN = IY+25;
    parameter D_WIDTH=640;    // width of display
    parameter D_HEIGHT=480;    // height of display
    

    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    reg x_dir = IX_DIR;  // horizontal animation direction
    reg y_dir = IY_DIR;  // vertical animation direction

    assign o_x1 = x - H_WIDTH;  // left: centre minus half horizontal size
    assign o_x2 = x + H_WIDTH;  // right
    assign o_y1 = y + H_HEIGHT;  // bottom
    assign o_y2 = y - H_HEIGHT;  // top
    reg pause_state = 0;

    always @ (posedge i_clk)
    begin
        if  (i_pause & ~adj) begin
            pause_state <= ~pause_state;
        end
        if (i_rst)  // on reset return to starting position
        begin
            x <= IX;
            y <= IY;
            x_dir <= IX_DIR;
            y_dir <= IY_DIR;
            pause_state <= 0;
        end
        if((pause_state & ~i_pause) | (~pause_state & i_pause) | adj)
        begin
            //do nothing? but still display ? or should we turn off display idk 
        end
        if (~lose & ~adj & ~done & ((pause_state & i_pause) | (~pause_state & ~i_pause)) && i_animate)
        begin
            if(i_jump && ~i_duck) begin
                y <= VERT;  // move left if positive x_dir
            end
            else if (i_duck && ~i_jump) begin
                y <= DOWN;
            end
            else begin
                y <= IY;
            end//y <= (y_dir) ? y + 1 : y - 1;  // move down if positive y_dir

            //if (x <= H_SIZE + 1)  // edge of square is at left of screen
            //   x_dir <= 1;  // change direction to right
            //if (x >= (D_WIDTH - H_SIZE - 1))  // edge of square at right
            //    x_dir <= 0;  // change direction to left          
            //if (y <= H_SIZE + 1)  // edge of square at top of screen
            //    y_dir <= 1;  // change direction to down
            //if (y >= (D_HEIGHT - H_SIZE - 1))  // edge of square at bottom
            //    y_dir <= 0;  // change direction to up              
        end
    end
endmodule




