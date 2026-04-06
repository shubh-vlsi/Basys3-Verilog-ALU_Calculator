`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2026 23:12:32
// Design Name: 
// Module Name: seven_seg_drive
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


module seven_seg_drive(
    input clk,
    input [7:0] bin_in,
    input blank,
    output reg [6:0] seg,
    output reg [3:0] an
    );

    // BCD Conversion for Radix Decimal
    wire [3:0] ones = bin_in % 10;
    wire [3:0] tens = (bin_in / 10) % 10;
    wire [3:0] hundreds = (bin_in / 100) % 10; // For results > 99

    reg [19:0] refresh_counter; 
    always @(posedge clk) refresh_counter <= refresh_counter + 1;
    wire [1:0] active_digit = refresh_counter[19:18];

    reg [3:0] hex_digit;
    always @(*) begin
        if (blank) begin
            an = 4'b1111;
            hex_digit = 4'hF;
        end else begin
            case(active_digit)
                2'b00: begin an = 4'b1110; hex_digit = ones; end
                2'b01: begin an = 4'b1101; hex_digit = tens; end
                2'b10: begin an = 4'b1011; hex_digit = hundreds; end
                2'b11: begin an = 4'b0111; hex_digit = 4'hF; end // Blank 4th digit
            endcase
        end
    end

    // Hex to 7-Segment Decoder
    always @(*) begin
        case(hex_digit)
            4'h0: seg = 7'b1000000; 4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100; 4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001; 4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010; 4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000; 4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111; // Off
        endcase
    end
endmodule
