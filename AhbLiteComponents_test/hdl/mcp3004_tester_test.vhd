-- Alexandre Schnegg <alexandre.schnegg@master.hes-so.ch>
-- Gaël Sieber <gael.sieber@master.hes-so.ch>
-- 03.05.2015

library ieee;
  use ieee.math_real.all;

ARCHITECTURE test OF mcp3004_tester IS
                                                              -- clock and reset
	constant spiFrequency: real := 20.0E6;
	constant spiPeriod: time := (1.0/spiFrequency) * 1 sec;
	signal sCk_int: std_uLogic := '1';
															 -- SPI data
	constant spidataLength: positive := 3*8;
	signal spiSend: std_ulogic;
	signal spiRisingEdgeClock: std_ulogic;
	signal spiDataOut: std_ulogic_vector(spidataLength-1 downto 0);
	signal spiDataIn: std_ulogic_vector(spidataLength-1 downto 0);
	signal spiSlaveSelect: std_ulogic;
														-- analog signal
	constant sineFrequency: real := 5.0E3;
	constant sinePeriod: time := 1 sec / sineFrequency;
	constant outAmplitude: real := 4.096;
	signal tReal: real := 0.0;
	signal outReal: real := 0.0;

	signal adValue: real;
	signal testValue:real;
	signal errorSig:std_logic:='0';

BEGIN
 ------------------------------------------------------------------------------
                                                                    -- SPI clock
  sCk_int <= not sCk_int after spiPeriod/2;
  

  ------------------------------------------------------------------------------
                                                                -- test sequence
  testSequence: process
  begin
	  chZero<=0.0;
    spiSend <= '0';
    spiDataOut <= (others => '0');
    wait for 1 us;

    spiDataOut <= X"C00000";
	  chZero<=outReal;
	  testValue<=outReal;
    spiSend <= '1', '0' after 1 ns; --Start transfer
	
	  wait for 25*spiPeriod;
	
	  adValue<=real(to_integer(unsigned(spiDataIn(16 downto 7))))*4.0E-3; --Compute value
	
	  wait for spiPeriod;
	
  	if abs(adValue-testValue)>4.0E-3 then
  		errorSig<='1';
  	else
  		errorSig<='0';
  	end if;
	
	  wait for spiPeriod;
	
	  assert false report "Simulation finished" severity failure;
	  wait;
  end process testSequence;

  ------------------------------------------------------------------------------
                                                                -- SPI send data
  spiRisingEdgeClock <= sCk_int;

  spiExchangeData: process
    variable outputShiftRegister: unsigned(spiDataOut'range);
    variable inputShiftRegister: unsigned(spiDataOut'range);
  begin
    spiSlaveSelect <= '0';
    mosi <= '0';
                                                             -- wait for sending
    wait until rising_edge(spiSend);
    spiSlaveSelect <= '1';
    outputShiftRegister := unsigned(spiDataOut);
    inputShiftRegister := (others => '-');
                                                                 -- loop on bits
  	for index in 1 to outputShiftRegister'length-1 loop
  																 -- send bit
  		wait until falling_edge(spiRisingEdgeClock);
  		mosi <= outputShiftRegister(outputShiftRegister'high);
  		outputShiftRegister := shift_left(outputShiftRegister, 1);
  		
  																	 -- read bit
  		wait until rising_edge(spiRisingEdgeClock);
  		inputShiftRegister(0) := miso;
  		inputShiftRegister := shift_left(inputShiftRegister, 1);
  	end loop;
                                                      -- deactivate slave enable
    wait until falling_edge(spiRisingEdgeClock);
    spiDataIn <= std_ulogic_vector(inputShiftRegister);

  end process spiExchangeData;

  clk <= '0' when spiSlaveSelect = '0' else sCk_int;
  cs_n <= not spiSlaveSelect;

  ------------------------------------------------------------------------------
                                                                 -- time signals
  process(sCk_int)
  begin
    if rising_edge(sCk_int) then
      tReal <= tReal + 1.0/spiFrequency;
    end if;
  end process;

  outReal <= outAmplitude * ( sin(2.0*math_pi*sineFrequency*tReal) + 1.0) / 2.0;

END ARCHITECTURE test;
