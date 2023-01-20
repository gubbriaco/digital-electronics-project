library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder is
    generic(n:integer);
    port(
        input1: in std_logic_vector(n-1 downto 0);
        input2: in std_logic_vector(n-1 downto 0);
        c0: in std_logic;
        ris: out std_logic_vector(n downto 0)
        );
end Adder;

architecture Behavioral of Adder is
    signal p,g: std_logic_vector(n downto 0);
    signal c: std_logic_vector(n+1 downto 0); 

    begin
        c(0) <= c0;
        p <= (input1(n-1) xor input2(n-1)) & (input1 xor input2);
        g <= (input1(n-1) and input2(n-1)) & (input1 and input2);
        ris <= p xor c(n downto 0);
        c(n+1 downto 1) <= g or (p and c(n downto 0)); 

end Behavioral;