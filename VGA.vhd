----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:26:30 12/05/2017 
-- Design Name: 
-- Module Name:    VGA - Behavioral 
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
use	IEEE.STD_LOGIC_UNSIGNED.ALL;
use	IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA is
port(
    rst : in  STD_LOGIC; -- reset
    clk_25 : in  STD_LOGIC; -- 50M
    hs,vs : out STD_LOGIC; -- to connect vga port
    r,g,b : out STD_LOGIC_VECTOR(2 downto 0); -- to connect vga port
    PAddress : in STD_LOGIC_VECTOR(14 downto 0); -- where to write
    PData : in STD_LOGIC_VECTOR(15 downto 0) -- what to write
);
end VGA;

architecture Behavioral of VGA is
	signal r1,g1,b1   : STD_LOGIC_VECTOR(2 downto 0);
	signal hs1,vs1    : STD_LOGIC;				
	signal vector_x : STD_LOGIC_VECTOR(9 downto 0);
	signal vector_y : STD_LOGIC_VECTOR(8 downto 0);
	signal clk	:	 STD_LOGIC;
	signal GRamAddrb_in : STD_LOGIC_VECTOR(18 downto 0);
	signal GRamDoutb_in :  STD_LOGIC_VECTOR(0 downto 0);
	signal unsignedA : unsigned(9 downto 0);
	signal unsignedB : unsigned(8 downto 0);
	signal result : unsigned(18 downto 0);
	signal GRamDouta : STD_LOGIC_VECTOR(15 downto 0);
	signal const640 : STD_LOGIC_VECTOR(9 downto 0);
    component GRam is
        port (
        clka : in STD_LOGIC;
        wea : in STD_LOGIC_VECTOR(0 downto 0);
        addra : in STD_LOGIC_VECTOR(14 downto 0);
        dina : in STD_LOGIC_VECTOR(15 downto 0);
        douta : out STD_LOGIC_VECTOR(15 downto 0);
        clkb : in STD_LOGIC;
        web : in STD_LOGIC_VECTOR(0 downto 0);
        addrb : in STD_LOGIC_VECTOR(18 downto 0);
        dinb : in STD_LOGIC_VECTOR(0 downto 0);
        doutb : out STD_LOGIC_VECTOR(0 downto 0)
    );
	end component;
    
begin
	const640 <= "1010000000";
	GRam_c: GRam port map(
			clka => clk, -- IN STD_LOGIC;
			clkb => clk, -- IN STD_LOGIC;
			wea => "1", -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			web => "0", -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			addra => PAddress, -- IN STD_LOGIC_VECTOR(14 DOWNTO 0);
			dina => PData, -- IN STD_LOGIC_VECTOR(15 DOWNTO 0);

			douta => GRamDouta, -- OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			addrb => GRamAddrb_in, -- IN STD_LOGIC_VECTOR(18 DOWNTO 0);
			dinb => (others => 'Z'), -- IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			doutb => GRamDoutb_in -- OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
		);

    --process(clk_0)
    --begin
    --    if(clk_0'event and clk_0 = '1') then 
    --         clk <= not clk;
    --    end if;
 	--end process;
    -- then clk is 25M
    
    clk <= clk_25;
    
	 process(clk, rst)
	 begin
		  if rst = '0' then
		   hs1 <= '1';
		  elsif clk'event and clk = '1' then
		   	if vector_x >= 656 and vector_x < 752 then
		    	hs1 <= '0';
		   	else
		    	hs1 <= '1';
		   	end if;
		  end if;
	 end process;
     -- hs1
     
	 process(clk, rst)
	 begin
	  	if rst = '0' then
	   		vs1 <= '1';
	  	elsif clk'event and clk = '1' then
	   		if vector_y >= 490 and vector_y < 492 then
	    		vs1 <= '0';
	   		else
	    		vs1 <= '1';
	   		end if;
	  	end if;
	 end process;
     -- vs1
     
	 process(clk, rst)
	 begin
	  	if rst = '0' then
	   		hs <= '0';
	  	elsif clk'event and clk = '1' then
	   		hs <=  hs1;
	  	end if;
	 end process;
     
	 process(clk, rst)
	 begin
	  	if rst = '0' then
	   		vs <= '0';
	  	elsif clk'event and clk = '1' then
	   		vs <=  vs1;
	  	end if;
	 end process;
     -- hs and vs
     
	process(clk, rst)
	 begin
	  	if rst = '0' then
	   		vector_x <= (others => '0');
	  	elsif clk'event and clk = '1' then
	   		if vector_x = 799 then
	    		vector_x <= (others => '0');
	   		else
	    		vector_x <= vector_x + 1;
	   		end if;
	  	end if;
	 end process;
     -- so vector_x = {0, 1, 2, ..., 799}
     
	 process(clk,rst)
	 begin
	  	if rst = '0' then
	   		vector_y <= (others=>'0');
	  	elsif clk'event and clk = '1' then
	   		if vector_x = 799 then
	    		if vector_y = 524 then
	     			vector_y <= (others => '0');
	    		else
	     			vector_y <= vector_y + 1;
	    		end if;
	   		end if;
	  	end if;
	 end process;
     -- so vector_y = {0, 1, ..., 524}
     -- so (y, x) = (0, 0), (0, 1), ..., (524, 799)
     
     
 	unsignedA <= unsigned(vector_x);
 	unsignedB <= unsigned(vector_y);
    
 	result <= unsignedB * unsigned(const640) + unsignedA;
    -- where (y, x) is stored
    
 	GRamAddrb_in <= STD_LOGIC_VECTOR(result);
	process(rst, clk, vector_x, vector_y)
	begin
		if rst = '0' then
			        r1  <= "000";
					g1	<= "000"; 
					b1	<= "000";
		elsif(clk'event and clk = '1') then
			if vector_x > 639 or vector_y > 479 then 
					r1  <= "000";
					g1	<= "000";
					b1	<= "000";
			else
				if GRamDoutb_in = "1" then
					r1  <= "100";
					g1	<= "100";
					b1	<= "100";
				else
					r1  <= "000";
					g1	<= "000";
					b1	<= "000";
				end if ;
			end if;
		end if;		 
	end process;
    -- set r1, g1, b1
    
	process (hs1, vs1, r1, g1, b1)
	begin
		if hs1 = '1' and vs1 = '1' then
			r	<= r1;
			g	<= g1;
			b	<= b1;
		else
			r	<= (others => '0');
			g	<= (others => '0');
			b	<= (others => '0');
		end if;
	end process;
    -- to comply with vga

end Behavioral;

