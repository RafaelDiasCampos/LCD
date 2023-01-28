module VGAMod
(
    input                   CLK,
    input                   nRST,

    input                   PixelClk,

    output                  LCD_DE,
    output                  LCD_HSYNC,
    output                  LCD_VSYNC,

    output          [4:0]   LCD_B,
    output          [5:0]   LCD_G,
    output          [4:0]   LCD_R
);

localparam      H_Area = 16'd1024;
localparam      V_Area = 16'd600;

localparam      H_Pulse      = 16'd1;
localparam      H_FrontPorch = 16'd210;
localparam      H_BackPorch  = 16'd46;
localparam      V_Pulse      = 16'd5;
localparam      V_FrontPorch = 16'd22;
localparam      V_BackPorch  = 16'd23;

localparam      PixelForHS  =   H_Pulse + H_FrontPorch + H_Area + H_BackPorch;
localparam      LineForVS   =   V_Pulse + V_FrontPorch + V_Area + V_BackPorch;

// Command order: Pulse -> FrontPorch -> Line -> BackPorch
localparam      PixelStartData = H_Pulse + H_FrontPorch;
localparam      PixelEndData   = PixelStartData + H_Area;
localparam      LineStartData  = V_Pulse + V_FrontPorch;
localparam      LineEndData    = LineStartData + V_Area;

reg [15:0] LineCount;
reg [15:0] PixelCount;

always @(  posedge PixelClk or negedge nRST  )begin
    if (!nRST) begin
        LineCount       <=  16'b0;    
        PixelCount      <=  16'b0;
    end else begin   
        
        if (PixelCount  ==  PixelForHS) begin
            PixelCount      <=  16'b0;
            LineCount       <=  LineCount + 1'b1;
        end else if (LineCount == LineForVS) begin
            LineCount       <=  16'b0;
            PixelCount      <=  16'b0;
        end else begin             
            PixelCount      <=  PixelCount + 1'b1;    
            SDRAMAddr       <= ( ( ( LineCount - LineStartData ) / 5 ) * 205) + ( ( PixelCount - PixelStartData ) / 5 );
        end              
    end
end

assign  LCD_HSYNC = PixelCount < H_Pulse ? 1'b0 : 1'b1;
assign  LCD_VSYNC = LineCount  < V_Pulse ? 1'b0 : 1'b1;
assign  LCD_DE = ( (PixelCount >= PixelStartData) && (PixelCount < PixelEndData) && (LineCount >= LineStartData) && (LineCount < LineEndData) ) ? 1'b1 : 1'b0;

reg  [14:0] SDRAMAddr;
wire [15:0] SDRAMOut;

Gowin_SP SDRAMInstance(
    .dout(SDRAMOut), //output [15:0] dout
    .clk(PixelClk), //input clk
    .oce(1'b1), //input oce
    .ce(1'b1), //input ce
    .reset(~nRST), //input reset
    .wre(1'b0), //input wre
    .ad(SDRAMAddr), //input [14:0] ad
    .din(16'b0) //input [15:0] din
);

assign  LCD_R   =  SDRAMOut[15:11];
assign  LCD_G   =  SDRAMOut[10:5];
assign  LCD_B   =  SDRAMOut[4:0];


endmodule