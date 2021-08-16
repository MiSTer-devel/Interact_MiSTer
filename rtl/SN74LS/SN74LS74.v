
module SN74LS74(
	prn1,
	d1,
	clk1,
	clrn1,
	q1,
	qn1,
	
	prn2,
	d2,
	clk2,
	clrn2,
	q2,
	qn2
);

input wire	prn1;
input wire	d1;
input wire	clk1;
input wire	clrn1;
output reg	q1;
output wire	qn1;

input wire	prn2;
input wire	d2;
input wire	clk2;
input wire	clrn2;
output reg	q2;
output wire	qn2;

always@(posedge clk1 or negedge clrn1 or negedge prn1)
begin
if (!clrn1)
	begin
	q1 <= 0;
	end
else
if (!prn1)
	begin
	q1 <= 1;
	end
else
	begin
	q1 <= d1;
	end
end

assign	qn1 =  ~q1;

always@(posedge clk2 or negedge clrn2 or negedge prn2)
begin
if (!clrn2)
	begin
	q2 <= 0;
	end
else
if (!prn2)
	begin
	q2 <= 1;
	end
else
	begin
	q2 <= d2;
	end
end

assign	qn2 =  ~q2;

endmodule
