#===============================================================================
# Build points for one line
#
function [x, y] = crSpline(lineEnd, offset, lineHeight)

xOffset = lineEnd/10;

x = [lineEnd, lineEnd, lineEnd-xOffset, lineEnd-2*xOffset, 2*xOffset, 0.1*xOffset,  0           ,  0                  ];
y = [0      , -offset, -offset        , -offset          , -offset  , -2*offset  , -lineHeight/2, -lineHeight+2*offset];
