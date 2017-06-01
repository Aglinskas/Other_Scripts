%% Case 4;
s_hyp = linspace(-10,10,1000);
x_obs = 3.3;
sigma = 1;
prior = normpdf(s_hyp, 0 , 3);
likelihood = normpdf(s_hyp,x_obs,sigma);
protoposterior = prior .* likelihood;
posterior  = protoposterior / sum(protoposterior);
posterior = posterior / diff(s_hyp(1:2));
f = figure(1);
%plot(s_hyp,prior,'r',likelihood,'b',posterior,'k')
clf
hold on
plot(s_hyp,prior,'r')
plot(s_hyp,likelihood,'b')
plot(s_hyp,posterior,'k')
% FIT sigma with MLE


% fitting models: fmincon
