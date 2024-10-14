library IEEE; 
use IEEE.STD_LOGIC_1164.all;

--------- aludec (decoficador para ULA) -------------------
--                                                         -
-- Esse módulo implementa a parte da unidade de controle   -
-- responsável por gerar os sinais de controle para a ula. -
--                                                         -
-- Entradas:                                               -
--   funct (6 bits): campo funct de instruções tipo-R.     -
--   aluop (2 bits): código gerado pelo main decoder.      -
-- Saidas:                                                 -
--   alucontrol (3 bits): sinais de controle para uma.     -
-- Para mais detalhes, ver seção 7.3.2 do livro indicado,  -
-- especialmente a figura 7.12 e tabelas 7.1, 7.2 e 7.3.   -
-----------------------------------------------------------

-- Nao altere esse modulo! ele ja foi testado e 
-- funciona corretamente. Apeas estude-o.



entity aludec is 
  port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
       aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
       alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
end;

architecture behave of aludec is
begin
  --veja tabelas 7.1, 7.2 e 7.3 do livro para entender os sinais gerados
  process(all) begin
    case aluop is
      when "00" => alucontrol <= "010"; -- add (for lw/sw/addi)
      when "01" => alucontrol <= "110"; -- sub (for beq)
      when others => case funct is      -- R-type instructions
                         when "100000" => alucontrol <= "010"; -- add 
                         when "100010" => alucontrol <= "110"; -- sub
                         when "100100" => alucontrol <= "000"; -- and
                         when "100101" => alucontrol <= "001"; -- or
                         when "101010" => alucontrol <= "111"; -- slt
                         when others   => alucontrol <= "---"; -- ???
                     end case;
    end case;
  end process;
end;
