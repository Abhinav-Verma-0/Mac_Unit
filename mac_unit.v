module mac_int8 #(
    parameter DATA_WIDTH = 8,  
    parameter ACC_WIDTH  = 32   
)(
    input                          clk,    
    input                          rst_n,   
    input                          en,         
    input                          clear_acc,  
    input  signed [DATA_WIDTH-1:0] a,         
    input  signed [DATA_WIDTH-1:0] b,         
    output reg signed [ACC_WIDTH-1:0] acc,    
    output reg                      valid_out 
);
    wire signed [(DATA_WIDTH*2)-1:0] product;
 
    assign product = a * b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc       <= {ACC_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end
        else if (clear_acc) begin
            acc       <= {ACC_WIDTH{1'b0}};
            valid_out <= 1'b0;
        end
        else if (en) begin
            acc       <= acc + {{(ACC_WIDTH-(DATA_WIDTH*2)){product[(DATA_WIDTH*2)-1]}}, product};
            valid_out <= 1'b1;
        end
        else begin
            valid_out <= 1'b0;
        end
    end
 
endmodule
