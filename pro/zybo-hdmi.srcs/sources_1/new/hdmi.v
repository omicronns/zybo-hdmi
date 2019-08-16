`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2019 11:07:04 PM
// Design Name: 
// Module Name: hdmi.v
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


module hdmi
#(
    parameter H_PIX_BUF_MSB = 10,
    parameter H_PIX = 800,
    parameter H_FRONT = 40,
    parameter H_SYNC = 128,
    parameter H_BACK = 88,
    parameter H_MAX = H_PIX + H_FRONT + H_SYNC + H_BACK,
    parameter V_PIX_BUF_MSB = 10,
    parameter V_PIX = 600,
    parameter V_FRONT = 1,
    parameter V_SYNC = 4,
    parameter V_BACK = 23,
    parameter V_MAX = V_PIX + V_FRONT + V_SYNC + V_BACK
)
(
    input pixclk,
    input enable,
    input [2:0] ctrl,
    output rst,
    output [7:0] r,
    output [7:0] g,
    output [7:0] b,
    output vde,
    output hsync,
    output vsync
);

reg [H_PIX_BUF_MSB:0] hpix = 0;
reg [V_PIX_BUF_MSB:0] vpix = 0;

reg [7:0] r_mem = 0;
reg [7:0] g_mem = 0;
reg [7:0] b_mem = 0;

always @ (posedge(pixclk))
begin
    if (hpix == H_MAX - 1)
    begin
        hpix <= 0;
        if (vpix == V_MAX - 1)
        begin
            vpix <= 0;
            hpix <= 0;
        end
        else vpix <= vpix + 1;
    end
    else hpix <= hpix + 1;
end

always @ (posedge(vsync))
begin
    if (ctrl[0]) r_mem <= r_mem + 1;
    if (ctrl[1]) g_mem <= g_mem + 1;
    if (ctrl[2]) b_mem <= b_mem + 1;
end

wire hblank = hpix >= H_PIX && hpix <= H_MAX;
wire vblank = vpix >= V_PIX && vpix <= V_MAX;

assign hsync = ~(hpix >= H_PIX + H_FRONT && hpix <= H_MAX - H_BACK);
assign vsync = ~(vpix >= V_PIX + V_FRONT && vpix <= V_MAX - V_BACK);

assign rst = ~enable;

assign r = r_mem;
assign g = g_mem;
assign b = b_mem;
assign vde = ~(hblank || vblank);

endmodule
