#!/bin/bash

ARQUIVO_ALVOS="servidores.txt"

echo "====================================================="
echo "  INICIANDO COLETA DE MÉTRICAS VIA SSH (AUTOMATIZADO)"
echo "====================================================="

for host in $(cat $ARQUIVO_ALVOS); do
    echo -e "\n---> Extraindo dados de: $host <---"
    
    ssh $host "
        echo '[CPU & Uptime]' && uptime && 
        echo '[Memória RAM]' && free -h | grep -E 'Mem|total' && 
        echo '[Armazenamento (/)]' && df -h / | grep -v tmpfs
    "
done

echo -e "\n====================================================="
echo "  RELATÓRIO CONCLUÍDO!"
echo "====================================================="
