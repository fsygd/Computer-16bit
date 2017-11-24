----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:14:59 11/19/2017 
-- Design Name: 
-- Module Name:    DECODE - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.def.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DECODE is	
	port(
		--*-- decode part --*--
		instruction: IN  STD_LOGIC_VECTOR(15 downto 0);

		op: OUT  STD_LOGIC_VECTOR(3 downto 0); -- tell alu what to do

		regToRead1: OUT  STD_LOGIC_VECTOR(3 downto 0); -- which register to read accroding to instruction (ASel
		regToRead2: OUT  STD_LOGIC_VECTOR(3 downto 0); -- (BSel
		
		regToWrite: OUT  STD_LOGIC_VECTOR(3 downto 0); -- which register to write back
		regWrite: OUT  STD_LOGIC; -- whether to write back
		
		memIn:  OUT STD_LOGIC_VECTOR(15 downto 0); -- data to write in memory
		memWrite:  OUT STD_LOGIC; -- whether to write memory
		memRead:  OUT STD_LOGIC; -- whether to read memory
		
		--*-- fast read & pc set part --*--
		--*-- by access register files (using regToRead) --*--
		
		dataRead1 : IN  STD_LOGIC_VECTOR (15 downto 0); -- bind to FWDUnit, the true data, can bind to operand?
		dataRead2 : IN  STD_LOGIC_VECTOR (15 downto 0);
		operand1 : OUT  STD_LOGIC_VECTOR(15 downto 0); -- data send to alu
		operand2 : OUT  STD_LOGIC_VECTOR(15 downto 0);
		rpc:  IN STD_LOGIC_VECTOR (15 downto 0); -- bind back to IF
		pcMuxSel :  OUT STD_LOGIC; -- bind back to IF 0:PC+1 1:PCVal
		pcVal :  OUT  STD_LOGIC_VECTOR (15 downto 0) -- bind back to IF
		);
end DECODE;

architecture Behavioral of DECODE is
begin
-- combinational logic
	process(instruction, dataRead1, dataRead2, rpc)
		alias opCode: std_logic_vector(4 downto 0) is instruction(15 downto 11);
		alias rx: std_logic_vector(2 downto 0) is instruction(10 downto 8);
		alias ry: std_logic_vector(2 downto 0) is instruction(7 downto 5);
		alias rz: std_logic_vector(2 downto 0) is instruction(4 downto 2);
	begin
		case opCode is
			when "01001" => --ADDIU
				regToRead1 <= "0" & rx;
				regToRead2 <= NO_REG;
				regToWrite <= "0" & rx;
				regWrite <= '1';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= OP_ADD;
				operand1 <= dataRead1;
				operand2(15 downto 8) <= (others => instruction(7));
				operand2(7 downto 0) <= instruction(7 downto 0);
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "01000" => --ADDIU3
				regToRead1 <= "0" & rx;
				regToRead2 <= "0" & ry;
				regToWrite <= "0" & ry;
				regWrite <= '1';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= OP_ADD;
				operand1 <= dataRead1;
				operand2(15 downto 4) <= (others => instruction(3));
				operand2(3 downto 0) <= instruction(3 downto 0);
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "01100" => --ADDSP|BTEQZ|MTSP|SW_RS
				if instruction(10 downto 8) = "011" then --ADDSP
					regToRead1 <= SP;
					regToRead2 <= NO_REG;
					regToWrite <= SP;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_ADD;
					operand1 <= dataRead1;
					operand2(15 downto 8) <= (others => instruction(7));
					operand2(7 downto 0) <= instruction(7 downto 0);
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				elsif instruction(10 downto 8) = "000" then --BTEQZ
					regToRead1 <= T;
					regToRead2 <= NO_REG;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= (others => 'X');
					operand1 <= (others => 'X');
					operand2 <= (others => 'X');
					if dataRead1 = ZERO then
						pcMuxSel <= '1';
						pcVal <= rpc + ((7 downto 0 => instruction(7)) & instruction(7 downto 0));
					else
						pcMuxSel <= '0';
						pcVal <= (others => 'X');
					end if;
				elsif instruction(10 downto 8) = "100" then --MTSP
					regToRead1 <= "0" & rx;
					regToRead2 <= NO_REG;
					regToWrite <= SP;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_PASS_A;
					operand1 <= dataRead1;
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				elsif instruction(10 downto 8) = "010" then --SW_RS
					regToRead1 <= SP;
					regToRead2 <= RA;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= dataRead2;
					memWrite <= '1';
					memRead <= '0';
					op <= OP_ADD;
					operand1 <= dataRead1;
					operand2(15 downto 8) <= (others => instruction(7));
					operand2(7 downto 0) <= instruction(7 downto 0);
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				else --NOP
					regToRead1 <= NO_REG;
					regToRead2 <= NO_REG;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= (others => 'X');
					operand1 <= (others => 'X');
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				end if;
			when "11100" => --ADDU|SUBU
				if instruction(1 downto 0) = "01" then --ADDU
					regToRead1 <= "0" & rx;
					regToRead2 <= "0" & ry;
					regToWrite <= "0" & rz;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_ADD;
					operand1 <= dataRead1;
					operand2 <= dataRead2;
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				elsif instruction(1 downto 0) = "11" then --SUBU
					regToRead1 <= "0" & rx;
					regToRead2 <= "0" & ry;
					regToWrite <= "0" & rz;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_SUB;
					operand1 <= dataRead1;
					operand2 <= dataRead2;
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				else --NOP
					regToRead1 <= NO_REG;
					regToRead2 <= NO_REG;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= (others => 'X');
					operand1 <= (others => 'X');
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				end if;
			when "11101" => --AND|CMP|JALA|JR|JRRA|MFPC|OR
				if instruction(4 downto 0) = "01100" then --AND
					regToRead1 <= "0" & rx;
					regToRead2 <= "0" & ry;
					regToWrite <= "0" & rx;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_AND;
					operand1 <= dataRead1;
					operand2 <= dataRead2;
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				elsif instruction(4 downto 0) = "01010" then --CMP
					regToRead1 <= "0" & rx;
					regToRead2 <= "0" & ry;
					regToWrite <= T;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_CMP;
					operand1 <= dataRead1;
					operand2 <= dataRead2;
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				elsif instruction(7 downto 0) = "11000000" then --JALR
					regToRead1 <= "0" & rx;
					regToRead2 <= NO_REG;
					regToWrite <= RA;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_PASS_A;
					operand1 <= rpc;
					operand2 <= (others => 'X');
					pcMuxSel <= '1';
					pcVal <= dataRead1;
				elsif instruction(7 downto 0) = "00000000" then --JR
					regToRead1 <= "0" & rx;
					regToRead2 <= NO_REG;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= (others => 'X');
					operand1 <= (others => 'X');
					operand2 <= (others => 'X');
					pcMuxSel <= '1';
					pcVal <= dataRead1;
				elsif instruction(10 downto 0) = "00000100000" then --JRRA
					regToRead1 <= RA;
					regToRead2 <= NO_REG;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= (others => 'X');
					operand1 <= (others => 'X');
					operand2 <= (others => 'X');
					pcMuxSel <= '1';
					pcVal <= dataRead1;
				elsif instruction(7 downto 0) = "01000000" then --MFPC
					regToRead1 <= NO_REG;
					regToRead2 <= NO_REG;
					regToWrite <= "0" & rx;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_PASS_A;
					operand1 <= rpc;
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				elsif instruction(4 downto 0) = "01101" then --OR
					regToRead1 <= "0" & rx;
					regToRead2 <= "0" & ry;
					regToWrite <= "0" & rx;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_OR;
					operand1 <= dataRead1;
					operand2 <= dataRead2;
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				else --NOP
					regToRead1 <= NO_REG;
					regToRead2 <= NO_REG;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= (others => 'X');
					operand1 <= (others => 'X');
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				end if;
			when "00010" => --B
				regToRead1 <= NO_REG;
				regToRead2 <= NO_REG;
				regToWrite <= NO_REG;
				regWrite <= '0';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= (others => 'X');
				operand1 <= (others => 'X');
				operand2 <= (others => 'X');
				pcMuxSel <= '1';
				pcVal <= rpc + ((4 downto 0 => instruction(10)) & instruction(10 downto 0));
			when "00100" => --BEQZ
				regToRead1 <= "0" & rx;
				regToRead2 <= NO_REG;
				regToWrite <= NO_REG;
				regWrite <= '0';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= (others => 'X');
				operand1 <= (others => 'X');
				operand2 <= (others => 'X');
				if dataRead1 = ZERO then
					pcMuxSel <= '1';
					pcVal <= rpc + ((7 downto 0 => instruction(7)) & instruction(7 downto 0));
				else
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				end if;
			when "00101" => --BNEZ
				regToRead1 <= "0" & rx;
				regToRead2 <= NO_REG;
				regToWrite <= NO_REG;
				regWrite <= '0';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= (others => 'X');
				operand1 <= (others => 'X');
				operand2 <= (others => 'X');
				if dataRead1 = ZERO then
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				else
					pcMuxSel <= '1';
					pcVal <= rpc + ((7 downto 0 => instruction(7)) & instruction(7 downto 0));
				end if;
			when "01101" => --LI
				regToRead1 <= NO_REG;
				regToRead2 <= NO_REG;
				regToWrite <= "0" & rx;
				regWrite <= '1';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= OP_PASS_A;
				operand1(15 downto 8) <= (others => '0');
				operand1(7 downto 0) <= instruction(7 downto 0);
				operand2 <= (others => 'X');
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "10011" => --LW
				regToRead1 <= "0" & rx;
				regToRead2 <= NO_REG;
				regToWrite <= '0' & ry;
				regWrite <= '1';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '1';
				op <= OP_ADD;
				operand1 <= dataRead1;
				operand2(15 downto 8) <= (others => instruction(7));
				operand2(7 downto 0) <= instruction(7 downto 0);
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "10010" => --LW_SP
				regToRead1 <= SP;
				regToRead2 <= NO_REG;
				regToWrite <= "0" & rx;
				regWrite <= '1';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '1';
				op <= OP_ADD;
				operand1 <= dataRead1;
				operand2(15 downto 8) <= (others => instruction(7));
				operand2(7 downto 0) <= instruction(7 downto 0);
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "11110" => --MFIH|MTIH
				if instruction(7 downto 0) = "00000000" then --MFIH
					regToRead1 <= IH;
					regToRead2 <= NO_REG;
					regToWrite <= "0" & rx;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_PASS_A;
					operand1 <= dataRead1;
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				elsif instruction(7 downto 0) = "000000001" then --MTIH
					regToRead1 <= "0" & rx;
					regToRead2 <= NO_REG;
					regToWrite <= IH;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_PASS_A;
					operand1 <= dataRead1;
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				else --NOP
					regToRead1 <= NO_REG;
					regToRead2 <= NO_REG;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= (others => 'X');
					operand1 <= (others => 'X');
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				end if;
			when "00001" => --NOP
				regToRead1 <= NO_REG;
				regToRead2 <= NO_REG;
				regToWrite <= NO_REG;
				regWrite <= '0';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= (others => 'X');
				operand1 <= (others => 'X');
				operand2 <= (others => 'X');
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "00110" => --SLL|SRA
				if instruction(1 downto 0) = "00" then --SLL
					regToRead1 <= "0" & ry;
					regToRead2 <= NO_REG;
					regToWrite <= "0" & rx;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_SLL;
					operand1 <= dataRead1;
					operand2(15 downto 3) <= (others => '0');
					operand2(2 downto 0) <= instruction(4 downto 2);
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				elsif instruction(1 downto 0) = "11" then --SRA
					regToRead1 <= "0" & ry;
					regToRead2 <= NO_REG;
					regToWrite <= "0" & rx;
					regWrite <= '1';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= OP_SRA;
					operand1 <= dataRead1;
					operand2(15 downto 3) <= (others => '0');
					operand2(2 downto 0) <= instruction(4 downto 2);
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				else --NOP
					regToRead1 <= NO_REG;
					regToRead2 <= NO_REG;
					regToWrite <= NO_REG;
					regWrite <= '0';
					memIn <= (others => 'X');
					memWrite <= '0';
					memRead <= '0';
					op <= (others => 'X');
					operand1 <= (others => 'X');
					operand2 <= (others => 'X');
					pcMuxSel <= '0';
					pcVal <= (others => 'X');
				end if;
			when "01010" => --SLTI
				regToRead1 <= "0" & rx;
				regToRead2 <= NO_REG;
				regToWrite <= T;
				regWrite <= '1';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= OP_SLT;
				operand1 <= dataRead1;
				operand2(15 downto 8) <= (others => instruction(7));
				operand2(7 downto 0) <= instruction(7 downto 0);
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "01011" => --SLTUI
				regToRead1 <= "0" & rx;
				regToRead2 <= NO_REG;
				regToWrite <= T;
				regWrite <= '1';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= OP_SLT;
				operand1 <= dataRead1;
				operand2(15 downto 8) <= (others => '0');
				operand2(7 downto 0) <= instruction(7 downto 0);
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "11011" => --SW
				regToRead1 <= "0" & rx;
				regToRead2 <= "0" & ry;
				regToWrite <= NO_REG;
				regWrite <= '0';
				memIn <= dataRead2;
				memWrite <= '1';
				memRead <= '0';
				op <= OP_ADD;
				operand1 <= dataRead1;
				operand2(15 downto 5) <= (others => instruction(4));
				operand2(4 downto 0) <= instruction(4 downto 0);
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when "11010" => --SW_SP
				regToRead1 <= SP;
				regToRead2 <= "0" & rx;
				regToWrite <= NO_REG;
				regWrite <= '0';
				memIn <= dataRead2;
				memWrite <= '1';
				memRead <= '0';
				op <= OP_ADD;
				operand1 <= dataRead1;
				operand2(15 downto 8) <= (others => instruction(7));
				operand2(7 downto 0) <= instruction(7 downto 0);
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
			when others => --NOP
				regToRead1 <= NO_REG;
				regToRead2 <= NO_REG;
				regToWrite <= NO_REG;
				regWrite <= '0';
				memIn <= (others => 'X');
				memWrite <= '0';
				memRead <= '0';
				op <= (others => 'X');
				operand1 <= (others => 'X');
				operand2 <= (others => 'X');
				pcMuxSel <= '0';
				pcVal <= (others => 'X');
		end case;
	end process;
end Behavioral;

