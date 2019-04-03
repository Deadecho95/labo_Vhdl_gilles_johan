library ieee;
  use ieee.math_real.all;

ARCHITECTURE RTL OF sinewaveGenerator IS

  constant pointsPerPeriod: real := 20.0;
  constant phaseStep: real := 2.0*math_pi/pointsPerPeriod;
  constant maxAmplitude: signed(sine'range) := shift_left(resize("01", sine'length), sine'length-1)-1;
  constant deltaReal: signed(cosine'range) := to_signed(integer(cos(phaseStep)*real(to_integer(maxAmplitude))+0.5), cosine'length);
  constant deltaImag: signed(sine'range) := to_signed(integer(sin(phaseStep)*real(to_integer(maxAmplitude))+0.5), sine'length);

  signal realPart1, realPart: signed(cosine'high+1 downto 0);
  signal imagPart1, imagPart: signed(sine'high+1 downto 0);
  signal realProduct: signed(2*cosine'length-1 downto 0);
  signal imagProduct: signed(2*sine'length-1 downto 0);

BEGIN

  realProduct <= resize(deltaReal*realPart - deltaImag*imagPart, realProduct'length);
  imagProduct <= resize(deltaReal*imagPart + deltaImag*realPart, imagProduct'length);
  realPart1 <= resize(
--    shift_right(realProduct, cosine'length-1) + shift_right(realProduct, 2*cosine'length-3),
    shift_right(realProduct, cosine'length-1),
    realPart1'length
  );
  imagPart1 <= resize(
--    shift_right(imagProduct, sine'length-1) + shift_right(imagProduct, 2*sine'length-3),
    shift_right(imagProduct, sine'length-1),
    imagPart1'length
  );

  simulateOscillator: process(reset, clock)
  begin
    if reset = '1' then
      realPart <= resize(maxAmplitude, realPart'length);
      imagPart <= (others => '0');
    elsif rising_edge(clock) then
      if realPart1 > maxAmplitude then
        realPart <= resize(maxAmplitude, realPart'length);
      elsif realPart1 < -maxAmplitude then
        realPart <= resize(-maxAmplitude, realPart'length);
      else
        realPart <= realPart1;
      end if;
      if imagPart1 > maxAmplitude then
        imagPart <= resize(maxAmplitude, imagPart'length);
      elsif imagPart1 < -maxAmplitude then
        imagPart <= resize(-maxAmplitude, imagPart'length);
      else
        imagPart <= imagPart1;
      end if;
    end if;
  end process simulateOscillator;

  -- sine <= resize(imagPart, sine'length);
  -- cosine <= resize(realPart, cosine'length);
  sine <= imagPart(sine'range);
  cosine <= realPart(cosine'range);

END ARCHITECTURE RTL;
