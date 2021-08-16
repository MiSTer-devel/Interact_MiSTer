// Video timings for Interact Model One based on sheet #2 of the Interact I Main Electronics Schematics
// Tries as much as possible to map modules to physical ICs on the original schematics

module video_timing (
	clk_14m,
	rst_n,
	ph1,
	ph2,
	cbclk,
	pix_a,
	vid_sel,
	vid_a0,
	vid_a1,
	vid_a2,
	vid_a3,
	vid_a4,
	vid_a5,
	vid_a6,
	vid_a7,
	vid_a8,
	vid_a9,
	vid_a10,
	vid_a11,
	vid_sel_n,
	nrr_n,
	ce_n,
	pce,
	vid_ltc,
	ram_clk,
	brst,
	tpclk,
	cmp_blank,
	irq,
	inte,
	cmp_sync,
	hblank_n,
	vblank_n,
	hsync_n,
	vsync_n
);


input wire	clk_14m;		// 14.38180 MHz Clock
input wire	rst_n;		// active low reset
output wire	ph1;			// CPU phase1 clock for 8080a
output wire	ph2;			// CPU phase2 clock
output wire	cbclk;		// colorburst clock
output wire	pix_a;		// pixel select
output reg	vid_sel;		// video select
output reg	vid_a0;		// video ram address
output reg	vid_a1;
output reg	vid_a2;
output reg	vid_a3;
output reg	vid_a4;
output reg	vid_a5;
output reg	vid_a6;
output reg	vid_a7;
output reg	vid_a8;
output reg	vid_a9;
output reg	vid_a10;
output reg	vid_a11;
output wire	vid_sel_n;	// video select low
input wire	nrr_n;		// refresh 
output wire	ce_n;			// RAS#
output wire	pce;			// video data latch enable
output wire	vid_ltc;		// video latch/pixel clock
output wire	ram_clk;		// ram clock
output wire	brst;			// color burst enable
output reg	tpclk;		// tape clock, once per scanline
output wire	cmp_blank;	// composite blank
output wire	irq;			// interrupt request low
input wire	inte;			// interrupt enable
output wire	cmp_sync;	// composite sync
output wire hblank_n;		// horizontal blank
output wire vblank_n;		//	vertical blank
output wire hsync_n;		// horizontal sync
output wire vsync_n;		// vertical sync

wire	ic15_qb;
wire	ic15_qc;
wire	ic15_qdn;

wire	ic16_qa;
wire	ic16_qc;

wire ic18_q1;
wire vclk_n;
wire vclk;

wire vreset_n;

wire ic20_d1;

wire hblank_en;

wire brst_n;
wire hreset_n;

wire ic24_q;

SN74LS195 IC15(
	.clk(clk_14m),
	.clrn(rst_n),
	.j(ic15_qdn),
	.kn(ic15_qdn),
	.sh_ldn(~(ic16_qa & ic16_qc & pix_a & vid_sel)),
	.a(0),
	.b(0),
	.c(0),
	.d(0),
	
	.qb(ic15_qb),
	.qc(ic15_qc),
	.qd(ph2),
	.qdn(ic15_qdn));

assign ph1 = ic15_qb & ~ic15_qc;


SN74LS92	IC16(
	.clka(~clk_14m),
	.clra(~rst_n),
	.clkb(ic16_qa),
	.clrb(~rst_n),
	
	.qa(ic16_qa),
	.qb(vid_ltc),
	.qc(ic16_qc),
	.qd(pix_a));


SN74LS74	IC20(	
	.clk1(ic16_qa),
	.clrn1(rst_n),
	.prn1(rst_n),
	.d1(ic20_d1),
	
	.qn1(ic20_d1),	
	.q1(cbclk),
	
	
	.clk2(vid_ltc & vid_sel & ~pix_a & vid_a0),
	.clrn2(rst_n),
	.prn2(rst_n),
	.d2(hblank_en),
	
	.q2(hblank_n)
);

//dff IC20a(.clk(ic16_qa), .clrn(rst_n), .prn(rst_n), .d(~cbclk), .q(cbclk));


//SN74LS393 IC17(
//	.a1(pix_a),
//	.clr1(~hreset_n | ~rst_n),
//	.a2(vid_a2),
//	.clr2(~hreset_n | ~rst_n),	
//	
//	.q1a(vid_sel),
//	.q1b(vid_a0),
//	.q1c(vid_a1),
//	.q1d(vid_a2),
//	.q2a(vid_a3),
//	.q2b(vid_a4),
//	.q2c(tpclk));

wire hclr = ~hreset_n | ~rst_n;	
always@(negedge pix_a or posedge hclr)
begin
if (hclr)
	begin
	{tpclk, vid_a4, vid_a3, vid_a2, vid_a1, vid_a0, vid_sel} <= 7'b0;
	end
else
	begin
	{tpclk, vid_a4, vid_a3, vid_a2, vid_a1, vid_a0, vid_sel} <= {tpclk, vid_a4, vid_a3, vid_a2, vid_a1, vid_a0, vid_sel} + 1'b1;
	end
end


assign vid_sel_n = ~vid_sel;

// SR Latch just not stable in simulation and probably no better in synthesis
//
//SN7LS279 IC21 (
//	.r1n(),
//	.s11n(),
//	.s12n(),
//	.q1(),
	
//	.r2n(~(vid_a5 & vid_a6 & vid_a11) & rst_n),
//	.s2n(vreset_n),
//	.q2(vblank_n),
	
//	.r3n(~(vid_a2 & vid_a3 & vid_a4) & rst_n),
//	.s31n(hreset_n),
//	.s32n(hreset_n),	
//	.q3(hblank_en),
	
//	.r4n(),
//	.s4n(),
//	.q4()
//);

// Substitute SR Flip-Flop for SR Latch, address signals only change on master clock anyway

srff IC21b (.s(1'b0), .r(vid_a7 & vid_a8 & vid_a11), .clk(clk_14m), .clrn(1'b1), .prn(vreset_n & rst_n), .q(vblank_n));
srff IC21c (.s(1'b0), .r(vid_a2 & vid_a3 & vid_a4), .clk(clk_14m), .clrn(1'b1), .prn(hreset_n & rst_n), .q(hblank_en));

assign cmp_blank = ~(vblank_n & hblank_n);

SN74LS138 IC22 (
	.a(vid_a1),
	.b(vid_a2),
	.c(vid_a3),
	.g1(1'b1),
	.g2an(hblank_en),
	.g2bn(hblank_en),
	.y0n(hsync_n),
	.y1n(brst_n),
	.y2n(),
	.y3n(hreset_n),
	.y4n(),
	.y5n(),
	.y6n(),
	.y7n()
);

assign brst = ~brst_n;

SN74LS73 IC18 (
	.clk1(tpclk),
	.j1(vclk_n),
	.k1(1'b1),
	.clrn1(vreset_n & rst_n),
	.q1(ic18_q1),
	
	.clk2(tpclk),
	.j2(ic18_q1),
	.k2(1'b1),
	.clrn2(vreset_n & rst_n),
	.q2(vclk),
	.qn2(vclk_n));

//jkff IC18a (.clk(tpclk), .j(~vclk), .k(1'b1), .clrn(vreset_n & rst_n), .prn(rst_n), .q(ic18_q1));	
//jkff IC18b (.clk(tpclk), .j(ic18_q1), .k(1'b1), .clrn(vreset_n & rst_n), .prn(rst_n), .q(vclk));	
	
//SN74LS393 IC19(
//	.a1(vclk),
//	.clr1(~vreset_n | ~rst_n),
//	.a2(vid_a8),
//	.clr2(~vreset_n | ~rst_n),	
//	
//	.q1a(vid_a5),
//	.q1b(vid_a6),
//	.q1c(vid_a7),
//	.q1d(vid_a8),
//	.q2a(vid_a9),
//	.q2b(vid_a10),
//	.q2c(vid_a11));

wire vclr = ~vreset_n | ~rst_n;	
always@(negedge vclk or posedge vclr)
begin
if (vclr)
	begin
	{vid_a11, vid_a10, vid_a9, vid_a8, vid_a7, vid_a6, vid_a5} <= 7'b0;
	end
else
	begin
	{vid_a11, vid_a10, vid_a9, vid_a8, vid_a7, vid_a6, vid_a5} <= {vid_a11, vid_a10, vid_a9, vid_a8, vid_a7, vid_a6, vid_a5} + 1'b1;
	end
end

assign vreset_n = (~(vid_a5 & vid_a6 & vid_a7)) | (~(ic18_q1 & vid_a9 & vid_a11));

assign vsync_n = ((vid_a6 | vid_a7) | ~(vid_a9 & vid_a11));
assign cmp_sync = !(vsync_n & hsync_n);

dff IC24(.d(1'b0), .q(ic24_q), .clk(~vblank_n), .prn(inte), .clrn(rst_n));

assign irq = ~ic24_q;

wire ce;
wire nrr_en = ~(~(nrr_n | ~vid_sel) & pix_a & vid_ltc);
srff IC21a (.s(1'b0), .r(ic16_qc & ~pix_a), .clk(clk_14m), .clrn(1'b1), .prn(~(~vid_sel & pix_a & vid_ltc) & nrr_en & rst_n), .q(ce));
srff IC21d (.s(1'b0), .r(ic16_qc & ~pix_a), .clk(clk_14m), .clrn(1'b1), .prn(nrr_en & rst_n), .q(pce));

assign ce_n = ~ce;

assign ram_clk = ~pix_a & pce;
	
endmodule
