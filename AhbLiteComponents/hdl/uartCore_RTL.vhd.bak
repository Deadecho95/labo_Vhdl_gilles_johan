--==============================================================================
--
-- UART core
--
-- Implements a serial port serializer and deserializer.
--

ARCHITECTURE RTL OF uartCore IS
                                                                       -- status
  constant statusReadyId: natural := 0;
  constant statusSendingId: natural := 1;
  constant statusReceivingId: natural := 2;
                                                                   -- serializer
  signal txPeriodCounter: unsigned(scaler'range);
  signal txEn: std_uLogic;
  signal txSending: std_uLogic;
  signal txShiftCounter : unsigned(addressBitNb(txData'length+2)-1 downto 0);
  signal txShiftRegister : unsigned(txData'high+1 downto 0);
                                                                 -- deserializer
  signal rxPeriodCounter: unsigned(txPeriodCounter'range);
  signal rxEn: std_uLogic;
  signal rxDelayed, rxChanged: std_uLogic;
  signal rxShiftCounter : unsigned(txShiftCounter'range);
  signal rxReceiving: std_uLogic;
  signal rxShiftRegister : unsigned(rxData'range);
  signal rxDataReady: std_uLogic;

BEGIN
  --============================================================================
                                                                   -- serializer
                                                                 -- tx baud rate
  countTxBaudRate: process(reset, clock)
  begin
    if reset = '1' then
      txPeriodCounter <= (others => '1');
    elsif rising_edge(clock) then
      if txPeriodCounter + 1 < scaler then
        txPeriodCounter <= txPeriodCounter + 1;
      else
        txPeriodCounter <= (others => '0');
      end if;
    end if;
  end process countTxBaudRate;

  txEn <= '1' when txPeriodCounter = 1
    else '0';
                                                               -- count tx shift
  countTxShift: process(reset, clock)
  begin
    if reset = '1' then
      txShiftCounter <= (others => '0');
    elsif rising_edge(clock) then
      if txShiftCounter = 0 then
        if send = '1' then
          txShiftCounter <= txShiftCounter + 1;
        end if;
      elsif txEn = '1' then
        if txShiftCounter < txData'length + 3 then
          txShiftCounter <= txShiftCounter + 1;
        else
          txShiftCounter <= (others => '0');
        end if;
      end if;
    end if;
  end process countTxShift;

  txSending <= '1' when txShiftCounter /= 0
    else '0';
                                                                -- tx serializer
  shiftTxData: process(reset, clock)
  begin
    if reset = '1' then
      txShiftRegister <= (others => '1');
    elsif rising_edge(clock) then
      if txEn = '1' then
        if txShiftCounter = 1 then
          txShiftRegister <= unsigned(txData) & '0';
        else
          txShiftRegister <= shift_right(txShiftRegister, 1);
          txShiftRegister(txShiftRegister'high) <= '1';
        end if;
      end if;
    end if;
  end process shiftTxData;

  TxD <= txShiftRegister(0);

  --============================================================================
                                                                 -- deserializer
  delayRxd: process(reset, clock)
  begin
    if reset = '1' then
      rxDelayed <= '0';
    elsif rising_edge(clock) then
      rxDelayed <= RxD;
    end if;
  end process delayRxd;

  rxChanged <= '1' when rxDelayed /= RxD
    else '0';
                                                                 -- rx baud rate
  countRxBaudRate: process(reset, clock)
  begin
    if reset = '1' then
      rxPeriodCounter <= (others => '1');
    elsif rising_edge(clock) then
      if rxChanged = '1' then
        rxPeriodCounter <= (others => '0');
      elsif rxPeriodCounter + 1 < scaler then
        rxPeriodCounter <= rxPeriodCounter + 1;
      else
        rxPeriodCounter <= (others => '0');
      end if;
    end if;
  end process countRxBaudRate;

  rxEn <= '1' when rxPeriodCounter = shift_right(scaler-2, 1)
    else '0';
                                                               -- count rx shift
  countRxShift: process(reset, clock)
  begin
    if reset = '1' then
      rxShiftCounter <= (others => '0');
    elsif rising_edge(clock) then
      if rxShiftCounter = 0 then
        if (RxD = '0') and (rxDelayed = '1') then
          rxShiftCounter <= rxShiftCounter + 1;
        end if;
      elsif rxEn = '1' then
        if rxShiftCounter < rxData'length + 2 then
          rxShiftCounter <= rxShiftCounter + 1;
        else
          rxShiftCounter <= (others => '0');
        end if;
      end if;
    end if;
  end process countRxShift;

  rxReceiving <= '1' when rxShiftCounter /= 0
    else '0';
                                                              -- rx deserializer
  shiftRxData: process(reset, clock)
  begin
    if reset = '1' then
      rxShiftRegister <= (others => '1');
      rxData <= (others => '0');
    elsif rising_edge(clock) then
      if rxEn = '1' then
        if rxShiftCounter <= rxData'length+1 then
          rxShiftRegister <= shift_right(rxShiftRegister, 1);
          rxShiftRegister(rxShiftRegister'high) <= RxD;
        end if;
        if rxShiftCounter = rxData'length+2 then
          rxData <= std_ulogic_vector(rxShiftRegister);
        end if;
      end if;
    end if;
  end process shiftRxData;

  --============================================================================
                                                           -- monitor data ready
  checkDataReady: process(reset, clock)
  begin
    if reset = '1' then
      rxDataReady <= '0';
    elsif rising_edge(clock) then
      if (rxEn = '1') and (rxShiftCounter = rxData'length+2) then
        rxDataReady <= '1';
      elsif read = '1' then
        rxDataReady <= '0';
      end if;
    end if;
  end process checkDataReady;
                                                                  -- status word
  status <= (
    statusReadyId     => rxDataReady,
    statusSendingId   => txSending,
    statusReceivingId => rxReceiving,
    others            => '0'
  );

END ARCHITECTURE RTL;
