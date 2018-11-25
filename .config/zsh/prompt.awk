BEGIN {
	A=0;
	M=0;
	D=0;
	C=" ";
	R="%F{r}";
	G="%F{g}";
	B="%F{blu}"
}
/^# branch.head/ {
	Br=$3
	next
}
/^[12] [^.?!]/ { C = "+" }
/^[12] A/  { A++; next }
/^[12] .M/ { M++; next }
/^[12] .D/ { D++; next }
END {
	printf "%s", "%B" C Br
	if (D+M+A) printf " "
	if (D) printf "%s", R D
	if (M) printf "%s", B M
	if (A) printf "%s", G A
	printf "%s", "%f%b"
}

