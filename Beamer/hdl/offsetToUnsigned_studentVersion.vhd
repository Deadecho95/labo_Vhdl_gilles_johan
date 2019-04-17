------------------------------------------------
--- Autor : Johan Chenaux and Florence Villoz
--- Date : 26.02.2019
--- Description : Signed to Unsigned
------------------------------------------------

ARCHITECTURE studentVersion OF offsetToUnsigned IS
  -- 
  constant shift: signed(signedIn'range):=(signedIn'high => '1',others => '0');
  
BEGIN
  -- cast + offset (>0)
  unsignedOut <= UNSIGNED(signedIn + shift);
  
END ARCHITECTURE studentVersion;
