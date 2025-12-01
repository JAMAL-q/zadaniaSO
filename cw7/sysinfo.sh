#!/bin/bash

    get_cpu(){
        cpu=$(lscpu | grep ^"Nazwa modelu:")
        echo "CPU: $cpu"
    }
    get_ram(){
        mem1=$(free -m | awk '/^Pamięć:/ {print $2}');
        mem2=$(free -m | awk '/^Pamięć:/ {print $3}');
        mem=$(100 * $mem1 / $mem2);
        echo "$mem1 / $mem2 MiB (mem% used)";
    }

    get_load(){
        load=$(uptime | awk -F'load average: ' '{print $2}')
        echo "LOAD: $load"
    }
    get_uptime(){
        time=$(cat /proc/uptime | awk '{print int($1)}')
            hour=$(($time/3600))
            min=$((($time%3600)/60))
            
            echo "Uptime: $hour hour $min minutes"
    }
    get_kernel(){
        karnel=$(uname -r)
        echo "KARNEL: $karnel"
    }
    get_gpu(){
        gpu=$(lspci | grep -i 'vga\|3d' | awk -F ': ' '{print $2}')
        echo "GPU: $gpu"
    }
    get_user(){
        user=$(uname)
        echo "USER: $user"
    }
    
    get_shell(){
        shell=$(env | grep 'SHELL' | awk -F '/' '{print $3}')
        echo "SHELL: $shell"
    }
    get_processes(){
        proc=$(ps -e --no-headers |wc -l)
        echo "prosesses: $proc"
        #
        #
    }
    get_threads(){
        thre=$(ps -eLf --no-headers |wc -l)
        echo "Threads: $thre"
    }
    get_ip(){
        ip=$(ip addr | grep 'inet[[:space:]]192' | awk -F ' ' '{print $2, $4}')
        echo "IP: $ip"
    }
    get_dns(){
        dns=$(cat /etc/resolv.conf | grep 'nameserver' | awk -F ' ' '{print $2}')
        echo "DNS: $dns"
    }
    get_internet(){
        if timeout 1 ping -c 1 8.8.8.8 &>/dev/null; then
            echo "Internet: OK"
        else
            echo "Internet: NOT OK"
        fi
    }

    if [ $# == 0 ]; then
        get_cpu
        get_ram
        get_load
        get_uptime
        get_kernel
        get_gpu
        get_user
        get_shell
        get_processes
        get_threads
        get_ip
        get_dns
        get_internet
        exit 0
    else 
        exit_code=0
        for arg in "$@"; do
            case "${arg,,}" in
                cpu) get_cpu ;;
                ram) get_ram ;;
                load) get_load ;;
                uptime) get_uptime ;;
                kernel) get_kernel ;;
                gpu) get_gpu ;;
                user) get_user ;;
                shell) get_shell ;;
                processes) get_processes ;;
                threads) get_threads ;;
                ip) get_ip ;;
                dns) get_dns ;;
                internet) get_internet ;;
                *) echo "Invalid argument: $arg" >&2; exit_code=1 ;;
            esac
        done
        exit $exit_code
    fi
    
