ARCHITECTURE test OF ahbGpio_tester IS
                                                              -- reset and clock
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal clock_int: std_uLogic := '1';
  signal reset_int: std_uLogic;
                                                          -- register definition
  constant peripheralBaseAddress: natural := 2**4;
  constant dataRegisterAddress: natural := 0;
  constant outputEnableRegisterAddress: natural := 1;
                                                              -- AMBA bus access
  signal registerAddress: natural;
  signal registerData: integer;
  signal registerWrite: std_uLogic;
  signal registerRead: std_uLogic;
  signal writeFlag: std_uLogic;
  signal writeData: integer;
                                                                  -- GPIO access
  signal ioData: integer;
  signal ioMask: integer;

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
    ioData <= 0;
    ioMask <= 0;
    wait for 100 ns;

    ----------------------------------------------------------------------------
                                                                  -- simple test
                                                                -- write en mask
    assert false
      report "----------------------------------------" & cr & "           " &
             "Writing data on the GPIO" &
             cr & "         " & "........................................"
      severity note;
    ioData <= 16#AA#;
    ioMask <= 16#0F#; wait for 0 ns;
    registerAddress <= outputEnableRegisterAddress;
    registerData <= ioMask;
    registerWrite <= '1', '0' after clockPeriod/2;
    wait for 4*clockPeriod;
                                                        -- write output data 55h
    registerAddress <= dataRegisterAddress;
    registerData <= 16#55#;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
    assert io = x"A5"
      report cr & cr & "Write failed"
      severity error;
                                                                    -- read data
    assert false
      report "----------------------------------------" & cr & "           " &
             "Reading data from the GPIO" &
             cr & "         " & "........................................"
      severity note;
    registerAddress <= dataRegisterAddress;
    registerRead <= '1', '0' after clockPeriod;
    for index in 1 to 3 loop
      wait until rising_edge(clock_int);
    end loop;
    assert hRData(io'range) = x"A5"
      report cr & cr & "Read failed"
      severity error;
    wait for 100 ns;

    ----------------------------------------------------------------------------
                                           -- test with a different base address
                                                                -- write en mask
    assert false
      report "----------------------------------------" & cr & "           " &
            "Writing data to a different base address" &
             cr & "         " & "........................................"
      severity note;
    ioData <= 16#AA#;
    ioMask <= 16#F0#; wait for 0 ns;
    registerAddress <= peripheralBaseAddress + outputEnableRegisterAddress;
    registerData <= ioMask;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                        -- write output data 55h
    registerAddress <= peripheralBaseAddress + dataRegisterAddress;
    registerData <= 16#55#;
    registerWrite <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                                    -- read data
    registerAddress <= peripheralBaseAddress + dataRegisterAddress;
    registerRead <= '1', '0' after clockPeriod;
    for index in 1 to 3 loop
      wait until rising_edge(clock_int);
    end loop;
    assert hRData(io'range) = x"5A"
      report cr & cr & "Read failed"
      severity error;
    wait for 4*clockPeriod;

    ----------------------------------------------------------------------------
                                                          -- access back to back
                                                                -- write en mask
    assert false
      report "----------------------------------------" & cr & "           " &
             "Accessing at full speed" &
             cr & "         " & "........................................"
      severity note;
    wait until rising_edge(clock_int);
    ioData <= 16#AA#;
    ioMask <= 16#0F#; wait for 0 ns;
    registerAddress <= outputEnableRegisterAddress;
    registerData <= ioMask;
    registerWrite <= '1' after clockPeriod/4, '0' after clockPeriod/2;
                                                        -- write output data 55h
    wait until rising_edge(clock_int);
    registerAddress <= dataRegisterAddress;
    registerData <= 16#55#;
    registerWrite <= '1' after clockPeriod/4, '0' after clockPeriod/2;
                                                                    -- read data
    wait until rising_edge(clock_int);
    registerAddress <= dataRegisterAddress;
    registerRead <= '1' after clockPeriod/4, '0' after clockPeriod/2;
    for index in 1 to 3 loop
      wait until rising_edge(clock_int);
    end loop;
    assert hRData(io'range) = x"A5"
      report cr & cr & "Read failed"
      severity error;
    wait for 4*clockPeriod;
                                                            -- end of simulation
    wait for 100 ns;
    assert false
      report "----------------------------------------" & cr & "              " &
             "End of tests" &
             cr & "            " & "........................................"
      severity failure;
    wait;
  end process testSequence;

  ------------------------------------------------------------------------------
                                                              -- AMBA bus access
                                                -- phase 1: address and controls
  busAccess1: process
    variable writeAccess: boolean := false;
  begin
    wait on reset_int, registerWrite, registerRead;
    if falling_edge(reset_int) then
      hAddr <= (others => '-');
      hTrans <= transIdle;
      hSel <= '0';
      writeFlag <= '0';
    end if;
    if rising_edge(registerWrite) or rising_edge(registerRead) then
      writeAccess := false;
      if rising_edge(registerWrite) then
        writeAccess := true;
      end if;
      wait until rising_edge(clock_int);
      hAddr <= to_unsigned(registerAddress, hAddr'length),
        (others => '-') after clockPeriod + 1 ns;
      hTrans <= transNonSeq, transIdle after clockPeriod + 1 ns;
      hSel <= '1', '0' after clockPeriod + 1 ns;
      if writeAccess then
        writeFlag <= '1', '0' after clockPeriod + 1 ns;
        writeData <= registerData;
      end if;
    end if;
  end process busAccess1;

  hWrite <= writeFlag;
                                                                -- phase 2: data
  busAccess2: process
  begin
    wait until rising_edge(clock_int);
    hWData <= (others => '-');
    if writeFlag = '1' then
      hWData <= std_uLogic_vector(to_signed(writeData, hWData'length));
    end if;
  end process busAccess2;


  ------------------------------------------------------------------------------
                                                                  -- GPIO access
  linesAccess: process(ioData, ioMask)
    variable ioDataVector: unsigned(io'range);
    variable ioMaskVector: unsigned(io'range);
  begin
    ioDataVector := to_unsigned(ioData, ioDataVector'length);
    ioMaskVector := to_unsigned(ioMask, ioMaskVector'length);
    for index in io'range loop
      if ioMaskVector(index) = '1' then
        io(index) <= 'Z';
      else
        io(index) <= ioDataVector(index);
      end if;
    end loop;
  end process;

END ARCHITECTURE test;
