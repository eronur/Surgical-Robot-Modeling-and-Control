% This function calculates the dynamic Coriolis effects on the remote stage(upper arms)
% of the surgical robot. The angles are symbolic since the equation will be
% used in a for loop that covers desired motion angle range. L: Lengths of robot links, LC: Lengths of center of mass, I: Moment of inertia of the robot links, 
%M: weight vector of the robot vectors. All vectors are 1x5 in my case

function [JC1,JC2,JC3,JCE] = CoriolisRemote(L,LC,I,M)

% syms l1 l2 l3 l4 lc1 lc2 lc3 lc4 rup q1 q2 q3 I1 I2 I3 I4 Ib m1 m2 m3 m4 md dq1 dq2 dq3 ddq1 ddq2 ddq3
syms q1 q2 q3 dq1 dq2 dq3 ddq1 ddq2 ddq3

%Jacobian Matrices Rotation
R00=RotateRoll(q1);
R01=RotateYaw(q2);
R12=RotateYaw(q3);
R0=R00;
R1=R00*R01;
R2=R00*R01*R12;
R3=R00*R12;
R4=R00*R12*R01;

for i = 1:3
    for j = 1:3
        dR0(i,j) = diff(R0(i,j),q1)*dq1 + diff(R0(i,j),q2)*dq2 + diff(R0(i,j),q3)*dq3;
        dR1(i,j) = diff(R1(i,j),q1)*dq1 + diff(R1(i,j),q2)*dq2 + diff(R1(i,j),q3)*dq3;
        dR2(i,j) = diff(R2(i,j),q1)*dq1 + diff(R2(i,j),q2)*dq2 + diff(R2(i,j),q3)*dq3;
        dR3(i,j) = diff(R3(i,j),q1)*dq1 + diff(R3(i,j),q2)*dq2 + diff(R3(i,j),q3)*dq3;
        dR4(i,j) = diff(R4(i,j),q1)*dq1 + diff(R4(i,j),q2)*dq2 + diff(R4(i,j),q3)*dq3;
    end
end
% Skew Symmetric Matrices
Wt0 = simplify(dR0*(inv(R0)));
W0(1,1) = Wt0(3,2); Wx0 = W0(1,1);
W0(2,1) = Wt0(1,3); Wy0 = W0(2,1);
W0(3,1) = Wt0(2,1); Wz0 = W0(3,1);

Wt1 = simplify(dR1*(inv(R1)));
W1(1,1) = Wt1(3,2); Wx1 = W1(1,1);
W1(2,1) = Wt1(1,3); Wy1 = W1(2,1);
W1(3,1) = Wt1(2,1); Wz1 = W1(3,1);

Wt2 = simplify(dR2*(inv(R2)));
W2(1,1) = Wt2(3,2); Wx2 = W2(1,1);
W2(2,1) = Wt2(1,3); Wy2 = W2(2,1);
W2(3,1) = Wt2(2,1); Wz2 = W2(3,1);

Wt3 = simplify(dR3*(inv(R3)));
W3(1,1) = Wt3(3,2); Wx3 = W3(1,1);
W3(2,1) = Wt3(1,3); Wy3 = W3(2,1);
W3(3,1) = Wt3(2,1); Wz3 = W3(3,1);

Wt4 = simplify(dR4*(inv(R4)));
W4(1,1) = Wt4(3,2); Wx4 = W4(1,1);
W4(2,1) = Wt4(1,3); Wy4 = W4(2,1);
W4(3,1) = Wt4(2,1); Wz4 = W4(3,1);

JW0=[diff(W0(1),dq1),diff(W0(1),dq2),diff(W0(1),dq3);diff(W0(2),dq1),diff(W0(2),dq2),diff(W0(2),dq3);diff(W0(3),dq1),diff(W0(3),dq2),diff(W0(3),dq3)];
JW1=[diff(W1(1),dq1),diff(W1(1),dq2),diff(W1(1),dq3);diff(W1(2),dq1),diff(W1(2),dq2),diff(W1(2),dq3);diff(W1(3),dq1),diff(W1(3),dq2),diff(W1(3),dq3)];
JW2=[diff(W2(1),dq1),diff(W2(1),dq2),diff(W2(1),dq3);diff(W2(2),dq1),diff(W2(2),dq2),diff(W2(2),dq3);diff(W2(3),dq1),diff(W2(3),dq2),diff(W2(3),dq3)];
JW3=[diff(W3(1),dq1),diff(W3(1),dq2),diff(W3(1),dq3);diff(W3(2),dq1),diff(W3(2),dq2),diff(W3(2),dq3);diff(W3(3),dq1),diff(W3(3),dq2),diff(W3(3),dq3)];
JW4=[diff(W4(1),dq1),diff(W4(1),dq2),diff(W4(1),dq3);diff(W4(2),dq1),diff(W4(2),dq2),diff(W4(2),dq3);diff(W4(3),dq1),diff(W4(3),dq2),diff(W4(3),dq3)];

Dw=simplify(transpose(JW0)*I(5)*JW0+transpose(JW1)*(I(1))*JW1+transpose(JW2)*(I(2))*JW2+transpose(JW3)*(I(3))*JW3+transpose(JW4)*(I(4))*JW4)
%Jacobian Matrices Translation
%Position of the center of gravity of each link from origin to end effector
% [xc1,yc1,zc1]=deal(LC(1)*cos(q1-pi),LC(1)*sin(q1-pi)*cos(q3),LC(1)*sin(q1-pi)*sin(q3));
% C1=[xc1;yc1;zc1];
% [xc2,yc2,zc2]=deal(-LC(2)*cos(2*pi-q2),LC(2)*sin(2*pi-q2)*cos(q3),LC(2)*sin(2*pi-q2)*sin(q3));
% C2=[xc2;yc2;zc2];
% [xc3,yc3,zc3]=deal(L(1)*cos(q1-pi)-LC(3)*cos(2*pi-q2),(L(1)*sin(q1-pi)+LC(3)*sin(2*pi-q2))*cos(q3),(L(1)*sin(q1-pi)+LC(3)*sin(2*pi-q2))*sin(q3));
% C3=[xc3;yc3;zc3];
% [xc4,yc4,zc4]=deal(-L(2)*cos(2*pi-q2)+LC(4)*cos(q1-pi),(L(2)*sin(2*pi-q2)+LC(4)*sin(q1-pi))*cos(q3),(L(2)*sin(2*pi-q2)+LC(4)*sin(q1-pi))*sin(q3));
% C4=[xc4;yc4;zc4];
% [xce,yce,zce]=deal(L(1)*cos(q1-pi)-L(3)*cos(2*pi-q2)+L(5)*cos(q2-5*pi/4),(L(1)*sin(q1-pi)+L(3)*sin(2*pi-q2)+L(5)*sin(q2-5*pi/4))*cos(q3),(L(1)*sin(q1-pi)+L(3)*sin(2*pi-q2)+L(5)*sin(q2-5*pi/4))*sin(q3));
% CE=[xce;yce;zce];

[xc1,yc1,zc1]=deal(LC(1)*cos(q2-pi),LC(1)*sin(q2-pi)*cos(q1),LC(1)*sin(q2-pi)*sin(q1));
C1=[xc1;yc1;zc1];
[xc2,yc2,zc2]=deal(-LC(2)*cos(2*pi-q3),LC(2)*sin(2*pi-q3)*cos(q1),LC(2)*sin(2*pi-q3)*sin(q1));
C2=[xc2;yc2;zc2];
[xc3,yc3,zc3]=deal(L(1)*cos(q2-pi)-LC(3)*cos(2*pi-q3),(L(1)*sin(q2-pi)+LC(3)*sin(2*pi-q3))*cos(q1),(L(1)*sin(q2-pi)+LC(3)*sin(2*pi-q3))*sin(q1));
C3=[xc3;yc3;zc3];
[xc4,yc4,zc4]=deal(-L(2)*cos(2*pi-q3)+LC(4)*cos(q2-pi),(L(2)*sin(2*pi-q3)+LC(4)*sin(q2-pi))*cos(q1),(L(2)*sin(2*pi-q3)+LC(4)*sin(q2-pi))*sin(q1));
C4=[xc4;yc4;zc4];
[xce,yce,zce]=deal(L(1)*cos(q2-pi)-L(3)*cos(2*pi-q3)+L(5)*cos(q3-5*pi/4),(L(1)*sin(q2-pi)+L(3)*sin(2*pi-q3)+L(5)*sin(q3-5*pi/4))*cos(q1),(L(1)*sin(q2-pi)+L(3)*sin(2*pi-q3)+L(5)*sin(q3-5*pi/4))*sin(q1));
CE=[xce;yce;zce];

JC1=[diff(C1(1),q1),diff(C1(1),q2),diff(C1(1),q3);diff(C1(2),q1),diff(C1(2),q2),diff(C1(2),q3);diff(C1(3),q1),diff(C1(3),q2),diff(C1(3),q3)];
JC2=[diff(C2(1),q1),diff(C2(1),q2),diff(C2(1),q3);diff(C2(2),q1),diff(C2(2),q2),diff(C2(2),q3);diff(C2(3),q1),diff(C2(3),q2),diff(C2(3),q3)];
JC3=[diff(C3(1),q1),diff(C3(1),q2),diff(C3(1),q3);diff(C3(2),q1),diff(C3(2),q2),diff(C3(2),q3);diff(C3(3),q1),diff(C3(3),q2),diff(C3(3),q3)];
JC4=[diff(C4(1),q1),diff(C4(1),q2),diff(C4(1),q3);diff(C4(2),q1),diff(C4(2),q2),diff(C4(2),q3);diff(C4(3),q1),diff(C4(3),q2),diff(C4(3),q3)];
JCE=[diff(CE(1),q1),diff(CE(1),q2),diff(CE(1),q3);diff(CE(2),q1),diff(CE(2),q1),diff(CE(2),q3);diff(CE(3),q1),diff(CE(3),q2),diff(CE(3),q3)];

Dv = simplify(M(1)*transpose(JC1)*JC1 + M(2)*transpose(JC2)*JC2 + M(3)*transpose(JC3)*JC3 + M(4)*transpose(JC4)*JC4 + M(5)*transpose(JCE)*JCE);%inertia matrices should be added
%Inertia matrix
D=Dv+Dw;
%Christoffel Symbols to derive Coriolis(C) matrix
c111=simplify(0.5*diff(D(1,1),q1)*dq1);
c121=simplify(0.5*diff(D(1,1),q2)*dq2);
c131=simplify(0.5*diff(D(1,1),q3)*dq3);
c112=simplify(0.5*(2*diff(D(2,1),q1)*dq1-diff(D(1,1),q2)*dq2));
c113=simplify(0.5*(2*diff(D(3,1),q1)*dq1-diff(D(1,1),q3)*dq3));
c122=simplify(0.5*(diff(D(2,2),q1)*dq1+diff(D(2,1),q2)*dq2-diff(D(1,2),q2)*dq2));
c123=simplify(0.5*(diff(D(3,2),q1)*dq1+diff(D(3,1),q2)*dq2-diff(D(1,2),q3)*dq3));
c132=simplify(0.5*(diff(D(2,3),q1)*dq1+diff(D(2,1),q3)*dq3-diff(D(1,3),q2)*dq2));
c133=simplify(0.5*(diff(D(3,3),q1)*dq1+diff(D(3,1),q3)*dq3-diff(D(1,3),q3)*dq3));
c221=simplify(0.5*(2*diff(D(1,2),q2)*dq2-diff(D(2,2),q1)*dq1));
c222=simplify(0.5*diff(D(2,2),q2)*dq2);
c223=simplify(0.5*(2*diff(D(3,2),q2)*dq2-diff(D(2,2),q3)*dq3));
c231=simplify(0.5*(diff(D(1,3),q2)*dq2+diff(D(1,2),q3)*dq3-diff(D(2,3),q1)*dq1));
c232=simplify(0.5*diff(D(2,2),q3)*dq3);
c233=simplify(0.5*(diff(D(3,3),q2)*dq2+diff(D(3,2),q3)*dq3-diff(D(2,3),q3)*dq3));
c331=simplify(0.5*(2*diff(D(1,3),q3)*dq3-diff(D(3,3),q1)*dq1));
c332=simplify(0.5*(2*diff(D(2,3),q3)*dq3-diff(D(3,3),q2)*dq2));
c333=simplify(0.5*diff(D(3,3),q3)*dq3);
%Coriolis Matrix
% syms c111 c121 c131 c112 c113 c122 c123 c132 c133 c221 c222 c223 c231 c232 c233 c331 c332 c333
C=[c111+c121+c131 c121+c221+c231 c131+c231+c331; c112+c122+c132 c122+c222+c232 c132+c232+c332; c113+c123+c133 c123+c223+c233 c133+c233+c333];
Co1=[C(1,1)+C(2,1)+C(3,1)];
Co2=[C(1,2)+C(2,2)+C(3,2)];
Co3=[C(1,3)+C(2,3)+C(3,3)];
end
