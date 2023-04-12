module karatsuba (input CLK, input START, input [7:0] LOADA, input [7:0] LOADB, 
output [15:0] RES, output DONE);

    reg [7:0] A, B, F, G;
    reg [4:0] E, D;
    reg [9:0] P;
    reg [3:0] Xh, Xl, Yh, Yl;
    reg [15:0] H, LOADP;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [1:0] aux, done;

    wire [4:0] n1, n2;
    wire [9:0] p;

    rom0 rom(n1, n2, p);

    parameter IDLE = 4'b0000, SHIFT = 4'b0001, MUL1 = 4'b0010,
              INT1 = 4'b0011, MUL2 = 4'b0100, INT2 = 4'b0101,
              MUL3 = 4'b0110, INT3 = 4'b0111, FINISH = 4'b1000;

        always@ (posedge CLK or posedge DONE)
        begin
            if (DONE == 1)
                state <= IDLE;
            else
                state <= next_state;    
        end

        always@ (START or DONE or aux or state)
        begin
            case (state)
                IDLE:
                    begin
                        if (START == 1)
                            next_state <= SHIFT;
                        else 
                            next_state <= IDLE;
                    end
                SHIFT:
                    begin
                        if (aux == 1)
                            next_state <= MUL1;
                        else
                            next_state <= SHIFT;
                    end
                MUL1:
                    begin
                        if (aux == 0)
                            next_state <= INT1;
                        else
                        next_state <= MUL1;
                    end
                INT1:
                    begin
                        if (aux == 1)
                            next_state <= MUL2;
                        else
                            next_state <= INT1;
                    end
                MUL2:
                    begin
                        if (aux == 0)
                            next_state <= INT2;
                        else
                            next_state <= MUL2;
                    end
                INT2:
                    begin
                        if (aux == 1)
                            next_state <= MUL3;
                        else
                            next_state <= INT2;
                    end
                MUL3:
                    begin 
                        if (aux == 0)
                            next_state <= INT3;
                        else
                            next_state <= MUL3;
                    end
                INT3:
                    begin
                        if (aux == 1)
                            next_state <= FINISH;
                        else
                            next_state <= INT3;
                    end 
                FINISH:
                    begin
                        if (DONE == 1)
                            next_state <= IDLE;
                        else
                            next_state <= FINISH;
                    end
            endcase
        end

        always@ (posedge CLK)
        begin
            case (state)
                IDLE: 
                    if (START == 1)
                        begin
                            A <= LOADA;
                            B <= LOADB;
                            F <= 0;
                            G <= 0;
                            P <= 0;
                            LOADP <= 0;
                            aux <= 0;
                        end
                SHIFT:
                    begin
                        Xl <= A<<4;
                        Xh <= A>>4;
                        Yl <= A<<4;
                        Yh <= A>>4;
                        aux <= 1;
                    end
                MUL1:
                    begin
                        E <= Xl + Yl;
                        D <= Xh + Yh;
                        n1 <= m41 m0 (Xl, Xh, D, 0, 0, 0, n1); // dúvida
                        n2 <= m41 m1 (Yl, Yh, D, 0, 0, 0, n2); // dúvida
                        aux <= 0;
                    end
                INT1:
                    begin
                        F <= p; 
                        aux <= 1;
                    end
                MUL2:
                    begin
                        n1 <= m41 m0 (Xl, Xh, D, 0, 0, 1, n1);
                        n2 <= m41 m1 (Yl, Yh, D, 0, 0, 1, n2);
                        aux <= 0;
                    end
                INT2:
                    begin
                        G <= p; 
                        aux <= 1;
                    end
                MUL3:
                    begin
                        n1 <= m41 m0 (Xl, Xh, D, 0, 1, 0, n1);
                        n2 <= m41 m1 (Yl, Yh, D, 0, 1, 0, n2);
                        H = G<<8;
                        aux <= 0;
                    end
                INT2:
                    begin
                        P <= p; 
                        aux <= 1;
                    end
                FINISH:
                    begin
                        LOADP <= F + H + (P-(F+G));
                        done <= 1;
                    end
            endcase
        end
    
    assign RES = LOADP;
    assign DONE = done;

endmodule