library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.MyDefinitions.ALL;

entity CSA is
    port(
        A   : IN  STD_LOGIC_VECTOR( n-1 downto 0 );
        B   : IN  STD_LOGIC_VECTOR( n-1 downto 0 );
        Cin : IN  STD_LOGIC;
        S   : OUT STD_LOGIC_VECTOR( n downto 0 )
    );
end CSA;

architecture Behavioral of CSA is
    
    component FA
        port(
            A    : IN  STD_LOGIC;
            B    : IN  STD_LOGIC;
            Cin  : IN  STD_LOGIC;
            S    : OUT STD_LOGIC;
            Cout : OUT STD_LOGIC
        );
    end component;
    
    signal carry_iniziale: STD_LOGIC_VECTOR( nFA downto 0 );
    
    signal carry_z: STD_LOGIC_VECTOR( nFA+1 downto 0 );
    signal zero : STD_LOGIC;
    
    signal carry_u: STD_LOGIC_VECTOR( nFA+1 downto 0 );
    signal uno : STD_LOGIC;
    
    signal selettore : STD_LOGIC; -- selettore che deciderà l'uscita dei MUX
    
    signal Ing1 : STD_LOGIC_VECTOR( nFA downto 0 ); -- vettore ingressi (corrispondenti alle uscite di FA_u) dei MUX
    signal Ing0 : STD_LOGIC_VECTOR( nFA downto 0 ); -- vettore ingressi (corrispondenti alle uscite di FA_z) dei MUX
    signal OutM : STD_LOGIC_VECTOR( nFA downto 0 ); -- vettore uscite dei MUX
    
 
 
    begin
        -- implemento il blocco di FA iniziale che somma i primi nFA (=> n/2) bit
        for_iniziale: for i in 0 to nFA-1 generate
            FA_iniziale: FA port map( A(i), B(i), carry_iniziale(i), S(i), carry_iniziale(i+1) );
        end generate for_iniziale;

        carry_iniziale(0) <= Cin;
        selettore <= carry_iniziale( nFA ); -- il selettore dei MUX sarà il Cout del blocco di FA iniziale
        
        zero <= '0';
        carry_z(0) <= zero; -- assegno '0' al Cin del primo blocco in parallelo
        uno <= '1';
        carry_u(0) <= uno; -- assegno '1' al Cin del secondo blocco in parallelo
        
        -- implemento i blocchi in parallelo FA_z e FA_u rispettivamente con Cin = zero e Cin = uno
        for_FAzu: for j in 0 to nFA generate
             ife: if j=nFA generate 
                       FA_Mz: FA port map( A(n-1), B(n-1), carry_z(nFA), Ing0(nFA), carry_z(nFA+1) );
                       FA_Mu: FA port map( A(n-1), B(n-1), carry_u(nFA), Ing1(nFA), carry_u(nFA+1) );
             end generate;
             ifl: if j<nFA generate
                       FA_Lz: FA port map( A(j+nFA), B(j+nFA), carry_z(j), Ing0(j), carry_z(j+1) );
                       FA_Lu: FA port map( A(j+nFA), B(j+nFA), carry_u(j), Ing1(j), carry_u(j+1) );
             end generate;
        end generate;          
        
        
        -- implemento i MUX
        for_mux: for w in 0 to nFA generate
            -- ricordando che Ing1 è il risultato del w-esimo FA del blocco in parallelo 
            -- con Cin = '1' e Ing0 è il risultato del w-esimo FA del blocco in parallelo 
            -- con Cin = '0'
            OutM(w) <= Ing0(w) when selettore = zero else
                       Ing1(w) when selettore = uno  else
                                                'X';
            S(w+nFA) <= OutM(w);
            -- l'indice w+nFA è pari all'indice del w-esimo MUX addizionato al numero di FA 
            -- così da ottenere l'indice corretto per salvare l'output del MUX all'interno 
            -- del vettore somma S
        end generate for_mux;
        

end Behavioral;
