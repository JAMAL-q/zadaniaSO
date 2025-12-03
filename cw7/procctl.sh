# 1

# ps -eo pid,ppid,%cpu,%mem,user --sort=-%cpu

# ps aux --sort=-%cpu | head -n 6

# 2 

#ps aux --sort=-%mem | head -n 6

# ps -eo pid,ppid,%cpu,%mem,user --sort=-%mem

# 3

#pstree 

# 4 

#ps -p 1234 -o comm=

# 5

#pgrep nazwa

# 6 

#sudo kill -s SIGTERM PID tutaj

# 7 

# pkill nazwa procesu ez 

echo " Process Control:
1) List top 5 processes by CPU usage
2) List top 5 processes by memory usage 
3) Show process tree
4) Show process name by PID
5) Show process PID(s) by name
6) Kill process by PID
7) Kill process by name
q) Exit
Choice:"

read choice

case $choice in
    1) ps aux --sort=-%cpu | head -n 6 ;;
    2) ps aux --sort=-%mem | head -n 6 ;;
    3) pstree ;;
    4) echo "Enter PID:"; read pid; ps -p $pid -o comm= ;;
    5) echo "Enter process name:"; read pname; pgrep $pname ;;
    6) echo "Enter PID to kill:"; read kpid; sudo kill -s SIGTERM $kpid ;;
    7) echo "Enter process name to kill:"; read kpname; pkill $kpname ;;
    q) exit 0 ;;
    *) echo "Invalid choice." ;;
esac    
