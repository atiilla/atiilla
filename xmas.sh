#!/bin/bash

# Trap to reset the terminal and exit on Ctrl+C (SIGINT)
trap "tput reset; tput cnorm; exit" 2

# Clear screen and hide cursor
clear
tput civis

# Initialize variables
lin=2
col=$(($(tput cols) / 2))
c=$((col - 1))
est=$((c - 2))
color=0
new_year=$(($(date +'%Y') + 1))  # Get next year

# Set color to green for tree and decorations
tput setaf 2
tput bold

# Draw Christmas Tree (using '*' characters)
for ((i = 1; i < 20; i += 2)); do
    tput cup $lin $col
    for ((j = 1; j <= i; j++)); do
        echo -n "*"
    done
    ((lin++))
    ((col--))
done

# Reset attributes and set color to yellow for trunk and text
tput sgr0
tput setaf 3

# Draw Trunk of the Tree
for ((i = 1; i <= 2; i++)); do
    tput cup $lin $c
    echo "|||"
    ((lin++))
done

# Display festive messages with colors
tput setaf 1
tput bold
tput cup $lin $((c - 6))
echo "MERRY CHRISTMAS"
tput cup $((lin + 1)) $((c - 10))
echo "And alot of fun in $new_year"

((c++))

# Lights and decorations loop
declare -a line column
k=1
while true; do
    for ((i = 1; i <= 35; i++)); do
        # Turn off previous light
        if [ $k -gt 1 ]; then
            tput setaf 2
            tput bold
            tput cup "${line[$((k-1))$i]}" "${column[$((k-1))$i]}"
            echo -n "*"
            unset line[$((k-1))$i]
            unset column[$((k-1))$i]
        fi

        # Random position for lights and change color
        li=$((RANDOM % 9 + 3))
        start=$((c - li + 2))
        co=$((RANDOM % (li - 2) * 2 + 1 + start))
        tput setaf $color
        tput bold
        tput cup $li $co
        echo -n "o"

        # Store the light position
        line[$k$i]=$li
        column[$k$i]=$co

        # Cycle through colors
        color=$(((color + 1) % 8))

        # Flashing text
        sh=1
        for l in F U N ; do
            tput cup $((lin + 1)) $((c + sh))
            echo -n "$l"
            ((sh++))
            sleep 0.01
        done
    done
    k=$((k % 2 + 1))  # Toggle k value between 1 and 2
done
