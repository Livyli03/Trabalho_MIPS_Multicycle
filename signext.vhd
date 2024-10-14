library IEEE; 
use IEEE.STD_LOGIC_1164.all;

-- extende um sinal de 16 bits para 32 bits considerando o sinal
-- usado na lógica do datapath para extensão do imediato (imm) das
-- instruções tipo-I.

-- Não altere esse módulo, ele ja foi testado e 
-- funciona corretamente. Apenas estude-o.

entity signext is
  port(a: in  STD_LOGIC_VECTOR(15 downto 0);
       y: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture synth of signext is
begin
  y <= (X"ffff" & a) when a(15) = '1' else (X"0000" & a); 
end;
