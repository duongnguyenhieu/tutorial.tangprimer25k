module top_uart_tx (
    input  wire clk,        // clock 50MHz
    input  wire reset_btn,  // nút reset
    output wire tx          // UART TX output
);

    // Data cần gửi: ký tự '1' (ASCII 0x31)
    localparam DATA_BYTE = 8'h31;

    // Tín hiệu điều khiển
    reg start;
    wire busy;

    // Khởi động gửi sau khi nhấn reset_btn
    always @(posedge clk or posedge reset_btn) begin
        if (reset_btn) begin
            start <= 1'b1;  // reset -> gửi ngay
        end else if (busy) begin
            start <= 1'b0;  // đang bận thì không gửi thêm
        end
    end

    // Instance UART TX
    uart_tx #(
        .CLK_FREQ(50000000),
        .BAUDRATE(9600)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset_btn),   // dùng nút reset luôn
        .data(DATA_BYTE),
        .start(start),
        .tx(tx),
        .busy(busy)
    );

endmodule
