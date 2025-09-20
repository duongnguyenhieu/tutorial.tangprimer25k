module top_uart_tx (
    input  wire clk,   // 50 MHz clock từ oscillator ngoài (chân E2)
    input  wire reset_btn, // Nút nhấn reset, active-high
    input  wire send_btn,  // Nút nhấn gửi dữ liệu
    output wire tx         // UART TX ra USB-UART
);

    // -----------------------------
    // Reset đồng bộ
    reg [1:0] rst_sync;
    always @(posedge clk) begin
        rst_sync <= {rst_sync[0], reset_btn};
    end
    wire reset = rst_sync[1]; // reset đồng bộ, active-high

    // -----------------------------
    // Đồng bộ + edge detect cho nút send
    reg btn_sync0, btn_sync1;
    always @(posedge clk) begin
        btn_sync0 <= send_btn;
        btn_sync1 <= btn_sync0;
    end

    wire send_pulse = btn_sync0 & ~btn_sync1; // xung 1 clock khi bấm

    // -----------------------------
    // UART TX instance
    wire busy;
    uart_tx #(
        .CLK_FREQ(50000000),   // Clock 50 MHz
        .BAUDRATE(9600)        // Baudrate (9600)
    ) uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .data(8'h31),      // ASCII '1'
        .start(send_pulse),// start truyền khi bấm nút
        .tx(tx),
        .busy(busy)
    );

endmodule
