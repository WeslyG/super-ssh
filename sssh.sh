#!/bin/bash
#helper
if [ $# -eq 0 ] || [ $1 == '?' ] || [ $1 == '--help' ] || [ $1 == '-h' ]; then
    echo 'Super SSH'
    echo 'Usage:'
    echo ''
    echo 'ssh example:'
    echo 's youre-machine-name'
    echo 's youre-machine-name -p 8080'
    echo ''
    echo 'scp example'
    echo 's file.txt my-vm:/tmp'
    echo 's my-vm:/tmp/file.txt /tmp'
    echo 's -p 23 my-vm:/tmp/file.txt /tmp'
    echo ''
    echo 'ssh tunnel example'
    echo 's -N my-vm -L 3000:localhost:3000 -L 2000:localhost:2000'
    echo ''
    exit 0
fi

production=my-production-prefix.com
develop=my-develop-prefix.com

# static
if [ $1 == "gate" ]; then
    ssh -t userName@my-proxy.server.ru 'sudo -i'
fi
# tunnel
if [ $1 == "-N" ]; then
    list=$(for ((i = 3; i <= $#; i++ )); do
        echo "${!i} "
    done)
    ssh -N $2.$production $list 2> /dev/null
        if [ $? -ne 0 ]; then
            ssh -N $2.$develop $list 2> /dev/null
                if [ $? -ne 0 ]; then
                    ssh -N $2 $list
                fi
        fi
fi


port='22'
if [ $# -eq 1 ] || [[ $# -eq 3 && $2 == "-p" || $2 == "-P" ]]; then
    # port checker
    if [[ $# -eq 3 && $2 == "-p" || $2 == "-P" ]]; then
        port=$3
    fi

    scp -P $port ~/.bashrc_remoute $1.$production:/tmp/ &> /dev/null
    ssh -p $port $1.$production -t "sudo -i \
        \cp -r /root/.bashrc /tmp/.bashrc_temp \
        && cat /tmp/.bashrc_temp >> /tmp/.bashrc_remoute \
        && sudo -i bash --rcfile /tmp/.bashrc_remoute; \
        sudo -i rm -rf /tmp/.bashrc*" 2> /dev/null
            if [ $? -ne 0 ]; then
                scp -P $port ~/.bashrc_remoute $1.$develop:/tmp/ &> /dev/null
                ssh -p $port $1.$develop -t "sudo -i \
                    \cp -r /root/.bashrc /tmp/.bashrc_temp \
                    && cat /tmp/.bashrc_temp >> /tmp/.bashrc_remoute \
                    && sudo -i bash --rcfile /tmp/.bashrc_remoute; \
                    sudo -i rm -rf /tmp/.bashrc*" 2> /dev/null
                if [ $? -ne 0 ]; then
                    ssh $1 -p $port
                fi
        fi
fi

# scp -P 23 test.txt vm-elk-k1:/tmp/
# scp -P 23 vm-elk-k1:/tmp/temp.txt /tmp
# scp test.txt vm-elk-k1:/tmp/
# scp vm-elk-k1:/tmp/test.txt /tmp


if [ $# -eq 2 ] || [[ $# -eq 3 && $1 == "-p" || $1 == "-P" ]]; then
    # port checker
    if [[ $# -eq 3 && $1 == "-p" || $1 == "-P" ]]; then
        port=$2
    fi

    if [ -f $3 ]; then
        vm=$(echo $4 | awk -F ":" '{ print $1}')
        file=$(echo $4 | awk -F ":" '{ print $2}')
        scp -P $port $3 $vm.$production:$file 2> /dev/null
        if [ $? -ne 0 ]; then
            scp -P $port $3 $vm.$develop:$file 2> /dev/null
            if [ $? -ne 0 ]; then
                scp -P $port $vm:$file
            fi
        fi
    else
        vm=$(echo $3 | awk -F ":" '{ print $1}')
        file=$(echo $3 | awk -F ":" '{ print $2}')
        scp -P $port $vm.$production:$file $4 2> /dev/null
        if [ $? -ne 0 ]; then
            scp -P $port $vm.$develop:$file $4 2> /dev/null
            if [ $? -ne 0 ]; then
                scp -P $port $vm:$file $4
            fi
        fi
    fi

    if [ -f $1 ]; then
        vm=$(echo $2 | awk -F ":" '{ print $1}')
        file=$(echo $2 | awk -F ":" '{ print $2}')
        scp $1 $vm.$production:$file 2> /dev/null
        if [ $? -ne 0 ]; then
            scp $1 $vm.$develop:$file 2> /dev/null
            if [ $? -ne 0 ]; then
                scp $1 $vm:$file
            fi
        fi
    else
        vm=$(echo $1 | awk -F ":" '{ print $1}')
        file=$(echo $1 | awk -F ":" '{ print $2}')
        scp $vm.$production:$file $2 2> /dev/null
        if [ $? -ne 0 ]; then
            scp $vm.$develop:$file $2 2> /dev/null
            if [ $? -ne 0 ]; then
                scp $vm:$file $2
            fi
        fi
    fi
fi
