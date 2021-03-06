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
  constant prescalerBitNb : positive := 8;
  
  -- constants for the register addresses
  constant baudBufferAddr : std_ulogic_vector(addrRegBitNb-1 downto 0) := "10";
  constant CtrlBufferAddr : std_ulogic_vector(addrRegBitNb-1 downto 0) := "01";
  constant TxBufferAddr : std_ulogic_vector(addrRegBitNb-1 downto 0) := "00";
  
  -- constants for the position of bits in CtrlBuffer
  constant readyReadBitPos : integer := 0;
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
  
  -- signals for counters
  signal counterPosBitTx : unsigned(2 downto 0);
  signal counterPosBitRx : unsigned(2 downto 0);
  signal incrPosBitTx : std_ulogic;
  signal incrPosBitRx : std_ulogic;
  signal counterRateRx : std_ulogic;
  signal counterRateTx : std_ulogic;
  signal countTimeRx : unsigned(BaudBuffer'range);
  signal countTimeTx : unsigned(BaudBuffer'range);
  signal startCounterTx : std_ulogic;
  signal startCounterRx : std_ulogic;  
  
  signal clearCtrlReadyRead: std_ulogic;
  signal setCtrlReadyRead: std_ulogic;
  

  TYPE STATE_TYPE_TX IS (
    waitForChar,
    startCounter,
    sendStartBit,
    sendBitX,
    sendStopBit
   );

  TYPE STATE_TYPE_RX IS (
    waitForChar,
    startCounter,
    readStartBit,
    readBitX,
    readStopBit
   );
        
  SIGNAL current_state_tx : STATE_TYPE_TX;
  SIGNAL next_state_tx : STATE_TYPE_TX;
   
  SIGNAL current_state_rx : STATE_TYPE_RX;
  SIGNAL next_state_rx : STATE_TYPE_RX;

BEGIN
  --------------------------------------------------------------------------------
  -- shift the controls signals of the bus
  --------------------------------------------------------------------------------
  shiftProcess: PROCESS(hClk, hReset_n)
  BEGIN
    IF hReset_n = '0' THEN 
      hTransInt <= (OTHERS => '0');
      addrInt <= (OTHERS => '0');
      hSelInt <= '0';
      hWriteInt <= '0';
      
    ELSIF rising_edge(hClk) THEN
      hTransInt <= hTrans;
      hSelInt <= hSel;
      hWriteInt <= hWrite;
      if hSel = '1'  then --save addr to be in phase with data
        addrInt <= std_ulogic_vector(resize(unsigned(hAddr),addrInt'length));
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
      BaudBuffer <= (OTHERS => '0');
      
    ELSIF rising_edge(hClk) THEN
      readyToSend <= '0'; --default value, set only when TxBuffer is written
      if hSelInt = '1' and hTransInt = transNonSeq then
        IF addrInt = TxBufferAddr and hWriteInt = '1' THEN -- work with tx buffer
          if ctrlBuffer(readyWriteBitPos) = '0' then --hWriteInt = '1' and
            TxBuffer <= std_ulogic_vector(RESIZE(unsigned(hWData), txFifoDepth));
            readyToSend <= '1';
          end if;
        ELSIF addrInt = CtrlBufferAddr THEN-- work with control buffer
          if hWriteInt = '1' then
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
  outRegProcess: PROCESS(addrInt, CtrlBuffer, RxBuffer)
  BEGIN
    clearCtrlReadyRead <= '0';
    if addrInt = CtrlBufferAddr then
      hRData <= std_ulogic_vector(RESIZE(unsigned(CtrlBuffer), ahbDataBitNb));
    else
      hRData <= std_ulogic_vector(RESIZE(unsigned(RxBuffer), ahbDataBitNb));
      clearCtrlReadyRead <= '1';
    end if;
  END PROCESS outRegProcess;
  
  --------------------------------------------------------------------------------
  -- set resetfor control bits
  --------------------------------------------------------------------------------
  setResetCtrlBits: PROCESS(hReset_n, hClk)
  BEGIN
    
    if hReset_n = '0' then
      CtrlBuffer(readyReadBitPos) <= '0';
    elsif rising_edge(hClk) then
      if setCtrlReadyRead ='1' then
        CtrlBuffer(readyReadBitPos) <= '1';
      elsif clearCtrlReadyRead = '1' then
        CtrlBuffer(readyReadBitPos) <= '0';
      end if;
    end if;
  END PROCESS setResetCtrlBits;
      
  --------------------------------------------------------------------------------
  -- transition for state machines
  --------------------------------------------------------------------------------
  state_machine_transition: PROCESS(hClk, hReset_n)
  BEGIN
    if hReset_n = '0' then
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
    incrPosBitTx <= '0';
    Txd <= '1';
    
    CASE current_state_tx IS
      -- currently waiting for a char to be written in the reg
      WHEN waitForChar =>
        startCounterTx <= '0';
        CtrlBuffer(readyWriteBitPos) <= '0'; --uC can write a new char
        IF readyToSend = '1' THEN
          next_state_tx <= startCounter;
        END IF;
        
      WHEN startCounter => 
        -- reset the control bit : uC can't write a new char
        CtrlBuffer(readyWriteBitPos) <= '1';
        -- start counter for the impuls
        startCounterTx <= '1';
        next_state_tx <= sendStartBit;
          
      WHEN sendStartBit => 
        Txd <= '0'; -- startBit
        startCounterTx <= '1';
        if counterRateTx = '1' then
          next_state_tx <= sendBitX;
        end if;

      WHEN sendBitX =>
        TxD <= TxBuffer(to_integer(UNSIGNED(counterPosBitTx)));
        startCounterTx <= '1';
        if counterRateTx = '1' then
          incrPosBitTx <= '1';
          if to_integer(UNSIGNED(counterPosBitTx)) = 7 then
            next_state_tx <= sendStopBit;
          end if;
        end if;
          
      WHEN sendStopBit =>
        startCounterTx <= '1';
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
      current_state_rx,
      RxD
   ) 
  BEGIN
    next_state_rx <= current_state_rx; -- default value
    CtrlBuffer(currentlyReceivingBitPos) <= '1';
    incrPosBitRx <= '0';
    setCtrlReadyRead <= '0';
    
    CASE current_state_rx IS
      -- waiting for a start bit
      WHEN waitForChar =>
        startCounterRx <= '0';
        CtrlBuffer(currentlyReceivingBitPos) <= '0'; -- not receiving
        IF RxD = '0' THEN
          next_state_rx <= startCounter;
        END IF;
        
      WHEN startCounter => 
        CtrlBuffer(currentlyReceivingBitPos) <= '1'; --receiving
        -- start counter for the impuls
        startCounterRx <= '1';
        next_state_rx <= readStartBit;
        
      WHEN readStartBit => 
        startCounterRx <= '1';
        if counterRateRx = '1' then
          next_state_rx <= readBitX;
        end if;

       WHEN readBitX =>
        RxBuffer(to_integer(UNSIGNED(counterPosBitRx))) <= RxD; --bit x of the buffer rx
        startCounterRx <= '1';
        if counterRateRx = '1' then
          incrPosBitRx <= '1';
          if to_integer(UNSIGNED(counterPosBitRx)) = 7 then
            next_state_rx <= readStopBit;
          end if;
        end if;
      
          
      WHEN readStopBit =>
        setCtrlReadyRead <= '1';
        startCounterRx <= '1';
        if counterRateRx = '1' then
          next_state_rx <= waitForChar;
        end if;
     END CASE; 
  END PROCESS nextstate_rx_proc;  

  --------------------------------------------------------------------------------
  -- timeCounterTx
  --------------------------------------------------------------------------------
  timeCounterTx: PROCESS(hClk, hReset_n)
  BEGIN
    IF hReset_n = '0' THEN
      countTimeTx <= (others => '0');
      
    ELSIF rising_edge(hClk) THEN
      counterRateTx <= '0';
      if startCounterTx = '1' then
      countTimeTx <= countTimeTx + 1;
        IF countTimeTx+1 = unsigned(BaudBuffer) THEN
          countTimeTx <= (others => '0');
          counterRateTx <= '1'; --signal done
        END IF;
      else
        countTimeTx <= (others => '0'); 
      end if;
    END IF;
  END PROCESS timeCounterTx;
  
  --------------------------------------------------------------------------------
  -- timeCounterRx
  --------------------------------------------------------------------------------
  timeCounterRx: PROCESS(hClk, hReset_n)
  BEGIN
    IF hReset_n = '0' THEN
      countTimeRx <= (others => '0');
      
    ELSIF rising_edge(hClk) THEN
      counterRateRx <= '0';
      if startCounterRx = '1' then
      countTimeRx <= countTimeRx + 1;
        IF countTimeRx+1 = unsigned(BaudBuffer) THEN
          countTimeRx <= (others => '0');
        ELSIF countTimeRx = shift_right(unsigned(BaudBuffer), 1)-1 THEN
          counterRateRx <= '1'; --signal done
        END IF; 
      else
        countTimeRx <= (others => '0');
      end if;
    END IF;
  END PROCESS timeCounterRx;
    
  --------------------------------------------------------------------------------
  -- posBitCounterRx
  --------------------------------------------------------------------------------
  posBitCounterRx: PROCESS(hClk, hReset_n)
  BEGIN
    IF hReset_n = '0' THEN
      counterPosBitRx <= (others => '0');
      
    ELSIF rising_edge(hClk) THEN
      if incrPosBitRx = '1' then
      counterPosBitRx <= counterPosBitRx + 1; 
      end if;
    END IF;
  END PROCESS posBitCounterRx;
  
  --------------------------------------------------------------------------------
  -- posBitCounterTx
  --------------------------------------------------------------------------------
  posBitCounterTx: PROCESS(hClk, hReset_n)
  BEGIN
    IF hReset_n = '0' THEN
      counterPosBitTx <= (others => '0');
      
    ELSIF rising_edge(hClk) THEN
      if incrPosBitTx = '1' then
      counterPosBitTx <= counterPosBitTx + 1; 
      end if;
    END IF;
  END PROCESS posBitCounterTx;
  
  --------------------------------------------------------------------------------

  -- AHB-Lite
  hReady  <=	'1';	
  hResp	  <=	'0';	

END ARCHITECTURE studentVersion;