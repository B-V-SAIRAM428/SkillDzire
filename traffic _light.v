`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2024 10:08:58
// Design Name: 
// Module Name: traffic _light
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module traffic_light(
    input clk,
    input rst,
output reg[2:0]east,south,west,north
    );
reg [2:0] count;
reg [2:0] state;
parameter east_green=3'b000;
parameter east_yellow=3'b001;
parameter south_green=3'b010;
parameter south_yellow=3'b011;
parameter west_green=3'b100;
parameter west_yellow=3'b101;
parameter north_green=3'b110;
parameter north_yellow=3'b111;
always@(posedge(clk)) begin
if(rst==1) begin
    east=3'd1;
    south=3'd3;
    west=3'd3;
    north=3'd3;
    count<=0;
    state<=east_green;
end
else case(state) 
east_green:  begin  
east=3'd1;
south=3'd3;
west=3'd3;
north=3'd3;                    // east_green
if (count==3'd7) begin
    count<=0;
    state<=east_yellow; //   east_yellow
end else begin
    count<=count+1;
    state<=east_green;  // east_green
end
end
east_yellow: begin
east=3'd2;
south=3'd2;
west=3'd3;
north=3'd3;
if(count==3'd4) begin
    count<=0;
    state<=south_green; // south_green
end else begin
    count<=count+1;
    state<=east_yellow;
end
end
south_green: begin
east=3'd3;
south=3'd1;
west=3'd3;
north=3'd3;
if (count==3'd7) begin
    count<=0;
    state<=south_yellow; //south_yellow
end else begin
    count<=count+1;
    state<=south_green;
end
end
south_yellow: begin
east=3'd3;
south=3'd2;
west=3'd2;
north=3'd3;
if(count==3'd4) begin
    count<=0;
    state<=west_green; // west_green
end else begin
    count<=count+1;
    state<=south_yellow;
end
end  
west_green: begin
east=3'd3;
south=3'd3;
west=3'd1;
north=3'd3;
if(count==3'd7) begin
    count<=0;
    state<=west_yellow;  // west_yellow
end else begin
    count<=count+1;
    state<=west_green;
end
end
west_yellow: begin
east=3'd3;
south=3'd3;
west=3'd2;
north=3'd2;
if (count==3'd4) begin
    count<=0;
    state<=north_green;  //north_green
end else begin
    count<=count+1;
    state<=west_yellow;
end
end
north_green: begin
east=3'd3;
south=3'd3;
west=3'd3;
north=3'd1;
if (count==3'd7) begin
    count<=0;
    state<=north_yellow; // north_yellow
end else begin
    count<=count+1;
    state<=north_green;
end
end
north_yellow: begin
east=3'd2;
south=3'd3;
west=3'd3;
north=3'd2;
if(count==3'd4) begin
    count<=0;
    state<=east_green;
end else begin
    count<=count+1;
    state<=north_yellow;
end
end
endcase
end
endmodule