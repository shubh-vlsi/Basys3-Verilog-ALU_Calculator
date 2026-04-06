`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 23:14:31
// Design Name: 
// Module Name: tb_calculator
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


module tb_calculator();

    // 1. Inputs (Reg) and Outputs (Wire)
    reg clk;
    reg [9:0] sw;
    reg btnC, btnL, btnR;
    wire [15:0] led;
    wire [6:0] seg;
    wire [3:0] an;

    // 2. Instantiate the Unit Under Test (UUT)
    calculator uut (
        .clk(clk),
        .sw(sw),
        .btnC(btnC),
        .btnL(btnL),
        .btnR(btnR),
        .led(led),
        .seg(seg),
        .an(an)
    );

    // 3. Clock Generation (100MHz = 10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle every 5ns
    end

    // 4. Stimulus (Testing the Logic)
    initial begin
        // Initialize Inputs
        sw = 0; btnC = 0; btnL = 0; btnR = 0;
        #100;

        // --- TEST 1: Addition (A=5, B=3) ---
        sw = 10'b00_0101_0011; // Op=00, A=5, B=3
        #20 btnC = 1;          // Press Center Button to show LEDs
        #40 btnC = 0;

        // --- TEST 2: Multiplication (A=4, B=2) ---
        sw = 10'b10_0100_0010; // Op=10, A=4, B=2
        #20 btnR = 1;          // Press Right Button to show Result on 7-seg
        #100 btnR = 0;

        // --- TEST 3: Check Side-by-Side (A=7, B=9) ---
        sw = 10'b00_0111_1001; // A=7, B=9
        #20 btnL = 1;          // Press Left Button
        #100 btnL = 0;

        $stop; // Pause simulation
    end

endmodule
