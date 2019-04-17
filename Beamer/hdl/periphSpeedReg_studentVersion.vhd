ARCHITECTURE studentVersion OF periphSpeedReg IS
  
  -- register for the speed
  signal speedRegister : unsigned(dataIn'range);
  
BEGIN
  
  --write a new value in the register, or put in on dataOut
  writeReadProcess: process(reset, clock)
  begin
    if reset = '1' then
      speedRegister <= (others => '0');
      
    elsif rising_edge(clock) then
      if selSpeed = '1' then
        if write = '1' then
         speedRegister <= dataIn;
        else
          dataOut <= speedRegister;
        end if; -- write
      end if; -- selControl = '1'
    end if;
  end process writeReadProcess;
  
  updatePeriod <= speedRegister;
  
END ARCHITECTURE studentVersion;

