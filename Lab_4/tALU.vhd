--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00010";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 			-- result = 0x124578AB  and zeroOut = 0

		-- Add test cases here to drive the ALU implementation
		--addi
		control <= "10010";
		wait for 20 ns;		--Result: 0x124578AB
		--sub
		datain_a <= x"01234567";
		datain_b <= x"11223344";
		control <= "00110";
		wait for 20 ns;
		--sub with result of 0
		datain_a <= x"11223344";
		control <= "00110";
		wait for 20 ns;		--get 0x00000000
		--and
		datain_b <= x"FFFFFFFF";
		control <= "00000";
		wait for 20 ns;
		--andi
		control <= "10000";
		wait for 20 ns;
		--or
		datain_a <= x"10305070";
		datain_b <= x"02040608";
		control <= "00001";
		wait for 20 ns;
		--ori
		control <= "10001";
		wait for 20 ns;
		--sll
		datain_a <= x"FFAABBCC";
		datain_b <= x"00000002";
		control <= "00011";
		wait for 20 ns;
		--slli
		control <= "10011";
		wait for 20 ns;
		--srl
		control <= "00100";
		wait for 20 ns;
		--srli
		control <= "10100";
		wait for 20 ns;
		--Pass through
		control <= "11111";
		wait for 20 ns;
		wait; -- will wait forever
	END PROCESS;

END;