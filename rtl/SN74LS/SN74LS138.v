

module SN74LS138 (
	a,
	b,
	c,
	g1,
	g2an,
	g2bn,
	y0n,
	y1n,
	y2n,
	y3n,
	y4n,
	y5n,
	y6n,
	y7n
);

input wire	a;
input wire	b;
input wire	c;
input wire	g1;
input wire	g2an;
input wire	g2bn;
output wire	y0n;
output wire	y1n;
output wire	y2n;
output wire	y3n;
output wire	y4n;
output wire	y5n;
output wire	y6n;
output wire	y7n;

wire	en;
assign	en = ~(~g1 | g2bn | g2an);

assign	y0n = ~(~a & ~b & ~c & en);
assign	y1n = ~(a & ~b & ~c & en);
assign	y2n = ~(~a & b & ~c & en);
assign	y3n = ~(a & b & ~c & en);
assign	y4n = ~(~a & ~b & c & en);
assign	y5n = ~(~b & c & a & en);
assign	y6n = ~(~a & c & b & en);
assign	y7n = ~(en & b & a & c);

endmodule
