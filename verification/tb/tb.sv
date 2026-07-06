module tb;
  
  timeunit      1ns;
  timeprecision 100ps;
  parameter WIDTH = 16;
//  import config_pkg::*;
  
  // Clock signal
  logic clk_i = 0;
  int unsigned MainClkPeriod = 10;  // 100 MHz -> 10 ns period
  always #(MainClkPeriod / 2) clk_i = ~clk_i; 
    // Interface
  vif_if vif (clk_i);
//  vif_if vif();
  
    // Test
  test top_test (vif);
  
  // Instantiation
  
  full_adder #(
    .WIDTH(WIDTH)
    )
  
  dut (
      .clk_i(vif.clk_i),
      .rst_i(vif.rst_i),  
      .a_i(vif.a_i),
      .b_i(vif.b_i),
      .carry_i(vif.carry_i),
      .sum_o(vif.sum_o),
      .carry_o(vif.carry_o)
    );


endmodule
      