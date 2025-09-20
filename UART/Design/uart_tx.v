module uart_tx #(
    parameter CLK_FREQ = 50000000,   // clock tần số hệ thống (Hz)
    parameter BAUDRATE = 9600      // baud rate
)(
    input wire clk,          // System clock
    input wire reset,        // Reset signal
    input wire [7:0] data,   // Data to transmit
    input wire start,        // Start transmission signal
    output reg tx,          // Transmit line
    output reg busy         // Transmission status
);


localparam BIT_PERIOD = CLK_FREQ / BAUDRATE;

reg [3:0] bit_index; // Current bit index
reg [15:0] counter;  // Bit counter

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx <= 1; // Idle state
        busy <= 0;
        counter <= 0;
        bit_index <= 0;
    end else if (start && !busy) begin
        busy <= 1;
        tx <= 0; // Start bit
        counter <= 0;
        bit_index <= 0;
    end else if (busy) begin
        if (counter < BIT_PERIOD - 1) begin
            counter <= counter + 16'd1;
        end else begin
            counter <= 0;
            if (bit_index < 8) begin
                tx <= data[bit_index]; // Send data bits
                bit_index <= bit_index + 1'd1;
            end else if (bit_index == 8) begin
                tx <= 1; // Stop bit
                bit_index <= bit_index + 1'd1;
            end else begin
                busy <= 0; // Transmission complete
            end
        end
    end
end

endmodule
