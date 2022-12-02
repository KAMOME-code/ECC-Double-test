`timescale 1ns/1ps

`define prime 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F

// Multiplier state
`define Init      0   //state
`define Mul1      1   //state
`define Mul2      2   //state
`define Mul3      3   //state
`define Mul4      4   //state
`define Mul5      5   //state
`define Mul6      6   //state
`define Mul7      7   //state
`define Mul8      8   //state
`define Mul9      9   //state
`define Mul10    10   //state
`define Mul11    11   //state
`define Mul12    12   //state
`define Mul13    13   //state
`define Mul14    14   //state
`define Mul15    15   //state
`define Mul16    16   //state
`define Add      17   //state
`define Final    18   //state

// Modular Reduction state
`define Init     0   //state
`define Mod1     1   //state
`define Mod2     2   //state
`define Mod3     3   //state
`define Mod4     4   //state
`define Mod5     5   //state
`define Mod6     6   //state
`define Mod7     7   //state
`define Mod8     8   //state
`define Finish   9  //state

// ECCcore state
`define Init      0   //state
`define ML        1   //state
`define Double1a  0   //state
`define Double1b  1   //state
`define Double1c  2   //state
`define Double1d  3   //state
`define Double1e  4   //state
`define Double1f  5   //state
`define Double1g  6   //state
`define Double1h  7   //state
`define Double2a  8   //state
`define Double2b  9   //state
`define Double2c  10   //state
`define Double2d  11   //state
`define Double2e  12   //state
`define Double2f  13   //state
`define Double2g  14   //state
`define Double2h  15   //state
`define Double3a  16   //state
`define Double3b  17   //state
`define Double3c  18   //state
`define Double3d  19   //state
`define Double4a  20   //state
`define Double4b  21   //state
`define Double4c  22   //state
`define Double4d  23   //state
`define Double5a  24   //state
`define Double5b  25   //state
`define Double5c  26   //state
`define Double5d  27   //state
`define Double5e  28   //state
`define Double5f  29   //state
`define Double6a  30   //state
`define Double6b  31   //state
`define Double6c  32   //state
`define Double6d  33   //state
`define Double6e  34   //state
`define Double6f  35   //state
`define Double6g  36   //state
`define Double6h  37   //state
`define Double7a  38   //state
`define Double7b  39   //state
`define Double7c  40   //state
`define Double7d  41   //state
`define Double8a  42   //state
`define Double8b  43   //state
`define Double8c  44   //state
`define Double8d  45   //state
`define Double8e  46   //state
`define Double8f  47   //state
`define MLfinal   48   //state

module Mul256with64(clk, start, busy, A, B, C);

input clk, start;
input [255:0] A,B;
output busy;
output [511:0] C;

reg [63:0] a,b;
reg [319:0] Reg1,Reg2;
reg [511:0] C;
reg [4:0] state;
reg busy;

wire [127:0] c;

assign c = a * b;

always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    state <= `Init;
end else begin
    if(state == `Init) begin
    busy <= 1;
    C <= 512'b0;
    Reg1 <= 320'b0;
    Reg2 <= 320'b0;
    a <= A[63:0];
    b <= B[63:0];
    state <= `Mul1;
    end else if(state == `Mul1) begin
    C[127:0] <= c;
    a <= A[63:0];
    b <= B[127:64];
    state <= `Mul2;
    end else if(state == `Mul2) begin
    C[191:64] <= C[191:64] + c;
    a <= A[63:0];
    b <= B[191:128];
    state <= `Mul3;
    end else if(state == `Mul3) begin
    C[255:128] <= C[255:128] + c;
    a <= A[63:0];
    b <= B[255:192];
    state <= `Mul4;
    end else if(state == `Mul4) begin
    C[319:192] <= C[319:192] + c;
    a <= A[127:64];
    b <= B[63:0];
    state <= `Mul5;
    end else if(state == `Mul5) begin
    Reg1[127:0] <= c;
    a <= A[127:64];
    b <= B[127:64];
    state <= `Mul6;
    end else if(state == `Mul6) begin
    Reg1[191:64] <= Reg1[191:64] + c;
    a <= A[127:64];
    b <= B[191:128];
    state <= `Mul7;
    end else if(state == `Mul7) begin
    Reg1[255:128] <= Reg1[255:128] + c;
    a <= A[127:64];
    b <= B[255:192];
    state <= `Mul8;
    end else if(state == `Mul8) begin
    Reg1[319:192] <= Reg1[319:192] + c;
    a <= A[191:128];
    b <= B[63:0];
    state <= `Mul9;
    end else if(state == `Mul9) begin
    C[383:64] <= C[383:64] + Reg1;
    Reg2[127:0] <= c;
    a <= A[191:128];
    b <= B[127:64];
    state <= `Mul10;
    end else if(state == `Mul10) begin
    Reg1 <= 320'b0;
    Reg2[191:64] <= Reg2[191:64] + c;
    a <= A[191:128];
    b <= B[191:128];
    state <= `Mul11;
    end else if(state == `Mul11) begin
    Reg2[255:128] <= Reg2[255:128] + c;
    a <= A[191:128];
    b <= B[255:192];
    state <= `Mul12;
    end else if(state == `Mul12) begin
    Reg2[319:192] <= Reg2[319:192] + c;
    a <= A[255:192];
    b <= B[63:0];
    state <= `Mul13;
    end else if(state == `Mul13) begin
    C[447:128] <= C[447:128] + Reg2;
    Reg1[127:0] <= c;
    a <= A[255:192];
    b <= B[127:64];
    state <= `Mul14;
    end else if(state == `Mul14) begin
    Reg1[191:64] <= Reg1[191:64] + c;
    a <= A[255:192];
    b <= B[191:128];
    state <= `Mul15;
    end else if(state == `Mul15) begin
    Reg1[255:128] <= Reg1[255:128] + c;
    a <= A[255:192];
    b <= B[255:192];
    state <= `Mul16;
    end else if(state == `Mul16) begin  
    Reg1[319:192] <= Reg1[319:192] + c;
    state <= `Add;
    end else if(state == `Add) begin
    C[511:192] <= C[511:192] + Reg1;
    state <= `Final;
    end else if(state == `Final) begin    
    busy <= 0;
    end
end
end
endmodule

module ModRed(clk, start, busy, A, B);

input clk, start;
input [511:0] A;
output busy;
output [255:0] B;

reg busy;
reg [511:0] Reg;
reg [255:0] B, RegH, RegL;
reg [3:0] state;

always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    state <= `Init;
end else begin
    if(state == `Init) begin    //Initialization
        {RegH, RegL} <= A;
        busy <= 1;
        state <= `Mod1;       
    end else if(state == `Mod1) begin
        Reg <= {256'b0, RegH} + {256'b0, RegL};
        state <= `Mod2;
    end else if(state == `Mod2) begin
        Reg <= {252'b0, RegH, 4'b0} + Reg;
        state <= `Mod3;
    end else if(state == `Mod3) begin
        Reg <= {250'b0, RegH, 6'b0} + Reg;
        state <= `Mod4;
    end else if(state == `Mod4) begin
        Reg <= {249'b0, RegH, 7'b0} + Reg;
        state <= `Mod5;
    end else if(state == `Mod5) begin
        Reg <= {248'b0, RegH, 8'b0} + Reg;
        state <= `Mod6;
    end else if(state == `Mod6) begin
        Reg <= {247'b0, RegH, 9'b0} + Reg;
        state <= `Mod7;
    end else if(state == `Mod7) begin
        Reg <= {224'b0, RegH, 32'b0} + Reg;
        state <= `Mod8;
    end else if(state == `Mod8) begin
        if(Reg[511:256] != 256'b0) begin
            {RegH, RegL} <= Reg;
            state <= `Mod1;
        end else begin
            B <= Reg[255:0];
            state <= `Finish;
        end
    end else begin
        busy <= 0;  //finish state
    end
end
end

endmodule

module ECCcoreDouble(clk, Xin, Yin, Zin, X, Y, Z, start, busy);

input clk, start;
input [255:0] Xin, Yin, Zin;
output [255:0] X, Y, Z;
output busy;

reg [255:0] X,Y,Z,X1,Y1,Z1,A,B,C,D,E,F,a1,a2,s1,s2,mulA,mulB;
reg [511:0] U;
reg main_state;
reg [6:0] state;
reg busy, mul_start, red_start;

wire [255:0] add, sub, red_out;
wire [511:0] mul_out;
wire [256:0] addx, subx;
wire mul_busy, red_busy;

Mul256with64 mul(.clk(clk),.start(mul_start),.busy(mul_busy),.A(mulA),.B(mulB),.C(mul_out));
ModRed red(.clk(clk),.start(red_start),.busy(red_busy),.A(U),.B(red_out));
assign      addx = a1 + a2;
assign      add  = (addx[256])? (a1 + a2 - `prime):(a1 + a2);
assign      subx = s1 - s2;
assign      sub  = (subx[256])? (s1 - s2 + `prime):(s1 - s2);


always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    main_state <= `Init;
end else begin
    if(main_state == `Init) begin    //Initialization
        busy <= 1;
        state <= `Double1a;
        mul_start <= 0; //Reset multiplier *important
        red_start <= 0; //Reset modred *important
        {X1,Y1,Z1} <= {Xin,Yin,Zin};
        main_state <= `ML;
    end else if(main_state == `ML) begin
            if(state == `Double1a) begin
            //wait_mul(Y1, Y1);
                mul_start <= 1;
                mulA <= Y1;
                mulB <= Y1;
                state <= `Double1b;
            end else if(state == `Double1b) begin
                state <= `Double1c; // wait 1 clk
            end else if(state == `Double1c) begin
                state <= (mul_busy == 1)? `Double1c:`Double1d;
            end else if(state == `Double1d) begin
                mul_start <= 0;
                U <= mul_out;
                state <= `Double1e;
            end else if(state == `Double1e) begin
            //wait_add(X1, X1, C);
                a1 <= X1;
                a2 <= X1;
                state <= `Double1f;
            end else if(state == `Double1f) begin
                C <= add;
                state <= `Double1g;
            end else if(state == `Double1g) begin
            //wait_add(C, X1, D);
                a1 <= C;
                a2 <= X1;
                state <= `Double1h;
            end else if(state == `Double1h) begin
                D <= add;
                state <= `Double2a;
            end else if(state == `Double2a) begin
            //wait_mulred(X1, D, B);
                mul_start <= 1;
                red_start <= 1;
                mulA <= X1;
                mulB <= D;
                state <= `Double2b;
            end else if(state == `Double2b) begin
                state <= `Double2c; // wait 1 clk
            end else if(state == `Double2c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Double2d:`Double2c;
            end else if(state == `Double2d) begin
                U <= mul_out;
                B <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Double2e;
            end else if(state == `Double2e) begin
            //wait_add(B, B, B);
                a1 <= B;
                a2 <= B;
                state <= `Double2f;
            end else if(state == `Double2f) begin
                B <= add;
                state <= `Double2g;
            end else if(state == `Double2g) begin
            //wait_add(B, B, C);
                a1 <= B;
                a2 <= B;
                state <= `Double2h;
            end else if(state == `Double2h) begin
                C <= add;
                state <= `Double3a;                
            end else if(state == `Double3a) begin
            //wait_mulred(C, X1, A);
                mul_start <= 1;
                red_start <= 1;
                mulA <= C;
                mulB <= X1;
                state <= `Double3b;
            end else if(state == `Double3b) begin
                state <= `Double3c; // wait 1 clk
            end else if(state == `Double3c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Double3d:`Double3c;
            end else if(state == `Double3d) begin
                U <= mul_out;
                A <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Double4a;
            end else if(state == `Double4a) begin
            //wait_mulred(C, B, D);
                mul_start <= 1;
                red_start <= 1;
                mulA <= C;
                mulB <= B;
                state <= `Double4b;
            end else if(state == `Double4b) begin
                state <= `Double4c; // wait 1 clk
            end else if(state == `Double4c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Double4d:`Double4c;
            end else if(state == `Double4d) begin
                U <= mul_out;
                D <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Double5a;
            end else if(state == `Double5a) begin
            //wait_mulred(A, A, C);
            //wait_add(D, D, E);
                mul_start <= 1;
                red_start <= 1;
                mulA <= A;
                mulB <= A;
                a1 <= D;
                a2 <= D;
                state <= `Double5b;
            end else if(state == `Double5b) begin
                E <= add;
                state <= `Double5c; // wait 1 clk
            end else if(state == `Double5c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Double5d:`Double5c;
            end else if(state == `Double5d) begin
                U <= mul_out;
                C <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Double5e;                
            end else if(state == `Double5e) begin
            //wait_add(Z1, Z1, Z1);
                a1 <= Z1;
                a2 <= Z1;
                state <= `Double5f;
            end else if(state == `Double5f) begin
                Z1 <= add;
                state <= `Double6a;  
            end else if(state == `Double6a) begin
            //wait_mulred(Y1, Z1, B);
                mul_start <= 1;
                red_start <= 1;
                mulA <= Y1;
                mulB <= Z1;
                state <= `Double6b;
            end else if(state == `Double6b) begin
                state <= `Double6c; // wait 1 clk
            end else if(state == `Double6c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Double6d:`Double6c;
            end else if(state == `Double6d) begin
                U <= mul_out;
                B <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Double6e;
            end else if(state == `Double6e) begin
            //wait_sub(B, E, X1);
                s1 <= B;
                s2 <= E;    
                state <= `Double6f;
            end else if(state == `Double6f) begin
                X1 <= sub;
                state <= `Double6g;      
            end else if(state == `Double6g) begin
            //wait_sub(D, X1, D);
                s1 <= D;
                s2 <= X1;    
                state <= `Double6h;
            end else if(state == `Double6h) begin
                D <= sub;
                state <= `Double7a; 
            end else if(state == `Double7a) begin
            //wait_mulred(D, A, Z1);
                mul_start <= 1;
                red_start <= 1;
                mulA <= D;
                mulB <= A;
                state <= `Double7b;
            end else if(state == `Double7b) begin
                state <= `Double7c; // wait 1 clk
            end else if(state == `Double7c) begin
                state <= ((red_busy == 0)&&(mul_busy == 0))? `Double7d:`Double7c;
            end else if(state == `Double7d) begin
                U <= mul_out;
                Z1 <= red_out;
                mul_start <= 0;
                red_start <= 0;
                state <= `Double8a;                
            end else if(state == `Double8a) begin
            //wait_red(Y1);
                red_start <= 1;
                state <= `Double8b;
            end else if(state == `Double8b) begin
                state <= `Double8c; // wait 1 clk
            end else if(state == `Double8c) begin
                state <= (red_busy == 1)? `Double8c:`Double8d;
            end else if(state == `Double8d) begin
                U <= mul_out;
                Y1 <= red_out;
                red_start <= 0;
                state <= `Double8e;
            end else if(state == `Double8e) begin
            //wait_sub(Y1, C, Y1);
                s1 <= Y1;
                s2 <= C;    
                state <= `Double8f;
            end else if(state == `Double8f) begin
                Y1 <= sub;
                state <= `MLfinal;                 
            end else if(state == `MLfinal) begin
                {X,Y,Z} <= {X1,Y1,Z1};
                busy <= 0;
            end
    end
end
end
endmodule