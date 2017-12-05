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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
            
			pcStop : out STD_LOGIC;
			
			FlashByte : out std_logic;
			FlashVpen : out std_logic;
			FlashCE : out std_logic;
			FlashOE : out std_logic;
			FlashWE : out std_logic;
			FlashRP : out std_logic;
			
			FlashAddr : out std_logic_vector(22 downto 0);
			FlashData : inout std_logic_vector(15 downto 0)
		);
end MMU;

architecture Behavioral of MMU is
	signal memFlash : STD_LOGIC;
	signal ctl_read : STD_LOGIC;
	signal flashBootAddr : STD_LOGIC_VECTOR(22 downto 0);
	signal flashMemAddr : STD_LOGIC_VECTOR(15 downto 0);
	signal flashBootData : STD_LOGIC_VECTOR(15 downto 0);
	signal FlashTimer : STD_LOGIC_VECTOR(7 downto 0);
	
	component FlashAdapter
		port (
			clk : in std_logic;
			rst : in std_logic;
			Address : in std_logic_vector(22 downto 0);
			OutputData : out std_logic_vector(15 downto 0);
			ctl_read : in std_logic;

			FlashByte : out std_logic;
			FlashVpen : out std_logic;
			FlashCE : out std_logic;
			FlashOE : out std_logic;
			FlashWE : out std_logic;
			FlashRP : out std_logic;

			FlashAddr : out std_logic_vector(22 downto 0);
			FlashData : inout std_logic_vector(15 downto 0)
		);
	end component;
	
	type STATE_TYPE is (INIT, READ_FLASH, WRITE_RAM, COMP, DONE);
	signal state : STATE_TYPE;
begin
	FlashAdapter_c : FlashAdapter port map (
		clk => clk,
		rst => rst,
		Address => flashBootAddr,
		OutputData => flashBootData,
		ctl_read => ctl_read,

		FlashByte => FlashByte,
		FlashVpen => FlashVpen,
		FlashCE => FlashCE,
		FlashOE => FlashOE,
		FlashWE => FlashWE,
		FlashRP => FlashRP,

		FlashAddr => FlashAddr,
		FlashData => FlashData
	);

	Addr_select : process(memFlash, flashBootAddr, flashMemAddr, memAddr, pc, memRead, memWrite, rst)
	begin
		if memFlash = '0' then
			if (memRead = '0' and memWrite = '0') or memAddr(15) = '1' then
				ram1_addr <= memAddr;
				ram2_addr <= pc;
				pcStop <= '0';
			else
				ram1_addr <= memAddr;
				ram2_addr <= memAddr;
				pcStop <= '1';
			end if;
		else
			ram1_addr <= (others => 'X');
			ram2_addr <= flashMemAddr;
			pcStop <= '1';
		end if;
	end process;

	control : process(state, memFlash, flashBootAddr, flashMemAddr, flashBootData, memAddr, memRead, memWrite, dataIn, data_ready, tsre, tbre, ram1_data, ram2_data, clk, rst)
	begin
		if memFlash = '1' then -- read flash
			rdn <= '1';
			wrn <= '1';
				
			ram1_oe <= '1';
			ram1_rw <= '1';
			ram1_en <= '1';
			
			ram2_oe <= '1';
			if state = WRITE_RAM then
				ram2_rw <= not clk;
			else
				ram2_rw <= '1';
			end if;
			ram2_en <= '0';
				
			ram1_data <= (others => 'Z');
			ram2_data <= flashBootData;
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
				ram1_rw <= not clk;
				ram1_en <= '0';
			
				ram2_oe <= '0';
				ram2_rw <= '1';
				ram2_en <= '0';
				
				ram1_data <= dataIn;
				ram2_data <= (others => 'Z');
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
		if memAddr = x"BF01" then
			memData(15 downto 2) <= (others => '0');
			memData(1) <= data_ready;
			memData(0) <= tsre and tbre;
		elsif memAddr(15) = '0' then
			memData <= ram2_data;
		elsif memAddr(15) = '1' then
			memData <= ram1_data;
		end if;
	end process;
	
	read_instruction : process(memAddr, ram2_data, memRead, memWrite, rst)
	begin
		if rst = '0' then
			instruction <= x"0800";
		elsif (memRead = '0' and memWrite = '0') or memAddr(15) = '1' then
			instruction <= ram2_data;
		else
			instruction <= x"0800";
		end if;
	end process;
	
	ctl_read <= '0' when state = READ_FLASH else '1';
	
	flash_state : process(clk, rst)
	begin
		if rst = '0' then
			memFlash <= '1';
			flashBootAddr <= (others => '0');
			flashMemAddr <= (others => '0');
			FlashTimer <= (others => '0');
			state <= INIT;
		elsif rising_edge(clk) then
			case state is
				when INIT =>
					memFlash <= '1';
					flashBootAddr <= (others => '0');
					flashMemAddr <= (others => '0');
					FlashTimer <=(others => '0');
					state <= READ_FLASH;
				when READ_FLASH =>
					if FlashTimer = "11111111" then
						FlashTimer <= (others => '0');
						state <= WRITE_RAM;
					else
						FlashTimer <= FlashTimer + 1;
						state <= READ_FLASH;
					end if;
				when WRITE_RAM =>
					state <= COMP;
				when COMP =>
					flashBootAddr <= flashBootAddr + 2;
					flashMemAddr <= flashMemAddr + 1;
					if flashBootAddr < x"0FFF" then
						state <= READ_FLASH;	
					else
						state <= DONE;
					end if;
				when DONE =>
					memFlash <= '0';
				when others =>
					state <= INIT;
			end case;
		end if;
	end process;
    
end Behavioral;

