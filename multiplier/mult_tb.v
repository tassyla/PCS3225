module multiplier_tb();

reg [7:0] BR; // registrador do multiplicando
reg [7:0] AR; // registrador do multiplicador
wire [15:0] PR; // registrador do produto

reg clk; // sinal de clock
reg rst; // sinal de reset

multiplier dut(
    .BR(BR),
    .AR(AR),
    .PR(PR),
    .clk(clk),
    .rst(rst)
);

initial begin
    // inicializa os sinais de entrada
    BR = 8'b10101010;
    AR = 8'b11001100;
    clk = 0;
    rst = 1;
    #10 rst = 0; // desativa o reset

    // exibe o valor esperado da multiplicação
    $display("Valor esperado: %d", 170 * 204);
end

always #5 clk = ~clk; // sinal de clock com período de 10 unidades de tempo

initial begin
    // simula a multiplicação por 2000 ciclos de clock
    #100000000;

    // exibe o valor final do registrador PR
    $display("Resultado: %d", PR);

    $finish;
end

endmodule
