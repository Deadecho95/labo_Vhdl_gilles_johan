ARCHITECTURE RTL OF charToMorseController IS
                                                      -- sequence for characters
  type characterStateType is (
    idle, waitReg,
    sA, sB, sC, sD, sE, sF, sG, sH, sI, sJ, sK, sL, sM, sN, sO, sP,
    sQ, sR, sS, sT, sU, sV, sW, sX, sY, sZ,
    s0, s1, s2, s3, s4, s5, s6, s7, s8, s9,
    s2a, s8a, s9a
  );
  signal characterState : characterStateType;
  signal isA, isB, isC, isD, isE, isF, isG, isH,
         isI, isJ, isK, isL, isM, isN, isO, isP,
         isQ, isR, isS, isT, isU, isV, isW, isX,
         isY, isZ,
         is0, is1, is2, is3, is4, is5, is6, is7,
         is8, is9 : std_ulogic;
  signal gotoE, gotoI, gotoS, gotoH, goto5,
         gotoF,
         gotoL, gotoR,
         gotoP,
         gotoN, gotoD, gotoB, goto6,
         gotoC,
         gotoG, gotoZ, goto7,
         goto8,
         goto9,
         gotoT : std_ulogic;
                                                         -- inter-FSM signalling
  signal sendDot, sendDash, sendDotDashDone: std_ulogic;
                                                     -- sequence for morse units
  type sequencerStateType is (
    idle,
    startDot, sendingDot, startDash, sendingDash,
    startSeparator, waitingSeparator,
    dotDashDone
  );
  signal sequencerState : sequencerStateType;

BEGIN
  ------------------------------------------------------------------------------
                                                   -- conditions for morse units
  isA <= '1' when std_match(unsigned(char), "1-0" & x"1") else '0';
  isB <= '1' when std_match(unsigned(char), "1-0" & x"2") else '0';
  isC <= '1' when std_match(unsigned(char), "1-0" & x"3") else '0';
  isD <= '1' when std_match(unsigned(char), "1-0" & x"4") else '0';
  isE <= '1' when std_match(unsigned(char), "1-0" & x"5") else '0';
  isF <= '1' when std_match(unsigned(char), "1-0" & x"6") else '0';
  isG <= '1' when std_match(unsigned(char), "1-0" & x"7") else '0';
  isH <= '1' when std_match(unsigned(char), "1-0" & x"8") else '0';
  isI <= '1' when std_match(unsigned(char), "1-0" & x"9") else '0';
  isJ <= '1' when std_match(unsigned(char), "1-0" & x"A") else '0';
  isK <= '1' when std_match(unsigned(char), "1-0" & x"B") else '0';
  isL <= '1' when std_match(unsigned(char), "1-0" & x"C") else '0';
  isM <= '1' when std_match(unsigned(char), "1-0" & x"D") else '0';
  isN <= '1' when std_match(unsigned(char), "1-0" & x"E") else '0';
  isO <= '1' when std_match(unsigned(char), "1-0" & x"F") else '0';
  isP <= '1' when std_match(unsigned(char), "1-1" & x"0") else '0';
  isQ <= '1' when std_match(unsigned(char), "1-1" & x"1") else '0';
  isR <= '1' when std_match(unsigned(char), "1-1" & x"2") else '0';
  isS <= '1' when std_match(unsigned(char), "1-1" & x"3") else '0';
  isT <= '1' when std_match(unsigned(char), "1-1" & x"4") else '0';
  isU <= '1' when std_match(unsigned(char), "1-1" & x"5") else '0';
  isV <= '1' when std_match(unsigned(char), "1-1" & x"6") else '0';
  isW <= '1' when std_match(unsigned(char), "1-1" & x"7") else '0';
  isX <= '1' when std_match(unsigned(char), "1-1" & x"8") else '0';
  isY <= '1' when std_match(unsigned(char), "1-1" & x"9") else '0';
  isZ <= '1' when std_match(unsigned(char), "1-1" & x"A") else '0';
  is0 <= '1' when std_match(unsigned(char), "011" & x"0") else '0';
  is1 <= '1' when std_match(unsigned(char), "011" & x"1") else '0';
  is2 <= '1' when std_match(unsigned(char), "011" & x"2") else '0';
  is3 <= '1' when std_match(unsigned(char), "011" & x"3") else '0';
  is4 <= '1' when std_match(unsigned(char), "011" & x"4") else '0';
  is5 <= '1' when std_match(unsigned(char), "011" & x"5") else '0';
  is6 <= '1' when std_match(unsigned(char), "011" & x"6") else '0';
  is7 <= '1' when std_match(unsigned(char), "011" & x"7") else '0';
  is8 <= '1' when std_match(unsigned(char), "011" & x"8") else '0';
  is9 <= '1' when std_match(unsigned(char), "011" & x"9") else '0';
  goto5 <= is5;
  gotoH <= ish or goto5 or is4;
  gotoS <= isS or gotoH or isV or is3;
  gotoF <= isF;
  gotoI <= isI or gotoS or isU or gotoF or is2;
  gotoL <= isL;
  gotoR <= isR or gotoL;
  gotoP <= isP;
  gotoE <= isE or gotoI or isA or gotoR or isW or gotoP or isJ or is1;
  goto6 <= is6;
  gotoB <= isB or goto6;
  gotoD <= isD or gotoB or isX;
  gotoC <= isC;
  gotoN <= isN or gotoD or isK or gotoC or isY;
  goto7 <= is7;
  gotoZ <= isZ or goto7;
  gotoG <= isG or gotoZ or isQ;
  goto8 <= is8;
  goto9 <= is9;
  gotoT <= isT or gotoN or isM or gotoG or isO or goto8 or goto9 or is0;
                                                     -- sequence for morse units
  sendCharacterState: process(reset, clock)
  begin
    if reset = '1' then
      characterState <= idle;
    elsif rising_edge(clock) then
      case characterState is
                                                                        -- start
        when idle =>
          if charValid = '1' then
            characterState <= waitReg;
          end if;
        when waitReg =>
          if gotoE = '1' then
            characterState <= sE;
          elsif gotoT = '1' then
            characterState <= sT;
          else
            characterState <= idle;
          end if;
                                                                      -- level 1
        when sE =>
          if sendDotDashDone = '1' then
            if isE = '1' then
              characterState <= idle;
            elsif gotoI = '1' then
              characterState <= sI;
            else
              characterState <= sA;
            end if;
          end if;
        when sT =>
          if sendDotDashDone = '1' then
            if isT = '1' then
              characterState <= idle;
            elsif gotoN = '1' then
              characterState <= sN;
            else
              characterState <= sM;
            end if;
          end if;
                                                                      -- level 2
        when sI =>
          if sendDotDashDone = '1' then
            if isI = '1' then
              characterState <= idle;
            elsif gotoS = '1' then
              characterState <= sS;
            else
              characterState <= sU;
            end if;
          end if;
        when sA =>
          if sendDotDashDone = '1' then
            if isA = '1' then
              characterState <= idle;
            elsif gotoR = '1' then
              characterState <= sR;
            else
              characterState <= sW;
            end if;
          end if;
        when sN =>
          if sendDotDashDone = '1' then
            if isN = '1' then
              characterState <= idle;
            elsif gotoD = '1' then
              characterState <= sD;
            else
              characterState <= sK;
            end if;
          end if;
        when sM =>
          if sendDotDashDone = '1' then
            if isM = '1' then
              characterState <= idle;
            elsif gotoG = '1' then
              characterState <= sG;
            else
              characterState <= sO;
            end if;
          end if;
                                                                     -- level 3a
        when sS =>
          if sendDotDashDone = '1' then
            if isS = '1' then
              characterState <= idle;
            elsif gotoH = '1' then
              characterState <= sH;
            else
              characterState <= sV;
            end if;
          end if;
        when sU =>
          if sendDotDashDone = '1' then
            if isU = '1' then
              characterState <= idle;
            elsif gotoF = '1' then
              characterState <= sF;
            else
              characterState <= s2a;
            end if;
          end if;
        when sR =>
          if sendDotDashDone = '1' then
            if isR = '1' then
              characterState <= idle;
            elsif gotoL = '1' then
              characterState <= sL;
            else
              characterState <= idle;
            end if;
          end if;
        when sW =>
          if sendDotDashDone = '1' then
            if isW = '1' then
              characterState <= idle;
            elsif gotoP = '1' then
              characterState <= sP;
            else
              characterState <= sJ;
            end if;
          end if;
                                                                     -- level 3b
        when sD =>
          if sendDotDashDone = '1' then
            if isD = '1' then
              characterState <= idle;
            elsif gotoB = '1' then
              characterState <= sB;
            else
              characterState <= sX;
            end if;
          end if;
        when sK =>
          if sendDotDashDone = '1' then
            if isK = '1' then
              characterState <= idle;
            elsif gotoC = '1' then
              characterState <= sC;
            else
              characterState <= sY;
            end if;
          end if;
        when sG =>
          if sendDotDashDone = '1' then
            if isG = '1' then
              characterState <= idle;
            elsif gotoZ = '1' then
              characterState <= sZ;
            else
              characterState <= sQ;
            end if;
          end if;
        when sO =>
          if sendDotDashDone = '1' then
            if isO = '1' then
              characterState <= idle;
            elsif goto8 = '1' then
              characterState <= s8a;
            else
              characterState <= s9a;
            end if;
          end if;
                                                                     -- level 4a
        when sH =>
          if sendDotDashDone = '1' then
            if isH = '1' then
              characterState <= idle;
            elsif goto5 = '1' then
              characterState <= s5;
            else
              characterState <= s4;
            end if;
          end if;
        when sV =>
          if sendDotDashDone = '1' then
            if isV = '1' then
              characterState <= idle;
            else
              characterState <= s3;
            end if;
          end if;
        when sF =>
          if sendDotDashDone = '1' then
            characterState <= idle;
          end if;
        when s2a =>
          if sendDotDashDone = '1' then
            characterState <= s2;
          end if;
                                                                     -- level 4b
        when sL =>
          if sendDotDashDone = '1' then
            characterState <= idle;
          end if;
        when sP =>
          if sendDotDashDone = '1' then
            characterState <= idle;
          end if;
        when sJ =>
          if sendDotDashDone = '1' then
            if isJ = '1' then
              characterState <= idle;
            else
              characterState <= s1;
            end if;
          end if;
                                                                     -- level 4c
        when sB =>
          if sendDotDashDone = '1' then
            if isB = '1' then
              characterState <= idle;
            elsif goto6 = '1' then
              characterState <= s6;
            else
              characterState <= idle;
            end if;
          end if;
        when sX =>
          if sendDotDashDone = '1' then
            characterState <= idle;
          end if;
        when sC =>
          if sendDotDashDone = '1' then
            characterState <= idle;
          end if;
        when sY =>
          if sendDotDashDone = '1' then
            characterState <= idle;
          end if;
                                                                     -- level 4d
        when sZ =>
          if sendDotDashDone = '1' then
            if isZ = '1' then
              characterState <= idle;
            elsif goto7 = '1' then
              characterState <= s7;
            else
              characterState <= idle;
            end if;
          end if;
        when sQ =>
          if sendDotDashDone = '1' then
            characterState <= idle;
          end if;
        when s8a =>
          if sendDotDashDone = '1' then
            characterState <= s8;
          end if;
        when s9a =>
          if sendDotDashDone = '1' then
            if goto9 = '1' then
              characterState <= s9;
            else
              characterState <= s0;
            end if;
          end if;
                                                                      -- level 5
        when s5 | s4 | s3 | s2 | s1 | s6 | s7 | s8 | s9 | s0 =>
          if sendDotDashDone = '1' then
            characterState <= idle;
          end if;

        when others => characterState <= idle;
      end case;
    end if;
  end process sendCharacterState;

  sendCharacterOutput: process(characterState)
  begin
    sendDot <= '0';
    sendDash <= '0';
    case characterState is
                                                                      -- level 1
      when sE =>
        sendDot <= '1';
      when sT =>
        sendDash <= '1';
                                                                      -- level 2
      when sI =>
        sendDot <= '1';
      when sA =>
        sendDash <= '1';
      when sN =>
        sendDot <= '1';
      when sM =>
        sendDash <= '1';
                                                                     -- level 3a
      when sS =>
        sendDot <= '1';
      when sU =>
        sendDash <= '1';
      when sR =>
        sendDot <= '1';
      when sW =>
        sendDash <= '1';
                                                                     -- level 3b
      when sD =>
        sendDot <= '1';
      when sK =>
        sendDash <= '1';
      when sG =>
        sendDot <= '1';
      when sO =>
        sendDash <= '1';
                                                                     -- level 4a
      when sH =>
        sendDot <= '1';
      when sV =>
        sendDash <= '1';
      when sF =>
        sendDot <= '1';
      when s2a =>
        sendDash <= '1';
                                                                     -- level 4b
      when sL =>
        sendDot <= '1';
      when sP =>
        sendDot <= '1';
      when sJ =>
        sendDash <= '1';
                                                                     -- level 4c
      when sB =>
        sendDot <= '1';
      when sX =>
        sendDash <= '1';
      when sC =>
        sendDot <= '1';
      when sY =>
        sendDash <= '1';
                                                                     -- level 4d
      when sZ =>
        sendDot <= '1';
      when sQ =>
        sendDash <= '1';
      when s8a =>
        sendDot <= '1';
      when s9a =>
        sendDash <= '1';
                                                                      -- level 5
      when s5 =>
        sendDot <= '1';
      when s4 =>
        sendDash <= '1';
      when s3 =>
        sendDash <= '1';
      when s2 =>
        sendDash <= '1';
      when s1 =>
        sendDash <= '1';
      when s6 =>
        sendDot <= '1';
      when s7 =>
        sendDot <= '1';
      when s8 =>
        sendDot <= '1';
      when s9 =>
        sendDot <= '1';
      when s0 =>
        sendDash <= '1';
      when others => null;
    end case;
  end process sendCharacterOutput;

  ------------------------------------------------------------------------------
                                                     -- sequence for morse units
  sendDotDashState: process(reset, clock)
  begin
    if reset = '1' then
      sequencerState <= idle;
    elsif rising_edge(clock) then
      case sequencerState is
                                                                         -- idle
        when idle =>
          if sendDot = '1' then
            sequencerState <= startDot;
          elsif sendDash = '1' then
            sequencerState <= startDash;
          end if;
                                                                          -- dot
        when startDot =>
          sequencerState <= sendingDot;
        when sendingDot =>
          if counterDone = '1' then
            sequencerState <= startSeparator;
          end if;
                                                                         -- dash
        when startDash =>
          sequencerState <= sendingDash;
        when sendingDash =>
          if counterDone = '1' then
            sequencerState <= startSeparator;
          end if;
                                                                    -- separator
        when startSeparator =>
          sequencerState <= waitingSeparator;
        when waitingSeparator =>
          if counterDone = '1' then
            sequencerState <= dotDashDone;
          end if;
                                                                         -- done
        when dotDashDone =>
          sequencerState <= idle;
      end case;
    end if;
  end process sendDotDashState;

  sendDotDashOutput: process(sequencerState)
  begin
    startCounter <= '0';
    unitNb <= (others => '-');
    sendDotDashDone <= '0';
    morseOut <= '0';
    case sequencerState is
      when startDot | startDash =>
        startCounter <= '1';
        morseOut <= '1';
      when sendingDot =>
        morseOut <= '1';
        unitNb <= to_unsigned(1, unitNb'length);
      when sendingDash =>
        morseOut <= '1';
        unitNb <= to_unsigned(3, unitNb'length);
      when startSeparator =>
        startCounter <= '1';
      when waitingSeparator =>
        unitNb <= to_unsigned(1, unitNb'length);
      when dotDashDone =>
        sendDotDashDone <= '1';
      when others => null;
    end case;
  end process sendDotDashOutput;

END ARCHITECTURE RTL;
