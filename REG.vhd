----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:36 11/19/2017 
-- Design Name: 
-- Module Name:    REG - Behavioral 
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

entity REG is
    Port ( clk : in  STD_LOGIC; -- this clk should only be used to write
           rst : in  STD_LOGIC;
			  
           regWrite : in  STD_LOGIC; -- '1' to write
			  
           regToWrite : in  STD_LOGIC_VECTOR (3 downto 0);
           dataToWrite : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  --*-- the read part of register files should code in combinational logic style --*--
			  
           regToRead1 : in  STD_LOGIC_VECTOR (3 downto 0);
           regToRead2 : in  STD_LOGIC_VECTOR (3 downto 0);
           dataRead1 : out  STD_LOGIC_VECTOR (15 downto 0);
           dataRead2 : out  STD_LOGIC_VECTOR (15 downto 0);
			  
			  dataOut : out STD_LOGIC_VECTOR(15 downto 0)
			  
			  );
end REG;

architecture Behavioral of REG is
signal Reg0000 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg0001 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg0010 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg0011 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg0100 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg0101 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg0110 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg0111 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1000 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1001 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1010 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1011 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1100 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1101 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1110 : STD_LOGIC_VECTOR(15 downto 0);
signal Reg1111 : STD_LOGIC_VECTOR(15 downto 0);

signal dataRead1Buffer : STD_LOGIC_VECTOR(15 downto 0);
signal dataRead2Buffer : STD_LOGIC_VECTOR(15 downto 0);
begin

-- rst to reset all the registers
-- set the correct address (and data when write)
-- when CLK down, check regWrite (to see if write back)
--RegWrite

	process(clk, rst, RegWrite, regToWrite, dataToWrite)
	begin
		if rst = '0' then
			Reg0000 <= (others => '0');
			Reg0001 <= (others => '0');
			Reg0010 <= (others => '0');
			Reg0011 <= (others => '0');
			Reg0100 <= (others => '0');
			Reg0101 <= (others => '0');
			Reg0110 <= (others => '0');
			Reg0111 <= (others => '0');
			Reg1000 <= (others => '0');
			Reg1001 <= (others => '0');
			Reg1010 <= (others => '0');
			Reg1011 <= (others => '0');
			Reg1100 <= (others => '0');
			Reg1101 <= (others => '0');
			Reg1110 <= (others => '0');
			Reg1111 <= (others => '0');
		elsif clk'event and clk = '0' then
			if RegWrite = '1' then
				case (regToWrite) is
					when "0000" =>
						Reg0000 <= dataToWrite;
					when "0001" =>
						Reg0001 <= dataToWrite;
					when "0010" =>
						Reg0010 <= dataToWrite;
					when "0011" =>
						Reg0011 <= dataToWrite;
					when "0100" =>
						Reg0100 <= dataToWrite;
					when "0101" =>
						Reg0101 <= dataToWrite;
					when "0110" =>
						Reg0110 <= dataToWrite;
					when "0111" =>
						Reg0111 <= dataToWrite;
					when "1000" =>
						Reg1000 <= dataToWrite;
					when "1001" =>
						Reg1001 <= dataToWrite;
					when "1010" =>
						Reg1010 <= dataToWrite;
					when "1011" =>
						Reg1011 <= dataToWrite;
					when "1100" =>
						Reg1100 <= dataToWrite;
					when "1101" =>
						Reg1101 <= dataToWrite;
					when "1110" =>
						Reg1110 <= dataToWrite;
					when "1111" =>
						Reg1111 <= dataToWrite;
					when others =>
						--none
				end case;
			end if;
		end if;
	end process;
	
	--regRead1
	process(regToRead1, Reg0000, Reg0001, Reg0010, Reg0011, Reg0100, Reg0101, Reg0110, Reg0111,
							  Reg1000, Reg1001, Reg1010, Reg1011, Reg1100, Reg1101, Reg1110, Reg1111, rst)
	begin
        if rst = '0' then
            dataRead1Buffer <= (others => '0');
        else
            case (regToRead1) is
                when "0000" =>
                    dataRead1Buffer <= Reg0000;
                when "0001" =>
                    dataRead1Buffer <= Reg0001;
                when "0010" =>
                    dataRead1Buffer <= Reg0010;
                when "0011" =>
                    dataRead1Buffer <= Reg0011;
                when "0100" =>
                    dataRead1Buffer <= Reg0100;
                when "0101" =>
                    dataRead1Buffer <= Reg0101;
                when "0110" =>
                    dataRead1Buffer <= Reg0110;
                when "0111" =>
                    dataRead1Buffer <= Reg0111;
                when "1000" =>
                    dataRead1Buffer <= Reg1000;
                when "1001" =>
                    dataRead1Buffer <= Reg1001;
                when "1010" =>
                    dataRead1Buffer <= Reg1010;
                when "1011" =>
                    dataRead1Buffer <= Reg1011;
                when "1100" =>
                    dataRead1Buffer <= Reg1100;
                when "1101" =>
                    dataRead1Buffer <= Reg1101;
                when "1110" =>
                    dataRead1Buffer <= Reg1110;
                when "1111" =>
                    dataRead1Buffer <= Reg1111;
                when others =>
                    --none
            end case;
        end if;
	end process;
	
	--regRead2
	process(regToRead2, Reg0000, Reg0001, Reg0010, Reg0011, Reg0100, Reg0101, Reg0110, Reg0111,
							  Reg1000, Reg1001, Reg1010, Reg1011, Reg1100, Reg1101, Reg1110, Reg1111, rst)
	begin
        if rst = '0' then
            dataRead2Buffer <= (others => '0');
        else
            case (regToRead2) is
                when "0000" =>
                    dataRead2Buffer <= Reg0000;
                when "0001" =>
                    dataRead2Buffer <= Reg0001;
                when "0010" =>
                    dataRead2Buffer <= Reg0010;
                when "0011" =>
                    dataRead2Buffer <= Reg0011;
                when "0100" =>
                    dataRead2Buffer <= Reg0100;
                when "0101" =>
                    dataRead2Buffer <= Reg0101;
                when "0110" =>
                    dataRead2Buffer <= Reg0110;
                when "0111" =>
                    dataRead2Buffer <= Reg0111;
                when "1000" =>
                    dataRead2Buffer <= Reg1000;
                when "1001" =>
                    dataRead2Buffer <= Reg1001;
                when "1010" =>
                    dataRead2Buffer <= Reg1010;
                when "1011" =>
                    dataRead2Buffer <= Reg1011;
                when "1100" =>
                    dataRead2Buffer <= Reg1100;
                when "1101" =>
                    dataRead2Buffer <= Reg1101;
                when "1110" =>
                    dataRead2Buffer <= Reg1110;
                when "1111" =>
                    dataRead2Buffer <= Reg1111;
                when others =>
                    --none
            end case;
        end if;
	end process;
	
	dataRead1 <= dataRead1Buffer;
	dataRead2 <= dataRead2Buffer;
	dataOut <= Reg0001;
end Behavioral;

