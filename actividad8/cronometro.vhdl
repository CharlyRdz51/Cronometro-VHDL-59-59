  --Aguilar Rodriguez Carlos Adolfo 
  --Circuitos Digitales 
  --Cronometro 0 - 59:59
  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
  -- Entidad
   entity cronometro is 
	port(  rlj,rst,ctrl           :in  std_logic;
       dseg  :out std_logic_vector(2 downto 0);
       useg  :out std_logic_vector(3 downto 0);    
	   dmin  :out std_logic_vector(2 downto 0);
       umin  :out std_logic_vector(3 downto 0));  
		end cronometro;
  --Arquitectura
  architecture arq1 of cronometro is 
      type estados is (paro,conteo,pausa);
      signal maquina : estados;
      signal memuseg : std_logic_vector(3 downto 0);
      signal memdseg : std_logic_vector(2 downto 0); 
      signal memumin : std_logic_vector(3 downto 0);
      signal memdmin : std_logic_vector(2 downto 0);  
  begin 
      unidad_segundos:process (rlj,rst,ctrl)
      begin
      
     if (rlj'event and rlj='1') then
      if (rst='1') then
		maquina<=paro;
		memuseg<= 0;
		
		else 
		case maquina is 
		when  paro =>
		     --memoria
		      memuseg <= 0;
			 --siguiente estado 
			 if(ctrl='1')then
			 maquina<=conteo;
			 end if;
		when  conteo =>
		     --memoria
		     if (memuseg=9) then 
		      memuseg<=0;
		     else
		     memuseg <= memuseg+'1';
			 end if;
			 --siguiente estado 
			 if(ctrl='1')then
			 maquina<=pausa;
			 end if;        
		when pausa =>
		     --memoria
		      memuseg <= memuseg;
			 --siguiente estado 
			 if(ctrl='1')then
			 maquina<=conteo;
			 end if; 
			              
	end case;
	end if;
	end if;
	end process;
	
	decenas_segundos: process(rlj,rst,memuseg)
	begin
	 if(rlj'event and rlj='1')then
	 if (rst='1') then
	 memdseg <= 0;
	 else
	   if (memuseg = 9) then
	       if (memdseg = 5) then
	           memdseg <= 0;
	           else
	       memdseg <= memdseg+'1';
	       end if;
		   end if;
	       end if;
		   end if;
	end process;

		unidades_minutos: process(rlj,rst,memdseg)
	begin
	 if(rlj'event and rlj='1')then
	 if (rst='1') then
	 memumin <= 0;
	 else
	   if ((memdseg = 5) AND (memuseg = 9))then
	       if (memumin = 9) then
	           memumin <= 0;
	           else
	       memumin <= memumin+'1';
	       end if;
		   end if;
	       end if;
		   end if;
	end process;

	decenas_minutos: process(rlj,rst,memumin)
	begin
	 if(rlj'event and rlj='1')then
	 if (rst='1') then
	 memdmin <= 0;
	 else
	   if ((memumin = 9) AND (memdseg = 5) AND (memuseg = 9)) then
	       if (memdmin = 5) then
	           memdmin <= 0;
	           else
	       memdmin <= memdmin+'1';
	       end if;
		   end if;
	       end if;
		   end if;
	end process;
	
	

  useg <= memuseg;
  dseg <= memdseg;
  umin <= memumin;
  dmin <= memdmin;
  end arq1;
