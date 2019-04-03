-- Alexandre Schnegg <alexandre.schnegg@master.hes-so.ch>
-- Gaël Sieber <gael.sieber@master.hes-so.ch>
-- 04.05.2015

ARCHITECTURE RTL OF ahbMcp3004 IS

	constant spidataLength: positive := 24;
	constant wakeUpCounterValue: unsigned(31 downto 0) := X"00000001"; --Number of clock cycle to wait before starting spi transfer
	constant spiPrescalerValue: unsigned(31 downto 0) := x"00000032";

	signal reset, clock: std_ulogic;
	
	--Subtype for adcSequencer states
	subtype adc_state_t is  std_ulogic_vector(4 DOWNTO 0);
	
	--adcSequencer states constants
	constant adc_idle			: adc_state_t  := "00001"; 
	constant adc_startConv  	: adc_state_t  := "00010"; 
	constant adc_waitConv  		: adc_state_t  := "00100"; 
	constant adc_waitWakeUp  	: adc_state_t  := "01000"; 
	constant adc_error  		: adc_state_t  := "10000"; 

	--adcSequencer state signal
	signal adcState: adc_state_t;
	
	--Subtype for spiMaster states
	subtype spi_state_t is  std_ulogic_vector(5 DOWNTO 0);
	
	--spiMaster states constants
	constant spi_idle			: spi_state_t  := "000001"; 
	constant spi_init		  	: spi_state_t  := "000010"; 
	constant spi_sendBit  		: spi_state_t  := "000100"; 
	constant spi_receiveBit	  	: spi_state_t  := "001000"; 
	constant spi_shift  		: spi_state_t  := "010000"; 
	constant spi_error  		: spi_state_t  := "100000"; 

	--spiMaster state signal
	signal spiState: spi_state_t;

	signal adcDataValid: std_ulogic;
	signal adcError: std_ulogic;

	signal startSpi:std_ulogic;
	signal spiDone:std_ulogic;

	signal spiInReg:unsigned(spidataLength-1 downto 0);
	signal spiOutReg:unsigned(spidataLength-1 downto 0);
	signal spiCounter:unsigned(7 downto 0);
	signal spiClk:std_ulogic;
	signal spiPrescaler:unsigned(31 downto 0);
	signal spiClkRisingEdge:std_ulogic;
	signal spiClkFallingEdge:std_ulogic;
	signal spiClkTemp:std_ulogic;

	signal statusReg:std_ulogic_vector(15 downto 0);
	signal dataReg:std_ulogic_vector(15 downto 0);

	signal wakeUpCounter:unsigned(31 downto 0);

BEGIN
	reset <= not hReset_n;
	clock <= hClk;

	adcSequencer: 
	process(reset, clock)
	begin
		if reset = '1' then
			adcState <= adc_idle;
		elsif rising_edge(clock) then
			case adcState is
			when adc_idle =>
				if enable = '1' then
					wakeUpCounter<=wakeUpCounterValue;
					adcState <= adc_waitWakeUp;
				end if;
			when adc_waitWakeUp =>
				if unsigned(wakeUpCounter) > 0 then
					wakeUpCounter<=unsigned(wakeUpCounter)-1;
				else
					adcState <= adc_startConv;
				end if;
			when adc_startConv =>
				adcState <= adc_waitConv;
			when adc_waitConv =>
				if spiDone = '1' then
					adcState <= adc_idle;
				end if;
			when adc_error=>
				adcState <= adc_idle;
			when others => 
				adcState<=adc_error;
			end case;
		end if;
	end process adcSequencer;

	cs_n<='1' when adcState=adc_idle else '0';
	adcDataValid<='1' when adcState=adc_idle else '0';
	
	startSpi<='1' when adcState=adc_startConv else '0';
	  
	spiMaster:
	process(reset,clock,spiClk)
	begin
		if reset = '1' then
			spiCounter<=(others =>'0');
			spiInReg<=(others =>'0');
			spiOutReg<=(others =>'0');
			spiDone<='0';
			mosi<='0';
			spiState<=spi_idle;
		elsif rising_edge(clock) then
			spiDone<='0';
			case spiState is
				when spi_idle =>
					if startSpi = '1' then
						spiState <= spi_init;
					end if;
				when spi_init =>
					spiCounter<=X"17";
					spiOutReg<= X"C00000";
					spiState<=spi_sendBit;
				when spi_sendBit =>
					if spiClkFallingEdge='1' then
						mosi <=spiOutReg(spiOutReg'high);
						spiState<=spi_receiveBit;
					end if;
				when spi_receiveBit =>
					if spiClkRisingEdge='1' then
						spiInReg(0)<=miso;
						spiState<=spi_shift;
					end if;
				when spi_shift =>
					spiCounter<=unsigned(spiCounter)-1;
					if unsigned(spiCounter)=0 then
						spiDone<='1';
						spiState<=spi_idle;
					else
						spiOutReg<=shift_left(spiOutReg, 1);
						spiInReg<=shift_left(spiInReg, 1);
						spiState<=spi_sendBit;
					end if;
				when spi_error=>
					spiState <= spi_idle;
				when others => 
					spiState<=spi_error;
			end case;
		end if;  
	end process spiMaster;	
	
	spiClkRisingEdgeP:
	process(reset,clock)
	begin
		if reset = '1' then
			spiClkTemp<='0';
		elsif rising_edge(clock) then
			spiClkTemp<=spiClk;
		end if;
	end process;
	
	spiClkRisingEdge<=(not spiClkTemp) and spiClk;
	spiClkFallingEdge<=(not spiClk) and spiClkTemp;

	spiClkGen:
	process(reset,clock)
	begin
		if reset = '1' or adcState=adc_idle then
			spiPrescaler<=spiPrescalerValue;
			spiClk<='0';
		elsif rising_edge(clock) then
			if unsigned(spiPrescaler)=0 then
				spiClk<=not(spiClk);
				spiPrescaler<=spiPrescalerValue;
			else
				spiPrescaler<=unsigned(spiPrescaler)-1;
			end if;
		end if;
	end process spiClkGen;
	
	clk <=spiClk;

	adcError<='1' when spiState=spi_error or adcState=adc_error else '0';
	statusReg<=X"00"&"000000"&adcError&adcDataValid;
	dataReg<="000000"&std_ulogic_vector(spiInReg(16 downto 7)) when adcDataValid='1' else X"0000";

	regReadProcess:
	process(reset,clock)
		begin
		if reset = '1' then
			hRData <= (others => '0'); 
		elsif rising_edge(clock) then
			hRData <= (others => '0');    -- default value
			if hSel= '1' and hWrite = '0' then -- Read cycle
				case to_integer(hAddr) is
					when 0 => hRData <= std_ulogic_vector(statusReg);
					when 1 => hRData <= std_ulogic_vector(dataReg);
					when others => null;
				end case;
			end if;
		end if;
	end process regReadProcess;

	hReady <= '1';  -- no wait state
	hResp  <= '0';  -- data OK

END ARCHITECTURE RTL;
