LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY FPGA_textWriter IS
GENERIC(
bitNb : positive := 16
);
PORT(
clock       : IN     std_ulogic;
reset_N     : IN     std_ulogic;
selSinCos_n : IN     std_ulogic;
triggerOut  : OUT    std_ulogic;
xOut        : OUT    std_ulogic;
yOut        : OUT    std_ulogic
);
END FPGA_textWriter ;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY inverterIn IS
PORT(
in1  : IN     std_uLogic;
out1 : OUT    std_uLogic
);
END inverterIn ;
ARCHITECTURE sim OF inverterIn IS
BEGIN
out1 <= NOT in1;
END ARCHITECTURE sim;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY textWriter IS
GENERIC(
curvePointNb : positive := 4;
testOutBitNb : positive := 16
);
PORT(
outX      : OUT    std_ulogic;
outY      : OUT    std_ulogic;
selSinCos : IN     std_ulogic;
clock     : IN     std_ulogic;
reset     : IN     std_ulogic;
testOut   : OUT    std_ulogic_vector (1 TO testOutBitNb)
);
END textWriter ;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY beamerPeriphControls IS
GENERIC(
curvePointNb        : positive := 4;
updatePeriodBitNb   : positive := 16;
signalBitNb         : positive := 16;
patternAddressBitNb : positive := 8;
testOutBitNb        : positive := 16
);
PORT(
clock          : IN     std_ulogic;
testOut        : OUT    std_ulogic_vector (1 TO testOutBitNb);
memX           : OUT    std_ulogic_vector (signalBitNb-1 DOWNTO 0);
memY           : OUT    std_ulogic_vector (signalBitNb-1 DOWNTO 0);
run            : OUT    std_ulogic;
updatePeriod   : OUT    unsigned (updatePeriodBitNb-1 DOWNTO 0);
interpolateLin : OUT    std_ulogic;
reset          : IN     std_ulogic;
newPolynom     : IN     std_ulogic
);
END beamerPeriphControls ;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY blockRAM IS
GENERIC(
addressBitNb : positive := 8;
dataBitNb    : positive := 16;
initFileSpec : string   := "ramInit.txt"
);
PORT(
dataIn  : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
dataOut : OUT    std_ulogic_vector (dataBitNb-1 DOWNTO 0);
en      : IN     std_ulogic;
clock   : IN     std_ulogic;
reset   : IN     std_ulogic;
write   : IN     std_ulogic;
addr    : IN     unsigned (addressBitNb-1 DOWNTO 0)
);
END blockRAM ;
USE std.textio.all;
ARCHITECTURE Spartan3E OF blockRAM IS
subtype registerType is std_ulogic_vector(dataBitNb-1 downto 0);
type memoryType is array (0 to 2**addressBitNb-1) of registerType;
impure function ReadRamContentFromFile(ramContentFileSpec : in string) return memoryType is
FILE     ramContentFile     : text open read_mode is ramContentFileSpec;
variable ramContentFileLine : line;
variable ramContent         : memoryType;
variable ramCurrentWord     : bit_vector(registerType'range);
variable index              : natural := 241;
begin
for index in ramContent'range loop
readline(ramContentFile, ramContentFileLine);
read(ramContentFileLine, ramCurrentWord);
ramContent(index) := std_ulogic_vector(to_stdlogicvector(ramCurrentWord));
end loop;
return ramContent;
end function;
shared variable memoryArray: memoryType := ReadRamContentFromFile(initFileSpec);
BEGIN
portA: process(clock)
begin
if rising_edge(clock) then
if (en = '1') then
if (write = '1') then
memoryArray(to_integer(addr)) := dataIn;
dataOut <= dataIn;
else
dataOut <= memoryArray(to_integer(addr));
end if;
end if;
end if;
end process portA;
END ARCHITECTURE Spartan3E;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY blockRAMControl IS
PORT(
memWr     : OUT    std_ulogic;
sel       : IN     std_ulogic;
memEn     : OUT    std_ulogic;
update    : IN     std_ulogic;
wr        : IN     std_ulogic;
cntIncr   : OUT    std_ulogic;
newSample : IN     std_ulogic;
clock     : IN     std_ulogic;
reset     : IN     std_ulogic
);
END blockRAMControl ;
ARCHITECTURE RTL OF blockRAMControl IS
signal writeDelayed: std_ulogic;
signal writePulse: std_ulogic;
signal memWr1: std_ulogic;
BEGIN
delayWrPulse: process(reset, clock)
begin
if reset = '1' then
writeDelayed <= '0';
elsif rising_edge(clock) then
writeDelayed <= wr;
end if;
end process delayWrPulse;
writePulse <= '1' when (wr='1') and (writeDelayed='0')
else '0';
cntIncr <= '1' when ( (update = '0') and (newSample = '1') )
or ( (update = '1') and (writePulse = '1') and (sel = '1') )
else '0';
memWr1 <= '1' when (update = '1') and (writePulse = '1') and (sel = '1')
else '0';
memWr <= memWr1;
memEn <= '1' when (sel = '1') or (update = '0')
else '0';
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY blockRAMAddressCounter IS
GENERIC(
addressBitNb : positive := 8
);
PORT(
en          : IN     std_ulogic;
clock       : IN     std_ulogic;
reset       : IN     std_ulogic;
updateMem   : IN     std_ulogic;
addr        : OUT    unsigned (addressBitNb-1 DOWNTO 0);
patternSize : IN     unsigned (addressBitNb-1 DOWNTO 0)
);
END blockRAMAddressCounter ;
ARCHITECTURE RTL OF blockRAMAddressCounter IS
signal updateMemDelayed : std_ulogic;
signal updateMemChanging : std_ulogic;
signal addressInt : unsigned(addr'range);
BEGIN
delay: process(reset, clock)
begin
if reset = '1' then
updateMemDelayed <= '0';
elsif rising_edge(clock) then
updateMemDelayed <= updateMem;
end if;
end process delay;
updateMemChanging <= '1' when (updateMem /= updateMemDelayed)
else '0';
count: process(reset, clock)
begin
if reset = '1' then
addressInt <= (others => '0');
elsif rising_edge(clock) then
if updateMemChanging = '1' then
addressInt <= (others => '0');
elsif en = '1' then
if updateMem = '1' then
addressInt <= addressInt + 1;
else
if addressInt < patternSize - 1  then
addressInt <= addressInt + 1;
else
addressInt <= (others => '0');
end if;
end if;
end if;
end if;
end process count;
addr <= addressInt;
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
ARCHITECTURE struct OF beamerPeriphControls IS
constant addressBitNb: positive := 32;
constant dataBitNb : positive := 32;
SIGNAL addrX         : unsigned(patternAddressBitNb-1 DOWNTO 0);
SIGNAL addrY         : unsigned(patternAddressBitNb-1 DOWNTO 0);
SIGNAL cntIncrX      : std_ulogic;
SIGNAL cntIncrY      : std_ulogic;
SIGNAL memEnX        : std_ulogic;
SIGNAL memEnY        : std_ulogic;
SIGNAL memWrX        : std_ulogic;
SIGNAL memWrY        : std_ulogic;
SIGNAL patternSize   : unsigned(patternAddressBitNb-1 DOWNTO 0);
SIGNAL updatePattern : std_ulogic;
SIGNAL write         : std_ulogic;
SIGNAL memDataIn     : std_ulogic_vector(signalBitNb-1 DOWNTO 0);
SIGNAL selY          : std_ulogic;
SIGNAL selX          : std_ulogic;
COMPONENT blockRAM
GENERIC (
addressBitNb : positive := 8;
dataBitNb    : positive := 16;
initFileSpec : string   := "ramInit.txt"
);
PORT (
dataIn  : IN     std_ulogic_vector (dataBitNb-1 DOWNTO 0);
dataOut : OUT    std_ulogic_vector (dataBitNb-1 DOWNTO 0);
en      : IN     std_ulogic ;
clock   : IN     std_ulogic ;
reset   : IN     std_ulogic ;
write   : IN     std_ulogic ;
addr    : IN     unsigned (addressBitNb-1 DOWNTO 0)
);
END COMPONENT;
COMPONENT blockRAMAddressCounter
GENERIC (
addressBitNb : positive := 8
);
PORT (
en          : IN     std_ulogic ;
clock       : IN     std_ulogic ;
reset       : IN     std_ulogic ;
updateMem   : IN     std_ulogic ;
addr        : OUT    unsigned (addressBitNb-1 DOWNTO 0);
patternSize : IN     unsigned (addressBitNb-1 DOWNTO 0)
);
END COMPONENT;
COMPONENT blockRAMControl
PORT (
memWr     : OUT    std_ulogic ;
sel       : IN     std_ulogic ;
memEn     : OUT    std_ulogic ;
update    : IN     std_ulogic ;
wr        : IN     std_ulogic ;
cntIncr   : OUT    std_ulogic ;
newSample : IN     std_ulogic ;
clock     : IN     std_ulogic ;
reset     : IN     std_ulogic
);
END COMPONENT;
BEGIN
testout(1) <= '1' when addrX = 0 else '0';
testout(2) <= updatePattern;
testout(3) <= '0';
testout(4) <= newPolynom;
testout(5) <= '0';
testout(6) <= '0';
testout(7) <= '0';
testout(8) <= '0';
testout(9) <= '0';
testout(10) <= '0';
testout(11) <= '0';
testout(12) <= '0';
testout(13) <= selX;
testout(14) <= selY;
testout(15) <= cntIncrX;
testout(16) <= cntIncrY;
memDataIn <= (others => '0');
patternSize <= to_unsigned(curvePointNb, patternSize'length);
updatePattern <= '0';
write <= '0';
selX <= '0';
selY <= '0';
run <= '1';
interpolateLin <= '0';
updatePeriod <= to_unsigned(20, updatePeriod'length);
I17 : blockRAM
GENERIC MAP (
addressBitNb => patternAddressBitNb,
dataBitNb    => signalBitNb,
initFileSpec => "../../Simulation\ramYInit.txt"
)
PORT MAP (
dataIn  => memDataIn,
dataOut => memY,
en      => memEnY,
clock   => clock,
reset   => reset,
write   => memWrY,
addr    => addrY
);
I18 : blockRAM
GENERIC MAP (
addressBitNb => patternAddressBitNb,
dataBitNb    => signalBitNb,
initFileSpec => "../../Simulation\ramXInit.txt"
)
PORT MAP (
dataIn  => memDataIn,
dataOut => memX,
en      => memEnX,
clock   => clock,
reset   => reset,
write   => memWrX,
addr    => addrX
);
I20 : blockRAMAddressCounter
GENERIC MAP (
addressBitNb => patternAddressBitNb
)
PORT MAP (
en          => cntIncrY,
clock       => clock,
reset       => reset,
updateMem   => updatePattern,
addr        => addrY,
patternSize => patternSize
);
I30 : blockRAMAddressCounter
GENERIC MAP (
addressBitNb => patternAddressBitNb
)
PORT MAP (
en          => cntIncrX,
clock       => clock,
reset       => reset,
updateMem   => updatePattern,
addr        => addrX,
patternSize => patternSize
);
I19 : blockRAMControl
PORT MAP (
memWr     => memWrY,
sel       => selY,
memEn     => memEnY,
update    => updatePattern,
wr        => write,
cntIncr   => cntIncrY,
newSample => newPolynom,
clock     => clock,
reset     => reset
);
I31 : blockRAMControl
PORT MAP (
memWr     => memWrX,
sel       => selX,
memEn     => memEnX,
update    => updatePattern,
wr        => write,
cntIncr   => cntIncrX,
newSample => newPolynom,
clock     => clock,
reset     => reset
);
END struct;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY beamerPeriphOperator IS
GENERIC(
updatePeriodBitNb : positive := 16;
signalBitNb       : positive := 16
);
PORT(
outX           : OUT    std_ulogic;
run            : IN     std_ulogic;
clock          : IN     std_ulogic;
reset          : IN     std_ulogic;
outY           : OUT    std_ulogic;
selSinCos      : IN     std_ulogic;
interpolateLin : IN     std_ulogic;
updatePeriod   : IN     unsigned (updatePeriodBitNb-1 DOWNTO 0);
memX           : IN     std_ulogic_vector (signalBitNb-1 DOWNTO 0);
memY           : IN     std_ulogic_vector (signalBitNb-1 DOWNTO 0);
newPolynom     : OUT    std_ulogic
);
END beamerPeriphOperator ;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY interpolatorCoefficients IS
GENERIC(
bitNb      : positive := 16;
coeffBitNb : positive := 16
);
PORT(
sample1           : IN     signed (bitNb-1 DOWNTO 0);
sample2           : IN     signed (bitNb-1 DOWNTO 0);
sample3           : IN     signed (bitNb-1 DOWNTO 0);
sample4           : IN     signed (bitNb-1 DOWNTO 0);
a                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
b                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
c                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
d                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
interpolateLinear : IN     std_ulogic
);
END interpolatorCoefficients ;
ARCHITECTURE RTL OF interpolatorCoefficients IS
BEGIN
calcCoeffs: process(interpolateLinear, sample1, sample2, sample3, sample4)
begin
if interpolateLinear = '1' then
a <= (others => '0');
b <= (others => '0');
c <=   resize(2*sample3, c'length)
- resize(2*sample2, c'length);
d <=   resize(  sample2, d'length);
else
a <=   resize(  sample4, a'length)
- resize(3*sample3, a'length)
+ resize(3*sample2, a'length)
- resize(  sample1, a'length);
b <=   resize(2*sample1, b'length)
- resize(5*sample2, b'length)
+ resize(4*sample3, b'length)
- resize(  sample4, b'length);
c <=   resize(  sample3, c'length)
- resize(  sample1, c'length);
d <=   resize(  sample2, d'length);
end if;
end process calcCoeffs;
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY DAC IS
GENERIC(
signalBitNb : positive := 16
);
PORT(
serialOut  : OUT    std_ulogic;
parallelIn : IN     unsigned (signalBitNb-1 DOWNTO 0);
clock      : IN     std_ulogic;
reset      : IN     std_ulogic
);
END DAC ;
ARCHITECTURE order2 OF DAC IS
constant acc1BitNb: positive := parallelIn'length+4;
constant acc2BitNb: positive := parallelIn'length+5;
constant c1: signed(acc1BitNb-1 downto 0)
:= shift_left(to_signed(1, acc1BitNb), parallelIn'length-1);
constant c2: signed(acc2BitNb-1 downto 0)
:= shift_left(resize(c1, acc2BitNb), 4);
signal parallelIn1: signed(parallelIn'high downto 0);
signal acc1: signed(acc1BitNb-1 downto 0);
signal acc2: signed(acc2BitNb-1 downto 0);
signal quantized: std_ulogic;
BEGIN
parallelIn1(parallelIn1'high) <= not parallelIn(parallelIn'high);
parallelIn1(parallelIn1'high-1) <= not parallelIn(parallelIn'high);
parallelIn1(parallelIn1'high-2 downto 0) <=
signed(parallelIn(parallelIn'high-1 downto 1));
integrate1: process(reset, clock)
begin
if reset = '1' then
acc1 <= (others => '0');
elsif rising_edge(clock) then
if quantized = '0' then
acc1 <= acc1 + resize(parallelIn1, acc1'length) + c1;
else
acc1 <= acc1 + resize(parallelIn1, acc1'length) - c1;
end if;
end if;
end process integrate1;
integrate2: process(reset, clock)
begin
if reset = '1' then
acc2 <= (others => '0');
elsif rising_edge(clock) then
if quantized = '0' then
acc2 <= acc2 + resize(acc1, acc2'length) + c2;
else
acc2 <= acc2 + resize(acc1, acc2'length) - c2;
end if;
end if;
end process integrate2;
quantized <= '1' when acc2 >= 0 else '0';
serialOut <= quantized;
END ARCHITECTURE order2;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY offsetToUnsigned IS
GENERIC(
bitNb : positive := 16
);
PORT(
unsignedOut : OUT    unsigned (bitNb-1 DOWNTO 0);
signedIn    : IN     signed (bitNb-1 DOWNTO 0)
);
END offsetToUnsigned ;
ARCHITECTURE RTL OF offsetToUnsigned IS
BEGIN
unsignedOut <= not(signedIn(signedIn'high)) & unsigned(signedIn(signedIn'high-1 downto 0));
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY sawtoothGen IS
GENERIC(
bitNb : positive := 16
);
PORT(
sawtooth : OUT    unsigned (bitNb-1 DOWNTO 0);
clock    : IN     std_ulogic;
reset    : IN     std_ulogic;
step     : IN     unsigned (bitNb-1 DOWNTO 0);
en       : IN     std_ulogic
);
END sawtoothGen ;
ARCHITECTURE RTL OF sawtoothGen IS
signal counter: unsigned(sawtooth'range);
begin
count: process(reset, clock)
begin
if reset = '1' then
counter <= (others => '0');
elsif rising_edge(clock) then
if en = '1' then
counter <= counter + step;
end if;
end if;
end process count;
sawtooth <= counter;
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY interpolatorCalculatePolynom IS
GENERIC(
signalBitNb       : positive := 16;
coeffBitNb        : positive := 16;
oversamplingBitNb : positive := 8
);
PORT(
clock          : IN     std_ulogic;
reset          : IN     std_ulogic;
restartPolynom : IN     std_ulogic;
d              : IN     signed (coeffBitNb-1 DOWNTO 0);
sampleOut      : OUT    signed (signalBitNb-1 DOWNTO 0);
c              : IN     signed (coeffBitNb-1 DOWNTO 0);
b              : IN     signed (coeffBitNb-1 DOWNTO 0);
a              : IN     signed (coeffBitNb-1 DOWNTO 0);
en             : IN     std_ulogic
);
END interpolatorCalculatePolynom ;
ARCHITECTURE RTL OF interpolatorCalculatePolynom IS
constant internalsBitNb: positive := signalBitNb + 3*oversamplingBitNb + 1;
signal x: signed(internalsBitNb-1 downto 0);
signal u: signed(internalsBitNb-1 downto 0);
signal v: signed(internalsBitNb-1 downto 0);
signal w: signed(internalsBitNb-1 downto 0);
BEGIN
iterativePolynom: process(reset, clock)
begin
if reset = '1' then
x <= (others => '0');
u <= (others => '0');
v <= (others => '0');
w <= (others => '0');
sampleOut <= (others => '0');
elsif rising_edge(clock) then
if en = '1' then
if restartPolynom = '1' then
x <=   shift_left(resize(2*d, x'length), 3*oversamplingBitNb);
u <=   resize(a, u'length)
+ shift_left(resize(b, u'length), oversamplingBitNb)
+ shift_left(resize(c, u'length), 2*oversamplingBitNb);
v <=   resize(6*a, v'length)
+ shift_left(resize(2*b, v'length), oversamplingBitNb);
w <=   resize(6*a, w'length);
sampleOut <= resize(d, sampleOut'length);
else
x <= x + u;
u <= u + v;
v <= v + w;
sampleOut <= resize(shift_right(x, 3*oversamplingBitNb+1), sampleOut'length);
end if;
end if;
end if;
end process iterativePolynom;
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY sinCosTable IS
GENERIC(
inputBitNb        : positive := 16;
outputBitNb       : positive := 16;
tableAddressBitNb : positive := 3
);
PORT(
sine   : OUT    signed (outputBitNb-1 DOWNTO 0);
phase  : IN     unsigned (inputBitNb-1 DOWNTO 0);
cosine : OUT    signed (outputBitNb-1 DOWNTO 0)
);
END sinCosTable ;
ARCHITECTURE RTL OF sinCosTable IS
signal changeSignSine : std_uLogic;
signal changeSignCosine : std_uLogic;
signal flipPhase : std_uLogic;
signal phaseTableAddress1 : unsigned(tableAddressBitNb-1 downto 0);
signal phaseTableAddress2 : unsigned(phaseTableAddress1'range);
signal quarterSine : signed(sine'range);
signal quarterCosine : signed(cosine'range);
BEGIN
changeSignSine <= phase(phase'high);
changeSignCosine <= phase(phase'high) xor phase(phase'high-1);
flipPhase <= phase(phase'high-1);
phaseTableAddress1 <= phase(phase'high-2 downto phase'high-2-tableAddressBitNb+1);
checkPhase: process(flipPhase, phaseTableAddress1)
begin
if flipPhase = '0' then
phaseTableAddress2 <= phaseTableAddress1;
else
phaseTableAddress2 <= 0 - phaseTableAddress1;
end if;
end process checkPhase;
quarterTableSine: process(phaseTableAddress2, flipPhase)
begin
case to_integer(phaseTableAddress2) is
when 0 => if flipPhase = '0' then
quarterSine <= to_signed(16#0000#, quarterSine'length);
else
quarterSine <= to_signed(16#7FFF#, quarterSine'length);
end if;
when 1 => quarterSine <= to_signed(16#18F9#, quarterSine'length);
when 2 => quarterSine <= to_signed(16#30FB#, quarterSine'length);
when 3 => quarterSine <= to_signed(16#471C#, quarterSine'length);
when 4 => quarterSine <= to_signed(16#5A82#, quarterSine'length);
when 5 => quarterSine <= to_signed(16#6A6D#, quarterSine'length);
when 6 => quarterSine <= to_signed(16#7641#, quarterSine'length);
when 7 => quarterSine <= to_signed(16#7D89#, quarterSine'length);
when others => quarterSine <= (others => '-');
end case;
end process quarterTableSine;
quarterTableCosine: process(phaseTableAddress2, flipPhase)
begin
case to_integer(phaseTableAddress2) is
when 0 => if flipPhase = '1' then
quarterCosine <= to_signed(16#0000#, quarterSine'length);
else
quarterCosine <= to_signed(16#7FFF#, quarterSine'length);
end if;
when 7 => quarterCosine <= to_signed(16#18F9#, quarterSine'length);
when 6 => quarterCosine <= to_signed(16#30FB#, quarterSine'length);
when 5 => quarterCosine <= to_signed(16#471C#, quarterSine'length);
when 4 => quarterCosine <= to_signed(16#5A82#, quarterSine'length);
when 3 => quarterCosine <= to_signed(16#6A6D#, quarterSine'length);
when 2 => quarterCosine <= to_signed(16#7641#, quarterSine'length);
when 1 => quarterCosine <= to_signed(16#7D89#, quarterSine'length);
when others => quarterCosine <= (others => '-');
end case;
end process quarterTableCosine;
checkSignSine: process(changeSignSine, quarterSine)
begin
if changeSignSine = '0' then
sine <= quarterSine;
else
sine <= 0 - quarterSine;
end if;
end process checkSignSine;
checkSignCosine: process(changeSignCosine, quarterCosine)
begin
if changeSignCosine = '0' then
cosine <= quarterCosine;
else
cosine <= 0 - quarterCosine;
end if;
end process checkSignCosine;
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY periphSpeedController IS
GENERIC(
updatePeriodBitNb : positive := 16
);
PORT(
enableOut    : OUT    std_ulogic;
clock        : IN     std_ulogic;
reset        : IN     std_ulogic;
updatePeriod : IN     unsigned (updatePeriodBitNb-1 DOWNTO 0);
enableIn     : IN     std_ulogic
);
END periphSpeedController ;
ARCHITECTURE RTL OF periphSpeedController IS
signal enableCounter: unsigned(updatePeriod'range);
signal endOfCount: std_uLogic;
BEGIN
count: process(reset, clock)
begin
if reset = '1' then
enableCounter <= (others => '0');
elsif rising_edge(clock) then
if (endOfCount = '0') and (enableIn = '1') then
enableCounter <= enableCounter - 1;
else
enableCounter <= updatePeriod;
end if;
end if;
end process count;
testEndOfCount: process(enableCounter)
begin
if enableCounter = 0 then
endOfCount <= '1';
else
endOfCount <= '0';
end if;
end process testEndOfCount;
enableOut <= endOfCount;
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY interpolatorShiftRegister IS
GENERIC(
signalBitNb : positive := 16
);
PORT(
clock        : IN     std_ulogic;
reset        : IN     std_ulogic;
shiftSamples : IN     std_ulogic;
sampleIn     : IN     signed (signalBitNb-1 DOWNTO 0);
sample1      : OUT    signed (signalBitNb-1 DOWNTO 0);
sample2      : OUT    signed (signalBitNb-1 DOWNTO 0);
sample3      : OUT    signed (signalBitNb-1 DOWNTO 0);
sample4      : OUT    signed (signalBitNb-1 DOWNTO 0)
);
END interpolatorShiftRegister ;
ARCHITECTURE RTL OF interpolatorShiftRegister IS
signal sample4_int: signed(sampleIn'range);
signal sample3_int: signed(sampleIn'range);
signal sample2_int: signed(sampleIn'range);
signal sample1_int: signed(sampleIn'range);
begin
shiftThem: process(reset, clock)
begin
if reset = '1' then
sample1_int <= (others => '0');
sample2_int <= (others => '0');
sample3_int <= (others => '0');
sample4_int <= (others => '0');
elsif rising_edge(clock) then
if shiftSamples = '1' then
sample1_int <= sample2_int;
sample2_int <= sample3_int;
sample3_int <= sample4_int;
sample4_int <= sampleIn;
end if;
end if;
end process shiftThem;
sample4 <= sample4_int;
sample3 <= sample3_int;
sample2 <= sample2_int;
sample1 <= sample1_int;
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY interpolatorTrigger IS
GENERIC(
counterBitNb : positive := 4
);
PORT(
triggerOut : OUT    std_ulogic;
clock      : IN     std_ulogic;
reset      : IN     std_ulogic;
en         : IN     std_ulogic
);
END interpolatorTrigger ;
ARCHITECTURE RTL OF interpolatorTrigger IS
signal triggerCounter: unsigned(counterBitNb-1 downto 0);
BEGIN
count: process(reset, clock)
begin
if reset = '1' then
triggerCounter <= (others => '0');
elsif rising_edge(clock) then
if en = '1' then
triggerCounter <= triggerCounter + 1;
end if;
end if;
end process count;
trig: process(triggerCounter, en)
begin
if triggerCounter = 0 then
triggerOut <= en;
else
triggerOut <= '0';
end if;
end process trig;
END ARCHITECTURE RTL;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
ARCHITECTURE struct OF beamerPeriphOperator IS
constant coeffBitNb : positive := signalBitNb+3;
constant sampleCountBitNb : positive := 8;
constant patternAddressBitNb : positive := 9;
constant tableAddressBitNb : positive := 3;
constant phaseBitNb : positive := sampleCountBitNb + tableAddressBitNb + 2;
SIGNAL aX                  : signed(coeffBitNb-1 DOWNTO 0);
SIGNAL aY                  : signed(coeffBitNb-1 DOWNTO 0);
SIGNAL bX                  : signed(coeffBitNb-1 DOWNTO 0);
SIGNAL bY                  : signed(coeffBitNb-1 DOWNTO 0);
SIGNAL cX                  : signed(coeffBitNb-1 DOWNTO 0);
SIGNAL cY                  : signed(coeffBitNb-1 DOWNTO 0);
SIGNAL cosine              : signed(signalBitNb-1 DOWNTO 0);
SIGNAL dX                  : signed(coeffBitNb-1 DOWNTO 0);
SIGNAL dY                  : signed(coeffBitNb-1 DOWNTO 0);
SIGNAL interpolateLinear   : std_ulogic;
SIGNAL interpolationEn     : std_ulogic;
SIGNAL interpolationEnable : std_ulogic;
SIGNAL phase               : unsigned(phaseBitNb-1 DOWNTO 0);
SIGNAL sampleX             : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleX1            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleX2            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleX3            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleX4            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleY             : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleY1            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleY2            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleY3            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sampleY4            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL samplesX            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL samplesY            : signed(signalBitNb-1 DOWNTO 0);
SIGNAL sine                : signed(signalBitNb-1 DOWNTO 0);
SIGNAL step                : unsigned(phaseBitNb-1 DOWNTO 0);
SIGNAL unsignedX           : unsigned(signalBitNb-1 DOWNTO 0);
SIGNAL unsignedY           : unsigned(signalBitNb-1 DOWNTO 0);
SIGNAL newPolynom_internal : std_ulogic;
COMPONENT DAC
GENERIC (
signalBitNb : positive := 16
);
PORT (
serialOut  : OUT    std_ulogic ;
parallelIn : IN     unsigned (signalBitNb-1 DOWNTO 0);
clock      : IN     std_ulogic ;
reset      : IN     std_ulogic
);
END COMPONENT;
COMPONENT interpolatorCalculatePolynom
GENERIC (
signalBitNb       : positive := 16;
coeffBitNb        : positive := 16;
oversamplingBitNb : positive := 8
);
PORT (
clock          : IN     std_ulogic ;
reset          : IN     std_ulogic ;
restartPolynom : IN     std_ulogic ;
d              : IN     signed (coeffBitNb-1 DOWNTO 0);
sampleOut      : OUT    signed (signalBitNb-1 DOWNTO 0);
c              : IN     signed (coeffBitNb-1 DOWNTO 0);
b              : IN     signed (coeffBitNb-1 DOWNTO 0);
a              : IN     signed (coeffBitNb-1 DOWNTO 0);
en             : IN     std_ulogic
);
END COMPONENT;
COMPONENT interpolatorCoefficients
GENERIC (
bitNb      : positive := 16;
coeffBitNb : positive := 16
);
PORT (
sample1           : IN     signed (bitNb-1 DOWNTO 0);
sample2           : IN     signed (bitNb-1 DOWNTO 0);
sample3           : IN     signed (bitNb-1 DOWNTO 0);
sample4           : IN     signed (bitNb-1 DOWNTO 0);
a                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
b                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
c                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
d                 : OUT    signed (coeffBitNb-1 DOWNTO 0);
interpolateLinear : IN     std_ulogic
);
END COMPONENT;
COMPONENT interpolatorShiftRegister
GENERIC (
signalBitNb : positive := 16
);
PORT (
clock        : IN     std_ulogic ;
reset        : IN     std_ulogic ;
shiftSamples : IN     std_ulogic ;
sampleIn     : IN     signed (signalBitNb-1 DOWNTO 0);
sample1      : OUT    signed (signalBitNb-1 DOWNTO 0);
sample2      : OUT    signed (signalBitNb-1 DOWNTO 0);
sample3      : OUT    signed (signalBitNb-1 DOWNTO 0);
sample4      : OUT    signed (signalBitNb-1 DOWNTO 0)
);
END COMPONENT;
COMPONENT interpolatorTrigger
GENERIC (
counterBitNb : positive := 4
);
PORT (
triggerOut : OUT    std_ulogic ;
clock      : IN     std_ulogic ;
reset      : IN     std_ulogic ;
en         : IN     std_ulogic
);
END COMPONENT;
COMPONENT offsetToUnsigned
GENERIC (
bitNb : positive := 16
);
PORT (
unsignedOut : OUT    unsigned (bitNb-1 DOWNTO 0);
signedIn    : IN     signed (bitNb-1 DOWNTO 0)
);
END COMPONENT;
COMPONENT periphSpeedController
GENERIC (
updatePeriodBitNb : positive := 16
);
PORT (
enableOut    : OUT    std_ulogic ;
clock        : IN     std_ulogic ;
reset        : IN     std_ulogic ;
updatePeriod : IN     unsigned (updatePeriodBitNb-1 DOWNTO 0);
enableIn     : IN     std_ulogic
);
END COMPONENT;
COMPONENT sawtoothGen
GENERIC (
bitNb : positive := 16
);
PORT (
sawtooth : OUT    unsigned (bitNb-1 DOWNTO 0);
clock    : IN     std_ulogic ;
reset    : IN     std_ulogic ;
step     : IN     unsigned (bitNb-1 DOWNTO 0);
en       : IN     std_ulogic
);
END COMPONENT;
COMPONENT sinCosTable
GENERIC (
inputBitNb        : positive := 16;
outputBitNb       : positive := 16;
tableAddressBitNb : positive := 3
);
PORT (
sine   : OUT    signed (outputBitNb-1 DOWNTO 0);
phase  : IN     unsigned (inputBitNb-1 DOWNTO 0);
cosine : OUT    signed (outputBitNb-1 DOWNTO 0)
);
END COMPONENT;
BEGIN
samplesY <= sine when selSinCos = '1'
else signed(memY);
samplesX <= cosine when selSinCos = '1'
else signed(memX);
step <= to_unsigned(1, step'length);
interpolationEnable <= '1' when selSinCos = '1'
else interpolationEn;
interpolateLinear <= '0' when selSinCos = '1'
else interpolateLin;
I_dacx : DAC
GENERIC MAP (
signalBitNb => signalBitNb
)
PORT MAP (
serialOut  => outX,
parallelIn => unsignedX,
clock      => clock,
reset      => reset
);
I_dacy : DAC
GENERIC MAP (
signalBitNb => signalBitNb
)
PORT MAP (
serialOut  => outY,
parallelIn => unsignedY,
clock      => clock,
reset      => reset
);
I_polyx : interpolatorCalculatePolynom
GENERIC MAP (
signalBitNb       => signalBitNb,
coeffBitNb        => coeffBitNb,
oversamplingBitNb => sampleCountBitNb
)
PORT MAP (
clock          => clock,
reset          => reset,
restartPolynom => newPolynom_internal,
d              => dX,
sampleOut      => sampleX,
c              => cX,
b              => bX,
a              => aX,
en             => interpolationEnable
);
I_polyy : interpolatorCalculatePolynom
GENERIC MAP (
signalBitNb       => signalBitNb,
coeffBitNb        => coeffBitNb,
oversamplingBitNb => sampleCountBitNb
)
PORT MAP (
clock          => clock,
reset          => reset,
restartPolynom => newPolynom_internal,
d              => dY,
sampleOut      => sampleY,
c              => cY,
b              => bY,
a              => aY,
en             => interpolationEnable
);
I_coeffx : interpolatorCoefficients
GENERIC MAP (
bitNb      => signalBitNb,
coeffBitNb => coeffBitNb
)
PORT MAP (
sample1           => sampleX1,
sample2           => sampleX2,
sample3           => sampleX3,
sample4           => sampleX4,
a                 => aX,
b                 => bX,
c                 => cX,
d                 => dX,
interpolateLinear => interpolateLinear
);
I_coeffy : interpolatorCoefficients
GENERIC MAP (
bitNb      => signalBitNb,
coeffBitNb => coeffBitNb
)
PORT MAP (
sample1           => sampleY1,
sample2           => sampleY2,
sample3           => sampleY3,
sample4           => sampleY4,
a                 => aY,
b                 => bY,
c                 => cY,
d                 => dY,
interpolateLinear => interpolateLinear
);
I_srx : interpolatorShiftRegister
GENERIC MAP (
signalBitNb => signalBitNb
)
PORT MAP (
clock        => clock,
reset        => reset,
shiftSamples => newPolynom_internal,
sampleIn     => samplesX,
sample1      => sampleX1,
sample2      => sampleX2,
sample3      => sampleX3,
sample4      => sampleX4
);
I_sry : interpolatorShiftRegister
GENERIC MAP (
signalBitNb => signalBitNb
)
PORT MAP (
clock        => clock,
reset        => reset,
shiftSamples => newPolynom_internal,
sampleIn     => samplesY,
sample1      => sampleY1,
sample2      => sampleY2,
sample3      => sampleY3,
sample4      => sampleY4
);
I_trig : interpolatorTrigger
GENERIC MAP (
counterBitNb => sampleCountBitNb
)
PORT MAP (
triggerOut => newPolynom_internal,
clock      => clock,
reset      => reset,
en         => interpolationEnable
);
I_offsx : offsetToUnsigned
GENERIC MAP (
bitNb => signalBitNb
)
PORT MAP (
unsignedOut => unsignedX,
signedIn    => sampleX
);
I_offsy : offsetToUnsigned
GENERIC MAP (
bitNb => signalBitNb
)
PORT MAP (
unsignedOut => unsignedY,
signedIn    => sampleY
);
I_speed : periphSpeedController
GENERIC MAP (
updatePeriodBitNb => updatePeriodBitNb
)
PORT MAP (
enableOut    => interpolationEn,
clock        => clock,
reset        => reset,
updatePeriod => updatePeriod,
enableIn     => run
);
I_phase : sawtoothGen
GENERIC MAP (
bitNb => phaseBitNb
)
PORT MAP (
sawtooth => phase,
clock    => clock,
reset    => reset,
step     => step,
en       => interpolationEnable
);
I_sin : sinCosTable
GENERIC MAP (
inputBitNb        => phaseBitNb,
outputBitNb       => signalBitNb,
tableAddressBitNb => tableAddressBitNb
)
PORT MAP (
sine   => sine,
phase  => phase,
cosine => cosine
);
newPolynom <= newPolynom_internal;
END struct;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
ARCHITECTURE struct OF textWriter IS
constant signalBitNb: positive := 16;
constant updatePeriodBitNb : positive := 16;
constant patternAddressBitNb : positive := 9;
SIGNAL run            : std_ulogic;
SIGNAL interpolateLin : std_ulogic;
SIGNAL updatePeriod   : unsigned(updatePeriodBitNb-1 DOWNTO 0);
SIGNAL memX           : std_ulogic_vector(signalBitNb-1 DOWNTO 0);
SIGNAL memY           : std_ulogic_vector(signalBitNb-1 DOWNTO 0);
SIGNAL newPolynom     : std_ulogic;
COMPONENT beamerPeriphOperator
GENERIC (
updatePeriodBitNb : positive := 16;
signalBitNb       : positive := 16
);
PORT (
outX           : OUT    std_ulogic ;
run            : IN     std_ulogic ;
clock          : IN     std_ulogic ;
reset          : IN     std_ulogic ;
outY           : OUT    std_ulogic ;
selSinCos      : IN     std_ulogic ;
interpolateLin : IN     std_ulogic ;
updatePeriod   : IN     unsigned (updatePeriodBitNb-1 DOWNTO 0);
memX           : IN     std_ulogic_vector (signalBitNb-1 DOWNTO 0);
memY           : IN     std_ulogic_vector (signalBitNb-1 DOWNTO 0);
newPolynom     : OUT    std_ulogic
);
END COMPONENT;
COMPONENT beamerPeriphControls
GENERIC (
curvePointNb        : positive := 4;
updatePeriodBitNb   : positive := 16;
signalBitNb         : positive := 16;
patternAddressBitNb : positive := 8;
testOutBitNb        : positive := 16
);
PORT (
clock          : IN     std_ulogic ;
testOut        : OUT    std_ulogic_vector (1 TO testOutBitNb);
memX           : OUT    std_ulogic_vector (signalBitNb-1 DOWNTO 0);
memY           : OUT    std_ulogic_vector (signalBitNb-1 DOWNTO 0);
run            : OUT    std_ulogic ;
updatePeriod   : OUT    unsigned (updatePeriodBitNb-1 DOWNTO 0);
interpolateLin : OUT    std_ulogic ;
reset          : IN     std_ulogic ;
newPolynom     : IN     std_ulogic
);
END COMPONENT;
BEGIN
I1 : beamerPeriphOperator
GENERIC MAP (
updatePeriodBitNb => updatePeriodBitNb,
signalBitNb       => signalBitNb
)
PORT MAP (
outX           => outX,
run            => run,
clock          => clock,
reset          => reset,
outY           => outY,
selSinCos      => selSinCos,
interpolateLin => interpolateLin,
updatePeriod   => updatePeriod,
memX           => memX,
memY           => memY,
newPolynom     => newPolynom
);
I0 : beamerPeriphControls
GENERIC MAP (
curvePointNb        => curvePointNb,
updatePeriodBitNb   => updatePeriodBitNb,
signalBitNb         => signalBitNb,
patternAddressBitNb => patternAddressBitNb,
testOutBitNb        => testOutBitNb
)
PORT MAP (
clock          => clock,
testOut        => testOut,
memX           => memX,
memY           => memY,
run            => run,
updatePeriod   => updatePeriod,
interpolateLin => interpolateLin,
reset          => reset,
newPolynom     => newPolynom
);
END struct;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY buff IS
PORT(
in1  : IN     std_uLogic;
out1 : OUT    std_uLogic
);
END buff ;
ARCHITECTURE sim OF buff IS
BEGIN
out1 <= in1;
END ARCHITECTURE sim;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY DFF IS
PORT(
CLK : IN     std_uLogic;
CLR : IN     std_uLogic;
D   : IN     std_uLogic;
Q   : OUT    std_uLogic
);
END DFF ;
ARCHITECTURE sim OF DFF IS
BEGIN
process(clk, clr)
begin
if clr = '1' then
q <= '0';
elsif rising_edge(clk) then
q <= d;
end if;
end process;
END ARCHITECTURE sim;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ARCHITECTURE struct OF FPGA_textWriter IS
constant curvePointNb: positive := 423;
constant testOutBitNb: positive := 16;
SIGNAL logic1         : std_uLogic;
SIGNAL reset          : std_ulogic;
SIGNAL resetSnch_N    : std_ulogic;
SIGNAL resetSynch     : std_ulogic;
SIGNAL selSinCos      : std_ulogic;
SIGNAL selSinCosSynch : std_ulogic;
SIGNAL testOut        : std_ulogic_vector(1 TO testOutBitNb);
COMPONENT DFF
PORT (
CLK : IN     std_uLogic ;
CLR : IN     std_uLogic ;
D   : IN     std_uLogic ;
Q   : OUT    std_uLogic
);
END COMPONENT;
COMPONENT buff
PORT (
in1  : IN     std_uLogic ;
out1 : OUT    std_uLogic
);
END COMPONENT;
COMPONENT inverterIn
PORT (
in1  : IN     std_uLogic ;
out1 : OUT    std_uLogic
);
END COMPONENT;
COMPONENT textWriter
GENERIC (
curvePointNb : positive := 4;
testOutBitNb : positive := 16
);
PORT (
outX      : OUT    std_ulogic ;
outY      : OUT    std_ulogic ;
selSinCos : IN     std_ulogic ;
clock     : IN     std_ulogic ;
reset     : IN     std_ulogic ;
testOut   : OUT    std_ulogic_vector (1 TO testOutBitNb)
);
END COMPONENT;
BEGIN
logic1 <= '1';
I6 : DFF
PORT MAP (
CLK => clock,
CLR => reset,
D   => logic1,
Q   => resetSnch_N
);
I9 : DFF
PORT MAP (
CLK => clock,
CLR => resetSynch,
D   => selSinCos,
Q   => selSinCosSynch
);
I3 : buff
PORT MAP (
in1  => testOut(1),
out1 => triggerOut
);
I0 : inverterIn
PORT MAP (
in1  => resetSnch_N,
out1 => resetSynch
);
I1 : inverterIn
PORT MAP (
in1  => reset_N,
out1 => reset
);
I7 : inverterIn
PORT MAP (
in1  => selSinCos_n,
out1 => selSinCos
);
I2 : textWriter
GENERIC MAP (
curvePointNb => curvePointNb,
testOutBitNb => testOutBitNb
)
PORT MAP (
outX      => xOut,
outY      => yOut,
selSinCos => selSinCosSynch,
clock     => clock,
reset     => resetSynch,
testOut   => testOut
);
END struct;
