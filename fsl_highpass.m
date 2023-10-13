%test
function hpfilter=fsl_highpass(nframe,sigma)
% mask
idx=ceil(-3*sigma):floor(3*sigma);
% gaussian weight vector
w=exp(-0.5*(idx).^2/sigma/sigma);
% linear trend vector
x=(idx).';
% intercept
x(:,2)=1;
% calculate gaussian-weighted least square in each windows
for i=1:nframe
    % creat observed mask
    t=i+(idx);
    imask=find(ismember(t,1:nframe));
    % weight X
    independent_variable=diag(w(imask))*x(imask,:);
    % regression matrix
    lpfilter_=(independent_variable.'*independent_variable)\independent_variable.'*diag(w(imask));
    % interception should be trend
    lpfilter(i,t(ismember(t,1:nframe)))=lpfilter_(2,:);
end
% remove trend component = highpass
hpfilter=eye(nframe)-lpfilter;