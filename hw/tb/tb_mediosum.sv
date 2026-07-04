//=============================================================================
// [Filename]       and_gate.sv
// [Project]        -
// [Author]         Luis Namigtle
// [Language]       SystemVerilog
// [Created]        Jan 2026
// [Modified]       -
// [Description]    - 
// [Notes]          -
// [Status]         stable
// [Revisions]      -
//===========================================================================

// Code your testbench here
// or browse Examples

  timeunit      1ns;
  timeprecision 1ps;

module tb ;
  
  logic tb_a;
  logic tb_b;
  logic tb_sum;
  logic tb_carry;
  
  // Instanciar
  
   medio_sumador dut (
    .a(tb_a),
    .b(tb_b),
     .sum(tb_sum),
     .carry(tb_carry)
   
  );
  

  initial begin
    //Inicializar valores
    tb_a = 0;
    tb_b = 0;
    
    $display("Tabla de verdad");
    $display("a b | sum carry");
    $monitor("%b %b | %b %b ", tb_a, tb_b, tb_sum, tb_carry);

    #0 tb_a = 0;  	tb_b = 0; // Test case 1 : If A = 0 y B = 0, C should be = 0
    #10 tb_a = 1; 	tb_b = 0;
    #10 tb_a = 0; 	tb_b = 1;
    #10 tb_a = 1;	tb_b = 1;
    #20 tb_a = 0;	tb_b = 0;

    //Finish simulatio
    $finish;
  end

  
endmodule

