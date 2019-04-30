------------------------------------------------
--- Autor : Johan Chenaux and Florence Villoz
--- Date : 20.20.2019
--- Description : Create a sinus signal 
------------------------------------------------

ARCHITECTURE studentVersion OF lowpass IS
  
  -- Intern signal : save the old value = flip-flop  
  signal reg : unsigned(lowpassIn'high+shiftBitNb downto 0);

  
BEGIN
  -- Process filter lowpass
  -- Description : for each rising edge, load new value
  
  filter: process(reset, clock)
  begin
    if reset = '1' then
      reg <= (others => '0');
    elsif rising_edge(clock) then
      -- new reg = old reg + lowpassout + lowpassIn  
      -- new reg = old reg + reg >> 2 + lowpassIn
      reg <= reg - shift_right(reg, shiftBitNb) + lowpassIn;
    end if;
    
  end process filter;
  
  --- process output
  --- descritpion : put a signal to output
  
  -- lopassOut = reg*gain
  lowpassOut <= resize(shift_right(reg,shiftBitNb), lowpassOut'length);
  
END ARCHITECTURE studentVersion;