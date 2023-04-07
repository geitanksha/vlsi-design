// ECE 425 MP2: Verilog RTL for Am2901 controller
// Rev 2/17/08

module controller(
	i,					// opcode (add your decoded signals)
	a,b,select_a_hi,select_b_hi,		// decoding of register addresses
	f,c,p,g_lo,p_lo,ovr,z,			// generation of ALU outputs
	y_tri,y_data,oe,			// tristate control of y bus
	ram0,ram3,		// tristate control of RAM shifter
	q0,q3,q0_data,q3_data,			// tristate control of Q shifter
	reg_wr,      //add additional signals for your design here
	aluop_1, aluop_0, inv_aluop_1, inv_aluop_0,
	r_sel0, r_sel1, inv_r_sel1, inv_r_sel0,
	s_sel0, s_sel1, inv_s_sel0, inv_s_sel1, 
	r_inv_sel, s_inv_sel,
	ff_sel0, ff_sel1, inv_ff_sel0, inv_ff_sel1,
	q_en, 
	regf_sel0, regf_sel1, inv_regf_sel0, inv_regf_sel1, 
	alu_dest, inv_alu_dest
	
);

 // define I/O for synthesized control
input [8:0] i;
input [3:0] a, b;
output [15:0] select_a_hi, select_b_hi;
input [3:0] f, c, p;
output g_lo, p_lo, ovr, z;
inout [3:0] y_tri;
input [3:0] y_data;
input oe;
inout ram0, ram3, q0, q3;
input q0_data, q3_data;
output reg_wr;    //define additional I/Os for your design
output aluop_1;
output aluop_0;
output inv_aluop_0;
output inv_aluop_1;
output r_sel0;
output r_sel1;
output inv_r_sel1;
output inv_r_sel0;
output s_sel0;
output s_sel1;
output inv_s_sel1;
output inv_s_sel0;
output r_inv_sel;
output s_inv_sel;
output ff_sel0;
output ff_sel1;
output inv_ff_sel0;
output inv_ff_sel1;
output q_en;
output regf_sel0;
output regf_sel1;
output inv_regf_sel0;
output inv_regf_sel1;
output alu_dest;
output inv_alu_dest;





 // named internal wires carry reusable subexpressions
wire shift_left, shift_right;

 // "assign" statements give us algebraic expressions
assign select_a_hi = 16'h0001 << a;
assign select_b_hi = 16'h0001 << b;
assign shift_left = i[8] & i[7];
assign shift_right = i[8] & ~ i[7];

 // simpler functionality is better implemented directly in logic gates
buf calcg(	g_lo,	~c[3] ); // glitchy with lookahead carry propagation, but shouldn't matter for us :v)
nand calcp(	p_lo,	p[3], p[2], p[1], p[0] );
xor calcovr(	ovr,	c[3], c[2] );
nor calczero(	z,	f[3], f[2], f[1], f[0] );

bufif1 drvy3(	y_tri[3],y_data[3], oe );
bufif1 drvy2(	y_tri[2],y_data[2], oe );
bufif1 drvy1(	y_tri[1],y_data[1], oe );
bufif1 drvy0(	y_tri[0],y_data[0], oe );
bufif1 drvraml( ram3,	f[3], shift_left );
bufif1 drvramr( ram0,	f[0], shift_right );
bufif1 drvqshl( q3,	q3_data, shift_left );
bufif1 drvqshr( q0,	q0_data, shift_right );


 // add your control signals here...
assign reg_wr = (i[8] | i[7]);

/* ALU */

// Choose which function the ALU will perform
assign aluop_1 = i[5];
assign aluop_0 = (i[4] & i[3]) | (i[4] & i[5]);
assign inv_aluop_1 = ~aluop_1;
assign inv_aluop_0 = ~aluop_0;

// Selects ALU input R: D (00), A (01), gnd (10)
assign r_sel0 = (~i[2] & ~i[1]);
assign r_sel1 = (~i[2] & i[1]) | (i[2] & ~i[1] & ~i[0]);
assign inv_r_sel0 = ~r_sel0;
assign inv_r_sel1 = ~r_sel1;

// Selects if S/R need to be inverted before input
assign r_inv_sel = (~i[4] & i[3]) | (i[5] & i[3]);
assign s_inv_sel = (~i[5] & i[4] & ~i[3]);


// Selects ALU input S: A (00), B (01), Q (10), gnd (11)
assign s_sel1 = (i[2] & i[1]) | (~i[2] & ~i[0]);
assign s_sel0 = (~i[2] & i[0]) | (i[1] & i[0]);
assign inv_s_sel0 = ~s_sel0;
assign inv_s_sel1 = ~s_sel1;

// Selects Q-reg (ff) inputs: F-R (00), F (01), F-L (10)
assign ff_sel1 = (i[8] & i[7] & ~i[6]);
assign ff_sel0 = (~i[8] & ~i[7] & ~i[6]);
assign inv_ff_sel0 = ~ff_sel0;
assign inv_ff_sel1 = ~ff_sel1;
assign q_en = (~i[7] & ~i[6]) | (i[8] & ~i[6]);

// Selects Regfile inputs: F-R (00), F (01), F-L (10)
assign regf_sel1 = (i[8] & i[7] );
assign regf_sel0 = (~i[8] & i[7]);
assign inv_regf_sel0 = ~regf_sel0;
assign inv_regf_sel1 = ~regf_sel1; 

// Selects Output Y: A (0), F (1)
assign alu_dest = (i[8] | ~i[7] | i[6]);
assign inv_alu_dest = ~alu_dest;

//end

endmodule

