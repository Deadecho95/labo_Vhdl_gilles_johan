ARCHITECTURE noPipe OF pipelineAdder IS

  constant stageBitNb : positive := sum'length/stageNb;
  subtype stageOperandType is signed(stageBitNb-1 downto 0);
  type stageOperandArrayType is array(stageNb-1 downto 0) of stageOperandType;
  subtype carryType is std_ulogic_vector(stageNb downto 0);

  signal a_int, b_int, sum_int : stageOperandArrayType;
  signal carryIn : carryType;

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

  pipeline: for index in stageOperandArrayType'range generate
    a_int(index) <= a(index*stageBitNb+stageBitNb-1 downto index*stageBitNb);
    b_int(index) <= b(index*stageBitNb+stageBitNb-1 downto index*stageBitNb);
    partialAdder: parallelAdder
      GENERIC MAP (bitNb => stageBitNb)
      PORT MAP (
         a    => a_int(index),
         b    => b_int(index),
         sum  => sum_int(index),
         cIn  => carryIn(index),
         cOut => carryIn(index+1)
      );
    sum(index*stageBitNb+stageBitNb-1 downto index*stageBitNb) <= sum_int(index);
  end generate pipeline;

  cOut <= carryIn(carryIn'high);

END ARCHITECTURE noPipe;
