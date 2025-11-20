#!/bin/bash

    get_cpu(){
        cpu=$(lscpu | grep ^"Nazwa modelu:")
        echo "CPU: $cpu"
    }
    # get_ram(){

    # }

    get_load(){
        load=$(uptime | awk -F'load average: ' '{print $2}')
        LOAD: $load
    }
    get_uptime(){
        time=$()
    }
    # get_kernel
    # get_gpu
    get_user(){
        user=$(uname)
        echo "USER: $user"
    }
    
    # get_shell
    # get_processes
    # get_threads
    # get_ip
    # get_dns
    # get_internet