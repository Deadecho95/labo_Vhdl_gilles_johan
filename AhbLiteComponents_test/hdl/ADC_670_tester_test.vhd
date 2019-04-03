library ieee;
  use ieee.math_real.all;

ARCHITECTURE test OF ADC_670_tester IS
                                                              -- clock and reset
  constant clockFrequency: real := 100.0E6;
  constant clockPeriod: time := (1.0/clockFrequency) * 1 sec;
  signal sClock: std_uLogic := '1';
                                                                -- analog signal
  constant sineFrequency: real := 5.0E3;
  constant sinePeriod: time := 1 sec / sineFrequency;
  constant outAmplitude: real := 2.55;
  signal tReal: real := 0.0;
  signal outReal: real := 0.0;
                                                                  -- ADC control
  constant samplingFrequency: real := 50.0E3;
  constant samplingPeriod: time := 1 sec / samplingFrequency;
  constant t_W : time := 300 ns;
  constant t_SD: time := 250 ns;
  constant t_R : time := 250 ns;
  constant t_DH: time :=  25 ns;
  signal BPO: std_ulogic;
  signal startConv: std_ulogic := '0';
  signal vSampled : signed(D'range);

BEGIN
  ------------------------------------------------------------------------------
                                                              -- clock and reset
  sClock <= not sClock after clockPeriod/2;
  -- clock <= transport sClock after clockPeriod*9/10;
  -- reset <= '1', '0' after 2*clockPeriod;

  ------------------------------------------------------------------------------
                                                           -- uinpolar / bipolar
  BPO <= '0', '1' after 2*sinePeriod;
  BPO_UPO_n <= BPO;
  FORMAT <= '0', '1' after 4*sinePeriod;
  
  startConv <= '1' after samplingPeriod - 1 ns when startConv = '0'
    else '0' after 1 ns;

  process
  begin
    CS_n <= '1';
    CE_n <= '1';
    R_W  <= '1';
    wait until rising_edge(startConv);
    CS_n <= '0';
    CE_n <= '0';
    R_W  <= '0';
    wait for t_W;
    CS_n <= '1';
    CE_n <= '1';
    R_W  <= '1';
    wait until falling_edge(STATUS);
    CS_n <= '0';
    wait for t_SD;
    CE_n <= '0';
    wait for t_R;
    CE_n <= '1';
    wait for t_DH/2;
    vSampled <= D;
  end process;

  ------------------------------------------------------------------------------
                                                                 -- time signals
  process(sClock)
  begin
    if rising_edge(sClock) then
      tReal <= tReal + 1.0/clockFrequency;
    end if;
  end process;

  outReal <= outAmplitude * ( sin(2.0*math_pi*sineFrequency*tReal) + 1.0) / 2.0;

  process(outReal)
  begin
    if BPO = '1' then
      VinHI <= outReal/2.0;
      VinLOW <= outAmplitude/2.0 - outReal/2.0;
    else
      VinHI <= outAmplitude/2.0 + outReal;
      VinLOW <= outAmplitude/2.0;
    end if;
  end process;

END ARCHITECTURE test;
