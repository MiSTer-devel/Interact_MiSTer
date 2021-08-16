// based on TI SN74LS195 datasheet

module SN74LS195(
	clk,
	clrn,
	sh_ldn,
	j,
	kn,
	a,
	b,
	c,
	d,
	qa,
	qb,
	qc,
	qd,
	qdn
);

input wire	clk;
input wire	clrn;
input wire	sh_ldn;
input wire	j;
input wire	kn;
input wire	a;
input wire	b;
input wire	c;
input wire	d;
output reg	qa;
output reg	qb;
output reg	qc;
output reg	qd;
output wire	qdn;

always@(posedge clk or negedge clrn)
begin
if (!clrn)
	begin
	qa <= 0;
	end
else
	begin
	qa <= (~qa & j & sh_ldn) | (sh_ldn & kn & qa) | (~sh_ldn & a);
	end
end


always@(posedge clk or negedge clrn)
begin
if (!clrn)
	begin
	qb <= 0;
	end
else
	begin
	qb <= (qa & sh_ldn) | (~sh_ldn & b);
	end
end


always@(posedge clk or negedge clrn)
begin
if (!clrn)
	begin
	qc <= 0;
	end
else
	begin
	qc <= (qb & sh_ldn) | (~sh_ldn & c);
	end
end


always@(posedge clk or negedge clrn)
begin
if (!clrn)
	begin
	qd <= 0;
	end
else
	begin
	qd <= (qc & sh_ldn) | (~sh_ldn & d);
	end
end

assign	qdn =  ~qd;

endmodule
