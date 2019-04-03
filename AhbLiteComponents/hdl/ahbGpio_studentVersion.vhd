--==============================================================================
--
-- AHB general purpose input/outputs
--
-- Provides "ioNb" input/output signals .
--
--------------------------------------------------------------------------------
--
-- Write registers
--
-- 00, data register receives the values to drive the output lines.
-- 01, output enable register defines the signal direction:
--     when '1', the direction is "out".
--
--------------------------------------------------------------------------------
--
-- Read registers
-- 00, data register provides the values detected on the lines.
--
ARCHITECTURE studentVersion OF ahbGpio IS
BEGIN
  
  
  inOutProcess: PROCESS(hClk, hReset_n)
  BEGIN
    IF reset = '1' THEN 

    ELSIF rising_edge(clock) THEN
      
    END IF;
  END PROCESS inOutProcess;


      ioOut <= (OTHERS => '0');
      ioEn  <= (OTHERS => '0');
      hRData  <=	(OTHERS => '0');
      hReady  <=	'0';	
      hResp	  <=	'0';	
      
END ARCHITECTURE studentVersion;

