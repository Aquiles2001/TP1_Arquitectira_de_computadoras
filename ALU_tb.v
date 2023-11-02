`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Student: Aquiles Benjamin Lencina
// Create Date: 10/26/2023 03:51:55 PM
// Module Name: ALU_tb.v
// Project Name: TP1 Arquitectura
//////////////////////////////////////////////////////////////////////////////////


module ALU_tb
   #(
        parameter SIZE_BTN  = 3, 
        parameter SIZE_COD  = 6,
        parameter SIZE_OP   = 4 
    );
    
    // Parametros a usar 
    localparam ADD       =   6'b100000;
    localparam SUB       =   6'b100010;
    localparam AND       =   6'b100100;  
    localparam OR        =   6'b100101;
    localparam XOR       =   6'b100110;
    localparam SRA       =   6'b000011;
    localparam SRL       =   6'b000010;
    localparam NOR       =   6'b100111;
    
    // registros
    reg                             clock;
    reg                             reset;
    reg  [SIZE_COD -  1 : 0]        i_sw;
    reg  [SIZE_BTN - 1 : 0]         i_btn;
    reg  signed [SIZE_OP -  1 : 0]  dato_a;
    reg  signed [SIZE_OP -  1 : 0]  dato_b;
    reg  signed [SIZE_OP -  1 : 0]  result;
    reg  signed [SIZE_COD - 1 : 0]  op_code;
    
    
    wire signed [SIZE_OP - 1: 0]    o_led;
    
    integer rand, i;
    
    // Generador de reloj
    always begin
        #5 clock = ~clock; // Cambia el reloj cada 5 unidades de tiempo
    end
    
    // Instanciamos el modulo de ALU_Top
    ALU_Top alu_tb (.i_btn(i_btn), .i_sw(i_sw), .i_reset(reset), .clock(clock), .o_led(o_led));
    
    // Simulacion
    initial begin
        for (i = 0; i<1000; i = i + 1) begin
            
            //Se reinicia todo en 0
            #50
            clock   = 0        ; 
            reset   = 0        ;   
            i_sw    = 6'b000000;
            i_btn   = 3'b0000  ; 
            
            // Se carga el dato a
            rand = $random                              ;
            #50 i_sw  = rand[5:0]                ; 
            dato_a = rand;
            #50 i_btn  = 3'b001                     ; // Pulsador[0] = RegA
            #50 i_btn  = 3'b000                     ; // Pulsador[0] = RegA
         
            
            // Se carga el dato B
            rand = $random                              ;
            #50 i_sw   = rand[5:0]               ; // Switches = 3
            dato_b = rand;
            #50 i_btn  = 3'b010                     ; // Pulsador[1] = RegB
            #50 i_btn  = 3'b000                     ; // Pulsador[0] = RegA
            
            // Se carga el opcode
            rand = $random                              ;
            op_code = rand;
            #50 i_sw   = rand[5:0]                ; // Switches = NOR
            #50 i_btn  = 3'b100                     ; // Pulsador[2] = Opcode
            #50 i_btn  = 3'b000                     ;

            case (op_code)
                ADD: result = dato_a + dato_b;     // ADD 
                SUB: result = dato_a - dato_b;     // SUB 
                AND: result = dato_a & dato_b;     // AND 
                OR : result = dato_a | dato_b;     // OR 
                XOR: result = dato_a ^ dato_b;     // XOR 
                SRA: result = dato_a >>> dato_b;   // SRA 
                SRL: result = dato_a >> dato_b;      // SRL
                NOR: result = ~(dato_a | dato_b);  // NOR 
                default:    result = 4'b0000;
            endcase

            if(result != o_led) begin
                $display("Fallo de simulacion");
                $finish;
            end else begin
                $display("Test pasado correctamente");
            end

        end
    end
    
endmodule
