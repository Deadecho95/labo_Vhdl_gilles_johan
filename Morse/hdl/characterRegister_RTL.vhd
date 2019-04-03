ARCHITECTURE RTL OF characterRegister IS
BEGIN

  storeCharacter: process(reset, clock)
  begin
    if reset = '1' then
      charOut <= (others => '0');
    elsif rising_edge(clock) then
      if charValid = '1' then
        charOut <= charIn;
      end if;
    end if;
  end process storeCharacter;

END ARCHITECTURE RTL;
