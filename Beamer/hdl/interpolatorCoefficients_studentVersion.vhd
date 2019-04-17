------------------------------------------------
--- Autor : Johan Chenaux and Florence Villoz
--- Date : 04.03.2019
--- Description : 
------------------------------------------------


ARCHITECTURE studentVersion OF interpolatorCoefficients IS
BEGIN
  
  
  a <= resize(-sample1 +3*sample2 -3*sample3 + sample4,coeffBitNb);
  b <= resize(2*sample1 -5*sample2 +4*sample3 - sample4,coeffBitNb);
  c <= resize(-sample1 + sample3,coeffBitNb);
  d <= resize(sample2,coeffBitNb);

END ARCHITECTURE studentVersion;
