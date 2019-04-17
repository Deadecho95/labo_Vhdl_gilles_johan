------------------------------------------------
--- Autor : Johan Chenaux and Florence Villoz
--- Date : 20.20.2019
--- Description : Create a sawtooth signal 
------------------------------------------------

ARCHITECTURE studentVersion OF sawtoothGen IS
  signal counter_int : unsigned(sawtooth'range);
begin
  
  --- process count
  --- description : count at each rising edge 
  count: process(reset, clock)
    begin
      if reset = '1' then
        counter_int <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        counter_int <= counter_int + step;
      end if;
    end if;
  end process count;
  
  --- process out
  --- descritpion : put a signal to output
  sawtooth <= counter_int;
    
END ARCHITECTURE studentVersion;

