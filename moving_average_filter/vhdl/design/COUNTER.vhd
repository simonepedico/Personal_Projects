library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
	 	 
entity counter is
    generic ( Nb : integer);
    port(
        T: in std_logic;
        clk: in std_logic;
        OUT_COUNT: out std_logic_vector(Nb-1 downto 0);
        ovf: out std_logic
    );
end counter;  
    
architecture counter_behavior of counter  is
constant ovf1: std_logic_vector(Nb-1 downto 0):=(others => '1');   

begin
process(clk)
variable ovf1_val: std_logic := '0';
variable count: std_logic_vector(Nb-1 downto 0):=(others => '0');
begin
    if rising_edge(clk) then   
        if T='1' then
            if count=ovf1 then
                count := (others => '0');
                ovf1_val := '1';
            else
                count := count + '1';
                ovf1_val := '0';
            end if;
        else
            count := count;
            ovf1_val := ovf1_val;
        end if;
    end if;
    out_count<=count;        
    ovf<=ovf1_val;
end process;

end counter_behavior;
