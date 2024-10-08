#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

# Function to generate a random number within a given range
random_in_range() {
    local lower=$1
    local upper=$2
    echo $((RANDOM % (upper - lower + 1) + lower))
}

template=$1
range0=$2
range1=$3
range2=$4
command_count=$5
output_file=$6

# Extract lower and upper bounds from input
IFS=',' read -r lower0 upper0 <<< "$range0"
IFS=',' read -r lower1 upper1 <<< "$range1"
IFS=',' read -r lower2 upper2 <<< "$range2"

cat header.txt > "$output_file"

echo -e "\n${YELLOW}Generating $command_count commands to $output_file${RESET}"

for ((i = 0; i < command_count; i++)); do
    # progress=$(( i * 100 / command_count ))
    # printf "\r${GREEN}Progress${RESET}: [${YELLOW}%-20s${RESET}] %d%%" $(printf "#%.0s" $(seq $((progress/5)))) $progress
    
    # Generate random values based on the provided ranges
    value0=$(random_in_range "$lower0" "$upper0")
    value1=$(random_in_range "$lower1" "$upper1")
    value2=$(random_in_range "$lower2" "$upper2")

    # Substitute the placeholders with random values
    command="${template//\{\$0\}/$value0}"
    command="${command//\{\$1\}/$value1}"
    command="${command//\{\$2\}/$value2}"

    # Write the command to the file
    echo "    $command" >> "$output_file"
done

echo "    ..."
sed -n '16,20p' $output_file
echo "    ..."
echo -e "${GREEN}Generated $command_count commands written to $output_file${RESET}"
