function DrawFootPrint(xsup, ysup, th, RL, col)

% right foot shape data(x,y) vertex in clockwise direction
footx = [ -0.053 0.115 0.180  0.180  0.158  0.100 -0.053 -0.065 -0.053];  
footy = [  0.028 0.050 0.031 -0.004 -0.037 -0.054 -0.028  0.0    0.028];

C = cos(th);
S = sin(th);

plot(xsup,ysup,[col,'o']);
hold on
if RL == 'R'
	h = plot(xsup+C*footx-S*footy, ysup+S*footx+C*footy,col);
else
	h = plot(xsup+C*footx+S*footy, ysup+S*footx-C*footy,col);
end
