`timescale 1ns/1ps

`define prime 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F
`define delay   10

class seq_item #();

  rand bit [255:0] rand_X, rand_Y, rand_Z;
  constraint value_X {rand_X inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}
  constraint value_Y {rand_Y inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}
  constraint value_Z {rand_Z inside {[256'h1:256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F]};}

endclass

module ECCcore_double_test_tb;

reg [255:0] Xout, Yout, Zout;
reg [511:0] Mul;
reg [255:0] Mod;

reg clk, start;
reg [255:0] Xin, Yin, Zin;
wire [255:0] X, Y, Z;
wire busy;

ECCcoreDouble ECCcore(clk, Xin, Yin, Zin, X, Y, Z, start, busy);
seq_item #() item;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #1000000
  $finish;
end

always #50  clk = ~clk;

function [767:0] ecc;
    input [255:0] Xin,Yin,Zin;

    reg [255:0] Xout, Yout, Zout, A, S, M, X1, Y1;
    reg [1027:0] U;

begin
    U = 4*Xin*Yin*Yin;
    S = U % `prime;
  
    U = 3 * Xin * Xin;
    M = U % `prime;

  	U = M * M - 2*S;
    Xout = U % `prime; 

  	U = Yin*Yin*Yin*Yin;
  	A = U % `prime;
  	U = (M * Xout + 8 * A);
  	A = U % `prime;  
  	U =  M * S - A; 
    Yout = U % `prime;

    U = 2 * Yin * Zin;
    Zout = U % `prime;

    ecc = {Xout, Yout, Zout};
end  
endfunction

initial begin
  clk = 1;  // initialize clk
  item = new();
    repeat(10) begin
        start = 0;
        item.randomize();
        Xin = item.rand_X;
        Yin = item.rand_Y;
        Zin = item.rand_Z;
        @(posedge clk)  #`delay;
        start = 1;
        @(posedge clk)  #`delay;
        while (busy==1) @(posedge clk);
        {Xout, Yout, Zout} = ecc(Xin, Yin, Zin);
        if((X==Xout)&&(Y==Yout)&&(Z==Zout)) begin
            $display("Pass");
        end else begin
            $display("Error X=%h    Y=%h    Z=%h",X, Y, Z);
            $display("   Xout=%h Yout=%h Zout=%h", Xout, Yout, Zout);
        end
    end
$finish;
end

endmodule