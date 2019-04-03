ARCHITECTURE studentVersion OF ahbDacSigmaDelta IS
BEGIN

  -- AHB-Lite
  hRData  <=	(OTHERS => '0');
  hReady  <=	'0';	
  hResp	  <=	'0';	

  -- output
  sigmaDelta  <= '0';
  
END ARCHITECTURE studentVersion;

