library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.MyDefinitions.all;

entity PC4O is
    generic(n:integer:=n_bit);
    port(
        A,B,C,D: in std_logic_vector(n-1 downto 0);
        Contr: in std_logic_vector(1 downto 0);
        clk,clr: in std_logic;
        Ris: out std_logic_vector(n+2 downto 0)
    );
end PC4O;

architecture Behavioral of PC4O is
    component Reg is
        generic(n:integer);
        port(
            D: in std_logic_vector(n-1 downto 0);
            CLK: in std_logic;
            CLR: in std_logic;
            Q: out std_logic_vector(n-1 downto 0)
        );
    end component;
    component Adder is
        generic(n:integer);
        port(
            input1: in std_logic_vector(n-1 downto 0);
            input2: in std_logic_vector(n-1 downto 0);
            c0: in std_logic;
            ris: out std_logic_vector(n downto 0)
        );
    end component;
    
    --signal corrispondenti ai valori negati di B,C,D
    signal notB,notC,notD: std_logic_vector(n-1 downto 0);
    -- signal corrispondenti agli input diretti e alle uscite di ogni registro
    signal sA,sB,sC,sD: std_logic_vector(n-1 downto 0);
    -- signal uscenti dai mux per decidere il valore diretto o negato
    signal muxB,muxC,muxD: std_logic_vector(n-1 downto 0);
    -- riporto in entrata per l'Adder C per calcolarne il positivo o il negativo
    signal CinC: std_logic;
    -- signal uscenti dagli Adder dopo aver uniformato i bit per ognuno
    signal trueA,trueB,trueC,trueD: std_logic_vector(n downto 0);
    -- riporti in entrata agli Adder AB, CD, ABCD
    signal CinAB,CinCD,CinABCD: std_logic;
    -- risultati degli Adder AB, CD e le uscite dei registri corrispondenti
    signal AB,CD,sAB,sCD: std_logic_vector(n+1 downto 0);
    -- risultato dell'Adder ABCD e L'uscita del registro corrispondente
    signal ABCD,sABCD: std_logic_vector(n+2 downto 0);

    begin
        notB<=not B; notC<=not C; notD<=not D;
        -- implemento i registri corrispondenti agli ingressi A,B,C,D
        RegA: Reg generic map(n) port map(A,clk,clr,sA);
        RegB: Reg generic map(n) port map(B,clk,clr,sB);
        RegC: Reg generic map(n) port map(C,clk,clr,sC);
        RegD: Reg generic map(n) port map(D,clk,clr,sD);
        
        -- implemento i mux corrispondenti ai valori di B,notB,C,notC,D,notD
        muxB <= sB when Contr(0)='0' else
                not B when Contr(0)='1' else
                (others=>'X');
        muxC <= sC when Contr(1)='0' else
                not C when Contr(1)='1' else
                (others=>'X'); 
        muxD <= sD when Contr(0)='0' else
                not D when Contr(0)='1' else
                (others=>'X');
                
        -- calcolo il riporto in entrata per l'Adder di C per calcolarne il positivo o il negativo
        CinC <= '0' when Contr(1)='0' else
                '1' when Contr(1)='1' else
                'X';  
        
        -- implemento gli adder per uniformare i bit
        AdderA: Adder generic map(n) port map(sA,(others=>'0'),'0',trueA);
        AdderB: Adder generic map(n) port map(muxB,(others=>'0'),'0',trueB);
        AdderC: Adder generic map(n) port map(muxC,(others=>'0'),CinC,trueC);
        AdderD: Adder generic map(n) port map(muxD,(others=>'0'),'0',trueD);
    
        -- calcolo i riporti in entrata per gli Adder AB,CD
        CinAB <= '0' when Contr(0)='0' else
                 '1' when Contr(0)='1' else
                 'X';
        CinCD <= '0' when Contr(0)='0' else
                 '1' when Contr(0)='1' else
                 'X';
    
        -- implemento gli Adder AB e CD
        AdderAB: Adder generic map(n+1) port map(trueA,trueB,CinAB,AB);
        AdderCD: Adder generic map(n+1) port map(trueC,trueD,CinCD,CD);
        
        -- implemento i registri per i risultati degli Adder AB e CD
        RegAB: Reg generic map(n+2) port map(AB,clk,clr,sAB);
        RegCD: Reg generic map(n+2) port map(CD,clk,clr,sCD);
        
        -- implemento l'Adder finale ABCD
        AdderABCD: Adder generic map(n+2) port map(sAB,sCD,'0',ABCD);
        
        -- implemento il registro corrispondente al risultato dell'Adder ABCD
        RegABCD: Reg generic map(n+3) port map(ABCD,clk,clr,sABCD);
        
        -- il risultato del circuito complessivo sarà:
        Ris<=sABCD;

end Behavioral;
