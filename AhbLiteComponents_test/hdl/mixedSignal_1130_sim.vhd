ARCHITECTURE sim OF mixedSignal_11300 IS

  constant t_DOT: time := 23 ns;
  constant t_DOD: time := 50 ns;
                                                                     -- SPI data
  constant CPOL: std_ulogic := '0';
  constant CPHA: std_ulogic := '0';
  constant spiAddressLength: positive := 8;
  constant spiDataLength: positive := 2*8;
  constant spiFrameLength: positive := spiAddressLength + spiDataLength;
  signal spiRisingEdgeClock: std_ulogic;
  signal spiSlaveSelect: std_ulogic;
  signal spiSlaveIn, spiSlaveOut: std_ulogic;
  signal spiAddress: natural;
  signal spiDataIn: std_ulogic_vector(spiDataLength-1 downto 0);
  signal spiDataOut: std_ulogic_vector(spiDataLength-1 downto 0);
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
                                                                  -- ADC signals
  constant inAmplitude: real := 10.0;
  signal vIn1Int, vIn2Int : integer;
                                                                  -- DAC signals
  constant outAmplitude: real := 10.0;
  signal vOutInt : integer;

BEGIN

  selectData: process(spiAddress)
  begin
    if (spiAddress mod 2) = 1 then
      case spiAddress/2 is
        when adc1Address =>
          spiDataOut <= std_ulogic_vector(to_unsigned(vIn1Int, spiDataOut'length));
        when adc2Address =>
          spiDataOut <= std_ulogic_vector(to_unsigned(vIn2Int, spiDataOut'length));
        when gpioAddress =>
          spiDataOut <= (others => '0');
          spiDataOut(gpi1Index) <= din1;
          spiDataOut(gpi2Index) <= din2;
        when others => 
          spiDataOut <= (others => '-');
      end case;
    else
      spiDataOut <= (others => 'Z');
    end if;
  end process selectData;

  ------------------------------------------------------------------------------
                                                         -- SPI signal interface
  spiRisingEdgeClock <= SCLK when (CPOL xor CPHA) = '0'
    else not SCLK;
  spiSlaveSelect <= not CS_n;
  spiSlaveIn <= DIN;
  DOUT <= spiSlaveOut after t_DOT when spiSlaveSelect = '1'
    else 'Z' after t_DOD;
                                                            -- SPI command input
  spiExchangeData: process
    variable inputShiftRegister: unsigned(spiDataIn'range);
    variable outputShiftRegister: unsigned(spiDataOut'range);
    variable addressCounter: natural;
  begin
                                                        -- activate slave enable
    wait on spiRisingEdgeClock, spiSlaveSelect;
    if rising_edge(spiSlaveSelect) then
      outputShiftRegister := (others => 'Z');
      spiSlaveOut <= outputShiftRegister(outputShiftRegister'high);
      addressCounter := 0;
    elsif rising_edge(spiRisingEdgeClock) then
      if spiSlaveSelect = '1' then
        inputShiftRegister := shift_left(inputShiftRegister, 1);
        inputShiftRegister(0) := spiSlaveIn;
        addressCounter := addressCounter + 1;
        if addressCounter = spiAddressLength then
          spiAddress <= to_integer(inputShiftRegister(spiAddressLength-1 downto 0));
        end if;
      end if;
    elsif falling_edge(spiRisingEdgeClock) then
      if spiSlaveSelect = '1' then
        outputShiftRegister := shift_left(outputShiftRegister, 1);
        if addressCounter = spiAddressLength then
          outputShiftRegister := unsigned(spiDataOut);
        end if;
        spiSlaveOut <= outputShiftRegister(outputShiftRegister'high);
      end if;
    elsif falling_edge(spiSlaveSelect) then
      spiDataIn <= std_ulogic_vector(inputShiftRegister);
    end if;

  end process spiExchangeData;

  ------------------------------------------------------------------------------
                                                            -- voltage to number
  vIn1Int <= integer(vIn1/inAmplitude * 2.0**spiDataLength);
  vIn2Int <= integer(vIn2/inAmplitude * 2.0**spiDataLength);
                                                            -- number to voltage
  vOutInt <= to_integer(unsigned(spiDataIn));
  sampleDacOutput: process
  begin
    wait until falling_edge(spiSlaveSelect);
    wait for 1 ns;
    if (spiAddress mod 2) = 0 then
      case spiAddress/2 is
        when dac1Address =>
          vOut1 <= outAmplitude * real(vOutInt) / 2.0**spiDataLength;
        when dac2Address =>
          vOut2 <= outAmplitude * real(vOutInt) / 2.0**spiDataLength;
        when gpioAddress =>
          dOut1 <= spiDataIn(gpo1Index);
          dOut2 <= spiDataIn(gpo2Index);
        when others => null;
      end case;
    end if;
  end process sampleDacOutput;

END ARCHITECTURE sim;
