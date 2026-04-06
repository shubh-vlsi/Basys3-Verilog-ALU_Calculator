`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 23:11:08
// Design Name: 
// Module Name: calculator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module calculator(
    input clk,                      // 100MHz system clock
    input [9:0] sw,                 // sw[7:4]=A, sw[3:0]=B, sw[9:8]=Op
    input btnC, btnL, btnR,         // Center, Left, Right buttons
    output reg [15:0] led,          // LEDs LD15 to LD0
    output [6:0] seg,               // Seven-segment segments
    output [3:0] an                 // Seven-segment anodes
    );

    wire [3:0] A = sw[7:4];
    wire [3:0] B = sw[3:0];
    wire [1:0] op = sw[9:8];
    reg [7:0] result;

    // --- Arithmetic Logic ---
    always @(*) begin
        case(op)
            2'b00: result = A + B;             // Addition
            2'b01: result = A - B;             // Subtraction
            2'b10: result = A * B;             // Multiplication
            2'b11: result = (B != 0) ? A / B : 0; // Division
            default: result = 8'b0;
        endcase
    end

    // --- LED Logic (Requirement A) ---
    always @(*) begin
        led[7:4] = A;
        led[3:0] = B;
        if (btnC)
            led[15:8] = result;
        else
            led[15:8] = 8'b0;
    end

    // --- Display Logic (Requirement B) ---
    reg [7:0] display_value;
    always @(*) begin
        if (btnL)
            display_value = {A, B}; // Operands side-by-side
        else if (btnR)
            display_value = result; // Result in decimal
        else
            display_value = 8'hFF;  // Turn off/Blank
    end

    seven_seg_drive display_unit (
        .clk(clk),
        .bin_in(display_value),
        .blank(~(btnL | btnR)),
        .seg(seg),
        .an(an)
    );

endmodule