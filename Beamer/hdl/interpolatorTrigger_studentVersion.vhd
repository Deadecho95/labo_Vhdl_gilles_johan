------------------------------------------------
--- Autor : Johan Chenaux and Florence Villoz
--- Date : 26.02.2019
--- Description : Générateur d'impulsions de séquencement à chaque changement de polynôme
----              c'est-à-dire pour chaque nouveau segment de courbe
------------------------------------------------
ARCHITECTURE studentVersion OF interpolatorTrigger IS
  
  -- Internal signal
  -- signal counter_int : positive; NON car sur 32 bits
     signal counter_int : unsigned (counterBitNb-1 DOWNTO 0) ; -- OUI car sur 5 bitss

BEGIN  
  --- process count
  --- description : count at each rising edge 
  count: process(reset, clock)
  begin
    if reset = '1' then
      counter_int <= (others => '0');
    elsif rising_edge(clock) then
      if en = '1' then
        counter_int <= counter_int + 1;
      end if;
    end if;
  end process count;

  --- process signalOut
  --- description : change the output signal if 2**sampleCountBitNb = 0 
  ---                                           <=> counter_int + 1 = 0 
  signalOut: process(counter_int,en)
  begin
    -- change signal output when we are max of the counter
    if counter_int + 1 = 0 then
      triggerOut <= en;
    else
      triggerOut <= '0';
    end if;
  end process signalOut;
  
END ARCHITECTURE studentVersion;
