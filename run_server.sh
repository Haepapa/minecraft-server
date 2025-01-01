#!/usr/bin/expect

# Retrieve the first argument
set action [lindex $argv 0]

# Load the .env file and export variables to the current script
set env_file "./.env"
array set env {}

if {[file exists $env_file]} {
    set file_id [open $env_file r]
    while {[gets $file_id line] >= 0} {
        # Skip comments and empty lines
        if {[string match "#*" $line] || [string trim $line] == ""} {
            continue
        }
        # Split the line into key and value
        set key_value [split $line "="]
        set key [lindex $key_value 0]
        set value [lindex $key_value 1]
        set env($key) $value
    }
    close $file_id
} else {
    puts "Error: .env file not found."
    exit 1
}

# Max attempts
set max_attempts 21
set attempt 1

# Start the process (replace with your actual command)
spawn java -Xms4G -Xmx4G -jar /minecraft/paper.jar --nogui

# Retry logic in a while loop
while {$attempt <= $max_attempts} {
    # Check if service is running on port 25565 using a shell command
    set result [exec sh -c "netstat -tuln | grep -q ':25565' && echo 'running' || echo 'not running'"]

    if {$result eq "running"} {
        # If the service is running, send the command to the process
        puts "Service is running on port 25565. Sleeping..."
        sleep 30

        if {$action eq "wl"} {
            # Turn on whitelist and add users
	        send "whitelist on\n"

            # Java users
            set wlj $env(WHITELIST_JAVA)
            set wlj_list [split $wlj ","]
            foreach usr $wlj_list {

                puts "Adding user $usr to whitelist."
                send "whitelist add $usr\n"
                sleep 5
            }

            # Bedrock users
            set wlb $env(WHITELIST_BEDROCK)
            set wlb_list [split $wlb ","]
            foreach usr $wlb_list {
                puts "Adding user $usr to fwhitelist."
                send "fwhitelist add $usr\n"
                sleep 5
            }
        }

        send "stop\n"
        puts "'stop' Command sent."
        break
    } else {
        # If not running, wait and retry
        puts "Attempt $attempt: Service not running. Retrying..."
        incr attempt
        sleep 5
    }
}

# If the max attempts are reached without success
if {$attempt > $max_attempts} {
    puts "Error: Service did not start after $max_attempts attempts."
}

# Interact with the process if needed
interact