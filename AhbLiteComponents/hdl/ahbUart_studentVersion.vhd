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
  
  SIGNAL current_state_tx : STATE_TYPE_TX;
  SIGNAL next_state_tx : STATE_TYPE_TX;
   
   TYPE STATE_TYPE_TX IS (
    waitForChar,
    startCounter,
    sendStartBit,
    sendBitX,
    nextBit,
    sendStopBit
   );
   
  SIGNAL current_state_rx : STATE_TYPE_RX;
  SIGNAL next_state_rx : STATE_TYPE_RX;
  
  TYPE STATE_TYPE_RX IS (
    waitForChar,
    startCounter,
    readStartBit,
    readBitX,
    nextBit,
    readStopBit
   );

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
  

      
  --------------------------------------------------------------------------------
  -- transition for state machines
  --------------------------------------------------------------------------------
  state_machine_transition: PROCESS(hClk, hReset_n)
  BEGIN
    if hReset_n = '1' then
      current_state_tx <= waitForChar; -- initial state
      current_state_rx <= waitForChar; -- initial state
    elsif rising_edge(hClk) then
      current_state_rx <= next_state_rx; -- transition of states
      current_state_tx <= next_state_tx; -- transition of states
    end if;
  END PROCESS state_machine_transition;
  
  --------------------------------------------------------------------------------
  -- state machine for the Tx
  --------------------------------------------------------------------------------
   nextstate_tx_proc : PROCESS ( 
      readyToSend,
      counterRateTx,
      counterPosBitTx,
      current_state_tx
   ) 
  BEGIN
    next_state_tx <= current_state_tx; -- default value
    startCounterTx <= '0';
    
    CASE current_state_tx IS
      -- currently waiting for a char to be written in the reg
      WHEN waitForChar =>
        CtrlBuffer(readyWriteBitPos) <= '1'; --uC can write a new char
        IF readyToSend = '1' THEN
          next_state_tx <= startCounter;
        END IF;
        
      WHEN startCounter => 
        -- reset the control bit : uC can't write a new char
        CtrlBuffer(readyWriteBitPos) <= '0';
        -- start counter for the impuls
        startCounterTx <= '1';
        next_state_tx <= sendStartBit;
          
      WHEN sendStartBit => 
        Txd <= '0'; -- startBit
        if counterRateTx = '1' then
          next_state_tx <= sendBitX;
        end if;
             
      WHEN sendBitX =>
         TxD <= TxBuffer(counterPosBitTx); --bit x of the buffer tx
        if counterRateTx = '1' then
          next_state_tx <= nextBit;
        end if;
          
      WHEN nextBit => 
        if counterPosBitTx = 7 then
          next_state_tx <= sendStopBit;
        else
          next_state_tx <= sendBitX;
        end if;
          
      WHEN sendStopBit =>
        TxD <= '1'; --stop bit
        if counterRateTx = '1' then
          next_state_tx <= waitForChar;
        end if;
     END CASE; 
  END PROCESS nextstate_tx_proc;  


  --------------------------------------------------------------------------------
  -- state machine for the rx
  --------------------------------------------------------------------------------
   nextstate_rx_proc : PROCESS ( 
      counterRateRx,
      counterPosBitRx,
      current_state_rx
   ) 
  BEGIN
    next_state_rx <= current_state_rx; -- default value
    startCounterRx <= '0';
    CtrlBuffer(readyReadBitPos) <= '0';
    CtrlBuffer(currentlyReceivingBitPos) <= '1';
    
--        waitForChar,
--    startCounter,
--    readStartBit,
--    readBitX,
--    nextBit,
--    readStopBit
    
    
    CASE current_state_rx IS
      -- waiting for a start bit
      WHEN waitForChar =>
        CtrlBuffer(currentlyReceivingBitPos) <= '0'; -- not receiving
        CtrlBuffer(readyReadBitPos) <= '1'; -- ready to read
        IF RxD = '0' THEN
          next_state_rx <= startCounter;
        END IF;
        
      WHEN startCounter => 
        CtrlBuffer(currentlyReceivingBitPos) <= '1'; --receiving
        CtrlBuffer(readyReadBitPos) <= '0'; -- not ready to read
        -- start counter for the impuls
        startCounterRx <= '1';
        next_state_rx <= readStartBit;
        
      WHEN readStartBit => 
        if counterRateRx = '1' then
          next_state_rx <= readBitX;
        end if;
             
      WHEN readBitX =>
        RxBuffer(counterPosBitRx) <= RxD; --bit x of the buffer rx
        if counterRateRx = '1' then
          next_state_rx <= nextBit;
        end if;
          
      WHEN nextBit => 
        if counterPosBitRx = 7 then
          next_state_rx <= readStopBit;
        else
          next_state_rx <= readBitX;
        end if;
          
      WHEN readStopBit =>
        if counterRate = '1' then
          next_state_rx <= waitForChar;
        end if;
     END CASE; 
  END PROCESS nextstate_rx_proc;  

  -- AHB-Lite
  hReady  <=	'1';	
  hResp	  <=	'0';	

END ARCHITECTURE studentVersion;

