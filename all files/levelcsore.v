
module levelscore(clk, unpaused_in, pause, adj, rst, num, sel, level10_in, level1_in, score10_in, score1_in, unpaused_out, level10_out, level1_out, score10_out, score1_out);
               
    input clk; 
  	//input tick;
  	input unpaused_in;
  	input pause;
  	input rst;
  	input adj; //adj for level selection? 
  	input [2:0] num; //maybe use this as level select
    input [1:0] sel;
    input [3:0] level10_in;
  	input [3:0] level1_in;
	input [3:0] score10_in;
  	input [3:0] score1_in;
  	output unpaused_out;
    output [3:0] level10_out;
  	output [3:0] level1_out;
  	output [3:0] score10_out;
  	output [3:0] score1_out;

    reg [3:0] level10_out;
    reg [3:0] level1_out;
    reg [3:0] score10_out;
    reg [3:0] score1_out;
  
  	reg unpaused_out;


    //or @ posedge of end of a level (x amount of obstacles, indicate what level you on)
  	always @ (posedge clk) //so at posedge of the counter for a passing obj, update score
    begin
      if(rst) begin
        	level10_out <= 1'b0;
        	level1_out <= 1'b0;
        	score10_out <= 1'b0;
        	score1_out <= 1'b0;
        
        	unpaused_out <= 1'b1;
      end
      else if (adj) begin
        if(pause) begin
          	//case(sel)
            //  0: begin
                  level10_out <= level10_in;
              	  //level1_out <= level1_in;
                  level1_out <= (num>7) ? 7 : num;
              	  score10_out <= score10_in;
                  score1_out <= score1_in;
        
                end
        else begin
            level10_out <= level10_in;
            level1_out <= level1_in;
            score10_out <= score10_in;
            score1_out <= score1_in;
        end
        unpaused_out <= 1'b1;
      end
   
      else begin
          if ( ((unpaused_in & ~pause)|(~unpaused_in & pause))) begin
          	  score1_out <= (score1_in + 1)%10;
              if((score1_in+1) > 9) begin
              	score10_out <= ((score10_in+1)%9);
              	if((score10_in+1) > 9) begin  //identify somehow the threshold for leveling up, after x amt of objects cleared in score?
                  level1_out <= ((level1_in+1)%7);
              		if((level1_in+1) > 7) begin
                      level10_out <= ((level10_in+1)%7);
              		end
                end              
              end              
          end
     
          else begin
              level10_out <= level10_in;
              level1_out <= level1_in;
              score10_out <= score10_in;
              score1_out <= score1_in;
          end
      	  if(pause) begin
        	  unpaused_out <= ~unpaused_in;
          end
          else begin
              unpaused_out <= unpaused_in;
          end
      end
	end