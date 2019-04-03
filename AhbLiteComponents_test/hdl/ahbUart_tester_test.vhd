ARCHITECTURE test OF ahbUart_tester IS
                                                              -- reset and clock
  constant clockFrequency: real := 100.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal clock_int: std_uLogic := '1';
  signal reset_int: std_uLogic;
                                                          -- register definition
  constant dataRegisterAddress: natural := 0;
  constant controlRegisterAddress: natural := 1;
  constant scalerRegisterAddress: natural := 2;

  constant statusRegisterAddress: natural := 1;
  constant statusValidAddress: natural := 0;
  constant valueRegisterAddress: natural := 1;
                                                              -- AMBA bus access
  signal registerAddress: natural;
  signal registerData: integer;
  signal registerWrite: std_uLogic;
  signal registerRead: std_uLogic;
                                                                  -- UART access
  constant baudPeriodNb: positive := 4;
  signal uartData: integer;
  signal uartSend: std_uLogic;

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
    uartSend <= '0';
    wait for 1 us;
                                                              -- write baud rate
    registerAddress <= scalerRegisterAddress;
    registerData <= baudPeriodNb;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                            -- write Tx data 55h
    registerAddress <= dataRegisterAddress;
    registerData <= 16#55#;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 20*baudPeriodNb*clockPeriod;
                                                            -- write Tx data 0Fh
    registerAddress <= dataRegisterAddress;
    registerData <= 16#0F#;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                                  -- read status
    registerAddress <= statusRegisterAddress;
    registerRead <= '1', '0' after clockPeriod;
    wait for 12*baudPeriodNb*clockPeriod;
    registerRead <= '1', '0' after clockPeriod;
    wait for 20*baudPeriodNb*clockPeriod;
                                                                  -- receive AAh
    uartData <= 16#AA#;
    uartSend <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                                  -- read status
    registerAddress <= statusRegisterAddress;
    registerRead <= '1', '0' after clockPeriod;
    wait for 10*baudPeriodNb*clockPeriod;
    registerRead <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                                    -- read data
    registerAddress <= dataRegisterAddress;
    registerRead <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                                  -- read status
    registerAddress <= statusRegisterAddress;
    registerRead <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                            -- end of simulation
    wait;
  end process testSequence;

  ------------------------------------------------------------------------------
                                                              -- AMBA bus access
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

  ------------------------------------------------------------------------------
                                                                  -- UART access
  sendByte: process
    variable serialData: unsigned(7 downto 0);
  begin
                                                                 -- send stop bit
    RxD <= '1';
                                                                 -- get new word
    wait until rising_edge(uartSend);
    serialData := to_unsigned(uartData, serialData'length);
                                                                -- send start bit
    RxD <= '0';
    wait for baudPeriodNb * clockPeriod;
                                                                -- send data bits
    for index in serialData'reverse_range loop
      RxD <= serialData(index);
      wait for baudPeriodNb * clockPeriod;
    end loop;
  end process sendByte;

END ARCHITECTURE test;
