--==============================================================================
--
-- AHB UART
--
-- Implements a serial port.
--
--------------------------------------------------------------------------------
--
-- Write registers
--
-- 00, data register receives the word to be sent to the serial port.
-- 01, control register is used to control the peripheral.
-- 02, scaler register is used to set the baud rate.
--
--------------------------------------------------------------------------------
--
-- Read registers
-- 00, data register provides the last word received by the serial port.
-- 01, status register is used to get the peripheral's state.
--     bit 0: data ready for read
--     bit 1: sending in progress
--     bit 2: receiving in progress
--
ARCHITECTURE studentVersion OF ahbUart IS
  
  -- constants for the bit number
  constant addrRegBitNb : positive := 2; 
  constant CtrlBitNb : positive := 3;
  constant prescalerBitNb : posititve := 8;
  
  -- constants for the register addresses
  constant baudBufferAddr : positive := 2;
  constant CtrlBufferAddr : positive := 1;
  constant TxBufferAddr : positive := 0;
  
  -- constants for the position of bits in CtrlBuffer
  constant readyReadBitPos : positive := 0;
  constant readyWriteBitPos : positive := 1;
  constant currentlyReceivingBitPos : positive := 2;
   
  -- delayed signals from the bus
  signal addrInt : std_ulogic_vector(addrRegBitNb-1 downto 0);
  signal hTransInt : std_ulogic_vector(hTrans'range);
  signal hWriteInt : std_ulogic;
  signal hSelInt : std_ulogic;
  
  -- signals between the registers and the rxtx part
  signal TxBuffer : std_ulogic_vector(txFifoDepth-1 downto 0);
  signal RxBuffer : std_ulogic_vector(txFifoDepth-1 downto 0);
  signal CtrlBuffer: std_ulogic_vector(CtrlBitNb-1 downto 0);
  signal BaudBuffer: std_ulogic_vector(prescalerBitNb-1 downto 0);
  signal readyToSend : std_ulogic; --set once char is stored in TxBuffer

BEGIN
  --------------------------------------------------------------------------------
  -- shift the controls signals of the bus
  --------------------------------------------------------------------------------
  shiftProcess: PROCESS(hClk, hReset_n)
  BEGIN
    IF hReset_n = '0' THEN 
      hTransInt <= (OTHERS => '0');
      addrInt <= '0';
      hSelInt <= '0';
      hWriteInt <= '0';
      
    ELSIF rising_edge(hClk) THEN
      hTransInt <= hTrans;
      hSelInt <= hSel;
      hWriteInt <= hWrite;
      if hSel = '1'  then --save addr to be in phase with data
        addrInt <= hAddr(1 downto 0);
      end if;
    END IF;
  END PROCESS shiftProcess;
  
  --------------------------------------------------------------------------------
  -- write registers from uC
  --------------------------------------------------------------------------------
  writeRegProcess: PROCESS(hClk, hReset_n)
  BEGIN 
    IF hReset_n = '0' THEN 
      TxBuffer <= (OTHERS => '0');
      CtrlBuffer <= (OTHERS => '0');
      BaudBuffer <= (OTHERS => '0');
      
    ELSIF rising_edge(hClk) THEN
      readyToSend <= '0'; --default value, set only when TxBuffer is written
      if hSelInt = '1' and hTransInt = transNonSeq then
        IF addrInt = TxBufferAddr THEN -- work with tx buffer
          if hWriteInt = '1'  and ctrlBuffer(readyWriteBitPos) = '0' then
            TxBuffer <= std_ulogic_vector(RESIZE(unsigned(hWData), txFifoDepth));
            readyToSend <= '1';
          end if;
        ELSIF addrInt = CtrlBufferAddr THEN-- work with control buffer
          if hWriteInt = '1' then
            CtrlBuffer <= std_ulogic_vector(RESIZE(unsigned(hWData), 3));
          end if;
        ELSIF addrInt = baudBufferAddr THEN-- work with baud register
          if hWriteInt = '1' then
            BaudBuffer <= std_ulogic_vector(RESIZE(unsigned(hWData), txFifoDepth));
          end if;
        END if; 
      end if;
    END IF;
  END PROCESS writeRegProcess;
  
  --------------------------------------------------------------------------------
  -- read registers from uC
  --------------------------------------------------------------------------------
  outRegProcess: PROCESS(hAddrInt)
  BEGIN
    if addrInt = CtrlBufferAddr then
      hRData <= std_ulogic_vector(RESIZE(unsigned(CtrlBuffer), ahbDataBitNb));
    else
      hRData <= std_ulogic_vector(RESIZE(unsigned(RxBuffer), ahbDataBitNb));
    end if;
  END PROCESS outRegProcess;

  -- AHB-Lite
  hRData  <=	(OTHERS => '0');
  hReady  <=	'0';	
  hResp	  <=	'0';	
  
  -- Serial
  TxD <= '0';
END ARCHITECTURE studentVersion;

