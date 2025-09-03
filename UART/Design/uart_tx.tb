`timescale 1ns/1ps

module uart_tx (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire [7:0] data,
    output reg        tx,
    output reg        busy
);
    parameter integer BAUD_RATE  = 9600;
    parameter integer CLOCK_FREQ = 96000;   // clock nhỏ để mô phỏng nhanh
    localparam integer BIT_PERIOD = CLOCK_FREQ / BAUD_RATE; // ~10 clk/bit

    reg [3:0]  bit_index;
    reg [15:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1'b1;
            busy <= 1'b0;
            counter <= 0;
            bit_index <= 0;
        end else if (start && !busy) begin
            busy <= 1'b1;
            tx <= 1'b0; // start bit
            counter <= 0;
            bit_index <= 0;
        end else if (busy) begin
            if (counter < BIT_PERIOD - 1) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                if (bit_index < 8) begin
                    tx <= data[bit_index];
                    bit_index <= bit_index + 1;
                end else if (bit_index == 8) begin
                    tx <= 1'b1; // stop bit
                    bit_index <= bit_index + 1;
                end else begin
                    busy <= 0; // done
                end
            end
        end
    end
endmodule
