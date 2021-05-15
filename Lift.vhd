library IEEE;
use IEEE.std_logic_1164.all;

entity lift is
	port(etaj, comanda: in std_logic_vector (3 downto 0);
	     clock, confirm, reset, senzor, usa, viteza: in std_logic;
	     avertizare1, avertizare2: out std_logic;
		 anozi: out std_logic_vector (3 downto 0);
		 catozi: out std_logic_vector (7 downto 0));
end entity;

architecture structural of lift is

	component Debouncer
    port(Buton, CLK : in STD_LOGIC;
           Buton_DB : out STD_LOGIC);
    end component;
	
	
	component UC
	port(reset, clock, confirm, senzor, TU, gasit, sens, ajuns, stop: in std_logic;
	     avertizare1, avertizare2, CETu, CEN1, write, s0, up, cen2, s1, sel_ram: out std_logic);
    end component;
	
	
	component TimerUsa
	port( EN, RST, CLK: in std_logic;
	      CR: out std_logic);
    end component;
	
	
	component numarator1
	port(CLK, EN, RESET: in std_logic;
	     Q: out std_logic_vector(3 downto 0));
    end component;
	
	
	component numarator2
	port(CLK, EN, UP, RESET: in std_logic;
	     Q: out std_logic_vector(3 downto 0));
    end component;
	
	
	component MEMORIE_RAM
	port(A_RAM, I_RAM: in STD_LOGIC_VECTOR (3 downto 0);
		 WE, CLK, RESET: in STD_LOGIC;  
         D_RAM: out STD_LOGIC_VECTOR(3 downto 0)); 
    end component;
	
	
	component MUX4_1
	port(X0, X1, X2, X3: in std_logic_vector (3 downto 0);
	     s1, s0: in std_logic;
		 Y: out std_logic_vector (3 downto 0));
    end component;
	
	
	component OR2 is
	port(x, y: in std_logic;
	     z: out std_logic);
    end component;
	
	
	component AND2B1
	port(x, y: in std_logic;
	     z: out std_logic);
    end component;
	
	
	component AND2
	port(x, y: in std_logic;
	     z: out std_logic);
    end component;
	
	
	component XNOR2
	port(x, y: in std_logic;
	     z: out std_logic);
    end component;
	
	component OR3
	port(x1, x2, x3: in std_logic;
	     y: out std_logic);
    end component;
	
	component AND4
	port(x1, x2, x3, x4: in std_logic;
	     y: out std_logic);
    end component;
	
	component comp4 is
	port(x, y: in std_logic_vector (3 downto 0);
	     f1, f2, f3: out std_logic); 
    end component;
	
	component mux2_1
	port (x0, x1: in std_logic_vector (3 downto 0);
	      sel: in std_logic;
	      y: out std_logic_vector (3 downto 0));
    end component;
	
	component DIVIZOR
    port( CLOCK: in STD_LOGIC;
          C: out STD_LOGIC);
    end component;
	
	component AFISOR
	port(numar: in std_logic_vector(3 downto 0);
	     clk: in std_logic;
		 catozi: out std_logic_vector(7 downto 0);
		 anozi: out std_logic_vector(3 downto 0));
    end component;
	
	component Counter3
	port( EN, RST, CLK: in std_logic;
	      CR: out std_logic);
    end component;
	
	component tri_state_buffer
	port ( x, en: in std_logic;
	       y: out std_logic);
    end component;
	
	component inversor
	port (x: in std_logic;
	      y: out std_logic);
    end component;
	
	signal outc1, outc2, enCETU, outc5, stu, sCEN1, sSens, sCEN2, sup, ss1, ss0, sgasit, swrite, sig1, sig2, sstop, sajuns, ssel, clock_div, N1, N2, N3: std_logic;
	signal outnum1, outnum2, outram, outmux, outmux2: std_logic_vector (3 downto 0);
begin
	c1: debouncer port map (buton => confirm, clk => clock, buton_db => outc1);
	c2: debouncer port map (buton => usa, clk => clock, buton_db => outc2);
	c3: UC port map (confirm => outc1, avertizare1 => avertizare1, avertizare2 => avertizare2, reset => reset, clock => clock, senzor => senzor, 
	                 TU => stu, gasit =>  sgasit, sens =>  ssens  , ajuns => sajuns , stop => sstop , CETu => enCETU, CEN1 => scen1 , write => swrite, s0 =>  ss0, up =>  sup,
					 CEN2 => scen2, s1 =>  ss1, sel_ram => ssel);
	c4: TimerUsa port map ( en => enCETU, rst => outc5 , clk => clock_div, cr => stu);
	c5: OR2 port map (x => outc2, y => reset, z => outc5);
	c6: numarator1 port map (clk => clock, en => scen1 , reset =>  reset, q => outnum1);
	c7: numarator2 port map (clk => N3, en => scen2 , up =>  sup , reset => reset, q => outnum2 );
	c8: mux4_1 port map (x0 => etaj, x1 => outnum1, x2 => outnum2 , x3 => "0000" , s1 => ss1 , s0 => ss0, y => outmux );
	c9: memorie_ram port map (A_RAM => outmux , I_RAM =>  outmux2 , we =>  swrite, clk => clock , reset => reset , D_RAM => outram );
	c10: OR2 port map (x => outram(3), y => outram(2), z => sgasit);
	c11: AND2 port map (x => outram(1), y => sup, z => sig1);
	c12: AND2B1 port map(x => sup, y => outram(0), z => sig2);
	c13: OR3 port map (x1 => outram(2), x2 => sig1, x3 => sig2, y => sstop);
	c14: comp4 port map (x => outnum1, y => outnum2, f2 => sajuns);
	c15: comp4 port map (x => outnum1, y => outnum2, f1 => ssens);
    c16: mux2_1 port map (x0 => comanda, x1 => "0000", sel => ssel, y => outmux2);
	c17: divizor port map (clock => clock, c => clock_div);
	c18: afisor port map (numar => outnum2, clk => clock, catozi => catozi, anozi => anozi);
	c19: counter3 port map (en => '1', rst => reset, clk => clock_div, cr => N1 );
	c20: inversor port map ( x => viteza, y => N2 );
	c21: tri_state_buffer port map (x => clock_div, en => N2, y => N3);
	c22: tri_state_buffer port map (x => N1, en => viteza, y => N3);
	
end architecture;