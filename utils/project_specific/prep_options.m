function options=prep_options
if datenum(version('-date'))>=736580
    options = optimoptions('lsqnonlin','MaxIter',25,'StepTolerance',1e-2,...
        'FunctionTolerance',0,...
        'OptimalityTolerance',0,'Display','iter',...
        'FiniteDifferenceStepSize',0.01);
%     options.Algorithm = 'levenberg-marquardt';
else
    options = optimoptions('lsqnonlin','MaxIter',25,'TolX',1e-6,...
        'TolFun',0,'TolPCG',0,'Display','iter','FinDiffRelStep',0.01);
%     options.Algorithm = 'levenberg-marquardt';
end

% 'MaxFunctionEvaluations',Inf,
% 'MaxFunEvals',Inf,
% 'MaxIter',35