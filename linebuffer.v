//Single line buffer, will be instantiating 4 line buffers in top module

module lineBuffer(
input   i_clk,
input   i_rst,
input [7:0] i_data, //Byte (single pixel, grayscale from 0 - 255) will be entering the line buffer
input   i_data_valid, //Indicates that the incoming data is valid
output [23:0] o_data, //Kernel size is 3x3, so 3 pixels are required in one go, 8*3 = 24 bits
input i_rd_data //Signal indicating that data needs to be read from the line buffer
);

    //Wires cannot be stored as 2D arrays, only registers.

reg [7:0] line [511:0];     //Memory that stores a row of the 512x512 image. 
reg [8:0] wrPntr;
reg [8:0] rdPntr;


//Writing data into the buffer
always @(posedge i_clk)
begin
    if(i_data_valid)
        line[wrPntr] <= i_data;
end


//Moving the write pointer forward
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
