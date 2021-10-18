function logical_mask = build_logical_mask(nt, maxNt, Ns)

%   Copyright (C) 2009 Cesare Magri
%   Version: 1.0.4

% -------
% LICENSE
% -------
% This software is distributed free under the condition that:
%
% 1. it shall not be incorporated in software that is subsequently sold;
%
% 2. the authorship of the software shall be acknowledged and the following
%    article shall be properly cited in any publication that uses results
%    generated by the software:
%
%      Magri C, Whittingstall K, Singh V, Logothetis NK, Panzeri S: A
%      toolbox for the fast information analysis of multiple-site LFP, EEG
%      and spike train recordings. BMC Neuroscience 2009 10(1):81;
%
% 3.  this notice shall remain in place in each source file.

logical_mask = (1:maxNt)'*ones(1,Ns)<=ones(maxNt,1)*nt(:)';