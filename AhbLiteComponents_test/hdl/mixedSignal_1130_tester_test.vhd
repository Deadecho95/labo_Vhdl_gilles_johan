library ieee;
  use ieee.math_real.all;

ARCHITECTURE test OF mixedSignal_1130_tester IS
                                                                   -- SPI clock
  constant spiFrequency: real := 10.0E6;
  constant spiPeriod: time := (1.0/spiFrequency) * 1 sec;
  signal spiClock: std_uLogic := '1';
                                                                     -- SPI data
  constant spiAddressLength: positive := 8;
  constant spiDataLength: positive := 2*8;
  constant spiFrameLength: positive := spiAddressLength + spiDataLength;
  signal spiSend: std_ulogic;
  signal spiRisingEdgeClock: std_ulogic;
  signal spiAddress: natural;
  signal spiDataOut: std_ulogic_vector(spiDataLength-1 downto 0);
  signal spiDataIn: std_ulogic_vector(spiDataLength-1 downto 0);
  signal spiSlaveSelect: std_ulogic;
                                                                -- SPI registers
  constant gpioAddress: natural := 16#0D#;
  constant gpi1Index: natural := 2;
  constant gpi2Index: natural := 3;
  constant gpo1Index: natural := 4;
  constant gpo2Index: natural := 5;
  constant adc1Address: natural := 16#40#;
  constant adc2Address: natural := 16#41#;
  constant dac1Address: natural := 16#60#;
  constant dac2Address: natural := 16#61#;
                                                                -- sampling rate
  constant samplingFrequency: real := 50.0E3;
  constant samplingPeriod: time := (1.0/samplingFrequency) * 1 sec;
  constant samplingEnPulseWidth: time := 0.5 us;
  signal samplingEn: std_uLogic := '0';
                                                               -- analog signals
  constant sineFrequency: real := samplingFrequency/10.0;
  constant sinePeriod: time := 1 sec / sineFrequency;
  constant outAmplitude: real := 10.0;
  signal tReal: real := 0.0;
  signal dacReal1, dacReal2, adcReal1, adcReal2: real := 0.0;
  signal vIn1_int, vIn2_int: real := 0.0;
  signal vIn1Sampled, vIn2Sampled : unsigned(spiDataLength-1 downto 0);
                                                              -- digital signals
  signal dIn1Sampled, dIn2Sampled : std_ulogic;
  signal dOut1Ref, dOut2Ref : std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                                    -- SPI clock
  spiClock <= not spiClock after spiPeriod/2;

  ------------------------------------------------------------------------------
                                                                    -- SPI clock
  samplingEn <= '0' after samplingEnPulseWidth when samplingEn = '1'
    else '1' after samplingPeriod - samplingEnPulseWidth;
  CNVT_n <= not samplingEn;

  ------------------------------------------------------------------------------
                                                                -- test sequence
  testSequence: process
  begin
    spiSend <= '0';
    spiDataOut <= (others => '0');
    wait for 1 us;

    spiAddress <= 16#F0#;
    spiDataOut <= X"CCAA";
    spiSend <= '1', '0' after 1 ns;

    while true loop
      wait until rising_edge(samplingEn);
                                                              -- send DAC1 value
      spiAddress <= 2*dac1Address;
      spiDataOut <= std_ulogic_vector(to_unsigned(
        integer(dacReal1 / outAmplitude * 2.0**spiDataLength),
        spiDataOut'length
      ));
      spiSend <= '1', '0' after 1 ns;
      wait until falling_edge(spiSlaveSelect);
                                                              -- send DAC2 value
      spiAddress <= 2*dac2Address;
      spiDataOut <= std_ulogic_vector(to_unsigned(
        integer(dacReal2 / outAmplitude * 2.0**spiDataLength),
        spiDataOut'length
      ));
      spiSend <= '1', '0' after 1 ns;
      wait until falling_edge(spiSlaveSelect);
                                                              -- send GPO values
      spiAddress <= 2*gpioAddress;
      spiDataOut <= (others => '0');
      spiDataOut(gpo1Index) <= dOut1Ref;
      spiDataOut(gpo2Index) <= dOut2Ref;
      spiSend <= '1', '0' after 1 ns;
      wait until falling_edge(spiSlaveSelect);
                                                              -- read GPI values
      spiAddress <= 2*gpioAddress + 1;
      spiDataOut <= (others => '-');
      spiSend <= '1', '0' after 1 ns;
      wait until falling_edge(spiSlaveSelect);
      dIn1Sampled <= spiDataIn(gpi1Index);
      dIn2Sampled <= spiDataIn(gpi2Index);
                                                              -- read ADC1 value
      spiAddress <= 2*adc1Address + 1;
      spiDataOut <= (others => '-');
      spiSend <= '1', '0' after 1 ns;
      wait until falling_edge(spiSlaveSelect);
      vIn1Sampled <= unsigned(spiDataIn);
                                                              -- read ADC2 value
      spiAddress <= 2*adc2Address + 1;
      spiDataOut <= (others => '-');
      spiSend <= '1', '0' after 1 ns;
      wait until falling_edge(spiSlaveSelect);
      wait for 1 ns;
      vIn2Sampled <= unsigned(spiDataIn);
    end loop;
  end process testSequence;

  ------------------------------------------------------------------------------
                                                                -- SPI send data
  spiRisingEdgeClock <= spiClock when (CPOL xor CPHA) = '0'
    else not spiClock;

  spiExchangeData: process
    variable outputShiftRegister: unsigned(spiFrameLength-1 downto 0);
    variable inputShiftRegister: unsigned(spiDataLength-1 downto 0);
  begin
    spiSlaveSelect <= '0';
    MOSI <= '-';
                                                             -- wait for sending
    wait until rising_edge(spiSend);
                                                        -- activate slave enable
    wait until falling_edge(spiRisingEdgeClock);
    spiSlaveSelect <= '1';
    outputShiftRegister := to_unsigned(spiAddress, spiAddressLength) &
      unsigned(spiDataOut);
    inputShiftRegister := (others => '-');
    MOSI <= outputShiftRegister(outputShiftRegister'high);
                                                               -- read first bit
    wait until rising_edge(spiRisingEdgeClock);
    inputShiftRegister(0) := MISO;
                                                                 -- loop on bits
    for index in 1 to outputShiftRegister'length-1 loop
                                                                     -- send bit
      wait until falling_edge(spiRisingEdgeClock);
      outputShiftRegister := shift_left(outputShiftRegister, 1);
      MOSI <= outputShiftRegister(outputShiftRegister'high);
                                                                     -- read bit
      wait until rising_edge(spiRisingEdgeClock);
      inputShiftRegister := shift_left(inputShiftRegister, 1);
      inputShiftRegister(0) := MISO;
    end loop;
                                                      -- deactivate slave enable
    wait until falling_edge(spiRisingEdgeClock);
    spiDataIn <= std_ulogic_vector(inputShiftRegister);

  end process spiExchangeData;

  SCK <= CPOL when spiSlaveSelect = '0'
    else spiClock;
  SS_n <= not spiSlaveSelect;

  ------------------------------------------------------------------------------
                                                                 -- time signals
  process(spiClock)
  begin
    if rising_edge(spiClock) then
      tReal <= tReal + 1.0/spiFrequency;
    end if;
  end process;

  dacReal1 <= outAmplitude * ( sin(2.0*math_pi*sineFrequency*tReal) + 1.0) / 2.0;
  dacReal2 <= outAmplitude * ( cos(2.0*math_pi*sineFrequency*tReal) + 1.0) / 2.0;
  vIn1_int <= outAmplitude * ( sin(2.0*math_pi*sineFrequency/2.0*tReal) + 1.0) / 2.0;
  vIn2_int <= outAmplitude * ( cos(2.0*math_pi*sineFrequency/2.0*tReal) + 1.0) / 2.0;
  vIn1 <= vIn1_int;
  vIn2 <= vIn2_int;

  dIn1 <= '1' when vIn1_int > outAmplitude/2.0 else '0';
  dIn2 <= '1' when vIn2_int > outAmplitude/2.0 else '0';
  dOut1Ref <= '1' when dacReal1 > outAmplitude/2.0 else '0';
  dOut2Ref <= '1' when dacReal2 > outAmplitude/2.0 else '0';

END ARCHITECTURE test;
