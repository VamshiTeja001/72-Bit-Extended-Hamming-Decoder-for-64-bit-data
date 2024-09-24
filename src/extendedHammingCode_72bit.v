`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2024 21:56:53
// Design Name: 
// Module Name: extendedHammingCode_72bit
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

module ExtendedHammingDecoder(
    input wire clk,
    input wire reset,
    input wire serial_in,       // Serial data input
    output reg [63:0] data_out, // Corrected 64-bit data output in parallel
    output reg error_detected,  // High if any error is detected
    output reg error_corrected, // High if an error is corrected
    output reg frequent_errors  // High if frequent error criteria are met
);

    parameter TOTAL_BITS = 72; // Total bits including data and parity bits
    reg [TOTAL_BITS-1:0] data_register; // Store the incoming codeword
    reg [6:0] bit_count; // Count bits to complete one codeword

    // Error history registers
    reg [6:0] correctable_errors_history;   // Tracks last 7 packets' correctable error status
    reg [6:0] non_correctable_errors_history; // Tracks last 7 packets' non-correctable error status

    // Parity check matrix
    reg [6:0] H[6:0]; // 7 parity bits, each checks specific positions defined below
    initial begin
        H[0] = 7'b1010101; // Example configurations, actual values needed
        H[1] = 7'b1100110;
        H[2] = 7'b1111000;
        H[3] = 7'b1111111; // Placeholder; actual matrix should reflect Hamming properties
        H[4] = 7'b1011011;
        H[5] = 7'b1101101;
        H[6] = 7'b1001100;
    end

    integer i; // Loop variable for bit counting

    // Function to count set bits
    function integer count_set_bits(input reg [6:0] bits);
        integer count, j;
        begin
            count = 0;
            for (j = 0; j < 7; j = j + 1) begin
                if (bits[j] == 1'b1)
                    count = count + 1;
            end
            count_set_bits = count;
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_register <= 0;
            bit_count <= 0;
            data_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
            frequent_errors <= 0;
            correctable_errors_history <= 0;
            non_correctable_errors_history <= 0;
        end else if (bit_count < TOTAL_BITS) begin
            data_register <= {data_register[TOTAL_BITS-2:0], serial_in}; // Shift in new bit
            bit_count <= bit_count + 1;
        end else begin
            // Perform error detection and correction
            perform_error_check(data_register);

            // Update error histories
            correctable_errors_history <= (correctable_errors_history << 1) | error_corrected;
            non_correctable_errors_history <= (non_correctable_errors_history << 1) | (error_detected & ~error_corrected);

            // Check for frequent errors
            frequent_errors <= (count_set_bits(correctable_errors_history) >= 4) ||
                               (count_set_bits(non_correctable_errors_history) >= 3);

            // Reset for next codeword
            bit_count <= 0;
        end
    end

    // Error checking and correction task using the parity check matrix
    task perform_error_check(input [TOTAL_BITS-1:0] codeword);
        integer i;
        reg [6:0] syndrome;
        begin
            syndrome = 0;
            // Calculate the syndrome using the parity check matrix
            for (i = 0; i < 7; i=i+1) begin
                syndrome[i] = ^ (codeword & H[i]);
            end

            // Detect and correct errors based on the syndrome
            if (syndrome != 0) begin
                error_detected <= 1;
                if (syndrome < TOTAL_BITS) begin
                    codeword[syndrome - 1] = ~codeword[syndrome - 1]; // Correct the bit
                    error_corrected <= 1;
                end else begin
                    error_corrected <= 0; // Syndrome out of range, multiple errors detected
                end
            end else begin
                error_detected <= 0;
                error_corrected <= 0;
            end

            data_out <= codeword[TOTAL_BITS-1:8]; // Assuming lower bits are parity
        end
    endtask

endmodule

