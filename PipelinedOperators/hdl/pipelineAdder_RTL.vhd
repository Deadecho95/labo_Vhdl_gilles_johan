ARCHITECTURE RTL OF pipelineAdder IS

  constant stageBitNb : positive := sum'length/stageNb;
  subtype stageOperandType is signed(stageBitNb-1 downto 0);
  type stageOperandVectorType is array(stageNb-1 downto 0) of stageOperandType;
  type stageOperandMatrixType is array(stageNb-1 downto 0) of stageOperandVectorType;
  subtype carryType is std_ulogic_vector(stageNb downto 0);

  signal a_int, b_int, sum_int : stageOperandMatrixType;
  signal carryIn, carryOut : carryType;

  COMPONENT parallelAdder
  GENERIC (
    bitNb : positive := 32
  );
  PORT (
    sum  : OUT    signed (bitNb-1 DOWNTO 0);
    cIn  : IN     std_ulogic ;
    cOut : OUT    std_ulogic ;
    a    : IN     signed (bitNb-1 DOWNTO 0);
    b    : IN     signed (bitNb-1 DOWNTO 0)
  );
  END COMPONENT;

BEGIN

  carryIn(0) <= cIn;

  distributeInput: for wordIndex in stageOperandVectorType'range generate
    a_int(wordIndex)(0) <= a(wordIndex*stageBitNb+stageBitNb-1 downto wordIndex*stageBitNb);
    b_int(wordIndex)(0) <= b(wordIndex*stageBitNb+stageBitNb-1 downto wordIndex*stageBitNb);
  end generate distributeInput;

  inputRegistersX: for wordIndex in stageOperandVectorType'high downto 1 generate
    inputRegistersY: for pipeIndex in stageOperandMatrixType'high downto 1 generate
      upperTriangle: if wordIndex >= pipeIndex generate
        inputRegisters: process(reset, clock)
        begin
          if reset = '1' then
            a_int(wordIndex)(pipeIndex) <= (others => '0');
            b_int(wordIndex)(pipeIndex) <= (others => '0');
          elsif rising_edge(clock) then
            a_int(wordIndex)(pipeIndex) <= a_int(wordIndex)(pipeIndex-1);
            b_int(wordIndex)(pipeIndex) <= b_int(wordIndex)(pipeIndex-1);
          end if;
        end process inputRegisters;
      end generate upperTriangle;
    end generate inputRegistersY;
  end generate inputRegistersX;

  operation: for index in stageOperandVectorType'range generate
    partialAdder: parallelAdder
      GENERIC MAP (bitNb => stageBitNb)
      PORT MAP (
         a    => a_int(index)(index),
         b    => b_int(index)(index),
         sum  => sum_int(index)(index),
         cIn  => carryIn(index),
         cOut => carryOut(index)
      );
      carryRegisters: process(reset, clock)
      begin
        if reset = '1' then
          carryIn(index+1) <= '0';
        elsif rising_edge(clock) then
          carryIn(index+1) <= carryOut(index);
        end if;
      end process carryRegisters;
  end generate operation;

  outputRegistersX: for wordIndex in stageOperandVectorType'range generate
    outputRegistersY: for pipeIndex in stageOperandMatrixType'range generate
      lowerTriangle: if wordIndex < pipeIndex generate
        outputRegisters: process(reset, clock)
        begin
          if reset = '1' then
            sum_int(wordIndex)(pipeIndex) <= (others => '0');
          elsif rising_edge(clock) then
            sum_int(wordIndex)(pipeIndex) <= sum_int(wordIndex)(pipeIndex-1);
          end if;
        end process outputRegisters;
      end generate lowerTriangle;
    end generate outputRegistersY;
  end generate outputRegistersX;

  packOutput: for index in stageOperandVectorType'range generate
    sum(index*stageBitNb+stageBitNb-1 downto index*stageBitNb) <=
      sum_int(index)(stageOperandMatrixType'high);
  end generate packOutput;

  cOut <= carryOut(carryOut'high-1);

END ARCHITECTURE RTL;
