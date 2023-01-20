library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
library work;
use work.MyDefinitions.all;

entity SimPC4O is
    generic(n:integer:=n_bit);
end SimPC4O;

architecture Behavioral of SimPC4O is
    component PC4O is
        port(
            A,B,C,D: in std_logic_vector(n-1 downto 0);
            Contr: in std_logic_vector(1 downto 0);
            clk,clr: in std_logic;
            Ris: out std_logic_vector(n+2 downto 0)
        );
    end component;
    
    signal IA,IB,IC,ID: std_logic_vector(n-1 downto 0);
    signal Icontr: std_logic_vector(1 downto 0);
    signal Iclk,Iclr: std_logic:='0';
    signal ORis: std_logic_vector(n+2 downto 0);
    constant Tclk:Time:=12ns;
    
    signal TrueRis,Error:integer;

    begin
            
        Icontr(1)<='1';
        IContr(0)<='1';
        
        PC4O_forSimulation: PC4O port map(IA,IB,IC,ID,Icontr,Iclk,Iclr,ORis);
        
        process
            begin
                wait for Tclk/2;
                Iclk<=not Iclk;
        end process;
        
        process
            begin
                Iclr <='1';
                wait for Tclk+100ns;
                Iclr<='0';
                
                for va in -( 2**(n-1) ) to ( 2**(n-1)-1 ) loop
                    IA <= conv_std_logic_vector( va, n );
                    for vb in -( 2**(n-1) ) to ( 2**(n-1)-1 ) loop          
                        IB <= conv_std_logic_vector( vb, n );
                        for vc in -( 2**(n-1) ) to ( 2**(n-1)-1 ) loop
                            IC <= conv_std_logic_vector( vc, n );
                            for vd in -( 2**(n-1) ) to ( 2**(n-1)-1 ) loop
                                ID <= conv_std_logic_vector( vd, n );
                                if(Icontr="00")then
                                    TrueRis <= va+vb+vc+vd;
                                    Error <= TrueRis - conv_integer( signed(ORis) );
                                elsif(Icontr="01" )then
                                    TrueRis <= va-vb+vc-vd;
                                    Error <= TrueRis - conv_integer( signed(ORis) );
                                elsif(Icontr="10" )then
                                    TrueRis <= va+vb-vc+vd;
                                    Error <= TrueRis - conv_integer( signed(ORis) );
                                elsif(Icontr="11" )then
                                    TrueRis <= va-vb-vc-vd;
                                    Error <= TrueRis - conv_integer( signed(ORis) );
                                end if;
                               wait for Tclk;
                            end loop;
                           wait for Tclk;
                        end loop;
                       wait for Tclk;
                    end loop;
                   wait for Tclk;
                end loop; 
        end process;
 
end Behavioral;
