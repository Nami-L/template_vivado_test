module full_adder #(
      parameter WIDTH = 16
)
(
    input logic clk_i,
    input logic rst_i,
    input logic  [WIDTH-1:0]a_i,
    input logic  [WIDTH-1:0]b_i,
    input logic  carry_i,
    output logic  [WIDTH-1:0]sum_o,
    output logic carry_o
);


always_ff @(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        sum_o <= 1'b0;
        carry_o <= 1'b0;
   end   else begin
       // sum_o <= (a_i ^ b_i) ^ carry_i;
       // carry_o <= (a_i & b_i) | ((a_i | b_i) & carry_i);
        {carry_o, sum_o} <= a_i + b_i + carry_i;

    end
end

endmodule : full_adder

//Aritmética
//                (Combinacional)       Flip-Flop (Secuencial)
//                                         ┌──────────┐
//   a_i ────────► ┌───────────┐           │        Q │───────► sum_o
//   b_i ────────► │     +     │──────────►│ D        │
//   carry_i ────► └───────────┘           │          │
//                          clk_i─────────►│          │
//                                         └────┬─────┘
//                                              │ (Reset)
//                                              ▼
//                                            rst_i