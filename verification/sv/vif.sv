`ifndef VIF_IF_SV
`define VIF_IF_SV

interface vif_if(
    input logic clk_i
); 

  timeunit      1ns;
  timeprecision 100ps;
  parameter WIDTH = 16;



// For adder

logic rst_i;
logic [WIDTH-1:0] a_i;
logic [WIDTH-1:0] b_i;
logic carry_i;
logic [WIDTH-1:0] sum_o;
logic carry_o;




  clocking cb @(posedge clk_i);
    default input #1ns output #1ns;
  // For PC
    output rst_i;
    output a_i;
    output b_i;
    output carry_i;
    input sum_o;
    input carry_o;


  endclocking


endinterface : vif_if

`endif // VIF_IF_SV