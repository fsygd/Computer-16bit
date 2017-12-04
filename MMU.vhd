----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:36:22 11/21/2017 
-- Design Name: 
-- Module Name:    MMU - Behavioral 
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

entity MMU is

-- input pc -> output instruction
-- input addr, dataIn -> write
	Port(
			clk : in STD_LOGIC;
			rst : in STD_LOGIC;

			memRead : in STD_LOGIC;
			memWrite : in STD_LOGIC;
			memAddr : in STD_LOGIC_VECTOR(15 downto 0);
			dataIn : in STD_LOGIC_VECTOR(15 downto 0);
			memData : out STD_LOGIC_VECTOR(15 downto 0);

			pc : in STD_LOGIC_VECTOR (15 downto 0);
			instruction : out STD_LOGIC_VECTOR(15 downto 0);

			ram1_oe, ram1_rw, ram1_en : out STD_LOGIC; --RAM1
			ram1_addr : out STD_LOGIC_VECTOR(15 downto 0);
			ram1_data : inout STD_LOGIC_VECTOR(15 downto 0);

			ram2_oe, ram2_rw,  ram2_en : out STD_LOGIC; --RAM2
			ram2_addr : out STD_LOGIC_VECTOR(15 downto 0);
			ram2_data : inout STD_LOGIC_VECTOR(15 downto 0);

			data_ready, tbre, tsre :  in STD_LOGIC; --COM
			rdn, wrn : out STD_LOGIC;
            
			pcStop : out STD_LOGIC
		);
end MMU;

architecture Behavioral of MMU is
begin
	Addr_select : process(memAddr, pc, memRead, memWrite, rst)
	begin
		if rst = '0' then
			ram1_addr <= (others => '0');
			ram2_addr <= (others => '0');
			pcStop <= '0';
		elsif (memRead = '0' and memWrite = '0') or memAddr(15) = '1' then
			ram1_addr <= memAddr;
			ram2_addr <= pc;
			pcStop <= '0';
		else
			ram1_addr <= memAddr;
			ram2_addr <= memAddr;
			pcStop <= '1';
		end if;
	end process;

	control : process(memAddr, memRead, memWrite, dataIn, data_ready, tsre, tbre, ram1_data, ram2_data, clk, rst)
	begin
		if rst = '0' then
			ram1_data <= (others => 'Z');
			ram2_data <= (others => 'Z');
			
			rdn <= '1';
			wrn <= '1';
			
			ram1_oe <= '1';
			ram1_rw <= '1';
			ram1_en <= '1';
			 
			ram2_oe <= '1';
			ram2_rw <= '1';
			ram2_en <= '1';
		elsif memRead = '1' then -- read memory
			if memAddr = x"BF00" then
				rdn <= '0';
				wrn <= '1';
				
				ram1_oe <= '1';
				ram1_rw <= '1';
				ram1_en <= '1';
			
				ram2_oe <= '0';
				ram2_rw <= '1';
				ram2_en <= '0';
				
				ram1_data <= (others => 'Z');
				ram2_data <= (others => 'Z');
			elsif memAddr = x"BF01" or memAddr = x"BF02" or memAddr = x"BF03" then
				rdn <= '1';
				wrn <= '1';
				
				ram1_oe <= '1';
				ram1_rw <= '1';
				ram1_en <= '1';
				
				ram2_oe <= '0';
				ram2_rw <= '1';
				ram2_en <= '0';
				
				ram1_data <= (others => 'Z');
				ram2_data <= (others => 'Z');
			else
				rdn <= '1';
				wrn <= '1';
				
				ram1_oe <= '0';
				ram1_rw <= '1';
				ram1_en <= '0';
				
				ram2_oe <= '0';
				ram2_rw <= '1';
				ram2_en <= '0';
				
				ram1_data <= (others => 'Z');
				ram2_data <= (others => 'Z');
			end if;
		elsif memWrite = '1' then -- write memory
			if memAddr = x"BF00" then
				rdn <= '1';
				wrn <= clk;
				
				ram1_oe <= '1';
				ram1_rw <= '1';
				ram1_en <= '1';
			
				ram2_oe <= '0';
				ram2_rw <= '1';
				ram2_en <= '0';
				
				ram1_data <= dataIn;
				ram2_data <= (others => 'Z');
			elsif memAddr = x"BF01" or memAddr = x"BF02" or memAddr = x"BF03" then
				rdn <= '1';
				wrn <= '1';
				
				ram1_oe <= '1';
				ram1_rw <= '1';
				ram1_en <= '1';
				
				ram2_oe <= '1';
				ram2_rw <= not clk;
				ram2_en <= '0';
				
				ram1_data <= dataIn;
				ram2_data <= dataIn;
			elsif memAddr(15) = '1' then
				rdn <= '1';
				wrn <= '1';
				
				ram1_oe <= '1';
				ram1_rw <= not clk;
				ram1_en <= '0';
				
				ram2_oe <= '0';
				ram2_rw <= '1';
				ram2_en <= '0';
				
				ram1_data <= dataIn;
				ram2_data <= (others => 'Z');
			else
				rdn <= '1';
				wrn <= '1';
				
				ram1_oe <= '1';
				ram1_rw <= not clk;
				ram1_en <= '0';
				
				ram2_oe <= '1';
				ram2_rw <= not clk;
				ram2_en <= '0';
				
				ram1_data <= dataIn;
				ram2_data <= dataIn;
			end if;
		else -- read instruction
			rdn <= '1';
			wrn <= '1';
			
			ram1_oe <= '1';
			ram1_rw <= '1';
			ram1_en <= '1';
			
			ram2_oe <= '0';
			ram2_rw <= '1';
			ram2_en <= '0';
			
			ram1_data <= (others => 'Z');
			ram2_data <= (others => 'Z');
		end if;
	end process;

	memData_read : process(memRead, memAddr, data_ready, tsre, tbre, ram1_data, ram2_data, rst)
	begin
		if rst = '0' then
			memData <= (others => 'X');
		elsif memAddr = x"BF01" then
			memData(15 downto 2) <= (others => '0');
			memData(1) <= data_ready;
			memData(0) <= tsre and tbre;
		elsif memAddr(15) = '0' then
			memData <= ram2_data;
		elsif memAddr(15) = '1' then
			memData <= ram1_data;
		end if;
	end process;
	
	process(memAddr, ram2_data, memRead, memWrite, rst)
	begin
		if rst = '0' then
			instruction <= x"0800";
		elsif (memRead = '0' and memWrite = '0') or memAddr(15) = '1' then
			instruction <= ram2_data;
		else
			instruction <= x"0800";
		end if;
	end process;
    
end Behavioral;

