------------------------------------------------
--- Autor : Johan Chenaux and Florence Villoz
--- Date : 04.03.2019
--- Description : 
------------------------------------------------
ARCHITECTURE studentVersion OF interpolatorCalculatePolynom IS
  
  constant customBitNb: positive := signalBitNb + 3*oversamplingBitNb +2;
  signal x: signed(customBitNb-1 downto 0);
  signal u: signed(customBitNb-1 downto 0);
  signal v: signed(customBitNb-1 downto 0);
  signal w: signed(customBitNb-1 downto 0);
  
BEGIN

  polynom: process(reset, clock)
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
            -- calculate initial values
          x <=   shift_left(resize(2*d, x'length), 3*oversamplingBitNb);
          
          u <=   resize(a, u'length)
               + shift_left(resize(b, u'length), oversamplingBitNb)
               + shift_left(resize(c, u'length), 2*oversamplingBitNb);
               
          v <=   resize(6*a, v'length)
               + shift_left(resize(2*b, v'length), oversamplingBitNb);
               
          w <=   resize(6*a, w'length);
          sampleOut <= resize(d, sampleOut'length);
          else
            -- calculate itérativ polynom
             x <= x + u;
             u <= u + v ;
             v <= v + w;
             sampleOut <= resize(shift_right(x, 3*oversamplingBitNb + 1), sampleOut'length);
          end if;
        end if;
      end if;   
    end process polynom;
END ARCHITECTURE studentVersion;
