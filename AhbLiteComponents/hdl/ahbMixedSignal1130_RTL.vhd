--==============================================================================
--
-- AHB MAX11300 controller
--
-- Drives the MAX11300 mixed-signal I/O.
--
--------------------------------------------------------------------------------
--
-- Write registers
--
-- 00 spiDivideCount: specifies by how much the clock is divided in order to
--   generate the SPI clock signal
--
-- 01 startConvCount: specifies the number of clock periods of the start
--   conversion pulse
--
-- 02 configAddress: stores an SPI address for writing a MAX11300 configuration
--   register.
--
-- 03 configData: when written, the data is sent to the MAX11300 via the
--   SPI bus.
--
-- 04 Vout1: DAC 1 value.
--
-- 05 Vout2: DAC 2 value.
--
-- 06 gpoData: the bit values to write on the digital outputs.
--
--------------------------------------------------------------------------------
--
-- Read registers
--
-- 00 status register:
--   bit 0 tells if a new input data set is ready for reading.
--   bit 1 tells if a configuration register data can be written.
--
-- 04 Vin1: ADC 1 value.
--
-- 05 Vin2: ADC 2 value.
--
-- 06 gpiData: the bit values read from the digital inputs.
--

ARCHITECTURE RTL OF ahbMixedSignal1130 IS

  signal reset, clock: std_ulogic;
                                                     -- AHB register definitions
  constant spiDivideCountId        : natural := 0;
  constant startConvDivideCountId  : natural := 1;
  constant configAddressRegisterId : natural := 2;
  constant configDataRegisterId    : natural := 3;
  constant dac1RegisterId          : natural := 4;
  constant dac2RegisterId          : natural := 5;
  constant gpoDataRegisterId       : natural := 6;

  constant statusRegisterId        : natural := 0;
  constant statusDataReadyId         : natural := 0;
  constant statusConfigReadyId       : natural := 1;
  constant adc1RegisterId          : natural := 4;
  constant adc2RegisterId          : natural := 5;
  constant gpiDataRegisterId       : natural := 6;

  constant registerNb: positive := gpoDataRegisterId+1;
  constant registerAddresssBitNb: positive := addressBitNb(registerNb);
  signal addressReg: unsigned(registerAddresssBitNb-1 downto 0);
  signal writeReg: std_ulogic;
                                                   -- control and data registers
  subtype registerType is unsigned(hWdata'range);
  type registerArrayType is array (registerNb-1 downto 0) of registerType;
  signal wRegisterArray, rRegisterArray: registerArrayType;
                                                     -- SPI register definitions
  constant gpioAddress: natural := 16#0D#;
  constant gpi1Index: natural := 2;
  constant gpi2Index: natural := 3;
  constant gpo1Index: natural := 4;
  constant gpo2Index: natural := 5;
  constant adc1Address: natural := 16#40#;
  constant adc2Address: natural := 16#41#;
  constant dac1Address: natural := 16#60#;
  constant dac2Address: natural := 16#61#;
                                                               -- SPI bus access
  signal spiClockDivideCount: registerType;
  signal spiClockDividerCounter: unsigned(spiClockDivideCount'range);
  signal spiClockDivideDone: std_ulogic;
  constant spiAddressLength: positive := 8;
  constant spiDataLength: positive := 2*8;
  constant spiFrameLength: positive := spiAddressLength + spiDataLength;
  signal spiFrameCounter: unsigned(addressBitNb(spiFrameLength+1)-1 downto 0);
  signal spiShiftRegister: unsigned(spiFrameLength-1 downto 0);
  signal spiSend, spiSent: std_ulogic;
  signal spiClock: std_ulogic;
  signal spiAddress: unsigned(spiAddressLength-1 downto 0);
  signal spiDataOut: unsigned(spiDataLength-1 downto 0);
  signal spiDataIn: unsigned(spiDataLength-1 downto 0);
  signal spiSlaveSelect: std_ulogic;
                                                       -- conversion start pulse
  signal convertPulseCount: registerType;
  signal convertPulseCounter: unsigned(hWdata'range);
  signal convertPulseEnd: std_ulogic;
                                                                          -- FSM
  type ioControlStateType is (
    idle, startConv,
    writeDac1, waitDac1, writeDac2, waitDac2, writeGpo, waitGpo,
    readGpi, waitGpi, readAdc1, waitAdc1, readAdc2, waitAdc2
  );
  signal ioControlState: ioControlStateType;
                                                                   -- data value
  signal adcData: signed(hWdata'range);
  signal adcDataValid: std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                              -- reset and clock
  reset <= not hReset_n;
  clock <= hClk;

  --============================================================================
                                                         -- address and controls
  storeControls: process(reset, clock)
  begin
    if reset = '1' then
      addressReg <= (others => '0');
      writeReg <= '0';
    elsif rising_edge(clock) then
      writeReg <= '0';
      if (hSel = '1') and (hTrans = transNonSeq) then
        addressReg <= hAddr(addressReg'range);
        writeReg <= hWrite;
      end if;
    end if;
  end process storeControls;

  --============================================================================
                                                                    -- registers
  updateWriteRegisters: process(reset, clock)
  begin
    if reset = '1' then
      wRegisterArray <= (others => (others => '0'));
    elsif rising_edge(clock) then
      if writeReg = '1' then
        wRegisterArray(to_integer(addressReg)) <= unsigned(hWData);
      end if;
    end if;
  end process updateWriteRegisters;

  spiClockDivideCount <= wRegisterArray(spiDivideCountId);
  convertPulseCount <= wRegisterArray(startConvDivideCountId);

  --============================================================================
                                                               -- controller FSM
  ioSequencer: process(reset, clock)
  begin
    if reset = '1' then
      ioControlState <= idle;
    elsif rising_edge(clock) then
      case ioControlState is
        when idle =>
          if enable = '1' then
            ioControlState <= startConv;
          end if;
        when startConv =>
          if convertPulseEnd = '1' then
            ioControlState <= writeDac1;
          end if;
        when writeDac1 =>
          ioControlState <= waitDac1;
        when waitDac1 =>
          if spiSent = '1' then
            ioControlState <= writeDac2;
          end if;
        when writeDac2 =>
          ioControlState <= waitDac2;
        when waitDac2 =>
          if spiSent = '1' then
            ioControlState <= writeGpo;
          end if;
        when writeGpo =>
          ioControlState <= waitGpo;
        when waitGpo =>
          if spiSent = '1' then
            ioControlState <= readGpi;
          end if;
        when readGpi =>
          ioControlState <= waitGpi;
        when waitGpi =>
          if spiSent = '1' then
            ioControlState <= readAdc1;
          end if;
        when readAdc1 =>
          ioControlState <= waitAdc1;
        when waitAdc1 =>
          if spiSent = '1' then
            ioControlState <= readAdc2;
          end if;
        when readAdc2 =>
          ioControlState <= waitAdc2;
        when waitAdc2 =>
          if spiSent = '1' then
            ioControlState <= idle;
          end if;
      end case;
    end if;
  end process ioSequencer;
                                                          -- controller controls
  ioControls: process(ioControlState)
  begin
    CNVT_n <= not('0');
    spiSend <= '0';
    spiAddress <= (others => '-');
    spiDataOut <= (others => '-');
    case ioControlState is
      when startConv =>
        CNVT_n <= not('1');
      when writeDac1 =>
        spiSend <= '1';
      when waitDac1 =>
        spiAddress <= to_unsigned(dac1Address*2, spiAddress'length);
        spiDataOut <= wRegisterArray(dac1RegisterId);
      when writeDac2 =>
        spiSend <= '1';
      when waitDac2 =>
        spiAddress <= to_unsigned(dac2Address*2, spiAddress'length);
        spiDataOut <= wRegisterArray(dac2RegisterId);
      when writeGpo =>
        spiSend <= '1';
      when waitGpo =>
        spiAddress <= to_unsigned(gpioAddress*2, spiAddress'length);
        spiDataOut <= wRegisterArray(gpoDataRegisterId);
      when readGpi =>
        spiSend <= '1';
      when waitGpi =>
        spiAddress <= to_unsigned(gpioAddress*2+1, spiAddress'length);
      when readAdc1 =>
        spiSend <= '1';
      when waitAdc1 =>
        spiAddress <= to_unsigned(adc1Address*2+1, spiAddress'length);
      when readAdc2 =>
        spiSend <= '1';
      when waitAdc2 =>
        spiAddress <= to_unsigned(adc2Address*2+1, spiAddress'length);
      when others => null;
    end case;
  end process ioControls;
                                               -- conversion start pulse counter
  countConversionStartLength: process(reset, clock)
  begin
    if reset = '1' then
      convertPulseCounter <= (others => '0');
    elsif rising_edge(clock) then
      if convertPulseCounter = 0 then
        if enable = '1' then
          convertPulseCounter <= convertPulseCounter + 1;
        end if;
      else
        if convertPulseEnd = '0' then
          convertPulseCounter <= convertPulseCounter + 1;
        else
          convertPulseCounter <= (others => '0');
        end if;
      end if;
    end if;
  end process countConversionStartLength;

  convertPulseEnd <= '1' when convertPulseCounter >= convertPulseCount - 1
    else '0';

  --============================================================================
                                                                -- data readback
  hReady <= '1';  -- no wait state
  hResp  <= '0';  -- data OK
                                                    -- update AHB read registers
  updateReadRegisters: process(reset, clock)
  begin
    if reset = '1' then
      rRegisterArray <= (others => (others => '0'));
    elsif rising_edge(clock) then
      rRegisterArray(statusRegisterId) <= (others => '0');
      if ioControlState = idle then
        rRegisterArray(statusRegisterId)(statusDataReadyId) <= '1';
        rRegisterArray(statusRegisterId)(statusConfigReadyId) <= '1';
      elsif spiSent = '1' then
        case ioControlState is
          when waitGpi =>
            rRegisterArray(gpiDataRegisterId)(gpi1Index) <= spiDataIn(gpi1Index);
            rRegisterArray(gpiDataRegisterId)(gpi2Index) <= spiDataIn(gpi2Index);
          when waitAdc1 =>
            rRegisterArray(adc1RegisterId) <= spiDataIn;
          when waitAdc2 =>
            rRegisterArray(adc2RegisterId) <= spiDataIn;
          when others => null;
        end case;
      end if;
    end if;
  end process updateReadRegisters;
                                                     -- select AHB read register
  selectDataRegister: process(addressReg, rRegisterArray)
  begin
    case to_integer(addressReg) is
      when statusRegisterId  => hRData <= std_ulogic_vector(rRegisterArray(statusRegisterId));
      when adc1RegisterId    => hRData <= std_ulogic_vector(rRegisterArray(adc1RegisterId));
      when adc2RegisterId    => hRData <= std_ulogic_vector(rRegisterArray(adc2RegisterId));
      when gpiDataRegisterId => hRData <= std_ulogic_vector(rRegisterArray(gpiDataRegisterId));
      when others            => hRData <= (others => '-');
    end case;
  end process selectDataRegister;

  --============================================================================
                                                          -- SPI clock generator
  generateSpiClock: process(reset, clock)
  begin
    if reset = '1' then
      spiClockDividerCounter <= (others => '0');
      spiClock <= '0';
    elsif rising_edge(clock) then
      if spiClockDivideDone = '1' then
        spiClockDividerCounter <= (others => '0');
        spiClock <= not spiClock;
      else
        spiClockDividerCounter <= spiClockDividerCounter + 1;
      end if;
    end if;
  end process generateSpiClock;

  spiClockDivideDone <= '1' when spiClockDividerCounter >= spiClockDivideCount/2 - 1
    else '0';
                                                            -- SPI frame counter
  countSpiFrame: process(reset, clock)
  begin
    if reset = '1' then
      spiFrameCounter <= (others => '0');
      spiSent <= '0';
    elsif rising_edge(clock) then
      spiSent <= '0';
      if spiFrameCounter = 0 then
        if spiSend = '1' then
          spiFrameCounter <= spiFrameCounter + 1;
        end if;
      elsif spiFrameCounter = 1 then
        if (spiClockDivideDone = '1') and (spiClock = '1') then
          spiFrameCounter <= spiFrameCounter + 1;
        end if;
      else
        if (spiClockDivideDone = '1') and (spiClock = '1') then
          if spiFrameCounter <= spiFrameLength then
            spiFrameCounter <= spiFrameCounter + 1;
          else
            spiFrameCounter <= (others => '0');
            spiSent <= '1';
          end if;
        end if;
      end if;
    end if;
  end process countSpiFrame;
                                                           -- SPI shift register
  shiftSpiData: process(reset, clock)
  begin
    if reset = '1' then
      spiShiftRegister <= (others => '0');
      spiDataIn <= (others => '0');
    elsif rising_edge(clock) then
      if spiFrameCounter = 1 then
        spiShiftRegister <= spiAddress & spiDataOut;
      elsif spiSlaveSelect = '1' then
        if (spiClockDivideDone = '1') and (spiClock = '1') then
          spiShiftRegister <= shift_left(spiShiftRegister, 1);
          spiDataIn <= shift_left(spiDataIn, 1);
          spiDataIn(0) <= MISO;
        end if;
      end if;
    end if;
  end process shiftSpiData;
                                                              -- SPI bus signals
  spiSlaveSelect <= '1' when spiFrameCounter > 1 else '0';
  SCK <= spiClock when spiSlaveSelect = '1' else '0';
  SS_n <= not spiSlaveSelect;
  MOSI <= spiShiftRegister(spiShiftRegister'high);

END ARCHITECTURE RTL;
