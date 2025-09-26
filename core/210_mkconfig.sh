#!/bin/bash

# Directory containing configuration files
CONFIG_DIR="/opt/ctrlNods"
MASTER_CONFIG="$CONFIG_DIR/M_config.sh"

# Check if master config exists
if [ ! -f "$MASTER_CONFIG" ]; then
    echo "Error: Master configuration file not found at $MASTER_CONFIG"
    exit 1
fi

# Source the master config to get the DEST_IP and DEST_MC arrays
source "$MASTER_CONFIG"

# Check if DEST_IP array is defined
if [ -z "$DEST_IP" ] || [ ${#DEST_IP[@]} -eq 0 ]; then
    echo "Error: DEST_IP array not found or empty in master configuration file."
    exit 1
fi

# Check if DEST_MC array is defined and has the same size as DEST_IP
if [ -z "$DEST_MC" ] || [ ${#DEST_MC[@]} -ne ${#DEST_IP[@]} ]; then
    echo "Warning: DEST_MC array not found or size does not match DEST_IP array."
    echo "FROM_MC values may not be set correctly."
fi

echo "Generating node-specific configuration files..."
echo "Found ${#DEST_IP[@]} nodes in configuration."

# Function to extract the last 3 digits of an IP address
get_ip_suffix() {
    local ip="$1"
    local suffix=$(echo "$ip" | sed -E 's/.*\.([0-9]{1,3})$/\1/')
    
    # Pad with zeros if less than 3 digits
    while [ ${#suffix} -lt 3 ]; do
        suffix="0$suffix"
    done
    
    echo "$suffix"
}

# Function to generate configuration for a specific node
generate_node_config() {
    local node_ip="$1"
    local node_index="$2"
    local node_city="${DEST_MC[$node_index]}"
    local ip_suffix=$(get_ip_suffix "$node_ip")
    local node_config="$CONFIG_DIR/M_config_${ip_suffix}.sh"
    local temp_config=$(mktemp)
    
    echo "Creating configuration for node: $node_ip (${node_city}) - File suffix: $ip_suffix"
    
    # Copy the master config file
    cp "$MASTER_CONFIG" "$temp_config"
    
    # Modify the DEST_IP array so that the node's IP is the last element
    # First, create a new array without the node's IP
    local new_dest_ip=()
    for ip in "${DEST_IP[@]}"; do
        if [ "$ip" != "$node_ip" ]; then
            new_dest_ip+=("$ip")
        fi
    done
    
    # Add the node's IP as the last element
    new_dest_ip+=("$node_ip")
    
    # Build the new DEST_IP array string
    local new_dest_ip_str="DEST_IP=(\n"
    for ip in "${new_dest_ip[@]}"; do
        new_dest_ip_str+="    \"$ip\"\n"
    done
    new_dest_ip_str+=")"
    
    # Replace the DEST_IP array in the config file
    sed -i '/DEST_IP=(/,/)/c\'"$new_dest_ip_str" "$temp_config"
    
    # Replace FROM_IP with the node's IP
    sed -i 's/^FROM_IP=.*$/FROM_IP="'"$node_ip"'"/' "$temp_config"
    
    # Replace FROM_MC with the node's city
    if [ -n "$node_city" ]; then
        sed -i 's/^FROM_MC=.*$/FROM_MC="'"$node_city"'"/' "$temp_config"
    fi
    
    # Move the modified file to its final destination
    mv "$temp_config" "$node_config"
    chmod +x "$node_config"
    
    echo "Node configuration saved to: $node_config"
}

# Generate configurations for each node
for i in "${!DEST_IP[@]}"; do
    node_ip="${DEST_IP[$i]}"
    generate_node_config "$node_ip" "$i"
done

echo "------------------------------------------------------"
echo "Configuration generation completed successfully!"
echo "Node-specific configuration files are available in: $CONFIG_DIR"
echo "------------------------------------------------------"
