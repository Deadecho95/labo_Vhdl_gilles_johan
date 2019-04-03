ARCHITECTURE test OF morse_tester IS
                                                              -- clock and reset
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal sClock: std_uLogic := '1';
  signal sReset: std_uLogic := '1';
                                                                         -- UART
  constant uartPeriod: time := (1.0/uartBaudRate) * 1 sec;
  constant uartWriteInterval: time := 10*uartPeriod;
  signal uartInString : string(1 to 32);
  signal uartSendInString: std_uLogic;
  signal uartSendInDone: std_uLogic;
  signal uartInByte: character;
  signal uartSendInByte: std_uLogic;

BEGIN
                                                              -- clock and reset
  sClock <= not sClock after clockPeriod/2;
  clock <= transport sClock after clockPeriod*9/10;
  sReset <= '1', '0' after 2*clockPeriod;
  reset <= sReset;
  ------------------------------------------------------------------------------
                                                                -- uart Tx test
  process
  begin
    uartSendInString <= '0';
    wait for 4*uartPeriod;

    uartInString <= "tea time                        ";
    uartSendInString <= '1', '0' after 1 ns;
    wait until uartSendInDone = '1';
    wait for uartWriteInterval;

    uartInString <= "eish54v3uf2arlwpj1              ";
    uartSendInString <= '1', '0' after 1 ns;
    wait until uartSendInDone = '1';
    wait for uartWriteInterval;

    uartInString <= "tndb6xkcymgz7qo890              ";
    uartSendInString <= '1', '0' after 1 ns;
    wait until uartSendInDone = '1';
    wait for uartWriteInterval;

    wait;
  end process;

  --============================================================================
                                                                   -- uart send
  rsSendSerialString: process
    constant uartBytePeriod : time := 15*uartPeriod;
    variable commandRight: natural;
  begin

    uartSendInByte <= '0';
    uartSendInDone <= '0';

    wait until rising_edge(uartSendInString);

    commandRight := uartInString'right;
    while uartInString(commandRight) = ' ' loop
      commandRight := commandRight-1;
    end loop;

    for index in uartInString'left to commandRight loop
      uartInByte <= uartInString(index);
      uartSendInByte <= '1', '0' after 1 ns;
      wait for uartBytePeriod;
    end loop;

    uartInByte <= cr;
    uartSendInByte <= '1', '0' after 1 ns;
    wait for uartBytePeriod;

    uartSendInDone <= '1';
    wait for 1 ns;

  end process rsSendSerialString;

  rsSendSerialByte: process
    variable rxData: unsigned(uartDataBitNb-1 downto 0);
  begin
    RxD <= '1';

    wait until rising_edge(uartSendInByte);
    rxData := to_unsigned(character'pos(uartInByte), rxData'length);

    RxD <= '0';
    wait for uartPeriod;

    for index in rxData'reverse_range loop
      RxD <= rxData(index);
      wait for uartPeriod;
    end loop;

  end process rsSendSerialByte;

END ARCHITECTURE test;
