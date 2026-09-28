module clock_divider #(
    parameter TERMINAL_COUNT = 26'd49_999_999 // Generates 1 Hz output from a 100 MHz clock
)(
    input wire clk_in,
    input wire rst,
    output reg clk_out
);

    reg [25:0] count;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            count <= 26'd0;
            clk_out <= 1'b0;
        end else begin
            if (count >= TERMINAL_COUNT) begin
                count <= 26'd0;
                clk_out <= ~clk_out;
            end else begin
                count <= count + 26'd1;
            end
        end
    end

endmodule