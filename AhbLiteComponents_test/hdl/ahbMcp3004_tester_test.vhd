-- Alexandre Schnegg <alexandre.schnegg@master.hes-so.ch>
-- Gaël Sieber <gael.sieber@master.hes-so.ch>
-- 04.05.2015

library ieee;
  use ieee.math_real.all;

ARCHITECTURE test OF ahbMcp3004_tester IS
                                                              -- reset and clock
  constant clockFrequency: real := 100.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal clock_int: std_uLogic := '1';
  signal reset_int: std_uLogic;
                                                               -- AHB bus access
  signal registerAddress: natural;
  signal registerWData: integer;
  signal registerRData: integer;
  signal registerWrite: std_uLogic;
  signal registerRead: std_uLogic;
                                                                -- analog signal
  constant sineFrequency: real := 5.0E3;
  constant sinePeriod: time := 1 sec / sineFrequency;
  constant outAmplitude: real := 2.55;
  signal tReal: real := 0.0;
  signal outReal: real := 0.0;
                                                                     -- sampling
  constant samplingPeriod: time := sinePeriod/5;
  signal sampleEn: std_uLogic := '0';
  signal sampleValueLow: integer;
  signal sampleValueHigh: integer;
  
  signal adValue:real:=0.0;
  signal valueToTest:real:=0.0;
  signal errorSig:std_logic:='0';

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

  ------------------------------------------------------------------------------
                                                                -- test sequence
  testSequence: 
  process
  begin
  	registerAddress <= 0;
  	registerWData <= 0;
  	registerWrite <= '0';
  	registerRead <= '0';
  	wait for 1 us;
															 -- wait until ready
  	registerAddress <= 0;
  	registerRead <= '1', '0' after clockPeriod;
  	wait for 3*clockPeriod;
  	while registerRData=0 loop
  		registerAddress <= 0;
  		registerRead <= '1', '0' after clockPeriod;
  		wait for 3*clockPeriod;
  	end loop;
															  -- read sample
  	registerAddress <= 1;
  	registerRead <= '1', '0' after clockPeriod;
  	wait for 3*clockPeriod;
  	sampleValueLow <= registerRData;
  	wait for 3*clockPeriod;

  	registerAddress <= 2;
  	registerRead <= '1', '0' after clockPeriod;
  	wait for 3*clockPeriod;
  	sampleValueHigh <= registerRData;
  	wait for 3*clockPeriod;

  	valueToTest<=(real(sampleValueHigh)*256.0+real(sampleValueLow))*4.0E-3;

  	wait for clockPeriod;

  	if abs(adValue-valueToTest)>4.0E-3 then
  		errorSig<='1';
  	else
  		errorSig<='0';
  	end if;

  	wait for 3*clockPeriod;

  	--assert false report "Simulation finished" severity failure;
  	wait;
  end process testSequence;

  saveValueP:
  process
  begin
  	wait until rising_edge(sampleEn);
  	adValue<=outReal;
  	chZero<=outReal;
  end process;

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
      hWData <= std_uLogic_vector(to_signed(registerWData, hWData'length));
    else
      registerRData <= to_integer(unsigned(hRData));
    end if;
    wait until rising_edge(clock_int);
  end process;

  ------------------------------------------------------------------------------
                                                                 -- time signals
  process(clock_int)
  begin
    if rising_edge(clock_int) then
      tReal <= tReal + 1.0/clockFrequency;
    end if;
  end process;

  outReal <= outAmplitude * ( sin(2.0*math_pi*sineFrequency*tReal) + 1.0) / 2.0;

END ARCHITECTURE test;
