ARCHITECTURE studentVersion OF periphSpeedController IS
  
  signal cntAddr : unsigned(updatePeriod'range);
  
BEGIN
  
  counterAddressProcess: process(clock, reset)
  begin
    if reset = '1' then
      cntAddr <= (others => '0');
    elsif rising_edge(clock) then
      enableOut <= '0';
      if enableIn = '1' then
        cntAddr <= cntAddr + 1;
      end if;   
      IF updatePeriod = cntAddr then
          cntAddr <= (others => '0');
          enableOut <= '1';  
      END IF;
    end if;
  
  end process counterAddressProcess;
  
END ARCHITECTURE studentVersion;
