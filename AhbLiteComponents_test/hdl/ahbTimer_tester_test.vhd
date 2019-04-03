ARCHITECTURE test OF ahbTimer_tester IS

  constant clockFrequency: real := 100.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal clock_int: std_uLogic := '1';
  signal reset_int: std_uLogic;

  signal registerAddress: natural;
  signal registerData: integer;
  signal registerWrite: std_uLogic;
  signal registerRead: std_uLogic;

BEGIN
  ------------------------------------------------------------------------------
                                                              -- reset and clock
  reset_int <= '1', '0' after 2*clockPeriod;
  hReset_n <= not(reset_int);

  clock_int <= not clock_int after clockPeriod/2;
  hClk <= transport clock_int after clockPeriod*9.0/10.0;

  ------------------------------------------------------------------------------
                                                                -- test sequence
  testSequence: process
  begin
    registerAddress <= 0;
    registerData <= 0;
    registerWrite <= '0';
    registerRead <= '0';
    wait for 1 us;
                                                                 -- write period
    registerAddress <= 0;
    registerData <= 128;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 3*clockPeriod;
                                                        -- write positive offset
    registerAddress <= 2;
    registerData <= 1;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 3*clockPeriod;
                                                        -- write negative offset
    registerAddress <= 4;
    registerData <= -1;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 3*clockPeriod;
    registerAddress <= 5;
    registerData <= -1;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 3*clockPeriod;
                                                          -- write last register
    registerAddress <= 2*enableNb;
    registerData <= 64;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 1 us;
                                                                -- read register
    registerAddress <= 6;
    registerRead <= '1', '0' after clockPeriod;
    wait for 3*clockPeriod;

    wait;
  end process testSequence;

  ------------------------------------------------------------------------------
                                                                   -- bus access
  busAccess: process
    variable writeAccess: boolean;
  begin
    hAddr <= (others => '-');
    hWData <= (others => '-');
    hTrans <= transIdle;
    hSel <= '0';
    hWrite <= '0';
    wait on registerWrite, registerRead;
    writeAccess := false;
    if rising_edge(registerWrite) then
      writeAccess := true;
    end if;
                                                -- phase 1: address and controls
    wait until rising_edge(clock_int);
    hAddr <= to_unsigned(registerAddress, hAddr'length);
    hTrans <= transNonSeq;
    hSel <= '1';
    if writeAccess then
      hWrite <= '1';
    end if;
                                                                -- phase 2: data
    wait until rising_edge(clock_int);
    hAddr <= (others => '-');
    hTrans <= transIdle;
    hSel <= '0';
    hWrite <= '0';
    if writeAccess then
      hWData <= std_uLogic_vector(to_signed(registerData, hWData'length));
    end if;
    wait until rising_edge(clock_int);
  end process;

END ARCHITECTURE test;
