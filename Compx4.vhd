library ieee;
use ieee.std_logic_1164.all;

entity Compx4 is port (
		A	:in std_logic_vector(3 downto 0);
		B	:in std_logic_vector(3 downto 0);
		AGTB	:out std_logic;
		ALTB	:out std_logic;
		AEQB	:out std_logic
);
end Compx4;


architecture design of Compx4 is

component Compx1 is port(
	A 		:in std_logic;
	B		:in std_logic;
	AGTB	:out std_logic;
	ALTB	:out std_logic;
	AEQB	:out std_logic
);
end component;

signal AGTB_TEMP: std_logic_Vector(3 downto 0);
signal ALTB_TEMP: std_logic_Vector(3 downto 0);
signal AEQB_TEMP: std_logic_Vector(3 downto 0);

begin

	INST1: Compx1 port map(A(3), B(3), AGTB_TEMP(3), ALTB_TEMP(3), AEQB_TEMP(3)); 
	INST2: Compx1 port map(A(2), B(2), AGTB_TEMP(2), ALTB_TEMP(2), AEQB_TEMP(2)); 
	INST3: Compx1 port map(A(1), B(1), AGTB_TEMP(1), ALTB_TEMP(1), AEQB_TEMP(1)); 
	INST4: Compx1 port map(A(0), B(0), AGTB_TEMP(0), ALTB_TEMP(0), AEQB_TEMP(0)); 

proc1: process(AGTB_TEMP(3 downto 0), ALTB_TEMP(3 downto 0), AEQB_TEMP(3 downto 0)) is

begin
	if (AEQB_TEMP(3) = '0') then
		AGTB <= AGTB_TEMP(3);
		ALTB <= ALTB_TEMP(3);
		AEQB <= AEQB_TEMP(3);
	elsif (AEQB_TEMP(2) = '0') then
		AGTB <= AGTB_TEMP(2);
		ALTB <= ALTB_TEMP(2);
		AEQB <= AEQB_TEMP(2);
	elsif (AEQB_TEMP(1) = '0') then
		AGTB <= AGTB_TEMP(1);
		ALTB <= ALTB_TEMP(1);
		AEQB <= AEQB_TEMP(1);
	else
		AGTB <= AGTB_TEMP(0);
		ALTB <= ALTB_TEMP(0);
		AEQB <= AEQB_TEMP(0);
	end if;
	
end process;

end design;