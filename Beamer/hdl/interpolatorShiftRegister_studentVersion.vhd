------------------------------------------------
--- Autor : Johan Chenaux and Florence Villoz
--- Date : 26.02.2019
--- Description : Registre à décalage
------------------------------------------------
ARCHITECTURE studentVersion OF interpolatorShiftRegister IS
    -- Inernal signal
  signal sample4_int: signed(sampleIn'range);
  signal sample3_int: signed(sampleIn'range);
  signal sample2_int: signed(sampleIn'range);
  signal sample1_int: signed(sampleIn'range);  
  
BEGIN
  --- process shifts
  --- description : shift the sample when shiftSamples permits
  shifts: process(reset, clock)
  begin
    if reset = '1' then
      sample4_int <= (others => '0');
      sample3_int <= (others => '0');
      sample2_int <= (others => '0');
      sample1_int <= (others => '0');      
    elsif rising_edge(clock) then
      if shiftSamples = '1' then
        sample1_int <= sample2_int;
        sample2_int <= sample3_int;
        sample3_int <= sample4_int;
        sample4_int <= sampleIn;
      end if;  
    end if;
  end process shifts;  
  
  --- process output
  --- descritpion : put signals to outputs
  sample1 <= sample1_int;
  sample2 <= sample2_int;
  sample3 <= sample3_int;
  sample4 <= sample4_int;
  
  
END ARCHITECTURE studentVersion;
