function inr = Inertia3D(m,r)

r_hat = [0 -r(3) r(2);r(3) 0 -r(1);-r(2) r(1) 0];
inr   = m * r_hat * r_hat';
