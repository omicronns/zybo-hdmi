`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2019 08:47:10 PM
// Design Name: 
// Module Name: top
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


module top(
    output hdmi_tx_clk_n,
    output hdmi_tx_clk_p,
    output [2:0] hdmi_tx_n,
    output [2:0] hdmi_tx_p,
    input [2:0] btn,
    input sysclk
);

wire pixclk;
wire serclk;
wire clklocked;

clk_wiz_0 pll(
    .reset(0),
    .clk_in1(sysclk),
    .clk_out1(pixclk),
    .clk_out2(serclk),
    .locked(clklocked)
);

wire rst;
wire [23:0] rgb;
wire vde;
wire hsync;
wire vsync;

hdmi source(
    .pixclk(pixclk),
    .enable(clklocked),
    .ctrl(btn),
    .rst(rst),
    .r(rgb[23:16]),
    .g(rgb[7:0]),
    .b(rgb[15:8]),
    .vde(vde),
    .hsync(hsync),
    .vsync(vsync)
);

rgb2dvi_0 rgb2dvi(
    .TMDS_Clk_p(hdmi_tx_clk_p),
    .TMDS_Clk_n(hdmi_tx_clk_n),
    .TMDS_Data_p(hdmi_tx_p),
    .TMDS_Data_n(hdmi_tx_n),
    .aRst(rst),
    .vid_pData(rgb),
    .vid_pVDE(vde),
    .vid_pHSync(hsync),
    .vid_pVSync(vsync),
    .PixelClk(pixclk),
    .SerialClk(serclk)
);

endmodule
