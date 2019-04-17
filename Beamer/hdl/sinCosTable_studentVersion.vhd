ARCHITECTURE studentVersion OF sinCosTable IS

  -- INTERNAL SIGNAL
  signal changeSign : std_uLogic;   -- signal interne indiquant le changement de signe
  signal flipPhase : std_uLogic;    -- signal interne indiquant le changement de phase
  signal cntQuart  : std_uLogic;    -- signal interne indiquant dans quel quart nous nous trouvons
    
  signal phaseTableAddress : unsigned(tableAddressBitNb-1 downto 0);
  signal phaseTableAddress2: unsigned(tableAddressBitNb-1 downto 0);
  signal quarterSine : signed(sine'range);

BEGIN
  
  changeSign <= phase(phase'high);  -- changement de signe selon MSB du signal entrant 
  flipPhase <= phase(phase'high-1); -- changement de phase selon MSB-1 du signal entrant


  phaseTableAddress <= phase(phase'high-2 downto phase'high-2-tableAddressBitNb+1);


  -- process flip horizontal
  -- description : Le bit suivant signale un changement à apporter à la phase pour lire la table dans le sens inverse, 
  -- ceci pour les deuxième et quatrième quarts de la période.-
  -- parameters : flipPhase (changement de phase)
  --              phaseTableAddress (valeur 1/4 du sinus)
  
  -- 0123456701234567012 : inputValue
  -- 0123456707654321012 : outputValue = 8-value pour le deuxième et quatrième quarts de la période
  fliphorizontal: process(flipPhase, phaseTableAddress)
  begin
    
    if flipPhase = '0' then
    -- premier et troisième quart inputValue = outputValue
        phaseTableAddress2 <= phaseTableAddress;
    else
    -- deuxième et quatrième quarts  
      phaseTableAddress2 <= 8-phaseTableAddress;  
      
    end if;
    
  end process fliphorizontal;


  -- process quarterTable
  -- description : adresse les valeurs de la table 
  -- parametters : phaseTableAddress2 (valeur du sinus avec flip horizontal)
  --               phase (signal d'entrée)
  quarterTable: process(phaseTableAddress2, phase)
  begin
    case to_integer(phaseTableAddress2) is
      -- deux provenances de la valeur 0 sont possibles :
      --    0 : croisement              : 0000
      --    0 : valeur du haut du sinus : 7FFF
      when 0 =>
        if phase(phase'high-1) = '0' then
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
  end process quarterTable;

  -- process flip vertical
  -- description : flip vertical selon le signal changeSigne
  -- parameters : changeSigne (changement de signe des valeurs du sinus)
  --              quarterSine (valeur correspondante au sinus)  
   flipvertical: process(changeSign, quarterSine)
   begin
     
    if  changeSign = '0' then
      sine <= quarterSine;
    else
      sine <= -quarterSine;
    end if;
    
   end process flipvertical;
   
END ARCHITECTURE studentVersion;
