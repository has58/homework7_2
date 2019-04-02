-- Author: Haider Ali Siddiquee
-- date : 4/2/2019
-- time 12:15
-- Hw7.vhd
-- To calculate 1. Most frequent input character in every 100ns
--              2. highest occurred input character with respect to time
Library IEEE;
Use IEEE.std_logic_1164.All;

Entity smoother is
  port( c_in : in std_logic;
        c_out : out std_logic);
  end Entity;

-- Architecture to calculate number of time input character come in every 100ns
Architecture smoother_arch of smoother is
	-- array with index data type std_logic
	-- std_index_array ('U', 'X','0','1','Z','W','L','H','-')
	type std_index_array is array(std_logic) of integer;
	-- this is a constant to resent the array after 100ns
	constant reset_array: std_index_array :=(0,0,0,0,0,0,0,0,0);
	-- internal array to store frequency of the charecter
	signal main_array : std_index_array := reset_array;
	-- funtion to find the most occured charecter
	--constant first_time : time := 0ns;
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
					wait for 100ns;
			  		clk <= NOT clk;
				
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

-- Architecture to calculate longest time occurred input character come in every 100ns
Architecture smoother_arch_time of smoother is

	-- array with index data type std_logic
	-- std_index_array ('U', 'X','0','1','Z','W','L','H','-')
	type std_index_array is array(std_logic) of time;
	-- this is a constant to resent the array after 100ns
	constant reset_array: std_index_array :=(0ns,0ns,0ns,0ns,0ns,0ns,0ns,0ns,0ns);
	-- internal array to store frequency of the charecter
	signal main_array : std_index_array := reset_array;
	-- funtion to find the longest occured charecter
	function max (signal array_max  : in std_index_array)
    		return std_logic is
    		variable biggest: std_logic := '0';
    		begin
			for i in std_index_array'range  loop
          			if ((array_max(biggest) < array_max(i)) or (array_max(biggest) = array_max(i))) then
            				biggest :=i;
          			end if;
        		end loop;
        		return biggest;
     		end max;
	-- procedure to update the array
	procedure counter(signal main_array : inout std_index_array;
				variable last_time: inout time;
                        			signal input : in std_logic) is
					begin
						main_array(input'last_value) <= main_array(input'last_value) + (now-last_time);
						last_time := now;
					end counter;
	-- internal clock
	signal clk : bit :='0';
	begin
		clk_p2: process
				begin
				clk <= NOT(clk);
				wait for 100ns;
				end process clk_p2;
		main_p2: process(clk, c_in)
			-- to trach time for the last character
			variable last_time : time :=0ns;
				begin
					if (clk'event) then
						--give the output
						c_out <= max(main_array);
					end if;
					if (c_in'event) then
						--calculate the time
						--update the array
						counter (main_array, last_time,c_in);
					end if;
				end process main_p2;
	end smoother_arch_time;
