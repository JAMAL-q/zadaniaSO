#!/bin/bash

    get_cpu(){
        cpu=$(lscpu | grep ^"Nazwa modelu:")
        echo "CPU: $cpu"
    }
    get_ram(){
        mem1=$(free -m | awk '/^Pamięć:/ {print $2}');
        mem2=$(free -m | awk '/^Pamięć:/ {print $3}');
        mem=$(100 * $mem1 / $mem2);
        echo "$mem1/$mem2 MiB (mem% used)";
    }

    get_load(){
        load=$(uptime | awk -F'load average: ' '{print $2}')
        echo "LOAD: $load"
    }
    get_uptime(){
        time=$()
    }
    get_kernel(){
        karnel=$(uname -r)
        echo "KARNEL: $karnel"
    }
    get_gpu(){
        gpu=$(lspci | grep -i 'vga\|3d' | awk -F ': ' '{print $2}')
        echo " GPU: $gpu"
    }
    get_user(){
        user=$(uname)
        echo "USER: $user"
    }
    
    #get_shell

    get_processes(){
        oc=$(ps -e --no-headers |wc -l)
        echo "prosesses: $proc"
    }
    get_threads(){
        thre=$(ps -eLf --no-headers |wc -l)
        echo "threads $thre"
    }
    get_ip(){
        ip=$(ip addr | grep 'inet[[:space:]]192' | awk -F ' ' '{print $2, $4}')
        echo "IP: $ip"
    }
    # get_dns

    # get_internet 
    
    #    ping -c 8.8.8.8
