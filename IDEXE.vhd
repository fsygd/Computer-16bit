----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:43:02 11/19/2017 
-- Design Name: 
-- Module Name:    IDEXE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDEXE is
    Port ( 
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  bubble : in STD_LOGIC;
			  pcStop : in STD_LOGIC;
			  
			  inOp : in  STD_LOGIC_VECTOR(3 downto 0);
			  inOperand1: in  STD_LOGIC_VECTOR(15 downto 0);
			  inOperand2: in  STD_LOGIC_VECTOR(15 downto 0);
			  inRegWrite: in STD_LOGIC; -- RegWE
			  inRegToWrite:  in  STD_LOGIC_VECTOR(3 downto 0); -- DestReg 
			  inMemIn:  in STD_LOGIC_VECTOR(15 downto 0); -- MemDIn
			  inMemWrite:   in STD_LOGIC; -- MemWE
			  inMemAccess:  in STD_LOGIC; -- AccMem
		
			  outOp:  out  STD_LOGIC_VECTOR(3 downto 0); 
			  outOperand1: out  STD_LOGIC_VECTOR(15 downto 0); 
			  outOperand2:  out  STD_LOGIC_VECTOR(15 downto 0);
			  outRegWrite: out STD_LOGIC;
			  outRegToWrite:   out  STD_LOGIC_VECTOR(3 downto 0);
			  outMemIn:    out STD_LOGIC_VECTOR(15 downto 0);
			  outMemWrite: out STD_LOGIC; 
			  outMemAccess: out STD_LOGIC
			  
			  
			  );
end IDEXE;

architecture Behavioral of IDEXE is
signal OpBuffer : STD_LOGIC_VECTOR(3 downto 0);
signal Operand1Buffer : STD_LOGIC_VECTOR(15 downto 0);
signal Operand2Buffer : STD_LOGIC_VECTOR(15 downto 0);
signal RegWriteBuffer : STD_LOGIC;
signal RegToWriteBuffer : STD_LOGIC_VECTOR(3 downto 0);
signal MemInBuffer : STD_LOGIC_VECTOR(15 downto 0);
signal MemWriteBuffer : STD_LOGIC;
signal MemAccessBuffer : STD_LOGIC;
begin

-- pass when clk up

-- if bubble, pass a NOP
	process(clk, rst, bubble, inOp, inOperand1, inOperand2, inRegWrite, inRegToWrite,
				inMemIn, inMemWrite, inMemAccess, pcStop)
	begin
		if rst = '0' then
			OpBuffer <= (others => '0');
			Operand1Buffer <= (others => '0');
			Operand2Buffer <= (others => '0');
			RegWriteBuffer <= '0';
			RegToWriteBuffer <= (others => '0');
			MemInBuffer <= (others => '0');
			MemWriteBuffer <= '0';
			MemAccessBuffer <= '0';
		elsif clk'event and clk = '1' then
            if bubble = '0' and pcStop = '0' then
                OpBuffer <= inOp;
                Operand1Buffer <= inOperand1;
                Operand2Buffer <= inOperand2;
                RegWriteBuffer <= inRegWrite;
                RegToWriteBuffer <= inRegToWrite;
                MemInBuffer <= inMemIn;
                MemWriteBuffer <= inMemWrite;
                MemAccessBuffer <= inMemAccess;
            else
                OpBuffer <= (others => '0');
                Operand1Buffer <= (others => '0');
                Operand2Buffer <= (others => '0');
                RegWriteBuffer <= '0';
                RegToWriteBuffer <= (others => '0');
                MemInBuffer <= (others => '0');
                MemWriteBuffer <= '0';
                MemAccessBuffer <= '0';
            end if;
        end if;
	end process;
	outOp <= OpBuffer;
	outOperand1 <= Operand1Buffer;
	outOperand2 <= Operand2Buffer;
	outRegWrite <= RegWriteBuffer;
	outRegToWrite <= RegToWriteBuffer;
	outMemIn <= MemInBuffer;
	outMemWrite <= MemWriteBuffer;
	outMemAccess <= MemAccessBuffer;
end Behavioral;

