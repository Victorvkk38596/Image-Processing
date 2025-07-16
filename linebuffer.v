//Single line buffer, will be instantiating 4 line buffers in top module

module lineBuffer(
input   i_clk,
input   i_rst,
input [7:0] i_data,
input   i_data_valid,
output [23:0] o_data,
input i_rd_data
);

reg [7:0] line [511:0];     //Stores a row of the 512x512 image.
reg [8:0] wrPntr;
reg [8:0] rdPntr;


//Writing data into the buffer
always @(posedge i_clk)
begin
    if(i_data_valid)
        line[wrPntr] <= i_data;
end


//Moving the pointer forward
always @(posedge i_clk)
begin
    if(i_rst)
        wrPntr <= 1'd0;
    else if(i_data_valid)
        wrPntr <= wrPntr + 1'd1;
end

//Outputs 3 contiguous image pixel in a line for the 3x3 kernel
assign o_data = {line[rdPntr],line[rdPntr+1],line[rdPntr+2]};


//Read pointer control, similar to write pointer. Only moved by a single pixel, assuming a stride size of 1.
always @(posedge i_clk)
begin
    if(i_rst)
        rdPntr <= 1'd0;
    else if(i_rd_data)
        rdPntr <= rdPntr + 1'd1;
end


endmodule
