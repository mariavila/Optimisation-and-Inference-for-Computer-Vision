function y = sol_diracReg( x, epsilon )
%  Dirac function of x
%    sol_diracReg( x, epsilon ) Computes the derivative of the heaviside
%    function of x with respect to x. Regularized based on epsilon.

for i = 1:size(x,1)
    for j = 1:size(x,2)
        y(i,j) = epsilon/(pi*(epsilon^2 + x(i,j)^2)); %TODO 19: Line to complete--> POT NO ESTAR BÉ
    end
end
