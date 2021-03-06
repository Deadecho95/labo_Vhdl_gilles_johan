ARCHITECTURE studentVersion OF periphAddressDecoder IS
  
  -- registers
  constant ctrlRegisterAddress : integer := 0; -- write access from uP
  constant speedRegisterAddress : integer := 1; 
  constant xRegisterAddress : integer := 2;
  constant yRegisterAddress : integer := 3;
  
BEGIN
  addressSelection : process(addr)
  begin 
    selControl  <= '0';
    --  selSize     <= '0';
    selSpeed    <= '0';
    selX        <= '0';
    selY        <= '0';

    if addr = ctrlRegisterAddress then
      selControl  <= '1';
    elsif addr = speedRegisterAddress then
      selSpeed    <= '1';
    elsif addr = xRegisterAddress then
      selX        <= '1';
    elsif addr = yRegisterAddress then
      selY        <= '1';
    end if;
  end process addressSelection;
  
  selZ        <= '0';
  
END ARCHITECTURE studentVersion;

