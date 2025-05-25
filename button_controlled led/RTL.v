module button_controlled (
    input wire clk,        // clock input
    input wire btn,        // nút nhấn
    output reg led         // LED output
);

    reg btn_prev;

    always @(posedge clk) begin
        // phát hiện cạnh lên
        if (btn && !btn_prev)
            led <= ~led;

        // lưu trạng thái nút ở chu kỳ trước
        btn_prev <= btn;
    end

endmodule
