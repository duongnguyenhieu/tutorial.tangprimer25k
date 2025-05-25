module blink (
    input clk,
    output wire led
);

    reg [26:0] counter = 0;

    always @(posedge clk)
        counter <= counter + 1;

    assign led = counter[26];  
endmodule
