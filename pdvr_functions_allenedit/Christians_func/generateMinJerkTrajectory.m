function [P, V, A, J] = generateMinJerkTrajectory(Pr,Vr,Ar,Jr,t)

% ref: http://www.shadmehrlab.org/book/minimum_jerk/minimumjerk.htm

%  - Flash T, and Hogan N (1985) The coordination of arm movements: an experimentally confirmed mathematical model.  J Neurosci 5: 1688-1703

%  - Hogan N (1984a) Adaptive control of mechanical impedance by coactivation of antagonist muscles.  Trans.Automatic.Control AC-29: 681-690

%  - Hogan N (1984b) An organizing principle for a class of voluntary movements.  J Neurosci. 4: 2745-2754


 

% get start and end position

Pstart = Pr(1,:);

Pend = Pr(end,:);


% direction

n_mov = Pend'-Pstart';

n_mov = n_mov/norm(n_mov);


% project coordinates on direction of motion

s_r = Pr*n_mov; s_r = s_r-s_r(1);

sp_r = Vr*n_mov;

spp_r = Ar*n_mov;

sppp_r = Jr*n_mov;


% get movement parameters

t = t-t(1);

T = t(end)-t(1);

D = norm(Pend-Pstart);

s0 = 0;

sf = D;

sp0 = sp_r(1);

spf = sp_r(end);

spp0 = spp_r(1);

sppf = spp_r(end);


M = [1 0 0 0 0 0

    0 1 0 0 0 0

    0 0 2*1 0 0 0

    1 T T^2 T^3 T^4 T^5

    0 1 2*T 3*T^2 4*T^3 5*T^4

    0 0 2 6*T 12*T^2 20*T^3];

b = [s0; sp0; spp0; sf; spf; sppf];


a = M\b;


% calculate distance travelled

s = [ones(size(t)) t t.^2 t.^3 t.^4 t.^5] * a;

sp = [zeros(size(t)) ones(size(t)) 2*t 3*t.^2 4*t.^3 5*t.^4] * a;

spp = [zeros(size(t)) zeros(size(t)) 2*ones(size(t)) 6*t 12*t.^2 20*t.^3] * a;

sppp = [zeros(size(t)) zeros(size(t)) zeros(size(t)) 6*ones(size(t)) 24*t 60*t.^2] * a;


% calculate global coordinates

P = (s*n_mov') + repmat(Pstart,length(s),1);

V = (sp*n_mov');

A = (spp*n_mov');

J = (sppp*n_mov');