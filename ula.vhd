library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;

------------------------ ULA ----------------------------------
--                                                             -
-- Esse módulo implementa a Unidade Lógica Aritmética.         -
--                                                             -
-- Entradas:                                                   -
--   a (32 bits): operando 1 (vem do regfile)                  -
--   b (32 bits): operando 2 (vem do refile ou imm ext)        -
--   alucontrol (3 bits): sinais de controle (vem do controler)-
-- Saída:                                                      -
--   result (32 bits): resultado da operação.                  -
--   zero (1 bit): sinaliza 1 quando a saída é zero.           -
--                                                             -
-- Para mais detalhes, ver seção 7.3.1 e 7.32 do livro indicado-
---------------------------------------------------------------

-- Não altere esse modulo! ele ja foi testado e 
-- funciona corretamente. Apenas estude-o.


entity ula is 
  port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
       result:     buffer STD_LOGIC_VECTOR(31 downto 0);
       zero:       out STD_LOGIC);
end;

architecture synth of ula is
  signal aluextended, condinvb, sum: STD_LOGIC_VECTOR(31 downto 0);
begin
  condinvb <= not b when alucontrol(2) = '1' else b;
  aluextended <= x"00000001" when alucontrol(2) = '1' else x"00000000";
  sum <= std_logic_vector(unsigned(a) + unsigned(condinvb) + unsigned(aluextended));

  process(all) begin
    case alucontrol(1 downto 0) is
      when "00"   => result <= a and b; 
      when "01"   => result <= a or b; 
      when "10"   => result <= sum; 
      when "11"   => result <= (0 => sum(31), others => '0');  -- set less than
      when others => result <= (others => 'X'); 
    end case;
  end process;

  zero <= '1' when result = X"00000000" else '0';
end;