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

bucketCapacity = signalRange;
accumulator1 = zeros(size(xC));
accumulator2 = zeros(size(xC));
sigmaDelta = zeros(size(xC));
for index = 1:length(xC)-1
  acc1 = accumulator1(index) + xC(index);
  acc2 = accumulator2(index) + 1/2*accumulator1(index) - signalRange/4;
  if acc2 < 0
    acc2 = 0;
  end;
  acc1 = mod(acc1, accumulatorRange);
  acc2 = mod(acc2, accumulatorRange);
  if acc2 >= accumulatorRange/2
    sigmaDelta(index) = 1;
    acc1 = acc1 - bucketCapacity;
    acc2 = acc2 - bucketCapacity;
  end;
  accumulator1(index+1) = acc1;
  accumulator2(index+1) = acc2;
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
