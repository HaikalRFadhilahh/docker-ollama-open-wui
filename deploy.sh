# Import Bash Config File
#!/bin/bash

# Exit Code When Command Error
# set -e

# Create Function Clear Screen
clear_screen() {
    echo -e "\033c"
} 

# Menu List
script_menu() {
    echo "==================================================================="
    print_text white "Script Deployment Ollama + Docker + Open Web UI By Haikal and Contributors"
    echo "==================================================================="
    echo "1. Pull Docker Image Services (Ollama + Open Web UI)"
    echo "2. Starting Docker Compose Services"
    echo "3. Stopping Docker Compose Services"
    echo "4. Installing Ollama Models"
    echo "5. Remove / Uninstall Ollama Models"
    echo "6. Change Port Docker Compose Service (Open Web UI)"
    echo "7. Exit"
    echo -n "Enter your preferred option number: "
    read ops
    case $ops in
    1)
        docker_utilities 1
        ;;
    2)
        docker_utilities 2
        ;;
    3)
        docker_utilities 3
        ;;
    4)
        docker_utilities 4
        ;;
    5)
        docker_utilities 5
        ;;
    6)
        docker_utilities 6
        ;;
    7)
        print_text green "\n Thanks For Using Haikal's Deployment Script 🐳! \n"
        exit 0
        ;;
    *)
        clear_screen
        print_text red "Options are not available. Please choose an available option! \n"
        ;;
    esac
}

# Docker Utilities Function
docker_utilities() {
    if docker info &> /dev/null ;then
        option=$1
        case $ops in
    1)
        pull_docker_compose_service
        ;;
    2)
        start_docker_compose
        ;;
    3)
        stopping_docker_compose_service
        ;;
    4)
        installing_ollama_models
        ;;
    5)
        remove_ollama_models
        ;;
    6)
        custom_network_docker_compose_service
        ;;
    esac
    else
        clear_screen
        print_text red "Cannot Running Docker!. Please Install or Running Docker and Docker Compose First \n"  
    fi
}

# Starting Docker Compose File
start_docker_compose() {
    if [[ -f "docker-compose.yml" ]];then
        if ! docker compose ls | grep "running(2)";then
            # Read and Checking Input Host 
            while true;do
                echo -n "Enter Host Address for Open Web UI (Default 127.0.0.1) : "
                read compose_service_host
                if ip addr | grep "$compose_service_host" &> /dev/null || [[ $compose_service_host == "0.0.0.0" ]];then
                    export OPEN_WEB_UI_HOST=$compose_service_host
                    break
                elif [[ -z "$compose_service_host" ]];then
                    export OPEN_WEB_UI_HOST=127.0.0.1
                    break
                fi
                print_text red "Invalid Host, Please Check and Input Again! \n"
            done
            # Read and Checking Port Input
            while true;do
                echo -n "Enter Port for Open Web UI (Default 8000) : "
                read compose_service_port
                export OPEN_WEB_UI_PORT=$compose_service_port
                if [[ -z "$compose_service_port" ]];then
                    export OPEN_WEB_UI_PORT=8000
                fi
                if docker compose up -d &> /dev/null;then
                    break
                fi
                print_text red "Invalid Port, The problem could be from using a prohibited port or a port already in use. Please change your port \n"
            done

            clear_screen
            print_text green "Ollama and Open Web UI Successfully Deploy and Running, You can access with this url ${OPEN_WEB_UI_HOST:-127.0.0.1}:${OPEN_WEB_UI_PORT:-8000} \n"
        else
            clear_screen
            print_text green "Ollama and Open Web UI Already Running, You can access with this url $(docker inspect ollama-open-web-ui | jq -r '.[0].HostConfig.PortBindings["8080/tcp"][0].HostIp'):$(docker inspect ollama-open-web-ui | jq -r '.[0].HostConfig.PortBindings["8080/tcp"][0].HostPort') \n"
        fi
    else
        clear_screen
        print_text red "Error Stating Docker Compose Service. File docker-compose.yml Not Found! \n"
    fi
}

# Downloading Docker Compose Image Service
pull_docker_compose_service() {
    if [[ -f "docker-compose.yml" ]];then
        docker compose pull
        clear_screen
        print_text green "Docker Image Service Successfully Pull from Registry! \n"
    else
        clear_screen
        print_text red "File docker-compose.yml Not Found! \n"
    fi
}

# Stopping Docker Compose Service
stopping_docker_compose_service() {
    if [[ -f "docker-compose.yml" ]];then
        # Volume Remove Confirmation
        echo -n "Do you want to delete docker volumes (Y/N) default (N): " 
        read volume_reset
        if [[ "$volume_reset" == "Y" || "$volume_reset" == "y" ]];then
            echo "Remove Docker Compose and Remove Volume Binding"
            docker compose down -v &> /dev/null
        else
            echo "Remove Docker Compose without Remove Volume Binding"
            docker compose down &> /dev/null
        fi
        # Alerting For Success Delete Docker Compose Service
        clear_screen
        print_text green "Docker Image Service Successfully Stopping and Remove! (Volumes Delete : $volume_reset) \n"
    else
        clear_screen
        print_text red "File docker-compose.yml Not Found! \n"
    fi
}

# Custom Port Docker Compose Service 
custom_network_docker_compose_service() {
    if [[ -f "docker-compose.yml" ]];then
        # Get Input Host and Port
        echo -n "Enter the Host address for the Open Web UI Service (Default value 127.0.0.1) : "
        read docker_service_host
        echo -n "Enter the port for Open Web UI Service (Default value 8000) : "
        read docker_service_port
        # Default Value Host and Port if null
        # Default Value Host when input value null
        if [[ -z "$docker_service_host" ]];then
            docker_service_host="127.0.0.1"
        fi
        # Default Value Port when input value null
        if [[ -z "$docker_service_port" ]];then
            docker_service_port="8000"
        fi

        # Set Export Value
        export OPEN_WEB_UI_HOST=$docker_service_host
        export OPEN_WEB_UI_PORT=$docker_service_port

        # Restart Docker Compose Service
        docker compose down &> /dev/null
        docker compose up -d &> /dev/null

        # Checking Docker Service Host and Port
        if [[ $? -eq 0 ]];then
            clear_screen
            print_text green "Successfully change the Host and Port of Open Web UI Docker Service, Open Web UI can be accessed on ${OPEN_WEB_UI_HOST}:${OPEN_WEB_UI_PORT} \n"
        else
            host_error_flag=0
            
            # Check First HOST is Valid
            if ! ip addr | grep $OPEN_WEB_UI_HOST &> /dev/null && [[ $OPEN_WEB_UI_HOST != "0.0.0.0" ]];then
                host_error_flag=1
                export OPEN_WEB_UI_HOST=127.0.0.1
            fi

            # Running With Available Port
            docker compose up -d &> /dev/null
            if [[ $? -ne 0 ]];then
                temp_port=8000
                while true;do
                    export OPEN_WEB_UI_PORT=$temp_port
                    docker compose up -d &> /dev/null
                    if [[ $? -eq 0  ]];then
                        break
                    fi
                    ((temp_port++))
                done
            fi

            # Gretting 
            clear_screen
            if [[ $host_error_flag -eq 1 ]];then
                print_text red "Invalid Host Configuration for Docker Compose. Host configured to default 127.0.0.1 \n"
            fi
            print_text green "Failed to change the port, but Open Web UI continues to run in the default configuration ${OPEN_WEB_UI_HOST:-127.0.0.1}:${OPEN_WEB_UI_PORT:-8000} \n"
        fi
    else
        clear_screen
        print_text red "File docker-compose.yml Not Found! \n"
    fi
}

# Installing Ollama Models
installing_ollama_models() {
    if docker ps | grep ollama-ai &> /dev/null;then
        # Information For Checking and Downloading Ollama Models
        echo "You can view the list of available Ollama Models via https://ollama.com/search"
        echo -n "Enter the name of the Ollama Models you want to install: " 
        read models_name
        # Checking Ollama Models Input
        if [[ -n "$models_name" ]];then
            docker exec -it ollama-ai ollama pull $models_name
        fi
        # Greeting Success Installed Models
        if [[ $? -ne 0 || -z "$models_name" ]];then
            clear_screen
            print_text red "Ollama Models Not Found!, Please checking again from Ollama Official Websites \n"
        else
            clear_screen
            print_text green "Success Pull and Installed Ollama $models_name Models, You can use new models in Open Web UI in ${OPEN_WEB_UI_HOST:-127.0.0.1}:${OPEN_WEB_UI_PORT:-8000} \n"
        fi
    else
        clear_screen
        print_text red "Ollama Service Not Found!. Please start the docker compose service first. \n"
    fi
}

# Remove Ollama Models
remove_ollama_models() {
    if docker ps | grep ollama-ai &> /dev/null;then
        echo "List of installed Ollama Models :"
        docker exec -it ollama-ai ollama list
        echo -n "Select the Ollama model you want to delete (type 'N' if you want to cancel): "
        read rm_models_name
        if [[ "$rm_models_name" == "n" || "$rm_models_name" == "N" || "$rm_models_name" == "'N'" || "$rm_models_name" == "'n'" ]];then
            clear_screen 
            print_text red "Canceled! \n"
        else 
            docker exec -it ollama-ai ollama stop $rm_models_name
            docker exec -it ollama-ai ollama rm $rm_models_name
            if [[ $? -eq 0 ]];then
                clear_screen
                print_text green "Success Remove Ollama Models \n"
            else
                clear_screen
                print_text red "Error Deleting Ollama Models, Maybe Models not found in your local machnine \n"
            fi
        fi
    else
        clear_screen
        print_text red "Ollama Service Not Found!. Please start the docker compose service first. \n"
    fi
}

# Helper 
print_text() {
    color=$1
    text=$2
    case $color in
        red)
            echo -e "\033[1;31m$text\033[0m"  # 1 untuk bold, 31 untuk merah
            ;;
        green)
            echo -e "\033[1;32m$text\033[0m"  # 1 untuk bold, 32 untuk hijau
            ;;
        yellow)
            echo -e "\033[1;33m$text\033[0m"  # 1 untuk bold, 33 untuk kuning
            ;;
        blue)
            echo -e "\033[1;34m$text\033[0m"  # 1 untuk bold, 34 untuk biru
            ;;
        white)
            echo -e "\033[1;37m$text\033[0m"  # 1 untuk bold, 34 untuk white
            ;;
        *)
            echo "$text"
            ;;
    esac
}

# Main Script Running
while true
do
    script_menu
done