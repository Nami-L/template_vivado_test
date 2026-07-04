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

// ===================================================
// Half Adder (Gate Level)
module medio_sumador(
    input a,
    input b,
    output sum,
    output carry
);
    // XOR for sum
    xor_gate u_xor (
        .a(a),
        .b(b),
        .c(sum)
    );

    // AND for carry
    and_gate u_and (
        .a(a),
        .b(b),
        .c(carry)
    );
endmodule