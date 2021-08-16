
module SN74LS73(
	j1,
	clk1,
	k1,
	clrn1,
	q1,
	qn1,
	
	j2,
	clk2,
	k2,
	clrn2,
	q2,
	qn2
);

input wire	j1;
input wire	clk1;
input wire	k1;
input wire	clrn1;
output reg	q1;
output wire	qn1;

input wire	j2;
input wire	clk2;
input wire	k2;
input wire	clrn2;
output reg	q2;
output wire	qn2;

always@(posedge clk1 or negedge clrn1)
begin
if (!clrn1)
	begin
	q1 <= 0;
	end
else
	begin
	q1 <= ~q1 & j1 | q1 & ~k1;
	end
end

assign	qn1 =  ~q1;

always@(posedge clk2 or negedge clrn2)
begin
if (!clrn2)
	begin
	q2 <= 0;
	end
else
	begin
	q2 <= ~q2 & j2 | q2 & ~k2;
	end
end

assign	qn2 =  ~q2;

endmodule
