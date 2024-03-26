function v=vprism(x1,x2,y1,y2,z1,z2)
%function vprism
%potential of a rectangular prism
%result in m2/s2 for rho=1g/cm3.
%
%For a positive result, the absolute value of the first coordinate needs to be
%smaller than the absolute value of the second coordinate

%uses vq.m

G=6.67428e-8;  %[cm^3/(g s^2)]
v=vq(x2,y2,z2)-vq(x2,y2,z1)-vq(x2,y1,z2)+vq(x2,y1,z1)-...
   vq(x1,y2,z2)+vq(x1,y2,z1)+vq(x1,y1,z2)-vq(x1,y1,z1);
v=v*G;
