library ieee;
  use ieee.math_real.all;

ARCHITECTURE test OF ahbMixedSignal11300_tester IS
                                                              -- reset and clock
  constant clockFrequency: real := 100.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal clock_int: std_uLogic := '1';
  signal reset_int: std_uLogic;
                                                                    -- SPI clock
  constant spiFrequency: real := 10.0E6;
  constant spiPeriod: time := (1.0/spiFrequency) * 1 sec;
  constant startConvDuration: real := 0.5E-6;
                                                         -- AHB device registers
  constant spiDivideCountId        : natural := 0;
  constant startConvDivideCountId  : natural := 1;
  constant configAddressRegisterId : natural := 2;
  constant configDataRegisterId    : natural := 3;
  constant dac1RegisterId          : natural := 4;
  constant dac2RegisterId          : natural := 5;
  constant gpoDataRegisterId       : natural := 6;
  constant gpo1Index                 : natural := 4;
  constant gpo2Index                 : natural := 5;
  constant adc1RegisterId          : natural := 4;
  constant adc2RegisterId          : natural := 5;
  constant gpiDataRegisterId       : natural := 6;
  constant gpi1Index                 : natural := 2;
  constant gpi2Index                 : natural := 3;
                                                               -- AHB bus access
  signal registerAddress: natural;
  signal registerWData: integer;
  signal registerRData: integer;
  signal registerWrite: std_uLogic;
  signal registerRead: std_uLogic;
                                                                     -- sampling
  constant samplingFrequency: real := 50.0E3;
  constant samplingPeriod: time := (1.0/samplingFrequency) * 1 sec;
  signal sampleEn: std_uLogic := '0';
                                                               -- analog signals
  constant sineFrequency: real := samplingFrequency/10.0;
  constant sinePeriod: time := 1 sec / sineFrequency;
  constant outAmplitude: real := 10.0;
  signal tReal: real := 0.0;
  signal dacReal1, dacReal2, adcReal1, adcReal2: real := 0.0;
  signal vIn1_int, vIn2_int: real := 0.0;
                                                              -- digital signals
  signal vIn1Sampled, vIn2Sampled: real := 0.0;
  signal dIn1Sampled, dIn2Sampled : std_ulogic;
  signal dOut1Ref, dOut2Ref : std_ulogic;

BEGIN
  ------------------------------------------------------------------------------
                                                              -- reset and clock
  reset_int <= '1', '0' after 2*clockPeriod;
  hReset_n <= not(reset_int);

  clock_int <= not clock_int after clockPeriod/2;
  hClk <= transport clock_int after clockPeriod*9.0/10.0;

  ------------------------------------------------------------------------------
                                                                     -- sampling
  sampleEn <= '1' after samplingPeriod-clockPeriod when sampleEn = '0'
    else '0' after clockPeriod;

  enable <= sampleEn;

  --============================================================================
                                                                -- test sequence
  testSequence: process
  begin
    registerAddress <= 0;
    registerWData <= 0;
    registerWrite <= '0';
    registerRead <= '0';
    wait for 100 ns;
                                                            -- send SPI baudrate
    registerAddress <= spiDivideCountId;
    registerWData <= integer(clockFrequency / spiFrequency);
    registerWrite <= '1', '0' after clockPeriod;
    wait for 4*clockPeriod;
                                                        -- send startConv period
    registerAddress <= startConvDivideCountId;
    registerWData <= integer(startConvDuration * clockFrequency);
    registerWrite <= '1', '0' after clockPeriod;
    wait for 1 us;
                                                           -- read/write samples
    loop
                                                           -- sampling frequency
      wait until rising_edge(sampleEn);
                                                              -- send DAC1 value
      registerAddress <= dac1RegisterId;
      registerWData <= integer(dacReal1 / outAmplitude * (2.0**hWData'length-1.0));
      registerWrite <= '1', '0' after clockPeriod;
      wait for 4*clockPeriod;
                                                              -- send DAC2 value
      registerAddress <= dac2RegisterId;
      registerWData <= integer(dacReal2 / outAmplitude * (2.0**hWData'length-1.0));
      registerWrite <= '1', '0' after clockPeriod;
      wait for 4*clockPeriod;
                                                              -- send GPO values
      registerAddress <= gpoDataRegisterId;
      registerWData <= 0;
      if dacReal1 > outAmplitude/2.0 then
        wait for 0 ns;
        registerWData <= registerWData + 2**gpo1Index;
      end if;
      if dacReal2 > outAmplitude/2.0 then
        wait for 0 ns;
        registerWData <= registerWData + 2**gpo2Index;
      end if;
      registerWrite <= '1', '0' after clockPeriod;
      wait for 4*clockPeriod;
                                                              -- read GPI values
      registerAddress <= gpiDataRegisterId;
      registerRead <= '1', '0' after clockPeriod;
      wait for 4*clockPeriod;
      dIn1Sampled <= to_unsigned(registerRData, hRData'length)(gpi1Index);
      dIn2Sampled <= to_unsigned(registerRData, hRData'length)(gpi2Index);
                                                              -- read ADC1 value
      registerAddress <= adc1RegisterId;
      registerRead <= '1', '0' after clockPeriod;
      wait for 4*clockPeriod;
      vIn1Sampled <= outAmplitude * real(registerRData) / 2.0**hRData'length;
                                                              -- read ADC2 value
      registerAddress <= adc2RegisterId;
      registerRead <= '1', '0' after clockPeriod;
      wait for 4*clockPeriod;
      vIn2Sampled <= outAmplitude * real(registerRData) / 2.0**hRData'length;
    end loop;
    wait;
  end process testSequence;

  --============================================================================
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
      hWData <= std_uLogic_vector(to_signed(registerWData, hWData'length));
    else
      registerRData <= to_integer(unsigned(hRData));
    end if;
    wait until rising_edge(clock_int);
  end process;

  --============================================================================
                                                                 -- time signals
  process(clock_int)
  begin
    if rising_edge(clock_int) then
      tReal <= tReal + 1.0/clockFrequency;
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
