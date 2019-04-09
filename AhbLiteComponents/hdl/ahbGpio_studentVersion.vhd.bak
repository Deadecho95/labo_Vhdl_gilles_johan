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

  signal addrInt : std_ulogic;
  signal hTransInt : std_ulogic_vector(hTrans'range);
  signal hWriteInt : std_ulogic;
  signal hSelInt : std_ulogic;
  
BEGIN

  clockedProcess: PROCESS(hClk, hReset_n)
  BEGIN
    IF hReset_n = '0' THEN 
      hTransInt <= (OTHERS => '0');
      addrInt <= '0';
      hSelInt <= '0';
      hWriteInt <= '0';
      
    ELSIF rising_edge(hClk) THEN
      hTransInt <= hTrans;
      hSelInt <= hSel;
      hWriteInt <= hWrite;
      if hSel = '1'  then --save addr to be in phase with data
        addrInt <= hAddr(hAddr'low);
      end if;
    END IF;
  END PROCESS clockedProcess;

  hRData <= std_ulogic_vector(RESIZE(unsigned(ioIn), ahbDataBitNb));
  
  inProcess: PROCESS(hClk, hReset_n)
  BEGIN 
    IF hReset_n = '0' THEN 
      ioEn <= (OTHERS => '1');
      ioOut <= (OTHERS => '0');
    ELSIF rising_edge(hClk) THEN
      if hSelInt = '1' and hTransInt = transNonSeq then
        IF addrInt = '1' THEN -- work with direction register
          if hWriteInt = '1' then
            ioEn <= std_ulogic_vector(RESIZE(unsigned(hWData), ioNb));
          end if;
        ELSE -- work with value register
          if hWriteInt = '1' then
            ioOut <= std_ulogic_vector(RESIZE(unsigned(hWData), ioNb));
          end if;
        END if; 
      end if;
    END IF;
  END PROCESS inProcess;
      
  hReady <= '1';
  hResp <= '0';

END ARCHITECTURE studentVersion;

