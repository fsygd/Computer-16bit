----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:59:48 12/05/2017 
-- Design Name: 
-- Module Name:    VGAADAPTER - Behavioral 
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

entity VGAADAPTER is
	port(
		clk_origin : in std_logic; -- normal clock
		clk_25 : in std_logic; -- 50M
		rst : in  std_logic; -- reset
		hs,vs : out std_logic; -- connect to vga port
		r,g,b : out std_logic_vector(2 downto 0); -- connect to vga
		WE : in std_logic_vector(0 downto 0); -- VGAWE, if address > F800 and be in a write state
		GAddress : in std_logic_vector(10 downto 0); -- VGA address, address to write
		GData : in std_logic_vector(7 downto 0) -- VGA data to write
	  );
end VGAADAPTER;

architecture Behavioral of VGAADAPTER is	
component CHAR is
		port(
			clk_origin : in std_logic;
			clk_25 : in std_logic;
			rst : in  std_logic;
			EN : in std_logic;
            
			GAddress : in std_logic_vector(10 downto 0);
			GData : in std_logic_vector(7 downto 0);
            
			PAddress : out std_logic_vector(14 downto 0);
			PData : out std_logic_vector(15 downto 0);
			WE : in std_logic_vector(0 downto 0)
			);
	end component;
	component VGA is
	 port(
			rst : in  STD_LOGIC;
			clk_25 : in  STD_LOGIC;
			hs,vs : out STD_LOGIC;
			r,g,b : out STD_LOGIC_vector(2 downto 0);
			PAddress : in std_logic_vector(14 downto 0);
			PData : in std_logic_vector(15 downto 0)
	  );
	end component;
	signal PAddress : std_logic_vector(14 downto 0);
	signal PData : std_logic_vector(15 downto 0);
begin
	myCHAR : CHAR port map(
		clk_origin => clk_origin,
		clk_25 => clk_25,
		rst => rst,
		GAddress => GAddress,
		GData => GData,
		WE => WE,
		PAddress => PAddress,
		PData => PData,
		EN => '1'
		);
	myVGA: VGA port map(
		rst => rst,
		clk_25 => clk_25,
		hs => hs,
		vs => vs,
		r => r,
		g => g,
		b => b,
		PAddress => PAddress,
		PData => PData
		);

end Behavioral;

