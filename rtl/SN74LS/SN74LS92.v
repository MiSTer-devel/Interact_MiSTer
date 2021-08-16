// Based on TI SN74LS92 datasheet

module SN74LS92(
	clra,
	clrb,
	clka,
	clkb,
	qa,
	qb,
	qc,
	qd
);

input wire	clra;
input wire	clrb;
input wire	clka;
input wire	clkb;
output reg	qa;
output reg	qb;
output reg	qc;
output reg	qd;

wire	reset;
assign	reset = clra & clrb;

always@(negedge clka or posedge reset)
begin
if (reset)
	begin
	qa <= 0;
	end
else
	begin
	qa <= ~qa;
	end
end

always@(negedge clkb or posedge reset)
begin
if (reset)
	begin
	qb <= 0;
	end
else
	begin
	qb <= ~(qb | qc);
	end
end

always@(negedge clkb or posedge reset)
begin
if (reset)
	begin
	qc <= 0;
	end
else
	begin
	qc <= qb;
	end
end

always@(negedge clkb or posedge reset)
begin
if (reset)
	begin
	qd <= 0;
	end
else
	begin
	qd <= qd ^ qc;
	end
end

endmodule
