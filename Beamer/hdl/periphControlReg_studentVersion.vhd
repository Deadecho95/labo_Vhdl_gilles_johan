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
      ctrlRegister <= (others => '0');
      
    elsif rising_edge(clock) then
      if en = '1' then
        if write = '1' then
         ctrlRegister <= unsigned(dataIn);
        end if; -- write
      end if; -- selControl = '1'
    end if;
  end process writeReadProcess;
  
  readProcess: process(en, ctrlRegister )
  begin
    if en = '1' then
      dataOut <= std_logic_vector(ctrlRegister); 
    else
      dataOut <= (others => 'Z'); 
    end if;
  end process readProcess;
  
  -- update the output signals for the next blocks
  outputProcess : process(ctrlRegister)
  begin
    run <= ctrlRegister(isRunningBit);
    interpolateLinear <= ctrlRegister(interpolateLinearBit);
    updatePattern <= ctrlRegister(updatePatternBit);
    patternSize <= resize(shift_right(ctrlRegister, 3), patternSize'length);
  end process outputProcess;

END ARCHITECTURE studentVersion;
