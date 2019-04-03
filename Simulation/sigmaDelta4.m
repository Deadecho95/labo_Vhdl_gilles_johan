%-------------------------------------------------------------------------------
% Specifications
%
signalBitNb = 16;
accumulatorBitNb = 18;

fck = 66E6;

fo = 10E3;

periodNb = 4;
tPointNb = periodNb * round(fck/fo);
fPointNb = tPointNb/round(fck/fo)*10;

AminDb = -110;

%-------------------------------------------------------------------------------
% General
%
Tck = 1/fck;
t = Tck * [0:tPointNb-1];
f = linspace(0, fck, tPointNb);
w = 2 * pi * f/fck;

signalRange = 2^signalBitNb;
accumulatorRange = 2^accumulatorBitNb;

figureId = 0;

separator = char('-' * ones(1, 80));
indent = char(' ' * ones(1, 2));

%-------------------------------------------------------------------------------
% Time signal
%
x = sin(2*pi*fo*t);

figureId = figureId + 1;
figure(figureId);
stairs(t, x);
grid;

%-------------------------------------------------------------------------------
% Circuit simulation
%
xC = round(signalRange/4*x) + signalRange/2;

a0 = 0.8653;
a = [1.1920, 0.3906, 0.06926, 0.005395];
b = [-3.540E-3, -3.542E-3, -3.134E-6, -1.567E-6];

a0 = 0.77486;
a = [1.07610, 0.36610, 0.07398, 0.00912];
b = [-3.558E-3, -3.559E-3, -3.23E-6, -1.61E-6];

bucketCapacity = signalRange;
accumulator1 = zeros(size(xC));
accumulator2 = zeros(size(xC));
accumulator3 = zeros(size(xC));
accumulator4 = zeros(size(xC));
sigmaDelta = zeros(size(xC));
for index = 1:length(xC)-1
  sum1 = xC(index) - bucketCapacity * sigmaDelta(index) + b(1) * accumulator1(index) + b(2) * accumulator2(index) + b(3) * accumulator3(index) + b(4) * accumulator4(index);
  acc1 = accumulator1(index) + sum1;
  acc2 = accumulator2(index) + accumulator1(index);
  acc3 = accumulator3(index) + accumulator2(index);
  acc4 = accumulator4(index) + accumulator3(index);
  sum2 = a0 * sum1 + a(1) * accumulator1(index) + a(2) * accumulator2(index) + a(3) * accumulator3(index) + a(4) * accumulator4(index);
%   if acc2 < 0
%     acc2 = 0;
%   end;
%   acc1 = mod(acc1, accumulatorRange);
%   acc2 = mod(acc2, accumulatorRange);
  if sum2 >= accumulatorRange/2
    sigmaDelta(index+1) = 1;
  end;
  accumulator1(index+1) = acc1;
  accumulator2(index+1) = acc2;
  accumulator3(index+1) = acc3;
  accumulator4(index+1) = acc4;
end;

figureId = figureId + 1;
figure(figureId);
stairs(t, xC);
hold on;
stairs(t, accumulator1, 'g');
stairs(t, accumulator2, 'y');
stairs(t, signalRange/4*sigmaDelta, 'r');
hold off;
grid;

%-------------------------------------------------------------------------------
% Frequency analysis
%
f = f(1:round(length(f)/2));

X = fft(xC/signalRange/tPointNb);
Adb = 20*log10(abs(X));
Adb = Adb(1:length(f));
Adb(Adb < AminDb) = AminDb;

S = fft(sigmaDelta/tPointNb);
Sdb = 20*log10(abs(S));
Sdb = Sdb(1:length(f));
Sdb(Sdb < AminDb) = AminDb;

figureId = figureId + 1;
figure(figureId);
plot(f, [Adb; Sdb]);
grid;

f = f(1:fPointNb);

Adb = 20*log10(abs(X));
Adb = Adb(1:fPointNb);
Adb(Adb < AminDb) = AminDb;

Sdb = 20*log10(abs(S));
Sdb = Sdb(1:length(f));
Sdb(Sdb < AminDb) = AminDb;

figureId = figureId + 1;
figure(figureId);
plot(f, [Adb; Sdb]);
grid;
