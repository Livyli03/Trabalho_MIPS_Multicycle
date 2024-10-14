library IEEE;  
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;

entity memory is 
  port(clk, we, IorD:  in STD_LOGIC;
       addr:     in STD_LOGIC_VECTOR(31 downto 0);
       wd:       in STD_LOGIC_VECTOR(31 downto 0);
       rd:       out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture synth of memory is
   -- Array de instruções (64 palavras de 32 bits)
   type ram_type1 is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
   signal mem1: ram_type1 := (
		    0 => x"20020005",  -- Instrução 1
              1 => x"2003000c",  -- Instrução 2
              2 => x"2067fff7",  -- Instrução 3
              3 => x"00e22025",  -- Instrução 4
              4 => x"00642824",  -- Instrução 5
              5 => x"00a42820",  -- Instrução 6
              6 => x"10a7000a",  -- Instrução 7
              7 => x"0064202a",  -- Instrução 8
              8 => x"10800001",  -- Instrução 9
              9 => x"20050000",  -- Instrução 10
              10 => x"00e2202a", -- Instrução 11
              11 => x"00853820", -- Instrução 12
              12 => x"00e23822", -- Instrução 13
              13 => x"ac670044", -- Instrução 14
              14 => x"8c020050", -- Instrução 15
              15 => x"08000011", -- Instrução 16
              16 => x"20020001", -- Instrução 17
              17 => x"ac020054", -- Instrução 18
              others => (others => '0') -- Inicializa o restante com zeros
   );

   -- Array de memória
   type ram_type2 is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
   signal mem2: ram_type2 := (others => (others => '0')); -- inicializada com zeros
   
begin
   process(clk, we, IorD, addr, wd) 
   begin
        -- Se IorD = '0' é leitura de instruções
        if(we = '0' and IorD = '0') then
             rd <= mem1(to_integer(unsigned(addr)));
        -- Se IorD = '1' é leitura de dados
        elsif(we = '0' and IorD = '1') then
             rd <= mem2(to_integer(unsigned(addr(7 downto 2))));
        -- Se IorD = '1' e we = '1' é escrita de dados
        elsif(we = '1' and rising_edge(clk) and IorD = '1') then
             -- Endereços de palavras avançam de 4 em 4. Por isso, se
             -- desconsidera os 2 bits menos significativos do endereço
             mem2(to_integer(unsigned(addr(7 downto 2)))) <= wd;
        end if;
   end process;
end synth;
