#-------------------------------------------------------------------------------
# parameters
#
characterWidth = 1;
separatorWidth = 0.25;
italicise = 0.5;
narrow = 0.75;
crOffset = 0.125;
lineHeight = 4;

text = [
  'hello';
  'world'
];
text = [
  ' abcd efgh ijkl ';
  ' mnop qrst uvwx ';
  ' yz '
];
text = [
  'guten tag';
  'silvan zahno'
];
text = [
  'welcome to';
  'the sem labs'
];

oversamplingRatio = 16;
indent = '  ';

signalBitNb = 16;
ambaTextFile = 'beamer.txt';
ambaBinaryFile = 'beamer.dat';
ramXTextFile = 'ramXInit.txt';
ramYTextFile = 'ramYInit.txt';

#-------------------------------------------------------------------------------
# points of the figure to be drawn
#
x = [];
y = [];
for index = 1:size(text)(1)
  line = text(index,:);
  while ( line(length(line)) == ' ' )
    line = line(1:length(line)-1);
  endwhile
  [xLine, yLine] = lineSpline(
    line, characterWidth, separatorWidth, italicise, narrow
  );
  lineOffset = -(index-1)*lineHeight;
  if (index < size(text)(1))
    crHeight = lineHeight;
  else
    crHeight = -(index-1)*lineHeight;
  endif
  [xCr, yCr] = crSpline(
    xLine(length(xLine)) + separatorWidth, crOffset, crHeight
  );
  x = [x, xLine           , xCr           ];
  y = [y, yLine+lineOffset, yCr+lineOffset];
endfor

disp([  'Longueur des vecteurs: ', ...
        sprintf('%d', length(x)), ...
        ' points' ...
    ]);

#-------------------------------------------------------------------------------
# spline interpolation
#
xSpline = spline(x, oversamplingRatio, 3);
ySpline = spline(y, oversamplingRatio, 3);

x = x - min(xSpline);
y = y - min(ySpline);
xSpline = xSpline - min(xSpline);
ySpline = ySpline - min(ySpline);
scale = max(max(xSpline), max(ySpline));
x = x / scale;
y = y / scale;
xSpline = xSpline / scale;
ySpline = ySpline / scale;

#-------------------------------------------------------------------------------
# X-Y graph
#
figure(1);
axis([0 1 0 1]);
plot(xSpline, ySpline, 'b');
axis equal;
hold on;
#plot(x, y, 'd')
hold off;

#-------------------------------------------------------------------------------
# write to text files
#
x = round( (2^signalBitNb-1) * (x-0.5) );
x(x < 0) = x(x < 0) + 2^signalBitNb;
y = round( (2^signalBitNb-1) * (y-0.5) );
y(y < 0) = y(y < 0) + 2^signalBitNb;
ambaFileId = fopen(ambaTextFile, 'w');
fprintf(ambaFileId, '55 55\n');
fprintf(ambaFileId, 'C0 80000300 00000002\n');
fprintf(ambaFileId, '55 55\n');
ramXTextFileId = fopen(ramXTextFile, 'w');
for index = 1:length(x)
  fprintf(ambaFileId, 'C0 80000302 %08X\n', x(index));
  fprintf(ramXTextFileId, [dec2bin(x(index), signalBitNb), '\n']);
endfor
fclose(ramXTextFileId);
fprintf(ambaFileId, '55 55\n');
ramYTextFileId = fopen(ramYTextFile, 'w');
for index = 1:length(y)
  fprintf(ambaFileId, 'C0 80000303 %08X\n', y(index));
  fprintf(ramYTextFileId, [dec2bin(y(index), signalBitNb), '\n']);
endfor
fclose(ramYTextFileId);
fprintf(ambaFileId, '55 55\n');
fprintf(ambaFileId, 'C0 80000300 00%04X01\n', length(x));
fprintf(ambaFileId, 'C0 80000301 00000010\n');
fclose(ambaFileId);

#-------------------------------------------------------------------------------
# convert text to binary file
#
ambaTextFileId = fopen(ambaTextFile, 'r');
ambaBinaryFileId = fopen(ambaBinaryFile, 'w');
while (! feof(ambaTextFileId) )
  line = fgetl(ambaTextFileId);
  trimmedLine = '';
  for index = 1:length(line)
    if ( line(index) != ' ' )
      trimmedLine = [trimmedLine, line(index)];
    endif
  endfor
  binaryData = '';
  for index = 1:length(trimmedLine)
    if ( rem(index, 2) == 1 )
      nibbleH = trimmedLine(index) - '0';
      if ( nibbleH > 9 )
        nibbleH = nibbleH - ('A' - '0') + 10;
      endif
    else
      nibbleL = trimmedLine(index) - '0';
      if ( nibbleL > 9 )
        nibbleL = nibbleL - ('A' - '0') + 10;
      endif
#printf('%02X', 16*nibbleH + nibbleL)
      binaryData = [binaryData, char(16*nibbleH + nibbleL)];
    endif
  endfor
#printf('%X', binaryData)
  fwrite(ambaBinaryFileId, binaryData, "schar");
endwhile
fclose(ambaBinaryFileId);
fclose(ambaTextFileId);
