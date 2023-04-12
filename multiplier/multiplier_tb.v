`timescale 1ns/10ps

module testbench();

	parameter CLOCK_PERIOD = 40,
			  BIT_PERIOD   = 8600,
              MULTIPLICADOR = 8'd25,
              MULTIPLICANDO = 8'd5;
	
	reg CLK = 0,
	    G = 0,
        RESET = 0;
	    
    reg [7:0] LOADA = 0,
	          LOADB = 0;
	    
    wire [7:0] LOADP;
    wire Z;
	
	
	multiplier multiplier_inst(.CLK(CLK), .RESET(RESET), .G(G), .LOADA(LOADA), .LOADB(LOADB), 
	.LOADP(LOADP), .Z(Z));
	
	always #(CLOCK_PERIOD/2) CLK <= !CLK;
	
	initial
	begin
		LOADA <= MULTIPLICADOR;
        LOADB <= MULTIPLICANDO;

        #(BIT_PERIOD);
		
		G <= 1;
		
		#(BIT_PERIOD);
		
		if(Z == 1)
            begin
			    $display("Valor de P = %d", LOADP);
                #(BIT_PERIOD);
                RESET <= 1;
            end
        
		$display("Valor de P = %d", LOADP);
        $display("Mon amour");
	$finish();
	end

endmodule
