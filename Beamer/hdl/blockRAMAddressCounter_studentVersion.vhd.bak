ARCHITECTURE studentVersion OF blockRAMAddressCounter IS
  
  signal cntAddr : unsigned(addr'range);
  signal oldUpdatePattern : std_ulogic;
  
BEGIN
  
  counterAddressProcess: process(clock, reset)
  begin
    if reset = '1' then
      cntAddr <= (others => '0');
    elsif rising_edge(clock) then
      if updateMem = '1'  and oldUpdatePattern = '0' then
        cntAddr <= (others => '0'); -- reset counter on the rising edge of updatePattern
      elsif updateMem = '1' and en = '1' then
        cntAddr <= cntAddr + 1; -- 
      else 
        IF en = '1' then
          cntAddr <= cntAddr + 1;
          if cntAddr = patternSize then
            cntAddr <= (others => '0');
          end if;
        END IF;
      end if;
      oldUpdatePattern <= updateMem;
      
    end if; -- updatePattern
  end process counterAddressProcess;
  
  addr <= cntAddr;

END ARCHITECTURE studentVersion;
