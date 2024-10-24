library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--------------------- máquina de estado finito -------------------------
--                                                          -
-- Esse módulo implementa o decodificador principal, que    - 
-- é controlado por uma máquina de estado finito e controla -
-- o datapath e dois sinais para para o módulo aludec       -
--                                                          -
--                                                          -
-- Entradas:                                                -
--   op (6 bits): opcode da instrução.                      -
--   clk: clock.                                            -
-- Saidas:                                                  -
--   op, regdst, memtoreg, regwrite, memwrite, branch       -
--   pcwrite, iord, irwrite, aluop, pcsrc, alusrcA, alusrcB -
--   são sinais que controlam o datapath;                   -
--   aluop alimenta o módulo aludec.                        -
------------------------------------------------------------------------


entity fsm is
    Port ( op 				: in  STD_LOGIC_VECTOR (5 downto 0);
           clk 			    : in  STD_LOGIC;
           regdst 		    : out  STD_LOGIC;
           memtoreg 		: out  STD_LOGIC;
           regwrite 		: out  STD_LOGIC;
           memwrite 		: out  STD_LOGIC;
		   branch	        : out  STD_LOGIC;
		   pcwrite		    : out  STD_LOGIC;
		   IorD			    : out  STD_LOGIC;
		   irwrite		    : out  STD_LOGIC;
           pcsrc		    : out  STD_LOGIC;
           alusrcA 		    : out  STD_LOGIC;
           alusrcB		    : out  STD_LOGIC_VECTOR (1 downto 0);
		   aluop 			: out  STD_LOGIC_VECTOR (1 downto 0));
end fsm;

architecture synth of fsm is

signal estado : STD_LOGIC_VECTOR(3 downto 0);
 
begin
 
process(op, estado, clk)
 
begin
 
if rising_edge(clk) then
        if estado = "0000" then
        estado <= "0001";
        elsif estado = "0001" then
            --if lw ou sw
            if op = "100011" or op = "101011" then
            estado <= "0010";
            --if Tipo-R
            elsif op = "000000" then
            estado <= "0110";
            --if beq
            elsif op = "000100" then
            estado <= "1000";
            --if addi
            elsif op = "001000" then
            estado <= "1001";
            --if jump
            elsif op = "000010" then
            estado <= "1011";
            end if;
        elsif estado = "0010" then
            --if lw
            if op = "100011" then
            estado <= "0011";
            else
            estado <= "0101";
            end if;
        elsif estado = "1001" then
            estado <= "1010";
        elsif estado = "1010" then
            estado <= "0000";
        elsif estado = "1011" then
            estado <= "0000";
        elsif estado = "0011" then
            estado <= "0100";
        elsif estado = "0100" then
            estado <= "0000";
        elsif estado = "0101" then
            estado <= "0000";
        elsif estado = "0110" then
            estado <= "0111";
        elsif estado = "0111" then
            estado <= "0000";
        elsif estado = "1000" then
            estado <="0000";
        end if;
end if;
--fetch de instrução
if estado = "0000" then
        pcwrite <= '1';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '1';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "01";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
	--fetch de decodificação/registro
    elsif estado = "0001" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "11";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
	--lw/sw executar
    elsif estado = "0010" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "10";
        alusrcA <='1';
        regwrite <='0';
        regdst <= '0';
	--lw acesso de memória
    elsif estado = "0011" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '1';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
	--lw write back
    elsif estado = "0100" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='1';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='1';
        regdst <= '0';
	--sw write back
    elsif estado = "0101" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '1';
        memwrite <= '1';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
    --Tipo-R execução
    elsif estado = "0110" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="10";
        alusrcB <= "00";
        alusrcA <='1';
        regwrite <='0';
        regdst <= '0';
	--Tipo-R finalização
    elsif estado = "0111" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='1';
        regdst <= '1';
	--BEQ finalização
    elsif estado = "1000" then
        pcwrite <= '0';
        branch <= '1';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="01";
        aluop <="01";
        alusrcB <= "00";
        alusrcA <='1';
        regwrite <='0';
        regdst <= '0';
    --addi execução
    elsif estado = "1001" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "10";
        alusrcA <='1';
        regwrite <='0';
        regdst <= '0';
    --addi write back
    elsif estado = "1010" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='1';
        regdst <= '0';
    --jump
    elsif estado = "1011" then
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="10";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
end if;
end process;
 
end synth;

