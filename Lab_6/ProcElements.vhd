--------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
-- Add your code here
	Result <= In0 when selector = '0' else
		In1 when selector = '1';
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
           opcode : in  STD_LOGIC_VECTOR (6 downto 0);
           funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
           funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
           Branch : out  STD_LOGIC_VECTOR(1 downto 0);
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC;
           ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
end Control;

architecture Boss of Control is
signal intermediate: std_logic_vector(4 downto 0);
begin
-- Add your code here
	--need intermediate signal to access 4th bit later on
	intermediate <= "00010" when opcode = "0110011" and funct3 = "000" and funct7 = "0000000" else --ADD
			"00110" when opcode = "0110011" and funct3 = "000" and funct7 = "0100000" else --SUB
			"00001" when opcode = "0110011" and funct3 = "110" and funct7 = "0000000" else --OR
			"00000" when opcode = "0110011" and funct3 = "111" and funct7 = "0000000" else --AND
			"00011" when opcode = "0110011" and funct3 = "001" and funct7 = "0000000" else --SLL
			"00100" when opcode = "0110011" and funct3 = "101" and funct7 = "0000000" else --SRL
			"10010" when opcode = "0010011" and funct3 = "000" else --ADDI
			"10001" when opcode = "0010011" and funct3 = "110" else --ORI
			"10000" when opcode = "0010011" and funct3 = "111" else --ANDI
			"10011" when opcode = "0010011" and funct3 = "001" else --SLLI
			"10100" when opcode = "0010011" and funct3 = "101" else --SRLI
			"00110" when opcode = "1100011" and (funct3 = "000" or funct3 = "001") else --BEQ/BNE
			"10010" when opcode = "0000011" or opcode = "0100011"  else --LW/SW
			"11111" when opcode = "0110111" else --LUI
			"01111"; --Pass through
	ALUCtrl <= intermediate;

	ImmGen <= "00" when opcode = "0010011" or opcode = "0000011" else --I-type immediate generator
		"01" when opcode = "0100011" else --S-type
		"10" when opcode = "1100011" else -- B-type
		"11"; --No immGen for R or U type
	Branch <= "10" when funct3 = "000" and funct7 = "1100011" else --BEQ
		"01" when funct3 = "001" and funct7 = "1100011" else --BNE
		"00";
	MemRead <= '0' when opcode = "0000011" else
		'1';
	MemtoReg <= '1' when opcode = "0000011" else
		'0';
	MemWrite <= '1' when opcode = "0100011" else
		'0';
	RegWrite <= '1' when (opcode = "0110111" or opcode = "0000011" or opcode = "0010011" or opcode = "0110011") and clk = '0' else
		'0';
	ALUSrc <= '0' when opcode = "011011" or opcode = "1100011" or opcode = "XXXXXXX"else
		'1'; 
	
end Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is

begin
-- Add your code here
	counter: process(Reset,Clock)
		begin
		if Reset = '1' then
			PCout <= x"00400000";
		end if;
		if rising_edge(Clock) then
			PCout <= PCin;
		end if;
	end process;
end executive;
--------------------------------------------------------------------------------
