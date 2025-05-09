#!/bin/bash

# === Color definitions ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# === Habit directory ===
HABIT_DIR="$HOME/Habits"

# === Check if habit directory exists ===
if [[ ! -d "$HABIT_DIR" ]]; then
    echo -e "${YELLOW}The directory '$HABIT_DIR' does not exist.${NC}"
    read -rp "$(echo -e "${YELLOW}Do you want to create it? [y/n] ${NC}")" create_dir
    case "$create_dir" in
        [Yy]* )
            mkdir -p "$HABIT_DIR"
            echo -e "${GREEN}Directory created at $HABIT_DIR.${NC}"
            ;;
        * )
            echo -e "${RED}Cannot continue without the habit directory. Exiting.${NC}"
            exit 1
            ;;
    esac
fi

# === Determine date based on argument ===
if [ "$1" == "yesterday" ]; then
    date_to_use=$(date -d "yesterday" +"%Y-%m-%d")
    echo -e "${BLUE}Tracking habits for yesterday (${date_to_use}).${NC}"
else
    date_to_use=$(date +"%Y-%m-%d")
    echo -e "${BLUE}Which habits did you do today (${date_to_use})?${NC}"
    echo -e "(Type one, then press enter. Type 'done' to finish.)"
fi

# === Main input loop ===
while true; do
    echo -n "> "
    read -r habit_input

    if [[ "$habit_input" == "done" ]]; then
        echo -e "${GREEN}Exiting habits.sh. Goodbye!${NC}"
        break
    elif [[ -z "$habit_input" ]]; then
        continue
    fi

    # Separate the habit name and the value (distance, time, etc.)
    habit_name=$(echo "$habit_input" | awk '{print $1}')
    habit_value=$(echo "$habit_input" | awk '{print $2}')

    log_file="$HABIT_DIR/${habit_name}.log"

    # Check if log file exists
    if [[ -f "$log_file" ]]; then
        # Check if the current date is already logged for this habit
        if grep -q "$date_to_use" "$log_file"; then
            echo -e "${RED}The habit '${habit_name}' is already logged for ${date_to_use}.${NC}"
            echo -e "${YELLOW}(1) Overwrite the log"
            echo -e "(2) Add another log"
            echo -e "(3) Cancel"
            echo -n "Please choose an option (1/2/3): "
            read -r choice

            case "$choice" in
                1)
                    # Overwrite the log with the new value
                    sed -i "/$date_to_use/d" "$log_file"  # Remove the old log entry for the date
                    echo -e "${date_to_use}\t${habit_value}" >> "$log_file"  # Add the new log entry
                    echo -e "${GREEN}Log overwritten for '${habit_name}' on ${date_to_use}, with a value of ${habit_value}.${NC}"
                    ;;
                2)
                    # Add a new log entry for the same date
                    echo -e "${date_to_use}\t${habit_value}" >> "$log_file"
                    echo -e "${GREEN}Added another log for '${habit_name}' on ${date_to_use}, with a value of ${habit_value}.${NC}"
                    ;;
                3)
                    # Cancel the operation
                    echo -e "${RED}Operation canceled. No changes made to the log.${NC}"
                    ;;
                *)
                    # Invalid option
                    echo -e "${RED}Invalid option. Please choose 1, 2, or 3.${NC}"
                    ;;
            esac
        else
            # No existing log for that date, so just add it
            echo -e "${date_to_use}\t${habit_value}" >> "$log_file"
            echo -e "${GREEN}You did '${habit_name}' on ${date_to_use}, with a value of ${habit_value}.${NC}"
        fi
    else
        # If the habit does not exist, ask to create it
        echo -e "${YELLOW}'${habit_name}' seems to be a new habit.${NC}"
        read -rp "$(echo -e "${YELLOW}Do you want to create it? [y/n] ${NC}")" response
        case "$response" in
            [Yy]* )
                echo -e "${date_to_use}\t${habit_value}" > "$log_file"
                echo -e "${GREEN}Created log and marked '${habit_name}' as done on ${date_to_use}, with a value of ${habit_value}.${NC}"
                ;;
            * )
                echo -e "${RED}Skipped '${habit_name}'.${NC}"
                ;;
        esac
    fi
done

