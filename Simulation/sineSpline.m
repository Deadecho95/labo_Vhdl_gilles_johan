#-------------------------------------------------------------------------------
# sinewave
#
dataBitNb = 16;
oversamplingBitNb = 5;
pointNb = 4*8;
polynomOrder = 3;

phase = linspace(0, 2*pi, pointNb+1);
#sine = sin(phase);
sine = round( ( 2^(dataBitNb-1) - 1 ) * sin(phase) );
oversamplingRatio = 2^oversamplingBitNb;
phaseOversampled = linspace(0, 2*pi, oversamplingRatio*pointNb+1);


#-------------------------------------------------------------------------------
# interpolate calcSpline
#
calcSpline = spline(sine, oversamplingRatio, polynomOrder);

#-------------------------------------------------------------------------------
# plot results
#
sine = [0, sine(1:length(sine)-1)];
plot(phase, sine, 'or');
calcSpline = calcSpline(2^(oversamplingBitNb):length(calcSpline));
calcSpline = calcSpline(1:length(phaseOversampled));
hold on;
plot(phaseOversampled, calcSpline);
hold off;
