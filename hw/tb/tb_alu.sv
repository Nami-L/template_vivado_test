  timeunit      1ns;
  timeprecision 1ps;

module tb;
parameter int DataWidth = 16;

// Señales
logic [DataWidth-1:0] x_i;
logic [DataWidth-1:0] y_i;
logic                 zx_i;
logic                 nx_i;
logic                 zy_i;
logic                 ny_i;
logic                 f_i;
logic                 no_i;
logic [DataWidth-1:0] out_o;
logic                 zr_o;
logic                 ng_o;
logic                 pos_o; 

// Instanciar el DUT
alu alu_dut(
    .x_i(x_i),
    .y_i(y_i),
    .zx_i(zx_i),
    .nx_i(nx_i),
    .zy_i(zy_i),
    .ny_i(ny_i),
    .f_i(f_i),
    .no_i(no_i),
    .out_o(out_o),
    .zr_o(zr_o),
    .ng_o(ng_o),
    .pos_o(pos_o)
);

initial begin
    // Inicializar valores
    x_i  = 0; y_i  = 0;
    zx_i = 0; nx_i = 0;
    zy_i = 0; ny_i = 0;
    f_i  = 0; no_i = 0;

    $display("Tabla de verdad");
    $display(" x  |  y  | zx | nx | zy | ny | f | no |   out    | zr | ng | pos");
    $monitor(" %8t: %4d | %4d | %b  | %b  | %b  | %b  | %b | %b  | %d | %b  | %b  | %b", 
             $realtime, x_i, y_i, zx_i, nx_i, zy_i, ny_i, f_i, no_i, out_o, zr_o, ng_o, pos_o);

    // Estimulos
    #10; // Dejar pasar 10ns con los valores iniciales
    
    x_i = 'd15; y_i = 'd5; zx_i = 0; nx_i = 1; zy_i = 0; ny_i = 0; f_i = 1; no_i = 1;

    #10;

    // Terminar simulación
    $finish;
end

endmodule