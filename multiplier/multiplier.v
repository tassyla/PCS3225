module multiplier (input CLK, input RESET, input G, input [7:0] LOADA, input [7:0] LOADB, 
output [7:0] LOADP, output Z);

    reg [1:0] state;
    reg [1:0] next_state;

    parameter IDLE = 1'b0, MUL = 1'b1;

    reg[7:0] A, B, P, P_aux;
    reg[1:0] z;

        always@ (posedge CLK or posedge RESET)
        begin
            if (RESET == 1)
                state <= IDLE;
            else
                state <= next_state;    
        end

        always@ (G or z or state)
        begin
            case (state)
                IDLE:
                    begin
                        if (G == 1)
                            next_state <= MUL;
                        else 
                            next_state <= IDLE;
                        z <= 0;
                    end
                MUL:
                    if (z == 1)
                        next_state <= IDLE;
                    else
                        next_state <= MUL;
            endcase
        end

        always@ (posedge CLK)
        begin
            case (state)
                IDLE: 
                    if (G == 1)
                        begin
                            A <= LOADA;
                            B <= LOADB;
                            P <= 0;
                        end
                MUL:
                    begin
                        if (A > 0)
                            begin
                                P <= P + B;
                                A <= A - 1;
                            end
                        else
                            begin
                                z <= 1;
                                P_aux <= P;
                            end
                    end
            endcase
        end
    
    assign LOADP = P_aux;
    assign Z = z;

endmodule