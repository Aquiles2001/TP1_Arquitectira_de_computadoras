`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Student: Aquiles Benjamin Lencina
// Create Date: 10/25/2023 06:03:36 PM
// Module Name: ALU_Top
// Project Name: TP1 Arquitectura
//////////////////////////////////////////////////////////////////////////////////

module ALU_Top
    #(
        parameter SIZE_BTN  = 3, // Cantidad de botones a usar
        parameter SIZE_COD  = 6, // Tamaño del codigo de operaciones
        parameter SIZE_OP   = 4  // Tamaño de los operandos
     )
     (
        // Entradas
        input[SIZE_BTN - 1: 0]  i_btn,   // Botones de accion
        input[SIZE_COD - 1: 0]  i_sw,    // switches
        input                   i_reset, // Boton de reset
        input                   clock,   // Entrada de clock
        
        // Salidas
        output[SIZE_OP - 1: 0]  o_led    // Leds
     );
     
        // Registros para almacenar los datos
        reg [SIZE_OP - 1 : 0]  op_a;
        reg [SIZE_OP - 1 : 0]  op_b;
        reg [SIZE_COD - 1 : 0] op_code;

     always @(posedge clock) // Asignacion de registros
     begin
        if(i_reset)begin // Reseteamos los registros con el boton up
            op_a       <=   4'b0;
            op_b       <=   4'b0;
            op_code    <=   6'b0;
        end  
        
        case(i_btn)       // Asignacion segun el boton
            3'b001  : op_a <= i_sw[SIZE_OP-1 : 0];      // Boton L (izquierda)
            3'b010  : op_b <= i_sw[SIZE_OP-1 : 0];      // Boton C (center)
            3'b100  : op_code <= i_sw[SIZE_COD-1 : 0];  // Boton R (Derecha)
        endcase
     end 
     
     // Instanciamos ALULogic
     ALU_Logic ALU (.i_a(op_a),.i_b(op_b),.i_code(op_code),.result(o_led));
     
endmodule

