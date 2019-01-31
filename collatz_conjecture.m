function new_n = collatz_conjecture(n)
%n = 10;
% collatz conjecture
% if even /2
% if odd * 3 + 1
    is_even = mod(n,2)==0;
    new_n = [];

    if is_even
        new_n = n / 2;
    else
        new_n = (n * 3) + 1;
    end % ends even/odd
    
end % ends function