`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:14:39 11/14/2018 
// Design Name: 
// Module Name:    SegDisp 
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

module digit_display(in, out);
  	input [3:0] in;
  	output [6:0] out;
    
    
  	reg [6:0] out;
    //reg out;
    always @(in) begin
          	case(in)
                0: out <=7'b1000000;
                1: out <=7'b1111001;
                2: out <=7'b0100100;
                3: out <=7'b0110000;
                4: out <=7'b0011001;
                5: out <=7'b0010010;
                6: out <=7'b0000010;
                7: out <=7'b1111000;
                8: out <=7'b0000000;
                9: out <=7'b0010000;
            	default: out <= 7'b1111111;
        	endcase
     end
endmodule




module levelscore(clk, score, i_pause, adj, rst, num, sel, level10_in, level1_in, score10_in, score1_in, level10_out, level1_out, score10_out, score1_out, done, lose);
               
    input clk; 
  	//input tick;
  	//input unpaused_in;
    
  	//reg unpaused_out;
    input score;
  	input i_pause;
  	input rst;
  	input adj; //adj for level selection?
    input lose;
  	input [2:0] num; //maybe use this as level select
    input [1:0] sel;
    input [3:0] level10_in;
  	input [3:0] level1_in;
	input [3:0] score10_in;
  	input [3:0] score1_in;
  	//output unpaused_out;
    output [3:0] level10_out;
  	output [3:0] level1_out;
  	output [3:0] score10_out;
  	output [3:0] score1_out;
    output done;

    reg [3:0] level10_out;
    reg [3:0] level1_out;
    reg [3:0] score10_out;
    reg [3:0] score1_out;
  


    reg [31:0] counterlvl; //count # of obstacles cleared. 

    reg pause_state;
    reg done;
    //or @ posedge of end of a level (x amount of obstacles, indicate what level you on)
  	always @ (posedge clk) //so at posedge of the counter for a passing obj, update score
    begin
      if(rst) begin
        	level10_out <= 1'b0;
        	level1_out <= 1'b1;
        	score10_out <= 1'b0;
        	score1_out <= 1'b0;
            pause_state<=1'b0;
            done<= 0;
       // 	unpaused_out <= 1'b1;
      end

      else if (adj & i_pause) begin //should be in pause state
        //pause_state<=1;
       // if(i_pause) begin  //can only select the level, but when changing lvl, have to change the score. 
          	//case(sel)   //just 1 bit for the level select?
              //0: begin
                  level10_out <= 0;//level10_in;
              	  //level1_out <= level1_in;
                  level1_out <= (num>7) ? 7 : ((num < 1) ? 1 : num);
              	  score10_out <= score10_in; //its basically num *4 so hopefully, we can configure that correct
                  score1_out <= score1_in;
             // end  //just need to be in adj state and we can already "lvl select "
      //endcase
      
       end
       else if(((~pause_state & ~i_pause)|(pause_state & i_pause))&~adj & ~done) begin
            if(score) begin
                score1_out <= (score1_in + 1)%10;
                counterlvl<=counterlvl+1; //levels after every 40 points scored. 
                if((score1_in+1) > 9) begin
                    score10_out <= ((score10_in+1)%10);           
                end 
                if( ((counterlvl+1)% 16)==0) begin //well 16 obstacles per level
                    level1_out<=(level1_in+1)%10;
                    level10_out <= 0;
                    if(level1_in+1 >= 8) begin
                        done <= 1;
                    end
                    //if( (level1_in+1)>9)begin
                      //level10_out<=((level10_in+1)%10);
                      //end
                end 
            end
       end
          
       
        //unpaused_out <= 1'b1;
   
      	  //if(pause) begin
        	  //unpaused_out <= ~unpaused_in;
         // end
          //else begin
          //    unpaused_out <= unpaused_in;
          //end
      
//       else if(score && ((~pause))) begin
//          	              
//          end
//
//

        else begin
            level10_out <= level10_in;
            level1_out <= level1_in;
            score10_out <= score10_in;
            score1_out <= score1_in;
        end
	end
endmodule    
    




//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:20:20 10/31/2018 
// Design Name: 
// Module Name:    7 Segment Display 
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
module altfull_display(rst,clk, disp_cycle, adj, lvl10, lvl1, score10, score1, seg, an);
  
  
  input rst;
  input clk;
  input adj;
  //input blink;
  //input [1:0] sel; 
  input disp_cycle;
  input [3:0] lvl10;
  input [3:0] lvl1;
  input [3:0] score10;
  input [3:0] score1;
  output [6:0] seg;
  output [3:0] an;
    
  reg [1:0] count;// = 2'b0;
    
  wire [6:0] seg;
    wire [3:0] pre_digit;
    reg [3:0] an;
  
  reg [3:0] digit;
    
    assign pre_digit = digit;
  
  digit_display d(pre_digit,seg);
    
  //always @ (posedge clk) begin  
  //  if(rst) begin
   //       count <= 2'b0;
   // end
  //end
  
//well currently goes on clk actually

    always @ (posedge disp_cycle or posedge rst) begin
        if(rst) begin
            count <= 2'b0;
            digit <= 4'b0000;
            an <= 4'b1111;
        end
        else begin
//            if(adj) begin// adj lvl (count == sel)) begin
//                  digit <= 4'b1111;
//                  //an <= sel; 
//              end
           // else begin
                case (count)
                      0:
                      begin
                          digit <= score1;
                           an <= 4'b1110;
                      end
                      1:
                      begin
                          digit <= score10;
                          an <= 4'b1101;
                      end
                      2:
                      begin
                          digit <= lvl1;
                          an <= 4'b1011;
                      end
                      3:
                      begin
                          digit <= lvl10;
                          an <= 4'b0111;
                       end
                 endcase 
              //end
              count <= count+1;
            end
      end 
endmodule


