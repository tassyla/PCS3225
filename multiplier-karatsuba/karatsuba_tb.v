module karatsuba_tb();

// module Karatsuba (input CLK, input START, input [7:0] LOADA, input [7:0] LOADB, 
// output [15:0] RES, output DONE);

reg [7:0] A; // registrador do multiplicando
reg [7:0] B; // registrador do multiplicador
wire [15:0] RES; // registrador do produto
wire DONE;

reg clk; // sinal de clock
reg start; // sinal de start

karatsuba kat(
    .CLK(clk),
    .START(start),
    .LOADA(A),
    .LOADB(B),
    .RES(RES),
    .DONE(DONE)
);

initial begin
    // inicializa os sinais de entrada
    A = 8'b00000101;
    B = 8'b00011001;
    clk = 0;
end

always #5 clk = ~clk; // sinal de clock com período de 10 unidades de tempo

initial begin
    // simula a multiplicação por 20 ciclos de clock

    
    #100;

    // falta terminar
    
end

endmodule
