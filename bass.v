module top (clk, led1, led2, led3, led4, led5, led6, led7, led8, lcol1, lcol2, lcol3, lcol4 );
    /* I/O */
    input clk; // 12MHz
    output led1;
    output led2;
    output led3;
    output led4;
    output led5;
    output led6;
    output led7;
    output led8;
    output lcol1;
    output lcol2;
    output lcol3;
    output lcol4;

    reg [8*27:0] message = "ZYXWVUTSRQPONMLKJIHGFEDCBA@";
    integer c = 26;
    integer offset = message[c*8+4:c*8]*4;

    reg [31:0] counter = 32'b0;
    reg [1:0] col_mask = counter[17:16]; // mux every 2^16 ticks
    reg [7:0] mem[27*4:0];
    initial begin
        $display("load bitmap");
        $readmemh("bitmap.mem", mem);
    end

    /* LED drivers - counter is inverted for display because leds are active low */
    assign {led8, led7, led6, led5, led4, led3, led2, led1} = mem[offset + col_mask] ^ 8'hff;
    assign {lcol4, lcol3, lcol2, lcol1} = 7'b1110111 >> col_mask;

    /* Count up on every edge of the incoming 12MHz clk */
    always @ (posedge clk) begin
        counter <= counter + 1;
    end

endmodule
