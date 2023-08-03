function topshare = PItab(p,s,t,f_out)
%% compute top income share using Piketty (2003)'s Pareto interpolation method
% p:        vector of top fractile
% s:        vector of conditional tail expectations
% t:        vector of thresholds
% f_out:    fractile to output top income shares
% topshare: top income shares

%% some error checking
K = length(p);
if length(s) ~= K
    error('s must have same length as p')
end
if any(diff(p) <= 0)
    error('p must be strictly increasing')
end
if any(diff(s) >= 0)
    error('s must be strictly decreasing')
end
if any(diff(t) >= 0)
    error('t must be strictly decreasing')
end

%% Piketty's Pareto interpolation

b = s./t; % local Pareto coefficient
a = b./(b - 1); % local Pareto exponent

J = length(f_out);
S = 0*f_out; % store theoretical total income

for j = 1:J
    q = f_out(j);
    [~,k] = min(abs(p - q)); % find closest fractile
    S(j) = s(k)*p(k)^(1/a(k))*q^(1/b(k));
end

topshare = S/S(1);

end

