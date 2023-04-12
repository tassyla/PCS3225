module multiplier(
    input [7:0] BR, // registrador do multiplicando
    input [7:0] AR, // registrador do multiplicador
    output reg [15:0] PR, // registrador do produto
    input clk, // sinal de clock
    input rst // sinal de reset
);

reg [7:0] AR_reg; // registrador temporário do multiplicador

always @(posedge clk) begin
    if (rst) begin
        PR <= 0;
        AR_reg <= 0;
    end else begin
        // verifica se AR é diferente de zero
        if (AR_reg != 0) begin
            // adiciona BR a PR
            PR <= PR + {BR, 8'b0};

            // desloca PR para a esquerda
            PR <= {PR[13:0], 2'b0};

            // decrementa AR
            AR_reg <= AR_reg - 1;
        end
    end
end

endmodule
