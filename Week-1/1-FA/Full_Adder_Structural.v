module FA_Structural (
    input A, B, Cin,
    output Sum,
    output Cout
);


wire AandB;
wire AorB;
wire CinandAorB;

xor(Sum, A, B, Cin);
and(AandB, A, B);
or(AorB, A, B);
and(CinandAorB, Cin, AorB);
or(Cout, AandB, CinandAorB);
    
endmodule

