ARCHITECTURE sim OF ADC_670 IS

  constant t_DC: time := 700 ns;
  constant t_C : time :=  10 us;
  constant t_TD: time := 250 ns;
  constant t_DT: time := 150 ns;

  signal vInReal : real;
  signal vInInt : integer;
  signal vIn, vInSampled : signed(D'range);
  signal status_int : std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                            -- voltage to number
  vInReal <= (VinHI-VinLOW)/10.0E-3;
  vInInt <= integer(vInReal);

  process(vInInt)
  begin
                                                              -- straight binary
    if BPO_UPO_n = '0' then
      vIn <= signed(to_unsigned(vInInt, vIn'length));
                                                                -- offset binary
    elsif FORMAT = '0' then
      vIn <= signed(to_unsigned(vInInt+2**(vIn'length-1), vIn'length));
                                                                -- 2s complement
    else
      vIn <= to_signed(vInInt, vIn'length);
    end if;
  end process;

  ------------------------------------------------------------------------------
                                                                         -- data
  process
  begin
    D <= (others => 'Z');
    wait on CS_n, CE_n, R_W;
                                            -- write or single conversion access
    if (CS_n = '0') and (CE_n = '0') and (R_W = '0') then
      vInSampled <= vIn;
      wait until status_int = '1';
      wait until status_int = '0';
                                                     -- single conversion access
      if (CS_n = '0') and (CE_n = '0') and (R_W = '1') then
        wait for t_TD;
        D <= vInSampled;
        wait until (CS_n = '1') or (CE_n = '1');
        wait for t_DT;
      end if;
                                                                  -- read access
    elsif (CS_n = '0') and (CE_n = '0') and (R_W = '1') then
      wait for t_TD;
      D <= vInSampled;
      wait until (CS_n = '1') or (CE_n = '1');
      wait for t_DT;
    end if;
  end process;

  ------------------------------------------------------------------------------
                                                                       -- status
  process
  begin
    status_int <= '0';
    wait until (R_W = '0') and (CS_n = '0') and (CE_n = '0');
    wait for t_DC;
    status_int <= '1';
    wait for t_c;
  end process;

  STATUS <= status_int;

END ARCHITECTURE sim;
