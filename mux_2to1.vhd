--Author: Group 19, Harry Wang, Benjamin Zeng
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- takes 2 4-bit input
-- select one input as the output based on input (which is pb[2])
ENTITY mux_2to1 IS
	PORT(
		bit_sel : in std_logic;
		input_A : in std_logic_vector (3 downto 0);
		input_B : in std_logic_vector (3 downto 0);
		output : out std_logic_vector (3 downto 0)
	);
END mux_2to1;


ARCHITECTURE behavior of mux_2to1 IS

BEGIN 

WITH bit_sel select
	output <= input_A when '0',
				input_B when '1';

END behavior;