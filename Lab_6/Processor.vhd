--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
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
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;
	

	signal writeIn: std_logic;
	signal pcout: std_logic_vector(31 downto 0);
	signal instr: std_logic_vector(31 downto 0);
	signal readReg1, readReg2, destReg: std_logic_vector(4 downto 0);
	signal co1, co2, co3: std_logic;
	signal Immgenout: std_logic_vector(31 downto 0);
	signal rightAdder, leftAdder: std_logic_vector(31 downto 0);
	signal signExt: std_logic_vector(19 downto 0);
	--Control
	signal branch: std_logic_vector(1 downto 0);
	signal MemRead: std_logic;
	signal MemReg: std_logic;
	signal ALUCtrl: std_logic_vector(4 downto 0);
	signal MemWrite: std_logic;
	signal ALUSrc: std_logic;
	signal regWrite: std_logic;
	signal immGen: std_logic_vector(1 downto 0);
	--ALU
	signal ALURes: std_logic_vector(31 downto 0);
	signal ALUintwo: std_logic_vector(31 downto 0);
	signal isZero: std_logic;
	--Memory
	signal dataMem: std_logic_vector(31 downto 0);
	signal memMuxOut: std_logic_vector(31 downto 0);
	signal newMemAddress: std_logic_vector(29 downto 0);
	signal tempo: std_logic_vector(31 downto 0);
	--Registers
	signal readout1: std_logic_vector(31 downto 0);
	signal readout2: std_logic_vector(31 downto 0);
	--Branch
	signal brancher: std_logic;
	signal branchSelect: std_logic_vector(2 downto 0);
	signal branchRes: std_logic_vector(31 downto 0);
begin
	
	readReg1 <= instr(19 downto 15);
	readReg2 <= instr(24 downto 20);
	destReg <= instr(11 downto 7);
	-- Add your code here
	writeIn <= '1' when (falling_edge(clock) and regWrite = '1') else
		'0';
	--determining immediate value
	with instr(31) select
	signExt <= (others => '1') when '1',
	(others => '0') when others;
	
	with immGen select
	Immgenout <= (signExt(19 downto 0) & instr(31 downto 20)) when "10", --I type
		(signExt(18 downto 0) & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0') when "01", --B type
		(signExt(19 downto 0) & instr(31 downto 25) & instr(11 downto 7)) when "11", --S
		(instr(31 downto 12) & "000000000000") when others; --U
	--for branch
	branchSelect <= isZero & branch;
	with branchSelect select
	brancher <= '1' when "001", --BNE
		'0' when "101",
		'1' when "110", --BEQ
		'0' when "010",
		'0' when others;

	PC: ProgramCounter port map(reset, clock, branchRes, pcout);

	InstructionMemory: InstructionRAM port map(reset, clock, pcout(31 downto 2), instr);

	ctrl: Control port map(clock, instr(6 downto 0), instr(14 downto 12), instr(31 downto 25), branch, memRead, memReg, ALUCtrl, MemWrite, ALUSrc, regWrite, immGen);

	reg: Registers port map(readReg1, readReg2, destReg, memMuxOut, writeIn, readout1, readout2);

	Reg2AluMUX: BusMux2to1 port map(ALUSrc, readout2, Immgenout, ALUintwo);

	ALUModule: ALU port map(readout1, ALUintwo, ALUCtrl, isZero, ALURes);

	offsetSubtractor: adder_subtracter port map(ALURes, x"10000000",'1', tempo, co3);

	newMemaddress <= tempo(31 downto 2);

	DataMemory: RAM port map(reset, clock, MemRead, MemWrite, newMemAddress, readout2, dataMem);

	Data2MemMUX: BusMux2to1 port map(MemReg, ALURes, dataMem, memMuxOut);

	Adder1: adder_subtracter port map(pcout, Immgenout,'1', rightAdder, co1);

	Adder2: adder_subtracter port map(pcout, "00000000000000000000000000000100", '0', leftAdder, co2);

	rightAdderMux: BusMux2to1 port map(brancher,leftAdder, rightAdder, branchRes); 
end holistic;

