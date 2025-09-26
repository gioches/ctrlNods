#!/bin/bash

# Define source directory
SOURCE_DIR="/opt/ctrlNods"
CONFIG_FILE="$SOURCE_DIR/M_config.sh"

# Function to display script header
display_header() {
    echo "======================================================"
    echo "       ctrlNods Deployment Script                     "
    echo "======================================================"
    echo "This script will deploy ctrlNods files to all nodes"
    echo "defined in the configuration file."
    echo "======================================================"
    echo ""
}

# Function to validate configuration file
validate_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Error: Configuration file not found at $CONFIG_FILE"
        echo "Please run the configuration script first."
        exit 1
    fi
    
    # Source the config file to get the DEST_IP array
    source "$CONFIG_FILE"
    
    # Check if DEST_IP array exists and is not empty
    if [ -z "$DEST_IP" ] || [ ${#DEST_IP[@]} -eq 0 ]; then
        echo "Error: No destination IPs found in configuration file."
        echo "Please configure the system properly first."
        exit 1
    fi
}

# Function to deploy files to a single node interactively
deploy_to_node() {
    local node_ip=$1
    local username=$2
    
    echo "Deploying to node: $node_ip"
    echo "You will be prompted for password when needed."
    
    # Copy files using scp
    echo "Copying files to $node_ip..."
    scp -o StrictHostKeyChecking=no -r "$SOURCE_DIR/"* "$username@$node_ip:$SOURCE_DIR/"
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to copy files to $node_ip"
        return 1
    fi
    

    
    echo "Deployment to $node_ip completed successfully."
    return 0
}

# Main script execution
display_header

# Validate configuration
validate_config

# Prompt for SSH username
read -p "Enter SSH username [default: root]: " username
username=${username:-root}

# Get total count of destination IPs
total_nodes=${#DEST_IP[@]}
echo "Found $total_nodes nodes in configuration."

# Skip the last node (which is this node)
deploy_nodes=$((total_nodes - 1))
echo "Will deploy to $deploy_nodes nodes (skipping the last node which is assumed to be this server)."
echo ""
echo "IMPORTANT: This script uses interactive password authentication."
echo "You will be prompted to enter the password for each connection."
echo "IMPORTANT: The directory $SOURCE_DIR must already exist on all target nodes."
echo ""

# Confirmation
read -p "Do you want to continue with deployment? [y/N]: " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 0
fi

# Deploy to each node except the last one
success_count=0
for ((i=0; i<deploy_nodes; i++)); do
    node_ip="${DEST_IP[$i]}"
    echo ""
    echo "Processing node $((i+1)) of $deploy_nodes: $node_ip"
    
    if deploy_to_node "$node_ip" "$username"; then
        ((success_count++))
    fi
done

# Summary
echo ""
echo "======================================================"
echo "Deployment Summary:"
echo "--------------------"
echo "Total nodes: $deploy_nodes"
echo "Successful deployments: $success_count"
echo "Failed deployments: $((deploy_nodes - success_count))"
echo "======================================================"

if [ $success_count -eq $deploy_nodes ]; then
    echo "All deployments completed successfully!"
    exit 0
else
    echo "Some deployments failed. Please check the logs above."
    exit 1
fi
