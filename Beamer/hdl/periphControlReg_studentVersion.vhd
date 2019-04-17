ARCHITECTURE studentVersion OF periphControlReg IS
    
  -- bit position of control register address
  constant isRunningBit : integer := 0;
  constant updatePatternBit : integer := 1;
  constant interpolateLinearBit : integer := 2;
  
  -- register for the control bits
  signal ctrlRegister : unsigned(dataIn'range);
  
BEGIN
  
  --write a new value in the register, or put in on dataOut
  writeReadProcess: process(reset, clock)
  begin
    if reset = '1' then
      ctrRegister <= (others => '0');
      
    elsif rising_edge(clock) then
      if selControl = '1' then
        if write = '1' then
         ctrlRegister <= dataIn;
        else
          dataOut <= ctrlRegister;
        end if; -- write
      end if; -- selControl = '1'
    end if;
  end process writeReadProcess;
  
  -- update the output signals for the next blocks
  outputProcess : process(ctrlRegister)
  begin
    run <= ctrlRegister(isRuningBit);
    interpolateLinear <= ctrlRegister(interpolateLinearBit);
    updatePattern <= ctrlRegister(updatePatternBit);
    patternSize <= shift_right(ctrlRegister, 3);
  end process outputProcess;

END ARCHITECTURE studentVersion;
