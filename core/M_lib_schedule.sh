#!/bin/bash
# simple_scheduler.sh - Include this file in your main script

# Set your schedule times here
ONCE_DAILY="03:30"
TWICE_DAILY=("10:15" "15:45")
THRICE_DAILY=("08:00" "12:30" "21:45")

# Get current time
CURRENT_TIME=$(date +%H:%M)

# Function to run script at once daily time
run_once_daily() {
    local script_path="$1"
    
    if [[ "$CURRENT_TIME" == "$ONCE_DAILY" ]]; then
        if [ -x "$script_path" ]; then
            echo "Executing once-daily script: $script_path"
            "$script_path"
        fi
        return 0
    fi
    return 1
}

# Function to run script at twice daily times
run_twice_daily() {
    local script_path="$1"
    
    for time in "${TWICE_DAILY[@]}"; do
        if [[ "$CURRENT_TIME" == "$time" ]]; then
            if [ -x "$script_path" ]; then
                echo "Executing twice-daily script: $script_path"
                "$script_path"
            fi
            return 0
        fi
    done
    
    return 1
}

# Function to run script at thrice daily times
run_thrice_daily() {
    local script_path="$1"
    
    for time in "${THRICE_DAILY[@]}"; do
        if [[ "$CURRENT_TIME" == "$time" ]]; then
            if [ -x "$script_path" ]; then
                echo "Executing thrice-daily script: $script_path"
                "$script_path"
            fi
            return 0
        fi
    done
    
    return 1
}

# Function to check if current time is an exception time
is_exception_time() {
    if [[ "$CURRENT_TIME" == "$ONCE_DAILY" ]]; then
        return 0
    fi
    
    for time in "${TWICE_DAILY[@]}"; do
        if [[ "$CURRENT_TIME" == "$time" ]]; then
            return 0
        fi
    done
    
    for time in "${THRICE_DAILY[@]}"; do
        if [[ "$CURRENT_TIME" == "$time" ]]; then
            return 0
        fi
    done
    
    return 1
}

# Function to run default script (when no exceptions apply)
run_default() {
    local script_path="$1"
    
    # Check if any exception applies
    if is_exception_time; then
        # Exception time, don't run default
        return 1
    fi
    
    # No exceptions, run default script
    if [ -x "$script_path" ]; then
        echo "Executing default script: $script_path"
        "$script_path"
    fi
    return 0
}

# Example usage (in your main script):
# source /path/to/simple_scheduler.sh
# 
# # Can call multiple scripts with the same schedule
# run_once_daily "/path/to/backup.sh"
# run_once_daily "/path/to/cleanup.sh"
# 
# run_twice_daily "/path/to/report1.sh"
# run_twice_daily "/path/to/report2.sh"
# 
# run_thrice_daily "/path/to/monitor.sh"
# 
# run_default "/path/to/default.sh"
