//=============================================================================
// [Filename]       Makefile.xilinx
// [Project]        -
// [Language]       GNU Makefile
// [Created]        Jan 2025
// [Modified]       -
// [Description]    - 
// [Notes]          -
// [Status]         stable
// [Revisions]      -
//=============================================================================

module and_gate (
input logic a,
input logic b,
output logic c
);

  assign c = (a & b);
endmodule
