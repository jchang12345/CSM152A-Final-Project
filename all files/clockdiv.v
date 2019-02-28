module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output segclk,	//7-segment clock: 381.47Hz
  output clk_db,
  output clk_db_d
	);


//input clk;
   // input rst;
    //output clk_slow;
    //output clk_medium;
    //output segclk;
   // output clk_db;
   // output clk_db_d;
    

    reg [18:0] counter_fast;
   // reg [24:0] counter_medium;
    //reg [26:0] counter_slow;
    
    reg [16:0]  clk_dv;
    wire [17:0] clk_dv_inc;
   //
    //reg clk_slow;
   // reg clk_medium;
    reg segclk;
    reg clk_db;
    reg clk_db_d;
    
    //assign clk_dv_inc = clk_dv + 1;
    
    always @(posedge clk)
    begin
      	if (clr) begin
            //clk_slow   <= 1'b0;
	        //clk_medium   <= 1'b0;
	    	segclk   <= 1'b0;
            
            clk_dv <= 0;
            clk_db <= 0;
            clk_db_d <= 0;
 	    
           // counter_slow   <= 27'b0;
            //counter_medium <= 25'b0;
	    	counter_fast <= 19'b0;
         end
       	 else begin
            clk_dv <= clk_dv_inc[16:0];
            clk_db <= clk_dv_inc[17];
            clk_db_d <= clk_db;
         
           if(counter_fast == 19'b1000001000110101010)
           //if(counter_fast == 19'b01)
            begin
                segclk<=1'b1;
                counter_fast<=19'b0;
            end
           	else begin
              	segclk<=1'b0;
            	counter_fast<=counter_fast+19'b1;
            end

          
            
      end
      
    end


endmodule

