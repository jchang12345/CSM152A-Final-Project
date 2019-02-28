`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:34:34 11/21/2018 
// Design Name: 
// Module Name:    rdebouncer 
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
module rdebouncer( input clk, input button, output debouncedbutton
    );
   
        
        reg debouncedbutton;
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
      
    end

endmodule
