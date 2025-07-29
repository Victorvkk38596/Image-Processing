/*The entire convolution operation is performed in a 3 stage pipelined circuit. The multiply, add and normalisation
are performed in 3 separate clk cycles for the given input. Although latency goes up throughput sees gains.*/

module conv(
input        i_clk,
input [71:0] i_pixel_data, //input accepts 9 flattened pixels in one go (3x3 kernel)
input        i_pixel_data_valid,
output reg [7:0] o_convolved_data,
output reg   o_convolved_data_valid
    );
    
integer i; 
reg [7:0] kernel [8:0];  //3x3 kernel
reg [7:0] multData[8:0]; //You could get away with using only 8 bit word size for multiplication output since the blur kernel only has ones and zeroes
reg [11:0] sumDataInt; //Values have been calculated accounting for worst case bit growth
reg [11:0] sumData;
reg multDataValid;
reg sumDataValid;
reg convolved_data_valid;

/*Initial block initialises the values of the kernel. During synthesis this just dictates 
    which values to load the kernel bits with, which is exactly what we require.*/
initial
begin
    for(i=0;i<9;i=i+1)
    begin
        kernel[i] = 1;
    end
end    
    
always @(posedge i_clk)
begin
    for(i=0;i<9;i=i+1)
    begin
        multData[i] <= kernel[i]*i_pixel_data[i*8+:8];
    end
    multDataValid <= i_pixel_data_valid;
end


always @(*)
begin
    sumDataInt = 0;
    for(i=0;i<9;i=i+1)
    begin
        sumDataInt = sumDataInt + multData[i];
    end
end

always @(posedge i_clk)
begin
    sumData <= sumDataInt;
    sumDataValid <= multDataValid;
end
    
always @(posedge i_clk)
begin
    o_convolved_data <= sumData/9;
    o_convolved_data_valid <= sumDataValid;
end
    
endmodule
