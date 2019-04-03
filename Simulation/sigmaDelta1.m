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

AminDb = -120;

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
xC = round(signalRange/2*x) + signalRange/2;

bucketCapacity = signalRange;
accumulator = zeros(size(xC));
sigmaDelta = zeros(size(xC));
for index = 1:length(accumulator)-1
  acc = accumulator(index) + xC(index);
  acc = mod(acc, accumulatorRange);
  if acc >= accumulatorRange/2
    sigmaDelta(index) = 1;
    acc = acc - bucketCapacity;
  end;
  accumulator(index+1) = acc;
end;

figureId = figureId + 1;
figure(figureId);
stairs(t, xC);
hold on;
stairs(t, accumulator, 'g');
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
