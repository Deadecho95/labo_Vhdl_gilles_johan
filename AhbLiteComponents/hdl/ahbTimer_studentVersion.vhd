--==============================================================================
--
-- AHB Timer
--
-- Provides "enableNb" enable signals having all the same period but different
-- offsets.
--
-- The period and offset registers have a width of "registerWordWidth" times the
-- AHB data width. This allows to have a long sampling period.
--
--------------------------------------------------------------------------------
--
-- Write registers
--
-- The register at address zero specifies the sampling period as a number of
-- clock cycles. The associated counter provides a pulse at the beginning of
-- every period.
-- All other registers specify an offset. They can be positive or negative.
-- They specify when the corresponding enable pulse arrives, relatively to the
-- sampling pulse.
--
--------------------------------------------------------------------------------
--
-- Read registers
--
-- None
--
ARCHITECTURE studentVersion OF ahbTimer IS
BEGIN

  -- AHB-Lite
  hRData  <=	(OTHERS => '0');
  hReady  <=	'0';	
  hResp	  <=	'0';	

  -- timer
  enable  <= (OTHERS => '0');
  
END ARCHITECTURE studentVersion;

