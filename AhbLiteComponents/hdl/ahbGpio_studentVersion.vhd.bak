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
  
BEGIN
  
  
  clockedProcess: PROCESS(hClk, hReset_n)
  BEGIN
    IF hReset_n = '0' THEN 
      ioEn <= (OTHERS => '1');
      ioOut <= (OTHERS => '0');
      hTransInt <= (OTHERS => '0');
      addrInt <= '0';
      
    ELSIF rising_edge(hClk) THEN
      hTransInt <= hTrans;
      if hSel = '1'  then --save addr to be in phase with data
        addrInt <= hAddr(hAddr'low);
        if hTransInt = transNonSeq then
          IF addrInt = '1' THEN -- work with direction register
            if hWrite = '1' then
              ioEn <= std_ulogic_vector(RESIZE(unsigned(hWData), ioNb));
            end if;
          ELSE -- work with value register
            if hWrite = '1' then
              ioOut <= std_ulogic_vector(RESIZE(unsigned(hWData), ioNb));
            end if;
          END if; 
        end if;
      end if;
    END IF;
  END PROCESS clockedProcess;
  
  outProcess: PROCESS(ioIn, hSel, hTransInt, hWrite)
  BEGIN
    if hSel = '1' and hTransInt = transNonSeq then --save addr to be in phase with data
      IF addrInt = '1' THEN -- work with direction register
        if hWrite = '0' then
          hRData <= (OTHERS => '0');
        end if;
      ELSE -- work with value register
        if hWrite = '0' then
          hRData <= std_ulogic_vector(RESIZE(unsigned(ioIn), ahbDataBitNb));
        end if;
      END if;
    end if;
  END PROCESS outProcess;
  
  inProcess: PROCESS()
  BEGIN

  END PROCESS inProcess;
  
  
      
  hReady <= '1';
  hResp <= '0';

END ARCHITECTURE studentVersion;

