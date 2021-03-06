ARCHITECTURE studentVersion OF blockRAMControl IS
BEGIN
  
ramControlProcess : process(reset, clock)
  begin
    if reset = '1' then
      
    elsif rising_edge(clock) then
      cntIncr <= '0';
      if update = '1' and wr = '1' and sel = '1' then
        cntIncr <= '1';
      elsif update <= '0' and wr = '0' then
        IF newSample = '1' then
          cntIncr <= '1';
        ELSE
          cntIncr <= '0';
        END IF;
      end if;
    end if;
  end process ramControlProcess;
  
  memEn <= sel;
  memWr <= wr;
  
END ARCHITECTURE studentVersion;
