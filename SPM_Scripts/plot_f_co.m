Ic = 1
nr_vox = 1;
add_lbls = 1;
% Figure out SPM fig;
    all_figs = get(0,'children');
    spm_g_fig = all_figs(find(cellfun(@isempty,arrayfun(@(x) strfind(all_figs(x).Name,': Graphics'),[1:2],'UniformOutput',0)) == 0));
    spm_res_fig = all_figs(find(cellfun(@isempty,arrayfun(@(x) strfind(all_figs(x).Name,': Results'),[1:2],'UniformOutput',0)) == 0));
    figure(spm_g_fig.Number) % Make active
    
c = spm_mip_ui('GetCoords');
%h=spm_mip_ui('FindMIPax');
c = spm_mip_ui('SetCoords',c);


v_ind = find(xSPM.XYZmm(1,:) == c(1) & xSPM.XYZmm(2,:) == c(2) & xSPM.XYZmm(3,:) == c(3));

XYZ = xSPM.XYZ(:,v_ind);
dist = arrayfun(@(x) pdist([xSPM.XYZ(:,x)';xSPM.XYZ(:,v_ind)']),1:size(xSPM.XYZ,2))';
[Y I] = sort(dist);

%nr_vox = 2
XYZ = xSPM.XYZ(:,I(1:nr_vox));



beta  = spm_get_data(SPM.Vbeta, XYZ);
ResMS = spm_get_data(SPM.VResMS,XYZ);
%vx = length(beta);
beta = mean(beta,2);
ResMS = mean(ResMS,2);
Bcov  = ResMS*SPM.xX.Bcov;

CI    = 1.6449;
% compute contrast of parameter estimates and 90% C.I.
%------------------------------------------------------------------
cbeta = SPM.xCon(Ic).c'*beta;
SE    = sqrt(diag(SPM.xCon(Ic).c'*Bcov*SPM.xCon(Ic).c));
CI    = CI*SE;

ff = figure(11);
clf ;
bar(cbeta);
hold on;
errorbar(cbeta,CI,'rx');

if add_lbls
ff.CurrentAxes.XTickLabel = t_labels(1:12);
ff.CurrentAxes.XTickLabelRotation = 45;
end
figure(spm_g_fig.Number); % Make active again

spm_mip_ui('GetCoords')'