ARCHITECTURE studentVersion OF periphSpeedReg IS
  
  -- register for the speed
  signal speedRegister : unsigned(dataIn'range);
  
BEGIN
  
  --write a new value in the register, or put in on dataOut
  writeProcess: process(reset, clock)
  begin
    if reset = '1' then
      speedRegister <= (others => '0');
      
    elsif rising_edge(clock) then
      if en = '1' then
        if write = '1' then
         speedRegister <= unsigned(dataIn);
        end if; -- write
      end if; -- selControl = '1'
    end if;
  end process writeProcess;
  
  readProcess: process(en, speedRegister )
  begin
    if en = '1' then
      dataOut <= std_logic_vector(speedRegister); 
    else
      dataOut <= (others => 'Z'); 
    end if;
  end process readProcess;
  
  updatePeriod <= speedRegister;
  
END ARCHITECTURE studentVersion;

