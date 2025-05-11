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
    echo "6. Exit"
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
    esac
    else
        clear_screen
        print_text red "Cannot Running Docker!. Please Install or Running Docker and Docker Compose First \n"  
    fi
}

# Starting Docker Compose File
start_docker_compose() {
    if [[ -f "docker-compose.yml" ]];then
        docker compose up -d
        clear_screen
        print_text green "Ollama and Open Web UI Starting and Running, You can access with this url ${OPEN_WEB_UI_HOST:-127.0.0.1}:${OPEN_WEB_UI_PORT:-8000} \n"
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
            docker compose down -v
        else
            echo "Remove Docker Compose without Remove Volume Binding"
            docker compose down
        fi
        # Alerting For Success Delete Docker Compose Service
        clear_screen
        print_text green "Docker Image Service Successfully Stopping and Remove! (Volumes Delete : $volume_reset) \n"
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