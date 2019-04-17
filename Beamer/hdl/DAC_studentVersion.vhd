ARCHITECTURE studentVersion OF DAC IS

  signal parallelInResize: signed(parallelIn'range);
  signal parallelInInv: signed(parallelIn'range);
  signal accumulator1: signed(parallelIn'high+8 downto 0);
  signal accumulator2: signed(parallelIn'high+20 downto 0);
  signal isPositiv: std_ulogic;
  
BEGIN
  
  -- divise par 2 et monte le signal d'un quart
  parallelInInv(parallelInInv'high) <= not parallelIn(parallelIn'high);
  parallelInInv(parallelIn'high-1 downto 0) <= signed(parallelIn(parallelIn'high-1 downto 0));

  parallelInResize <=resize(parallelInInv + shift_left("1",parallelIn'length-3)*7,parallelInResize'length);
  
  order1: process(reset, clock)
  begin
    if reset = '1' then
      accumulator1 <= (others => '0');
    elsif rising_edge(clock) then
      if isPositiv = '0' then
        -- additionne
        accumulator1 <= accumulator1 + parallelInResize
          + shift_left(resize("01", accumulator1'length),parallelIn'length-1);
      else
        -- additionne et soutrait le nombre de bit qu'on veut convertir
        accumulator1 <= accumulator1 + parallelInResize
          - shift_left(resize("01", accumulator1'length),parallelIn'length-1);
      end if;
    end if;
  end process order1;
  
  order2: process(reset, clock)
  begin
    if reset = '1' then
      accumulator2 <= (others => '0');
    elsif rising_edge(clock) then
      if isPositiv = '0' then
        -- additionne
        accumulator2 <= accumulator2 + accumulator1
        + shift_left(resize("01", accumulator2'length),parallelIn'length+3);
      else
        -- additionne et soutrait le nombre de bit qu'on veut convertir
        accumulator2 <= accumulator2 + accumulator1
          - shift_left(resize("01", accumulator2'length),parallelIn'length+3);
      end if;
    end if;
  end process order2;

 -- détecte si msb est à 1 ou à 0
  isPositiv <= not accumulator2(accumulator1'high);
  
  -- 
  serialOut <= isPositiv;

END ARCHITECTURE studentVersion;
