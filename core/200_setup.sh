#!/bin/bash

# Output file definition
CONFIG_FILE="/opt/ctrlNods/M_config.sh"

# Function to create ASCII art
create_ascii_art() {
    cat << "EOF"

   888            888 888b    888               888
         888            888 8888b   888               888
         888            888 88888b  888               888
 .d8888b 888888 888d888 888 888Y88b 888  .d88b.   .d88888 .d8888b
d88P"    888    888P"   888 888 Y88b888 d88""88b d88" 888 88K
888      888    888     888 888  Y88888 888  888 888  888 "Y8888b.
Y88b.    Y88b.  888     888 888   Y8888 Y88..88P Y88b 888      X88
 "Y8888P  "Y888 888     888 888    Y888  "Y88P"   "Y88888  88888P'


EOF
}

# Function to confirm default values
confirm_default() {
    local default_value=$1
    local var_name=$2

    read -p "Confirm default value \"$default_value\"? [Y/n]: " confirm
    if [[ -z "$confirm" || "$confirm" == [Yy]* ]]; then
        echo "$var_name=\"$default_value\"" >> "$CONFIG_FILE"
        return 0
    else
        return 1
    fi
}

# Function to validate directory path
validate_directory() {
    local path=$1
    if [[ -d "$path" ]]; then
        return 0
    else
        echo "Error: Directory does not exist. Please enter a valid path."
        return 1
    fi
}

# Function to get Cassandra cluster IPs using nodetool
get_cassandra_ips() {
    local cass_bin_path=$1
    local nodetool_path="${cass_bin_path}/nodetool"
    
    if [[ -x "$nodetool_path" ]]; then
        echo "Retrieving Cassandra cluster IP addresses..."
        # Extract IPs from nodetool status output
        # The command extracts the IP addresses from the output, 
        # looking for lines with UN (Up/Normal) status
        local cluster_ips=($("$nodetool_path" status 2>/dev/null | grep "UN" | awk '{print $2}'))
        
        if [[ ${#cluster_ips[@]} -gt 0 ]]; then
            echo "Found ${#cluster_ips[@]} node(s) in the Cassandra cluster."
            return 0
        else
            echo "No Cassandra nodes found or unable to connect to Cassandra."
            return 1
        fi
    else
        echo "nodetool command not found at ${nodetool_path}."
        return 1
    fi
}

# Create configuration file directory if it doesn't exist
mkdir -p "$(dirname "$CONFIG_FILE")"

# Initialize configuration file
echo "#!/bin/bash" > "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"
echo "# Automatically generated configuration file" >> "$CONFIG_FILE"
echo "# Date: $(date)" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"

# Display ASCII art and welcome message
clear
create_ascii_art
echo ""
echo "Welcome to the ctrlNods initialization procedure"
echo "This procedure will configure the essential parameters for system operation."
echo ""
echo "Press ENTER to continue..."
read

# Section 0b: Header
echo "" >> "$CONFIG_FILE"
echo "# ----------- Cluster and Node Data -----------" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"

# 1) dir_bin_cass (moved from point 10)
echo "------------------------------------------------------"
echo "1) Cassandra binary path"
echo "------------------------------------------------------"
DEFAULT_CASSANDRA_PATH="/opt/cass/cassandra-meta/apache-cassandra-3.11.4/bin"

if [[ -d "$DEFAULT_CASSANDRA_PATH" ]]; then
    if ! confirm_default "$DEFAULT_CASSANDRA_PATH" "dir_bin_cass"; then
        while true; do
            read -p "Enter the Cassandra binary path: " dir_bin_cass
            if validate_directory "$dir_bin_cass"; then
                echo "dir_bin_cass=\"$dir_bin_cass\"" >> "$CONFIG_FILE"
                break
            fi
        done
    else
        dir_bin_cass="$DEFAULT_CASSANDRA_PATH"
    fi
else
    echo "Default Cassandra path not found."
    while true; do
        read -p "Enter the Cassandra binary path: " dir_bin_cass
        if validate_directory "$dir_bin_cass"; then
            echo "dir_bin_cass=\"$dir_bin_cass\"" >> "$CONFIG_FILE"
            break
        fi
    done
fi
echo ""

# 2) idcluster (shifted from point 1)
echo "------------------------------------------------------"
echo "2) Cluster identification code"
echo "------------------------------------------------------"
read -p "Enter the cluster identification code: " idcluster
echo "idcluster=\"$idcluster\"" >> "$CONFIG_FILE"
echo ""

# 3) array DEST_IP (shifted from point 2)
echo "------------------------------------------------------"
echo "3) List of IP addresses of cluster nodes"
echo "------------------------------------------------------"

# Get Cassandra cluster IPs as defaults
cluster_ips=()
if get_cassandra_ips "$dir_bin_cass"; then
    cluster_ips=($("$dir_bin_cass/nodetool" status 2>/dev/null | grep "UN" | awk '{print $2}'))
    
    echo "Found the following Cassandra nodes:"
    for ip in "${cluster_ips[@]}"; do
        echo " - $ip"
    done
    
    read -p "Use these IPs as default values? [Y/n]: " use_default_ips
    if [[ -z "$use_default_ips" || "$use_default_ips" == [Yy]* ]]; then
        echo "DEST_IP=(" >> "$CONFIG_FILE"
        for ip in "${cluster_ips[@]}"; do
            echo "    \"$ip\"" >> "$CONFIG_FILE"
        done
        echo ")" >> "$CONFIG_FILE"
        echo "Cassandra node IPs set as default values."
    else
        echo "Enter the IP addresses of cluster nodes manually."
        echo "Press ENTER after each IP. Type 'done' to finish."
        echo ""
        
        echo "DEST_IP=(" >> "$CONFIG_FILE"
        while true; do
            read -p "IP (or 'done' to finish): " ip
            if [[ "$ip" == "done" ]]; then
                break
            fi
            if [[ -n "$ip" ]]; then
                echo "    \"$ip\"" >> "$CONFIG_FILE"
            fi
        done
        echo ")" >> "$CONFIG_FILE"
    fi
else
    echo "Unable to get Cassandra cluster IPs automatically."
    echo "Enter the IP addresses of cluster nodes manually."
    echo "Press ENTER after each IP. Type 'done' to finish."
    echo ""
    
    echo "DEST_IP=(" >> "$CONFIG_FILE"
    while true; do
        read -p "IP (or 'done' to finish): " ip
        if [[ "$ip" == "done" ]]; then
            break
        fi
        if [[ -n "$ip" ]]; then
            echo "    \"$ip\"" >> "$CONFIG_FILE"
        fi
    done
    echo ")" >> "$CONFIG_FILE"
fi
echo ""

# 4) array DEST_MC (shifted from point 3)
echo "------------------------------------------------------"
echo "4) List of cities for each node location"
echo "------------------------------------------------------"
echo "Enter the cities where each node is located (in the same order as the IPs)."
echo "Press ENTER after each city. Type 'done' to finish."
echo ""

echo "DEST_MC=(" >> "$CONFIG_FILE"
while true; do
    read -p "City (or 'done' to finish): " city
    if [[ "$city" == "done" ]]; then
        break
    fi
    if [[ -n "$city" ]]; then
        echo "    \"$city\"" >> "$CONFIG_FILE"
    fi
done
echo ")" >> "$CONFIG_FILE"
echo ""

# 5) FROM_IP (shifted from point 4)
echo "------------------------------------------------------"
echo "5) IP address of this node"
echo "------------------------------------------------------"
# Try to get local IP as default
local_ip=$(hostname -I | awk '{print $1}')
if [[ -n "$local_ip" ]]; then
    if ! confirm_default "$local_ip" "FROM_IP"; then
        read -p "Enter the IP address of this node: " from_ip
        echo "FROM_IP=\"$from_ip\"" >> "$CONFIG_FILE"
    fi
else
    read -p "Enter the IP address of this node: " from_ip
    echo "FROM_IP=\"$from_ip\"" >> "$CONFIG_FILE"
fi
echo ""

# 6) FROM_MC (shifted from point 5)
echo "------------------------------------------------------"
echo "6) City where this node is located"
echo "------------------------------------------------------"
read -p "Enter the city where this node is located: " from_mc
echo "FROM_MC=\"$from_mc\"" >> "$CONFIG_FILE"
echo ""

# Section 6b: Path header
echo "" >> "$CONFIG_FILE"
echo "# ---- Application file paths ------------" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"

# 7) dir_sqlite (shifted from point 6)
echo "------------------------------------------------------"
echo "7) SQLite path"
echo "------------------------------------------------------"
if ! confirm_default "/opt/ramdisk/bin" "dir_sqlite"; then
    read -p "Enter the SQLite path: " dir_sqlite
    echo "dir_sqlite=\"$dir_sqlite\"" >> "$CONFIG_FILE"
fi
echo ""

# 8) dir_log (shifted from point 7)
echo "------------------------------------------------------"
echo "8) Log files path"
echo "------------------------------------------------------"
if ! confirm_default "/opt/ramdisk/log" "dir_log"; then
    read -p "Enter the log files path: " dir_log
    echo "dir_log=\"$dir_log\"" >> "$CONFIG_FILE"
fi
echo ""

# 9) dir_bin (shifted from point 8)
echo "------------------------------------------------------"
echo "9) Binary files path"
echo "------------------------------------------------------"
if ! confirm_default "/opt/ramdisk/bin" "dir_bin"; then
    read -p "Enter the binary files path: " dir_bin
    echo "dir_bin=\"$dir_bin\"" >> "$CONFIG_FILE"
fi
echo ""

# 10) dir_mod (shifted from point 9)
echo "------------------------------------------------------"
echo "10) Module files path"
echo "------------------------------------------------------"
if ! confirm_default "/opt/ramdisk/modules" "dir_mod"; then
    read -p "Enter the module files path: " dir_mod
    echo "dir_mod=\"$dir_mod\"" >> "$CONFIG_FILE"
fi
echo ""

# 11) conn (unchanged)
echo "------------------------------------------------------"
echo "11) Cassandra connection credentials"
echo "------------------------------------------------------"
if ! confirm_default " 9142 -u user --ssl -p pass " "conn"; then
    read -p "Enter Cassandra connection credentials: " conn
    echo "conn=\" $conn\"" >> "$CONFIG_FILE"
fi
echo ""

# Finalization
echo "" >> "$CONFIG_FILE"
echo "# End of configuration" >> "$CONFIG_FILE"
echo "# Automatically generated script - Do not modify manually" >> "$CONFIG_FILE"
echo "" >> "$CONFIG_FILE"
echo "#---------------" >> "$CONFIG_FILE"
echo "source M_config_plugin.sh" >> "$CONFIG_FILE"

# Make the file executable
chmod +x "$CONFIG_FILE"

echo "------------------------------------------------------"
echo "Configuration completed successfully!"
echo "The configuration file has been saved to: $CONFIG_FILE"
echo "------------------------------------------------------"


