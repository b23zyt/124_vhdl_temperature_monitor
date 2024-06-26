library ieee;
use ieee.std_logic_1164.all;

entity Compx1 is port (
	A 		:in std_logic;
	B		:in std_logic;
	AGTB	:out std_logic;
	ALTB	:out std_logic;
	AEQB	:out std_logic
);
end Compx1;

architecture design of Compx1 is

begin

	AGTB <= A AND (NOT B);
	ALTB <= (NOT A) AND B;
	AEQB <= NOT (A XOR B);

--proc1: process(A, B) is
--
--begin
--
--	if (A = '1') AND (B = '0') then
--		AGTB <= '1';
--		ALTB <= '0';
--		AEQB <= '0';
--	if (A = '0') AND (B = '1') then
--		AGTB <= '0';
--		ALTB <= '1';
--		AEQB <= '0';	
--	if (A = '0') AND (B = '0') then
--		AGTB <= '0';
--		ALTB <= '0';
--		AEQB <= '1';	
--	if (A = '1') AND (B = '1') then
--		AGTB <= '0';
--		ALTB <= '0';
--		AEQB <= '1';		
--end process;
		
end design;
