-----------//////////////////////////////////////////////////--------------------
----------//////////�����ˣ����Ľ� 20060122//////////////////--------------------
----------//////////���ܣ�����CRC32/////////////////////////--------------------
----------//////////˵�����̫��CRCʹ�ù���˵��
-----------//////////////////////////////////////////////////--------------------	



	library IEEE;
	use IEEE.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.std_logic_arith.all;

    entity crc32ByteLanAAL5 is
         port ( reset,crcEn        : in std_logic ; 
                clk                 : in std_logic ;
				data 				: in  std_logic_vector(7 downto 0);
				dataCrcOut0			: out std_logic_vector(7 downto 0);
				dataCrcOut1			: out std_logic_vector(7 downto 0);
				dataCrcOut2			: out std_logic_vector(7 downto 0);
				dataCrcOut3			: out std_logic_vector(7 downto 0);
				dataCrc           : out std_logic_vector(31 downto 0);
				crcCheckOk			: out std_logic
                                
               );
    end ;

    architecture CRC32_arc of crc32ByteLanAAL5 is

		signal dataCrcBuff 			:  std_logic_vector(31 downto 0);
		signal dataIn					: std_logic_vector(7 downto 0);
		signal crcOk			:  std_logic;
  begin

-----------------crcOK is dataCrcOut0=X"1C"-----
-----------------crcOK is dataCrcOut1=X"DF"-----
-----------------crcOK is dataCrcOut2=X"44"-----
-----------------crcOK is dataCrcOut3=X"21"-----
		-------------data out is X"C704DD7B"=
		dataIn(7)<=data(7);
		dataIn(6)<=data(6);
		dataIn(5)<=data(5);
		dataIn(4)<=data(4);
		dataIn(3)<=data(3);
		dataIn(2)<=data(2);
		dataIn(1)<=data(1);
		dataIn(0)<=data(0);
		dataCrcOut0(7)<=dataCrcBuff(31) xor'1';
		dataCrcOut0(6)<=dataCrcBuff(30) xor'1';
		dataCrcOut0(5)<=dataCrcBuff(29) xor'1';
		dataCrcOut0(4)<=dataCrcBuff(28) xor'1';
		dataCrcOut0(3)<=dataCrcBuff(27) xor'1';
		dataCrcOut0(2)<=dataCrcBuff(26) xor'1';
		dataCrcOut0(1)<=dataCrcBuff(25) xor'1';
		dataCrcOut0(0)<=dataCrcBuff(24) xor'1';

		dataCrcOut1(7)<=dataCrcBuff(23) xor'1';
		dataCrcOut1(6)<=dataCrcBuff(22) xor'1';
		dataCrcOut1(5)<=dataCrcBuff(21) xor'1';
		dataCrcOut1(4)<=dataCrcBuff(20) xor'1';
		dataCrcOut1(3)<=dataCrcBuff(19) xor'1';
		dataCrcOut1(2)<=dataCrcBuff(18) xor'1';
		dataCrcOut1(1)<=dataCrcBuff(17) xor'1';
		dataCrcOut1(0)<=dataCrcBuff(16) xor'1';


		dataCrcOut2(7)<=dataCrcBuff(15) xor'1';
		dataCrcOut2(6)<=dataCrcBuff(14) xor'1';
		dataCrcOut2(5)<=dataCrcBuff(13) xor'1';
		dataCrcOut2(4)<=dataCrcBuff(12) xor'1';
		dataCrcOut2(3)<=dataCrcBuff(11) xor'1';
		dataCrcOut2(2)<=dataCrcBuff(10) xor'1';
		dataCrcOut2(1)<=dataCrcBuff(9) xor'1';
		dataCrcOut2(0)<=dataCrcBuff(8) xor'1';

		dataCrcOut3(7)<=dataCrcBuff(7) xor'1';
		dataCrcOut3(6)<=dataCrcBuff(6) xor'1';
		dataCrcOut3(5)<=dataCrcBuff(5) xor'1';
		dataCrcOut3(4)<=dataCrcBuff(4) xor'1';
		dataCrcOut3(3)<=dataCrcBuff(3) xor'1';
		dataCrcOut3(2)<=dataCrcBuff(2) xor'1';
		dataCrcOut3(1)<=dataCrcBuff(1) xor'1';
		dataCrcOut3(0)<=dataCrcBuff(0) xor'1';
      dataCrc<= dataCrcBuff;
		crcCheckOk<=crcOk;
		
        process (reset, clk)
        begin
			if reset='0' then
				dataCrcBuff<=(others=>'1');
				crcOk<='0';
			elsif rising_edge(clk) then
				if crcEn='0'  then
					if  dataCrcBuff=X"C704DD7B" then
						crcOk<='1';
					else
						crcOk<='0';
					end if;
				else
					
					crcOk<=crcOk;
				end if;
				
				
			  if crcEn='1' then
		-------------X32+X26+X23+X22+X16+X12+X11+X10+X8+X7+X5+X4+X2+X+1-----------------------------
                dataCrcBuff(0)<= dataIn(6) xor dataIn(0) xor dataCrcBuff(24) xor dataCrcBuff(30);
  				dataCrcBuff(1) <= dataIn(7) xor dataIn(6) xor dataIn(1) xor dataIn(0) xor dataCrcBuff(24) 
								    xor dataCrcBuff(25) xor  dataCrcBuff(30) xor dataCrcBuff(31);
			    dataCrcBuff(2) <= dataIn(7) xor dataIn(6) xor dataIn(2) xor dataIn(1) xor dataIn(0) 
									xor dataCrcBuff(24) xor dataCrcBuff(25) xor dataCrcBuff(26) xor dataCrcBuff(30) xor dataCrcBuff(31);
				dataCrcBuff(3) <= dataIn(7) xor dataIn(3) xor dataIn(2) xor dataIn(1) 
									xor dataCrcBuff(25) xor dataCrcBuff(26) xor dataCrcBuff(27) xor dataCrcBuff(31);
	   			dataCrcBuff(4) <= dataIn(6) xor dataIn(4) xor dataIn(3) xor dataIn(2) xor dataIn(0) 
									xor dataCrcBuff(24) xor  dataCrcBuff(26) xor dataCrcBuff(27) xor dataCrcBuff(28) xor dataCrcBuff(30);
    			dataCrcBuff(5) <= dataIn(7) xor dataIn(6) xor dataIn(5) xor dataIn(4) xor dataIn(3) xor dataIn(1) xor  dataIn(0) 
									xor dataCrcBuff(24) xor dataCrcBuff(25) xor dataCrcBuff(27) xor dataCrcBuff(28) xor dataCrcBuff(29) 
									xor dataCrcBuff(30) xor dataCrcBuff(31);
	    		dataCrcBuff(6) <= dataIn(7) xor dataIn(6) xor dataIn(5) xor dataIn(4) xor dataIn(2) xor dataIn(1) xor 
                 					dataCrcBuff(25) xor dataCrcBuff(26) xor dataCrcBuff(28) xor 
									dataCrcBuff(29) xor dataCrcBuff(30) xor dataCrcBuff(31);
			    dataCrcBuff(7) <= dataIn(7) xor dataIn(5) xor dataIn(3) xor dataIn(2) xor dataIn(0) xor dataCrcBuff(24) xor 
                 					dataCrcBuff(26) xor dataCrcBuff(27) xor dataCrcBuff(29) xor dataCrcBuff(31);
			    dataCrcBuff(8) <= dataIn(4) xor dataIn(3) xor dataIn(1) xor dataIn(0) xor dataCrcBuff(0) xor dataCrcBuff(24) xor 
             					    dataCrcBuff(25) xor dataCrcBuff(27) xor dataCrcBuff(28);
			    dataCrcBuff(9) <= dataIn(5) xor dataIn(4) xor dataIn(2) xor dataIn(1) xor dataCrcBuff(1) xor dataCrcBuff(25) xor 
            					   dataCrcBuff(26) xor dataCrcBuff(28) xor dataCrcBuff(29);
			    dataCrcBuff(10) <= dataIn(5) xor dataIn(3) xor dataIn(2) xor dataIn(0) xor dataCrcBuff(2) xor dataCrcBuff(24) xor 
            				      	dataCrcBuff(26) xor dataCrcBuff(27) xor dataCrcBuff(29);
			    dataCrcBuff(11) <= dataIn(4) xor dataIn(3) xor dataIn(1) xor dataIn(0) xor dataCrcBuff(3) xor dataCrcBuff(24) xor 
              					    dataCrcBuff(25) xor dataCrcBuff(27) xor dataCrcBuff(28);
			    dataCrcBuff(12) <= dataIn(6) xor dataIn(5) xor dataIn(4) xor dataIn(2) xor dataIn(1) xor dataIn(0) xor 
            					    dataCrcBuff(4) xor dataCrcBuff(24) xor dataCrcBuff(25) xor dataCrcBuff(26) xor 
									dataCrcBuff(28) xor dataCrcBuff(29) xor dataCrcBuff(30);
			    dataCrcBuff(13) <= dataIn(7) xor dataIn(6) xor dataIn(5) xor dataIn(3) xor dataIn(2) xor dataIn(1) xor 
        							dataCrcBuff(5) xor dataCrcBuff(25) xor dataCrcBuff(26) xor dataCrcBuff(27) xor 
									dataCrcBuff(29) xor dataCrcBuff(30) xor dataCrcBuff(31);
    			dataCrcBuff(14) <= dataIn(7) xor dataIn(6) xor dataIn(4) xor dataIn(3) xor dataIn(2) xor dataCrcBuff(6) xor 
                					dataCrcBuff(26) xor dataCrcBuff(27) xor dataCrcBuff(28) xor dataCrcBuff(30) xor dataCrcBuff(31);
			    dataCrcBuff(15) <= dataIn(7) xor dataIn(5) xor dataIn(4) xor dataIn(3) xor dataCrcBuff(7) xor dataCrcBuff(27) xor 
                  					dataCrcBuff(28) xor dataCrcBuff(29) xor dataCrcBuff(31);
				dataCrcBuff(16) <= dataIn(5) xor dataIn(4) xor dataIn(0) xor dataCrcBuff(8) xor dataCrcBuff(24) xor dataCrcBuff(28) xor 
                					dataCrcBuff(29);
				dataCrcBuff(17) <= dataIn(6) xor dataIn(5) xor dataIn(1) xor dataCrcBuff(9) xor dataCrcBuff(25) xor dataCrcBuff(29) xor 
                 					dataCrcBuff(30);
				dataCrcBuff(18) <= dataIn(7) xor dataIn(6) xor dataIn(2) xor dataCrcBuff(10) xor dataCrcBuff(26) xor dataCrcBuff(30) xor 
                 					 dataCrcBuff(31);
			    dataCrcBuff(19) <= dataIn(7) xor dataIn(3) xor dataCrcBuff(11) xor dataCrcBuff(27) xor dataCrcBuff(31);
			    dataCrcBuff(20) <= dataIn(4) xor dataCrcBuff(12) xor dataCrcBuff(28);
			    dataCrcBuff(21) <= dataIn(5) xor dataCrcBuff(13) xor dataCrcBuff(29);
			    dataCrcBuff(22) <= dataIn(0) xor dataCrcBuff(14) xor dataCrcBuff(24);
			    dataCrcBuff(23) <= dataIn(6) xor dataIn(1) xor dataIn(0) xor dataCrcBuff(15) xor dataCrcBuff(24) xor dataCrcBuff(25) xor 
            				        dataCrcBuff(30);
			    dataCrcBuff(24) <= dataIn(7) xor dataIn(2) xor dataIn(1) xor dataCrcBuff(16) xor dataCrcBuff(25) xor dataCrcBuff(26) xor 
            				       dataCrcBuff(31);
			    dataCrcBuff(25) <= dataIn(3) xor dataIn(2) xor dataCrcBuff(17) xor dataCrcBuff(26) xor dataCrcBuff(27);
			    dataCrcBuff(26) <= dataIn(6) xor dataIn(4) xor dataIn(3) xor dataIn(0) xor dataCrcBuff(18) xor dataCrcBuff(24) xor 
					                dataCrcBuff(27) xor dataCrcBuff(28) xor dataCrcBuff(30);
			    dataCrcBuff(27) <= dataIn(7) xor dataIn(5) xor dataIn(4) xor dataIn(1) xor dataCrcBuff(19) xor dataCrcBuff(25) xor 
					                dataCrcBuff(28) xor dataCrcBuff(29) xor dataCrcBuff(31);
			    dataCrcBuff(28) <= dataIn(6) xor dataIn(5) xor dataIn(2) xor dataCrcBuff(20) xor dataCrcBuff(26) xor dataCrcBuff(29) xor 
            		    		     dataCrcBuff(30);
			    dataCrcBuff(29) <= dataIn(7) xor dataIn(6) xor dataIn(3) xor dataCrcBuff(21) xor dataCrcBuff(27) xor dataCrcBuff(30) xor 
				                    dataCrcBuff(31);
			    dataCrcBuff(30) <= dataIn(7) xor dataIn(4) xor dataCrcBuff(22) xor dataCrcBuff(28) xor dataCrcBuff(31);
			    dataCrcBuff(31) <= dataIn(5) xor dataCrcBuff(23) xor dataCrcBuff(29);

-------------X32+X26+X23+X22+X16+X12+X11+X10+X8+X7+X5+X4+X2+X+1-----------------------------
				else
					dataCrcBuff<=dataCrcBuff;
				end if;
            end if;
       end process;    


     end CRC32_ARC;

