#!/bin/bash

# Main menu
while true; do
    echo "Select an option:"
    echo "1) Create user"
    echo "2) Delete user"
    echo "3) Modify user password"
    echo "4) Append user to group"
    echo "5) Remove user from group"
    echo "6) Create group"
    echo "7) Delete group"
    echo "8) Create file/directory"
    echo "9) Delete file/directory"
    echo "10) Set permissions to file/directory (including sticky bit)"
    echo "11) Change owner of file/directory"
    echo "12) Configure password policy for user"
    echo "13) Show account aging status"
    echo "14) Set account expiration date"
    echo "15) Set password age"
    echo "16) Show system logs (/var/log/syslog with latest n lines)"
    echo "17) Show kernel logs (dmesg)"
    echo "18) Show system logs (journalctl -xe)"
    echo "19) Show SELinux status"
    echo "20) Show firewall status (ufw status)"
    echo "21) Show open ports (netstat)"
    echo "22) Show listening ports (netstat)"
    echo "23) Show firewalld rules"
    echo "24) Show iptables rules"
    echo "25) Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) # Create user
            read -p "Enter username: " username
            sudo adduser $username
            ;;
        2) # Delete user
            read -p "Enter username to delete: " username
            sudo deluser $username
            ;;
        3) # Modify user password
            read -p "Enter username: " username
            sudo passwd $username
            ;;
        4) # Append user to group
            read -p "Enter username: " username
            read -p "Enter group name: " groupname
            sudo usermod -aG $groupname $username
            ;;
        5) # Remove user from group
            read -p "Enter username: " username
            read -p "Enter group name: " groupname
            sudo deluser $username $groupname
            ;;
        6) # Create group
            read -p "Enter group name: " groupname
            sudo addgroup $groupname
            ;;
        7) # Delete group
            read -p "Enter group name to delete: " groupname
            sudo delgroup $groupname
            ;;
        8) # Create file/directory
            read -p "Enter file/directory name: " filename
            touch $filename # For file
            # mkdir $filename # For directory
            ;;
        9) # Delete file/directory
            read -p "Enter file/directory name to delete: " filename
            rm -rf $filename
            ;;
        10) # Set permissions to file/directory (including sticky bit, SUID, SGID)
            read -p "Enter file/directory name: " filename
            read -p "Enter permissions (e.g., 755): " permissions
            read -p "Set SUID? (y/n): " suid
            read -p "Set SGID? (y/n): " sgid
            read -p "Set sticky bit? (y/n): " sticky
            if [ "$suid" == "y" ]; then
                chmod u+s $filename
            fi
            if [ "$sgid" == "y" ]; then
                chmod g+s $filename
            fi
            if [ "$sticky" == "y" ]; then
                chmod +t $filename
            fi
            chmod $permissions $filename
            ;;
        11) # Change owner of file/directory
            read -p "Enter file/directory name: " filename
            read -p "Enter username to change ownership to: " username
            sudo chown $username $filename
            ;;
        12) # Configure password policy for user
            read -p "Enter username: " username
            echo "Select an option:"
            echo "1) Show account aging status"
            echo "2) Set account expiration date"
            echo "3) Set password age"
            read -p "Enter your choice: " policy_choice
            case $policy_choice in
                1)
                    sudo chage -l $username
                    ;;
                2)
                    read -p "Enter account expiration date (YYYY-MM-DD): " expiration_date
                    sudo chage -E $expiration_date $username
                    ;;
                3)
                    read -p "Enter maximum password age (days): " max_age
                    sudo chage -M $max_age $username
                    ;;
                *)
                    echo "Invalid option. Please try again."
                    ;;
            esac
            ;;
        13) # Show account aging status
            read -p "Enter username: " username
            sudo chage -l $username
            ;;
        14) # Set account expiration date
            read -p "Enter username: " username
            read -p "Enter account expiration date (YYYY-MM-DD): " expiration_date
            sudo chage -E $expiration_date $username
            ;;
        15) # Set password age
            read -p "Enter username: " username
            read -p "Enter maximum password age (days): " max_age
            sudo chage -M $max_age $username
            ;;
        16) # Show system logs (/var/log/syslog with latest n lines)
            read -p "Enter number of lines to display: " num_lines
            sudo tail -n $num_lines /var/log/syslog
            ;;
        17) # Show kernel logs (dmesg)
            sudo dmesg
            ;;
        18) # Show system logs (journalctl -xe)
            sudo journalctl -xe
            ;;
        19) # Show SELinux status
            sudo sestatus
            ;;
        20) # Show firewall status (ufw status)
            sudo ufw status
            ;;
        21) # Show open ports (netstat)
            netstat -tuln
            ;;
        22) # Show listening ports (netstat)
            netstat -tln
            ;;
        23) # Show firewalld rules
            sudo firewall-cmd --list-all
            ;;
        24) # Show iptables rules
            sudo iptables -L
            ;;
        25) # Exit
            echo "Exiting..."
            exit 0
            ;;
        *) # Invalid option
            echo "Invalid option. Please try again."
            ;;
    esac
done
