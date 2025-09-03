`timescale 1ns/1ps

module tb_uart_tx;

  reg clk;
  reg reset;
  reg start;
  reg [7:0] data;
  wire tx;
  wire busy;

  // Clock 50 MHz (20ns period)
  always #10 clk = ~clk;

  // DUT
  uart_tx uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .data(data),
    .tx(tx),
    .busy(busy)
  );

  initial begin
    $dumpfile("uart_tx_tb.vcd");
    $dumpvars(0, tb_uart_tx);

    // init
    clk   = 0;
    reset = 1;
    start = 0;
    data  = 8'h00;

    // giữ reset một lúc
    #100 reset = 0;

    // gửi byte 0xA5 (1010_0101)
    #100 data = 8'hA5;
         start = 1;
    #20  start = 0;   // chỉ giữ start 1 chu kỳ

    // chạy thêm thời gian đủ để gửi hết
    #120000;

    $finish;
  end

endmodule
