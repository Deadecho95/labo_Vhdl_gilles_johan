#===============================================================================
# Build spline from points vector
#
function mySpline = spline(points, oversamplingRatio, polynomOrder)

samples = zeros(1, polynomOrder+1);
mySpline = [];
for index = 1:length(points)
  samples = [samples(2:length(samples)), points(index)];
  coeff2 = samples * [-1,  2, -1,  0;
                       3, -5,  0,  1;
                      -3,  4,  1,  0;
                       1, -1,  0,  0];
  x = 2*coeff2(4) * oversamplingRatio^3;
  u = coeff2(1) + coeff2(2)*oversamplingRatio + coeff2(3)*oversamplingRatio^2;
  v = 6*coeff2(1) + 2*coeff2(2)*oversamplingRatio;
  w = 6*coeff2(1);
  mySpline = [mySpline, coeff2(4)];
  for index = 1:oversamplingRatio-1
    x = x + u;
    u = u + v;
    v = v + w;
    mySpline = [mySpline, x / (2*oversamplingRatio^3)];
  endfor
endfor
