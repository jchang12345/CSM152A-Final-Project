	// Code your testbench here
// or browse Examples
`timescale 1ms / 1ps

module game_test;

   reg clk;
   reg rst;
   wire hs;
   wire vs;
   wire [2:0] red;
   wire [2:0]green;
   wire [1:0] blue;
   wire [6:0] seg;
   wire [3:0] an;
   reg pause;
   reg chooselvl;
   reg jump;
   reg duck;
   reg adj;
   reg [2:0] num;
   

   initial
     begin
     	$dumpfile("timingStopwatch.vcd");
        $dumpvars;
     
        //$shm_open  ("dump", , ,1);
        //$shm_probe (tb, "ASTF");

        clk = 0;
        rst = 1;
        pause = 0;
        chooselvl = 0;
        jump = 0;
        duck = 0;
        adj = 0;
        num = 3'b0;
        #100 rst = 0;
        #100 pause = 1;
        #50 pause = 0;
        #50 pause = 1;
        #50 pause = 0;
        #100 jump = 1;
        #50 jump = 0;
        #50 duck = 1;
        #50 duck = 0;
        
        #150000000;
        
        #1000;        
        $finish;
     end

top game(.CLK(clk),.RST_BTN(rst),.VGA_HS_O(hs),.VGA_VS_O(vs),.VGA_R(red),.VGA_G(green),.VGA_B(blue),.seg(seg),.an(an),.pause(pause),.chooselvl(chooselvl),.jump(jump),.duck(duck),.adj(adj),.num(num));


   always #5 clk = ~clk;

   //always @ (posedge clk)
   //  if (uut_.inst_vld)
   //    $display("%d ... instruction %08b executed", $stime, uut_.inst_wd);

   //always @ (led)
   //  $display("%d ... led output changed to %08b", $stime, led);
   
endmodule // tb
// Local Variables:
// verilog-library-flags:("-y ../src/")
// End:
