-- Alexandre Schnegg <alexandre.schnegg@master.hes-so.ch>
-- Gaël Sieber <gael.sieber@master.hes-so.ch>
-- 03.05.2015

ARCHITECTURE sim OF mcp3004 IS

	constant t_sample: time := 700 ns;
	constant spidataLength: positive := 10;
	signal spiDataOut: std_logic_vector(spidataLength-1 downto 0);
	signal vInReal:real := 0.0;

BEGIN
  
  --Sampling
  
  vInReal<=chZero/4.0E-3 when chZero>=0.0 and chZero<=4.096 else 0.0;

  spiDataOut <= STD_LOGIC_VECTOR(TO_UNSIGNED(INTEGER(vInReal),10));
  
  --SPI comm
  process
  	variable outputShiftRegister: unsigned(spiDataOut'range);
  begin
  	miso<='0';
      wait until rising_edge(clk) and (cs_n='0') and (mosi='1'); --Wait start bit
  	wait until rising_edge(clk) and (cs_n='0') and (mosi='1'); --Wait for single mode
  	wait until rising_edge(clk) and (cs_n='0'); --Wait for CH0
  	wait until rising_edge(clk) and (cs_n='0') and (mosi='0'); --Wait for CH0
  	wait until rising_edge(clk) and (cs_n='0') and (mosi='0'); --Wait for CH0
  	
  	--Sampling
  	outputShiftRegister := unsigned(spiDataOut);
  	
  	wait until rising_edge(clk);
  	
  	wait until rising_edge(clk);
  	
  	--Send 10 bits
  	for index in 0 to outputShiftRegister'length loop
  		wait until falling_edge(clk);
  		miso <= outputShiftRegister(outputShiftRegister'high);
  		outputShiftRegister := shift_left(outputShiftRegister, 1);
  	end loop;
  	miso<='0';
  end process;

END ARCHITECTURE sim;
