library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;
--	
component Tester port (
 MC_TESTMODE				: in  std_logic;
 I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
	end component;
--	
component HVAC 	port (
	HVAC_SIM					: in boolean;
	clk						: in std_logic; 
	run		   			: in std_logic;
	increase, decrease	: in std_logic;
	temp						: out std_logic_vector (3 downto 0)
	);
end component;
------------------------------------------------------------------
-- Add any Other Components here
component Compx4 port(
		A	:in std_logic_vector(3 downto 0);
		B	:in std_logic_vector(3 downto 0);
		AGTB	:out std_logic;
		ALTB	:out std_logic;
		AEQB	:out std_logic
		);
end component;


component Energy_Monitor is port(
		vacation_mode : in std_logic;
		MC_test_mode : in std_logic;
		window_open : in std_logic;
		door_open : in std_logic;
		Compx_AGTB : in std_logic;
		Compx_ALTB : in std_logic;
		Compx_AEQB : in std_logic;
--------------------------------------
		HVAC_increase : out std_logic;
		HVAC_decrease : out std_logic;
		HVAC_run : out std_logic;
		furnace : out std_logic;
		at_temp : out std_logic;
		AC	: out std_logic;
		blower : out std_logic;
		window : out std_logic;
		door : out std_logic;
		vacation : out std_logic
	);
end component;

component PB_Inverters IS
	PORT
	(
		pb_n	:	IN std_logic_vector(3 downto 0);
		pb		:	OUT std_logic_vector(3 downto 0)
	);
END component;

component mux_2to1 IS
	PORT(
		bit_sel : in std_logic;
		input_A : in std_logic_vector (3 downto 0);
		input_B : in std_logic_vector (3 downto 0);
		output : out std_logic_vector (3 downto 0)
	);
END component;
-------------------------------------------------------------------

------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in					: std_logic;
signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);
signal hvac_run, hvac_inc, hvac_dec : std_logic;
signal pb: std_logic_vector(3 downto 0);
signal tmp_GT, tmp_LT, tmp_EQ : std_logic;
signal hvac_out_temp : std_logic_vector(3 downto 0);
signal mux_out : std_logic_vector(3 downto 0);
------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input

-- temp inputs hook-up to internal busses.
hex_A <= sw(3 downto 0);
hex_B <= sw(7 downto 4);


--inst1: sevensegment port map ('0'&tmp_GT&tmp_LT&tmp_EQ, hexA_7seg);
inst1: sevensegment port map (hvac_out_temp, hexA_7seg);
inst2: sevensegment port map (mux_out, hexB_7seg);
inst3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
--inst4: Compx4 port map(mux_out, hvac_out_temp, tmp_GT, tmp_EQ, tmp_LT);
inst4: Compx4 port map(mux_out, hvac_out_temp, tmp_GT, tmp_LT, tmp_EQ);
inst5: HVAC port map(HVAC_SIM, clkin_50, hvac_run, hvac_inc, hvac_dec, hvac_out_temp(3 downto 0));
inst6: Energy_Monitor port map(pb(3),pb(2),pb(1),pb(0),tmp_GT,tmp_LT,tmp_EQ, hvac_inc, hvac_dec, hvac_run, leds(0),leds(1),leds(2),leds(3),leds(4),leds(5),leds(7)); 
inst7: PB_inverters port map(pb_n, pb);
inst8: Tester port map(pb(2), tmp_EQ, tmp_GT, tmp_LT, hex_A, hvac_out_temp, leds(6));
inst9: mux_2to1 port map(pb(3), hex_A, hex_B, mux_out);
end design;

