ARCHITECTURE studentVersion OF blockRAMAddressCounter IS
  
  signal cntAddr : unsigned(addr'range);
  
BEGIN
  
  counterAddressProcess: process(clock, reset)
  begin
    if reset = '1' then
      cntAddr <= (others => '0');
    elsif rising_edge(clock) then
        
      end if; -- updatePattern
  end process counterAddressProcess;
  
  
  addr <= (others => '0');
END ARCHITECTURE studentVersion;
