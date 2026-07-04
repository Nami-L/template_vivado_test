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
//=============================================================================


module xor_gate (
input logic a,
input logic b,
output logic c
);
  
  assign c = (a ^ b);
 
endmodule
