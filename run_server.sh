#!/usr/bin/expect

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
        puts "Service is running. Sleeping."
        sleep 120
        send "stop\n"
        puts "stop Command sent."
        break
    } else {
        # If not running, wait and retry
        puts "Attempt $attempt: Service not running. Retrying..."
        incr attempt
        sleep 10
    }
}

# If the max attempts are reached without success
if {$attempt > $max_attempts} {
    puts "Error: Service did not start after $max_attempts attempts."
}

# Interact with the process if needed
interact