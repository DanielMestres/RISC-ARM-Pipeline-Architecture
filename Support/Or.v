module Or (
    output reg Output,
    input inputA,
    input inputB
    );
    always@(inputA, inputB) begin
        Output = inputA || inputB;
    end
endmodule