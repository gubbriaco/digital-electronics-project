library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
library work;
use work.MyDefinitions.ALL;

entity SimCSA is
--  Port ( );
end SimCSA;

architecture Behavioral of SimCSA is
    component CSA is
        port(
            A   : IN  STD_LOGIC_VECTOR( n-1 downto 0 );
            B   : IN  STD_LOGIC_VECTOR( n-1 downto 0 );
            Cin : IN  STD_LOGIC;
            S   : OUT STD_LOGIC_VECTOR( n downto 0 )
        );
    end component;

    signal IA   :  STD_LOGIC_VECTOR( n-1 downto 0 );
    signal IB   :  STD_LOGIC_VECTOR( n-1 downto 0 );
    signal Icin :  STD_LOGIC;
    signal OS   :  STD_LOGIC_VECTOR( n downto 0 );
    signal TrueRis, Error:integer;
    
    
    
    begin
    
      csa_circ: CSA port map( IA, IB, Icin, OS );
      Icin <= '0';
      
      process
          begin
            for va in -( 2**(n-1) ) to ( 2**(n-1)-1 ) loop
                IA <= conv_std_logic_vector( va, n );
                for vb in -( 2**(n-1) ) to ( 2**(n-1)-1 ) loop          
                    IB <= conv_std_logic_vector( vb, n );
                    TrueRis <= va+vb;
                    wait for 10ns;
                end loop;
            end loop;
      end process;
      
      Error <= TrueRis - conv_integer( signed(OS) ); 


end Behavioral;
