#!/bin/bash

echo "=== Terminal Color Debug Script ==="
echo "Displaying ANSI colors 0-15 with background and foreground examples"
echo

# Function to print color sample
print_color() {
    local color=$1
    local name=$2
    
    # Background color sample
    printf "Color %-2d (%s):" "$color" "$name"
    printf "\033[48;5;${color}m        \033[0m "
    
    # Foreground color sample  
    printf "\033[38;5;${color}m████████\033[0m "
    
    # RGB values if available
    if command -v tput >/dev/null 2>&1; then
        printf "tput: \033[38;5;${color}m$(tput setaf $color 2>/dev/null || echo 'N/A')\033[0m"
    fi
    
    echo
}

echo "Standard ANSI Colors (0-15):"
echo "Format: Color ## (name): [BG] [FG] [tput info]"
echo

# Standard 16 colors with names
print_color 0 "black"
print_color 1 "red"  
print_color 2 "green"
print_color 3 "yellow"
print_color 4 "blue"
print_color 5 "magenta"
print_color 6 "cyan"
print_color 7 "white"
print_color 8 "bright_black"
print_color 9 "bright_red"
print_color 10 "bright_green"
print_color 11 "bright_yellow"
print_color 12 "bright_blue"
print_color 13 "bright_magenta"
print_color 14 "bright_cyan"
print_color 15 "bright_white"

echo
echo "=== True Color Test ==="
echo "Testing 24-bit (RGB) color support:"
printf "Red gradient:   \033[48;2;255;0;0m        \033[0m \033[48;2;200;0;0m        \033[0m \033[48;2;150;0;0m        \033[0m\n"
printf "Green gradient: \033[48;2;0;255;0m        \033[0m \033[48;2;0;200;0m        \033[0m \033[48;2;0;150;0m        \033[0m\n"
printf "Blue gradient:  \033[48;2;0;0;255m        \033[0m \033[48;2;0;0;200m        \033[0m \033[48;2;0;0;150m        \033[0m\n"

echo
echo "=== Environment Info ==="
echo "TERM: ${TERM:-not set}"
echo "COLORTERM: ${COLORTERM:-not set}"
echo "Terminal: $(ps -p $PPID -o comm= 2>/dev/null || echo 'unknown')"

echo
echo "=== 256 Color Support Test ==="
echo "Extended color palette (16-255):"
for i in {16..51}; do
    printf "\033[48;5;${i}m  \033[0m"
    if [ $((($i - 15) % 6)) -eq 0 ]; then echo; fi
done
echo