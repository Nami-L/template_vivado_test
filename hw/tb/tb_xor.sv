//=============================================================================
// [Filename]       tb_xor.sv
// [Project]        -
// [Author]         Luis Namigtle
// [Language]       SystemVerilog
// [Created]        Jan 2026
// [Modified]       -
// [Description]    - 
// [Notes]          -
// [Status]         stable
// [Revisions]      -
//=============================================================================

// Code your testbench here
// or browse Examples
  timeunit      1ns;
  timeprecision 1ps;

module tb ;
  
  logic tb_a;
  logic tb_b;
  logic tb_c;
  
  // Instanciar
  
  xor_gate dut (
    .a(tb_a),
    .b(tb_b),
    .c(tb_c)
   
  );
    
  initial begin
    $display("Compuerta XOR");
$display("a b | c");
    $monitor("%b %b | %b", tb_a, tb_b, tb_c);

    #0 tb_a = 0;  	tb_b = 0;
    #10 tb_a = 1; 	tb_b = 0;
    #10 tb_a = 0; 	tb_b = 1;
    #10 tb_a = 1;	tb_b = 1;
    #20 tb_a = 0;	tb_b = 0;

    
    $finish;
  end
  
endmodule

