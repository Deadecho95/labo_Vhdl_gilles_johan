ARCHITECTURE RTL OF ahbTlv1544 IS

  signal reset, clock: std_ulogic;
  
  -- Registers Definitions Write
  --===========================
  -- Address 0 : Function MODE
  --===========================
    constant ADC_MODE_Add_C: natural := 0; 
    
    Constant ADC_Mode_Data_Normal_C     : std_logic_vector (hWData'range):= x"0000";  
    Constant ADC_Mode_Data_SelfTest1_C  : std_logic_vector (hWData'range):= x"000B";  
    Constant ADC_Mode_Data_SelfTest2_C  : std_logic_vector (hWData'range):= x"000C"; 
    Constant ADC_Mode_Data_SelfTest3_C  : std_logic_vector (hWData'range):= x"000D"; 
    
    Constant ADC_Add_Xaxis_C     : std_logic_vector (9 downto 0):= "0000" & "000000"; 
    Constant ADC_Add_Yaxis_C     : std_logic_vector (9 downto 0):= "0010" & "000000"; 
    Constant ADC_Add_Zaxis_C     : std_logic_vector (9 downto 0):= "0100" & "000000"; 
  
    signal  ADC_SingleConv_result_s     : std_logic_vector (hWData'range); 
    signal  ADC_xAxis_result_s          : std_logic_vector (hWData'range); 
    signal  ADC_yAxis_result_s          : std_logic_vector (hWData'range); 
    signal  ADC_zAxis_result_s          : std_logic_vector (hWData'range); 
    
    signal  ADC_xAxis_result_temp_s          : std_logic_vector (hWData'range); 
    signal  ADC_yAxis_result_temp_s          : std_logic_vector (hWData'range); 
    signal  ADC_zAxis_result_temp_s          : std_logic_vector (hWData'range); 
    
    
    signal ADC_xAxis_Register_s         : std_logic_vector (hWData'range); 
    signal ADC_yAxis_Register_s         : std_logic_vector (hWData'range); 
    signal ADC_zAxis_Register_s         : std_logic_vector (hWData'range); 
     
            
   --================================
  -- Address 1 : Data Read Cycle
  --=================================
  constant ADC_Read_Cycle_C: natural := 1; 
               
  
  constant stepRegisterId: natural := 4; 
  constant statusValidId: natural := 0;
  constant valueRegisterId: natural := 1;

  constant registerNb: positive := stepRegisterId+1;
  constant registerAddresssBitNb: positive := addressBitNb(registerNb);
  signal addressReg: unsigned(registerAddresssBitNb-1 downto 0);
  signal writeReg: std_ulogic;
                                                            -- control registers
  subtype registerType is unsigned(hWData'range);
  type registerArrayType is array (registerNb-1 downto 0) of registerType;
  signal registerArray: registerArrayType;
                                                             -- FSM step counter
  constant fsmEnableCounterBitNb: positive := 8;
  signal fsmEnableCounter: unsigned(fsmEnableCounterBitNb-1 downto 0);
  signal fsmEnable: std_ulogic;
                                                                          -- FSM
  constant powerEnableId: positive := 1;
  signal powerEnable: std_ulogic;
  constant startEnableId: positive := 1;
  signal startEnable: std_ulogic;
---------------------------------------------------------------------------------
  --- State machine 1 parmis n encodage 
    constant idle                       : std_logic_vector( 15 downto 0) :=x"0001";
    constant powerOn                    : std_logic_vector( 15 downto 0) :=x"0002";
    constant startconv_singleValue      : std_logic_vector( 15 downto 0) :=x"0004";
    constant waitconv_singlevalue       : std_logic_vector( 15 downto 0) :=x"0008";
    constant startconv_X_axis           : std_logic_vector( 15 downto 0) :=x"0010";
    constant waitconv_x                 : std_logic_vector( 15 downto 0) :=x"0020";
    constant startconv_Y_axis           : std_logic_vector( 15 downto 0) :=x"0040";
    constant waitconv_y                 : std_logic_vector( 15 downto 0) :=x"0080";
    constant startconv_z_axis           : std_logic_vector( 15 downto 0) :=x"0100";
    constant waitconv_z                 : std_logic_vector( 15 downto 0) :=x"0200";
    constant startconv_dummy            : std_logic_vector( 15 downto 0) :=x"0400";
    constant waitconv_dummy             : std_logic_vector( 15 downto 0) :=x"0800";
    constant conversion_done            : std_logic_vector( 15 downto 0) :=x"1000";
  
  signal SPI_state: std_logic_vector ( 15 downto 0); 
---------------------------------------------------------------------------------

  signal single_value_Write_s : std_logic;                                                                 
  -- data value
  signal adcData: signed(hWData'range);
  signal adcDataValid: std_ulogic;
  signal New_data_Ready_s: std_logic_vector(hWData'range);

  -- SPI 
  signal SPI_Clk_s                  : std_logic;   
  signal clock_counter_s            : unsigned(2 downto 0);
  signal SPI_Slave_Data_s           : std_logic_vector(9 downto 0);
  signal SPI_Slave_Data_Ready_s     : std_logic;
  signal SPI_busy_s                 : std_logic;
  signal SPI_Master_Start_s         : std_logic;     
  signal SPI_Master_Data_s          : std_logic_vector(9 downto 0); 
  signal SPI_Slave_wr_ack_s         : std_logic;  
  
  signal SPI_nCS_s                  : std_logic;   
  
  component spi_master is
    generic (   
        N               : positive := 32;                                           -- 32bit serial word length is default
        CPOL            : std_logic := '0';                                         -- SPI mode selection (mode 0 default)
        CPHA            : std_logic := '0';                                         -- CPOL = clock polarity, CPHA = clock phase.
        PREFETCH        : positive := 2;                                            -- prefetch lookahead cycles
        SPI_2X_CLK_DIV  : positive := 5);                                           -- for a 100MHz sclk_i, yields a 10MHz SCK
    port (  
        sclk_i          : in std_logic := 'X';                                      -- high-speed serial interface system clock
        pclk_i          : in std_logic := 'X';                                      -- high-speed parallel interface system clock
        rst_i           : in std_logic := 'X';                                      -- reset core
        ---- serial interface ----
        spi_ssel_o      : out std_logic;                                            -- spi bus slave select line
        spi_sck_o       : out std_logic;                                            -- spi bus sck
        spi_mosi_o      : out std_logic;                                            -- spi bus mosi output
        spi_miso_i      : in std_logic := 'X';                                      -- spi bus spi_miso_i input
        ---- parallel interface ----
        di_req_o        : out std_logic;                                            -- preload lookahead data request line
        di_i            : in  std_logic_vector (N-1 downto 0) := (others => 'X');   -- parallel data in (clocked on rising spi_clk after last bit)
        wren_i          : in std_logic := 'X';                                      -- user data write enable, starts transmission when interface is idle
        wr_ack_o        : out std_logic;                                            -- write acknowledge
        do_valid_o      : out std_logic;                                            -- do_o data valid signal, valid during one spi_clk rising edge.
        do_o            : out  std_logic_vector (N-1 downto 0);                    -- parallel output (clocked on rising spi_clk after last bit)
        --- debug ports: can be removed or left unconnected for the application circuit ---
        sck_ena_o       : out std_logic;                                            -- debug: internal sck enable signal
        sck_ena_ce_o    : out std_logic;                                            -- debug: internal sck clock enable signal
        do_transfer_o   : out std_logic;                                            -- debug: internal transfer driver
        wren_o          : out std_logic;                                            -- debug: internal state of the wren_i pulse stretcher
        rx_bit_reg_o    : out std_logic;                                            -- debug: internal rx bit
        state_dbg_o     : out std_logic_vector (3 downto 0);                        -- debug: internal state register
        core_clk_o      : out std_logic;
        core_n_clk_o    : out std_logic;
        core_ce_o       : out std_logic;
        core_n_ce_o     : out std_logic;
        sh_reg_dbg_o    : out std_logic_vector (N-1 downto 0)                       -- debug: internal shift register
        );                     
end component;

BEGIN
  ------------------------------------------------------------------------------
  FS <= '0';                                                          -- reset and clock
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
  storeRegisters: process(reset, clock)
  begin
    if reset = '1' then
      registerArray <= (others => (others => '0'));
    elsif rising_edge(clock) then         
        if writeReg = '1' then
            registerArray(to_integer(addressReg)) <= unsigned(hWData);        
        end if;      
    end if;
  end process storeRegisters;

  --============================================================================

  powerEnable <= enable(powerEnableId);
  startEnable <= enable(startEnableId); -- fix with same value as PowerEnable

  ------------------------------------------------------
  -- SPI FSM State Machine

  SPIStateMachine: process(reset, clock)
  begin
    if reset = '1' then
        SPI_state                   <= idle;      
        SPI_Master_Start_s       <= '0';
        single_value_Write_s        <= '0';
        ADC_SingleConv_result_s     <= (others => '0');
        ADC_xAxis_result_s          <= (others => '0');
        ADC_yAxis_result_s          <= (others => '0');
        ADC_zAxis_result_s          <= (others => '0');
        ADC_xAxis_result_temp_s     <= (others => '0');
        ADC_yAxis_result_temp_s     <= (others => '0');
        ADC_zAxis_result_temp_s     <= (others => '0');
        SPI_Master_Data_s              <= (others => '0');
        New_data_Ready_s            <= (others => '0'); -- AMBA flag
        ADC_xAxis_Register_s        <= (others => '0');
        ADC_yAxis_Register_s        <= (others => '0');
        ADC_zAxis_Register_s        <= (others => '0');
    elsif rising_edge(clock) then
        SPI_Master_Start_s   <= '0';
        case SPI_state is
            when idle =>
                if powerEnable = '1' then
                    SPI_state <= powerOn;
                end if;
            when powerOn =>
                -- Start a conversion, depending on Mode
                if startEnable = '1' then 
                    if registerArray(ADC_MODE_Add_C)= unsigned(ADC_Mode_Data_Normal_C) then
                        SPI_state <= startconv_X_axis;
                    else
                        SPI_state               <= startconv_singleValue;
                        single_value_Write_s    <= '1'; 
                    end if;
                end if;  
         
            when startconv_singleValue =>
                if SPI_busy_s='0' then
                    SPI_Master_Start_s   <= '1';
                    SPI_Master_Data_s          <= std_logic_vector(registerArray(ADC_MODE_Add_C)(3 downto 0)) & "000000"; -- sends the 10 lower bits as SPI add
                    SPI_state                <= waitconv_singlevalue;                
                end if;
               
            when waitconv_singlevalue =>
                if SPI_Slave_Data_Ready_s ='1' then
                   ADC_SingleConv_result_s( 9 downto 0)    <= SPI_Slave_Data_s;
                     -- needs a second transfer to get the value
                    if single_value_Write_s ='1' then
                        single_value_Write_s    <='0';
                        SPI_state               <= startconv_singleValue;
                    else -- second time we wait, we Save the SPI value
                        
                        SPI_state                               <= conversion_done;                
                    end if;
                
                end if;
                
               -- if SPI_Slave_wr_ack_s= '1' then
                  
              --  end if;
            when startconv_X_axis =>
                if SPI_busy_s='0' then
                    SPI_Master_Start_s   <= '1';
                    SPI_Master_Data_s          <= ADC_Add_Xaxis_C(9 downto 0); -- sends the 10 lower bits as SPI add
                    SPI_state                <= waitconv_x;                
                end if;
              
            when waitconv_x =>
                -- ignores the 1st result
                if SPI_Slave_Data_Ready_s ='1' then
                    SPI_state   <= startconv_Y_axis; 
                end if;
                
            when startconv_Y_axis =>
                if SPI_busy_s='0' then
                    SPI_Master_Start_s   <= '1';
                    SPI_Master_Data_s          <= ADC_Add_Yaxis_C(9 downto 0); -- sends the 10 lower bits as SPI add
                    SPI_state                <= waitconv_y;                
                end if;

            when waitconv_y =>
                if SPI_Slave_Data_Ready_s ='1' then
                    SPI_state                       <= startconv_z_axis; 
                    ADC_xAxis_result_temp_s(9 downto 0)  <= SPI_Slave_Data_s; -- saves X axis
                end if;
                
            when startconv_z_axis =>    
                if SPI_busy_s='0' then
                    SPI_Master_Start_s   <= '1';
                    SPI_Master_Data_s          <= ADC_Add_Zaxis_C(9 downto 0); -- sends the 10 lower bits as SPI add
                    SPI_state                <= waitconv_z;                
                end if;
           
            when waitconv_z =>
                if SPI_Slave_Data_Ready_s ='1' then
                    SPI_state                       <= startconv_dummy; 
                    ADC_yAxis_result_temp_s(9 downto 0)  <= SPI_Slave_Data_s; -- saves Y axis
                end if;
            
            when startconv_dummy =>
                if SPI_busy_s='0' then
                    SPI_Master_Start_s   <= '1';
                    SPI_Master_Data_s          <= ADC_Add_Zaxis_C(9 downto 0); -- sends the 10 lower bits as SPI add
                    SPI_state                <= waitconv_dummy;                
                end if;
            
            when waitconv_dummy =>
                if SPI_Slave_Data_Ready_s ='1' then
                    SPI_state                       <= conversion_done; 
                    ADC_zAxis_result_temp_s(9 downto 0)  <= SPI_Slave_Data_s; -- saves Y axis
                   
                end if; 
            when conversion_done =>
                New_data_Ready_s                <= x"0001"; -- AMBA flag
                SPI_state                       <= powerOn;               
                    
                -- updates all results at the same time
                ADC_xAxis_result_s          <= ADC_xAxis_result_temp_s;
                ADC_yAxis_result_s          <= ADC_yAxis_result_temp_s;
                ADC_zAxis_result_s          <= ADC_zAxis_result_temp_s;
            when others=> 
                SPI_state   <= idle;
        end case;
       
       -- if Read Cycle is not currently being done on the Bus, we can update the registers
        if registerArray((ADC_Read_Cycle_C))(0)= '0' then           
            ADC_xAxis_Register_s        <= ADC_xAxis_result_s;
            ADC_yAxis_Register_s        <= ADC_yAxis_result_s;
            ADC_zAxis_Register_s        <= ADC_zAxis_result_s;
        else
            -- clear the flags if a read cycle is being done
            New_data_Ready_s  <= (others=>'0'); -- AMBA flag
        end if;
    end if;
  end process SPIStateMachine;

  --============================================================================
  -- data readback

  hRData <=   std_ulogic_vector(ADC_SingleConv_result_s)  when addressReg = x"0000" else
                std_ulogic_vector(ADC_xAxis_Register_s)       when addressReg = x"0001" else 
                std_ulogic_vector(ADC_yAxis_Register_s)       when addressReg = x"0002" else
                std_ulogic_vector(ADC_zAxis_Register_s)       when addressReg = x"0003" else
                std_ulogic_vector(New_data_Ready_s)         when addressReg = x"0004" else                
                (others=>'0');

  hReady <= '1';  -- no wait state
  hResp  <= '0';  -- data OK


    -- Spi master
 --===================================
    ADC_spi_master : spi_master
 --===================================
    generic map
    (
        N               => 10,
        CPOL            => '0',
        CPHA            => '0',
        PREFETCH        => 2,
        SPI_2X_CLK_DIV  => 2
    )
    port map
    (
        sclk_i          => SPI_Clk_s,
        pclk_i          => clock, 
        rst_i           => reset,
        spi_ssel_o      => SPI_nCS_s,
        spi_sck_o       => CLK,
        spi_mosi_o      => DATA_IN,
        spi_miso_i      => DATA_OUT,
        di_req_o        => open,
        di_i            => SPI_Master_Data_s,
        wren_i          => SPI_Master_Start_s,
        wr_ack_o        => SPI_Slave_wr_ack_s,
        do_valid_o      => SPI_Slave_Data_Ready_s,
        do_o            => SPI_Slave_Data_s,
        sck_ena_o       => open,
        sck_ena_ce_o    => open,
        do_transfer_o   => open,
        wren_o          => open,
        rx_bit_reg_o    => open,
        state_dbg_o     => open,
        core_clk_o      => open,
        core_n_clk_o    => open,
        core_ce_o       => open,
        core_n_ce_o     => open,
        sh_reg_dbg_o    => open
    );
  CS_n <= SPI_nCS_s;
  -- SPI clock /3 Divider 
  SPI_busy_s <=not SPI_nCS_s;

 SPICLK: process(reset, clock)
  begin
    if reset = '1' then
        SPI_Clk_s <='0';
        clock_counter_s <= (others=>'0');
    elsif rising_edge(clock) then         
       
        clock_counter_s <= clock_counter_s +1;
        if clock_counter_s="001" then 
            clock_counter_s <= (others=>'0');
            SPI_Clk_s <= not SPI_Clk_s;
        end if;
    end if;
  end process SPICLK;


END ARCHITECTURE RTL;
