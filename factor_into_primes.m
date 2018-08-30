function primes = factor_into_primes(input);
search = 1;
primes = [];
try_primes = find(isprime(1:100));
current_number = input;
while search
    for p = try_primes;
    if mod(current_number,p)==0
        primes(end+1) = p;
        current_number = current_number / p;
    end
    end
    if prod(primes) == input
        %clc;disp('found');
        break
    end
end
primes = sort(primes,'descend');
%disp([num2str(input) ' is a product of: [' num2str(primes) ']'])