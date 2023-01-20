library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    port(
        A    : IN  STD_LOGIC;
        B    : IN  STD_LOGIC;
        Cin  : IN  STD_LOGIC;
        S    : OUT  STD_LOGIC;
        Cout : OUT STD_LOGIC
    );
end FA;


architecture Behavioral of FA is

    begin
        S <= A xor B xor Cin;
        Cout <= (A and B) or ( (A xor B) and Cin );

end Behavioral;
