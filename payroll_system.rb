# LAST NAME: SABATER
# Language: Ruby
# Paradigm(s): Object-oriented, Functional, Imperative

class WeeklyPayroll
    # Constants for day types
    WORK_DAY_TYPES = ["N", "R", "SNWH", "SNWHR", "RH", "RHR"]
    BREAK_TIME = 1 #  OUT_TIME - IN_TIME includes unpaid one continuous hour of break time 

    attr_reader :id

    # Initialize default configuration
    def initialize(id, daily_rate = 500.0, max_hours = 8, weekly_daytypes = ["N", "N", "N", "N", "N", "R", "R"], in_times = [9, 9, 9, 9, 9, 9, 9], out_times = [9, 9, 9, 9, 9, 9, 9])
        @id = id
        @daily_rate = daily_rate
        @max_hours = max_hours
        @weekly_daytypes = weekly_daytypes
        @in_times = in_times
        @out_times = out_times
    end

    # Gets the dedicated salary rate depending on the day_type
    def get_special_rate(day_type)
        hourly_rate = 1
        case day_type
        when 'N'
          hourly_rate = 1.0
        when 'R', 'SNWH'
          hourly_rate = 1.3
        when 'SNWHR'
          hourly_rate = 1.5
        when 'RH'
          hourly_rate = 2.0
        when 'RHR'
          hourly_rate = 2.6
        end
        return hourly_rate
    end
    
    # Gets the overtime rate depending on the day_type and nightshift status
    def get_overtime_rate(day_type, is_night_shift)
        overtime_rate = 1
        if (is_night_shift)
            case day_type
            when 'N'
            overtime_rate = 1.375
            when 'R', 'SNWH'
            overtime_rate = 1.859
            when 'SNWHR'
            overtime_rate = 2.145
            when 'RH'
            overtime_rate = 2.86
            when 'RHR'
            overtime_rate = 3.718
            end
        elsif (!is_night_shift)
            case day_type
            when 'N'
            overtime_rate = 1.25
            when 'R', 'SNWH'
            overtime_rate = 1.69
            when 'SNWHR'
            overtime_rate = 1.95
            when 'RH'
            overtime_rate = 2.6
            when 'RHR'
            overtime_rate = 3.38
            end
        end
        return overtime_rate
    end

    def get_daytype_desc (day_type)
        desc = ""
        case day_type
        when 'N' 
            desc = "Normal Day"
        when 'R' 
            desc = "Rest Day"
        when 'SNWH'
            desc = "SNWH"
        when 'SNWHR'
            desc = "SNWH, Rest Day"
        when 'RH'
            desc = "RH"
        when 'RHR'
            desc = "RH, Rest Day"
        end
        return desc
    end

    # Displays the main menu choices
    def display_menu
        puts "___________________________________________________"
        puts "|              WEEKLY PAYROLL SYSTEM              |"
        puts "|_________________________________________________|"
        puts "Welcome to the Weekly Payroll of Employee ##{@id}!"
        puts "\t1. Generate the Payroll"
        puts "\t2. Configure settings"
        puts "\t3. Exit"
        puts "Please enter your choice!"
    end

    # Loop that allows user to navigate through the Payroll System until they exit
    # Program terminates once the user chooses to exit
    def menu
        loop do 
            display_menu
            print ">>> "
            choice = gets.chomp.to_i
        
            case choice
            when 1 
                generate_payroll
                puts "\n"
            when 2 
                edit_configuration
                puts "\n"
            when 3
                puts "You will be redirected to the list of employees\n"
                break
            else
                puts "Invalid input! Please enter your choice again\n"
            end
        end
    end 

    # Displays current configuration with appropriate formatting
    # Initially shows default values
    def display_configuration
        puts "___________________________________________________\n"
        puts "1. DAILY RATE:\t\t#{@daily_rate}"
        puts "2. MAX HOURS PER DAY:\t#{@max_hours}"
        
        puts "3. WEEKLY DAY TYPES:"
        puts "  DAY:\t[  1  |  2  |  3  |  4  |  5  |  6  |  7  ]"
        print "  TYPES:["
        @weekly_daytypes.each_with_index do |day, idx| 
            formatted_day = day.center(5)
            print "#{formatted_day}"
            if (idx != 6) then print "|" end
        end
        puts "]"

        puts "4. IN TIMES:"
        puts "  DAY:\t[  1  |  2  |  3  |  4  |  5  |  6  |  7  ]"
        print "  TIMES:["
        @in_times.each_with_index do |time, idx| 
            formatted_time = (time.to_s + "00").rjust(4, '0').center(5) 
            print "#{formatted_time}"
            if (idx != 6) then print "|" end
        end
        puts "]"

        puts "5. OUT TIMES:"
        puts "  DAY:\t[  1  |  2  |  3  |  4  |  5  |  6  |  7  ]"
        print "  TIMES:["
        @out_times.each_with_index do |time, idx| 
            formatted_time = (time.to_s + "00").rjust(4, '0').center(5)
            print "#{formatted_time}"
            if (idx != 6) then print "|" end
        end
        puts "]"
        puts "___________________________________________________\n"
    end

    # Loop that allows user to edit the current configuration until they're satisfied
    # Will redirect user to main menu once loop breaks  
    def edit_configuration
        loop do 
            puts "___________________________________________________"
            puts "|              CURRENT CONFIGURATION              |"
            puts "|_________________________________________________|"
            display_configuration
            puts "Select the element (1-5) you would like to change"
            puts " (Press 0 to go back):"
            print ">>> "
            choice = gets.chomp.to_i
        
            case choice
            when 1  # daily rate 
                puts "Editing DAILY RATE:"
                successful = false
                until successful == true do
                    print ">>> "
                    input = gets.chomp.to_f
                    if (input > 0)
                        @daily_rate = input
                        successful = true
                    else
                        puts "Invalid Input! Please enter again"
                    end
                end
                puts "Successfully updated the DAILY RATE!"
            
            when 2  # max hours
                puts "Editing MAX HOURS (Enter a number between 8 & 24):"
                successful = false
                until successful == true do
                    print ">>> "
                    input = gets.chomp.to_i
                    if (input >= 8 && input <= 24)
                        @max_hours = input
                        successful = true
                    else
                        puts "Invalid Input! Please enter again"
                    end   
                end    
                puts "Successfully updated the MAX HOURS!"        

            when 3  # weekly day types
                puts "\n___________________________________________________"
                puts "GUIDE"
                puts " N   \tNormal Day"
                puts " R   \tRest Day"
                puts " SNWH   Special Non-Working Day"
                puts " SNWHR  Special Non-Working Day AND Rest Day"
                puts " RH   \tRegular Holiday"
                puts " RHR   \tRegular Holiday AND Rest Day"
                puts "___________________________________________________"

                puts "Editing WEEKLY DAY TYPES:"

                @weekly_daytypes.each_with_index do |day, idx|
                    successful = false
                    until successful == true do
                        print ("DAY #{idx + 1} >>> ")
                        input = gets.chomp.upcase
                        if WORK_DAY_TYPES.include?(input)
                            @weekly_daytypes[idx] = input
                            successful = true
                        else
                            puts "Invalid input! Please enter again"
                        end
                    end
                end
                puts "Successfully updated WEEKLY DAY TYPES!"
         
            when 4  # in_times
                puts "Editing IN TIMES (Enter a number between 1 & 24):"
                @in_times.each_with_index do |time, idx|
                    successful = false
                    until successful == true do
                        print ("DAY #{idx + 1} >>> ")
                        input = gets.chomp.to_i
                        if (1..24).cover?(input)
                            if (input == 24)
                                @in_times[idx] = 0 # midnight stored as 0000
                            else                             
                                @in_times[idx] = input
                            end
                            successful = true
                        else
                            puts "Invalid input! Please enter again"
                        end
                    end
                end
                puts "Successfully updated IN TIMES!"

            when 5  # out_times
                puts "Editing OUT TIMES (Enter a number between 1 & 24):"
                @out_times.each_with_index do |time, idx|
                    successful = false
                    until successful == true do
                        print ("DAY #{idx + 1} >>> ")
                        input = gets.chomp.to_i                    
                        if (1..24).cover?(input)
                            if (input == 24)
                                @out_times[idx] = 0 # midnight stored as 0000
                            else                             
                                @out_times[idx] = input
                            end
                            successful = true
                        else
                            puts "Invalid input! Please enter again"
                        end
                    end
                end
                puts "Successfully updated OUT TIMES!"

            when 0  # exit
                puts "You will be redirected to the Employee's payroll menu!\n"
                break

            else    # default invalid input message
                puts "Invalid input! Please enter your choice again\n"
            end
        end
    end

    # Generates the Employee's Payroll, enumerating Daily Salary for the 7 days,
    # as well as the Total Salary for the week
    def generate_payroll
        puts "___________________________________________________"
        puts "|            EMPLOYEE'S WEEKLY PAYROLL            |"
        puts "|_________________________________________________|"
        puts "___________________________________________________"
        puts "Weekly payroll of Employee No. #{@id}"
        weekly_salary = 0.0
        i = 0
        until i == 7
            formatted_in_time = (@in_times[i].to_s + "00").rjust(4, '0')
            formatted_out_time = (@out_times[i].to_s + "00").rjust(4, '0')

            result = compute_daily_salary(@in_times[i], @out_times[i], @weekly_daytypes[i])
            daily_salary = result[0]
            normal_overtime = result[1]
            nightshift_overtime = result[2]
            nightshift_hours = result[3]

            weekly_salary += daily_salary

            puts "                  >>> DAY #{i+1} <<<               "
            puts "IN Time: #{formatted_in_time}"
            puts "OUT Time: #{formatted_out_time}"
            puts "Day Type: #{get_daytype_desc(@weekly_daytypes[i])}"
            puts "Night Shift Hours: #{nightshift_hours}"
            puts "Hours Overtime (Night Shift Overtime): #{normal_overtime} (#{nightshift_overtime})"
            puts "Salary for the day: %.2f" % daily_salary
            puts "___________________________________________________"
            i += 1
        end

        puts "WEEKLY SALARY: %.2f" % weekly_salary
    end

    # helper function for compute_daily_salary 
    # to assist with calculating hours worked
    def adjust_out_time (out_time) 
        if (0..12).cover?(out_time)
            return out_time + 24
        end
        return out_time
    end

    # helper function for compute_daily_salary
    # Computes the amount earned per hour based on that day's configuration
    def compute_amt_per_hour (hourly_rate, is_night_shift, is_overtime, day_type)
        add_amount = 0
        if (is_overtime)
            add_amount = get_overtime_rate(day_type, is_night_shift) * hourly_rate
        elsif (is_night_shift && !is_overtime)
            add_amount = 1.1 * hourly_rate
        else
            add_amount = 1.0 * hourly_rate  # NORMAL WORKING DAY 
        end
        return add_amount  
    end

    # helper function for compute_daily_salary
    # Gets the nightshift hours of a day
    def get_nightshift_hours (start_time, hours_worked_w_break)
        temp_time = start_time
        nightshift_hours = 0
        count = hours_worked_w_break
        (count).times do   
            if (temp_time == 24)
                temp_time = 0
            end
            if (0..11).cover?(temp_time)
                if (0..6).cover?(temp_time)
                    nightshift_hours += 1
                end
            elsif (12..23).cover?(temp_time)
                if (temp_time == 22 || temp_time == 23) # increments the hr from 2200-2300
                    nightshift_hours += 1
                end
            end
            temp_time += 1
        end
        return nightshift_hours
    end

    # Computes the daily salary of an employee based on the configuration for that specific day
    def compute_daily_salary(in_time, out_time, day_type)
        # ASSUMPTIONS:
        # 1. Employees ARE NOT LATE, will always follow configured in_time
        # 2. Employees WORK >= 8 hrs, i.e >= max_hours
        # 3. Employees MAY BE ABSENT, where in_time == out_time

        hours_worked_w_break = (adjust_out_time(out_time)-in_time).abs() # gets difference
        hours_worked = hours_worked_w_break - BREAK_TIME # break time = 1hr
        overtime_hours = hours_worked - @max_hours # value guaranteed always >= 0

        # initializes variables
        nightshift_hours = 0
        normal_overtime = 0         # normal OT hours
        nightshift_overtime = 0     # nightshift OT hours
        daily_salary = 0.0
        hourly_rate = @daily_rate / @max_hours
        absent_rest_day = false
        absent_other_day = false

        # stores the variables for the diff times
        start_time = in_time
        end_time = out_time
        mid_time = start_time + @max_hours + 1

        nightshift_hours = get_nightshift_hours(start_time, hours_worked_w_break)

        # checks if current day is rest day or absent day or neither
        if (in_time == out_time && (day_type == 'R' || day_type == 'SNWHR' || day_type == 'RHR'))
            absent_rest_day = true
        elsif (in_time == out_time)
            absent_other_day = true
        end
         
        # [SCENARIO 1] IF EMPLOYEE IS ABSENT, NO SALARY
        if (absent_other_day)
            return daily_salary = 0.0, 0, 0, 0

        # [SCENARIO 2] IF EMPLOYEE IS ABSENT ON A "REST" DAY
        elsif (absent_rest_day)
            return daily_salary = @daily_rate, 0, 0, 0
        end

        # [SCENARIO 3] IF NIGHT SHIFT DIFFERENTIAL CASE, METHOD OF CALCULATION is different
        if (overtime_hours == 0 && nightshift_hours > 0)
            nsd = hourly_rate * (nightshift_hours * 1.1)
            daily_salary = @daily_rate * get_special_rate(day_type) + nsd
            return daily_salary, normal_overtime, nightshift_overtime, nightshift_hours
        end

        # [SCENARIO 4] OTHERWISE, CALCULATE THE BASE DAILY RATE NORMALLY BASED ON DAY TYPE
        daily_salary += @daily_rate * get_special_rate(day_type);

        # CALCULATE OVERTIME PAY IF THERE IS ANY
        if (overtime_hours > 0)
            additional_pay = 0
            temp_time = mid_time  # start from mid time (time after max_hours and break time)
            is_night_shift = false
            is_overtime = true

            overtime_hours.times do   
                # IF time reaches 24 (midnight), reset the clock
                if (temp_time == 24)   # must convert to military format
                    temp_time = 0       
                end
                
                # IF time is in NIGHT SHIFT RANGE, is_night_shift = true
                if (0..11).cover?(temp_time)
                    if (0..6).cover?(temp_time)
                        is_night_shift = true
                    end
                elsif (12..23).cover?(temp_time)
                    if (temp_time == 22 || temp_time == 23) # increments the hr from 2200-2300
                        is_night_shift = true
                    end
                end

                # Increments the normal and nightshift OT hours accordingly
                if (is_night_shift)
                    nightshift_overtime += 1
                else
                    normal_overtime += 1
                end
                temp_time += 1  # updates the clock

                additional_pay += compute_amt_per_hour(hourly_rate, is_night_shift, is_overtime, day_type) 
                daily_salary += compute_amt_per_hour(hourly_rate, is_night_shift, is_overtime, day_type)
            end
        end
        return daily_salary, normal_overtime, nightshift_overtime, nightshift_hours
    end
end

puts "Enter the number of employees: "
num_of_employees = gets.chomp.to_i
employees = []
i = 0
until i == num_of_employees
    employees << WeeklyPayroll.new(i+1)
    i += 1
end

puts "There are #{num_of_employees} employees in the Weekly Payroll System"

loop do 
    employees.each_with_index do |employee, idx|
        puts "- Employee ##{employee.id}"
    end
    puts "\nChoose the employee whose payroll you would like to generate"
    puts "Otherwise, enter 0 to exit"

    print ">>> "
    choice = gets.chomp.to_i

    if (choice == 0)
        puts "You have exited the program. Have a nice day!\n"
        break
    elsif (1..(num_of_employees)).cover?(choice)
        employees[choice-1].menu
        puts ""
    else
        puts "Invalid input! please enter again!\n"
    end
end

  