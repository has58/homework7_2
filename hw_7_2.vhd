Library IEEE;
Use IEEE.std_logic_1164.All;

Entity smoother is
  port( c_in : in std_logic;
        c_out : out std_logic);
  end Entity;

Architecture smoother_arch of smoother is
	-- array with index data type std_logic
	-- std_index_array ('U', 'X','0','1','Z','W','L','H','-')
	type std_index_array is array(std_logic) of integer;
	-- this is a constant to resent the array after 100ns
	constant reset_array: std_index_array :=(0,0,0,0,0,0,0,0,0);
	-- internal array to store frequency of the charecter
	signal main_array : std_index_array := reset_array;
	-- funtion to find the most occured charecter
	function max (signal array_max  : in std_index_array)
    		return std_logic is
    		variable biggest: std_logic := '0';
    		begin
			for i in std_index_array'range  loop
          			if (array_max(biggest) < array_max(i)) then
            				biggest :=i;
          			end if;
        		end loop;
        		return biggest;
     		end max;
	-- procedure to update the array
	procedure counter(signal main_array : inout std_index_array;
                        			signal input : in std_logic) is
					begin
						main_array(input) <= main_array(input)+1;
					end counter;
	-- internal clock
	signal clk : bit :='0';
	begin
	internal_clock:	process
				begin
			  		clk <= NOT clk;
				wait for 100ns;
				end process internal_clock;
	process(clk, c_in)
		begin
			if (clk'event) then
				-- update the result
				-- this function check which character have highest frequency and return that charecter
				c_out <= max(main_array);
				main_array <= reset_array;
			end if;
			if (c_in'event) then
				--update the array
				counter(main_array, c_in);

			end if;
		end process;
	end smoother_arch;
