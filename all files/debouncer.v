//`timescale 1ns / 1ps
//1 Setup a counter variable, initialise to zero.
// 2 Setup a regular sampling event, perhaps using a timer. Use a period of about 1ms.

// 3 On a sample event:
 //4   if switch signal is high then
 //5     Reset the counter varaible to zero
 //6     Set internal switch state to released
 //7   else
 //8     Increment the counter variable to a maximum of 10
 //9   end if
//10   if counter=10 then
//11     Set internal switch state to pressed
//12   end if
module debouncer(input clk, input clk_db, input clk_db_d, input button, output debouncedbutton);

reg [2:0] step_d;
reg debouncedbutton;

 always @ (posedge clk) begin
     //if (rst)
      // begin
      //    //inst_wd[7:0] <= 0;
      //    step_d[2:0]  <= 0;
      // end
     //else 
     if (clk_db) // Down sampling
       begin
          //inst_wd[7:0] <= sw[7:0];
          step_d[2:0]  <= {button, step_d[2:1]};
       end
       else begin
            step_d[2:0] <= step_d[2:0];
       end
	   end
	// Detecting posedge of btnS
   wire is_btnS_posedge;
   assign is_btnS_posedge = ~ step_d[0] & step_d[1];
   always @ (posedge clk) begin
//     if (rst)
//       debouncedbutton <= 1'b0;
//     else
     if (clk_db_d)
       debouncedbutton <= is_btnS_posedge;
	  else
	    debouncedbutton <= 0;
  end
endmodule



        
        
        
 /*        reg debouncedbutton;
  reg [26:0] counter; //21 bits long of holding means held for a long time
  always @(posedge clk)
    begin
      if(button == 0)
        begin
          counter<=0;
          debouncedbutton<=0;
        end
      else
        begin
          //button is 1
          counter <= counter +1;
          if(counter[20]==1)//27'b111111111111111111111111111) //max of counter
            begin
              debouncedbutton<=1;
              counter<=0;
            end
          
        end
      
    end*/