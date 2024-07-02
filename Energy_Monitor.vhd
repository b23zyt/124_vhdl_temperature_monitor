library ieee;
use ieee.std_logic_1164.all;

entity Energy_Monitor is port(
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
end entity;
		
architecture rtl of Energy_Monitor is

signal mux_temp_not_equal : std_logic;
signal House_State : std_logic;

signal tmp_at_temp : std_logic;
signal tmp_blower : std_logic;
signal tmp_ac : std_logic;
signal tmp_furnace : std_logic;

begin

state_control: process(vacation_mode, window_open, door_open, MC_test_mode)
	begin
		door <= '0';
		window <= '0';
		vacation <= '0';
		if((door_open = '1') OR (window_open = '1') OR (MC_test_mode = '1')) then
			House_State <= '0';						
			if((door_open = '1')) then
				door <= '1';
			end if;
			if((window_open = '1')) then
				window <= '1';
			end if;
		else
			House_State <= '1';
		end if;
		if((vacation_mode = '1')) then
			vacation <= '1';
		end if;

	end process;

temp_control: process(Compx_AGTB, Compx_AEQB, Compx_ALTB)
		variable hvac_inc, hvac_dec : std_logic;
	begin
		hvac_inc := '0';
		hvac_dec := '0';
		
		tmp_ac <= '0';
		tmp_furnace <= '0';
		tmp_blower <= '1';
		tmp_at_temp <= '0';
		mux_temp_not_equal <= '1';
		
		if(Compx_AGTB = '1') then
			hvac_inc := '1';
			tmp_furnace <= '1';
		elsif(Compx_ALTB = '1') then 
			hvac_dec := '1'; 
			tmp_ac <= '1';
		elsif(Compx_AEQB = '1') then
			tmp_blower <= '0';
			tmp_at_temp <= '1';
			mux_temp_not_equal <= '0';
		end if;
		HVAC_decrease <= hvac_dec;
		HVAC_increase <= hvac_inc;
	end process;

	AC <= tmp_ac and mux_temp_not_equal;
	furnace <= tmp_furnace and mux_temp_not_equal;
	at_temp <= tmp_at_temp and NOT(mux_temp_not_equal);
	blower <= tmp_blower and mux_temp_not_equal and House_state;
	
--	AC <= tmp_ac and mux_temp_not_equal and House_State;
--	furnace <= tmp_furnace and mux_temp_not_equal and House_State;
--	at_temp <= tmp_at_temp and mux_temp_not_equal and House_State;
--	blower <= tmp_blower and mux_temp_not_equal and House_State;
	HVAC_run <= mux_temp_not_equal and House_State;
end rtl;