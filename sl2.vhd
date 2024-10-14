library IEEE; 
use IEEE.STD_LOGIC_1164.all;

-- desloca dois bits para a esquerda o sinal de 
-- entrada de 32 (equivale a multiplicar por 4).
-- usado na lógica do datapath para calcular o
-- endereço de desvio de instruções beq.

-- Não altere esse módulo, ele ja foi testado e 
-- funciona corretamente. Apenas estude-o.

entity sl2 is
  port(a: in  STD_LOGIC_VECTOR(31 downto 0);
       y: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture synth of sl2 is
begin
  y <= a(29 downto 0) & "00";
end;