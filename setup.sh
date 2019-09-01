#!/bin/bash

# Software to install

GOOGLE_CHROME='Google Chrome'
INTELLIJ_IDEA='IntelliJ IDEA CE'
VISUAL_STUDIO_CODE='Visual Studio Code'
POSTMAN='Postman'
ITERM='iTerm'
JAVA8='Java 8'
OH_MY_ZSH='Oh My Zsh'
MAVEN='Maven'

INSTALLING_PREFIX="\033[1;32m+\033[0m"
SKIPPING_PREFIX="\033[1;90m-\033[0m"

is_application_installed() {

    test ! -z "$(ls /Applications | grep "$1")"
}

# Google Chrome

is_google_chrome_installed() {

    is_application_installed "$GOOGLE_CHROME"
}

install_google_chrome() {

    if ! is_google_chrome_installed
    then
        echo -e "  $INSTALLING_PREFIX Installing $GOOGLE_CHROME"
        brew cask install google-chrome
    else
        echo -e "  $SKIPPING_PREFIX Skipping $GOOGLE_CHROME (already installed)"
    fi
}

# IntelliJ IDEA CE

is_intellij_idea_installed() {

    is_application_installed "$INTELLIJ_IDEA"
}

install_intellij_idea() {

    if ! is_intellij_idea_installed
    then
        echo -e "  $INSTALLING_PREFIX Installing $INTELLIJ_IDEA"
        brew cask install intellij-idea
    else
        echo -e "  $SKIPPING_PREFIX Skipping $INTELLIJ_IDEA (already installed)"
    fi
}

# Visual Studio Code

is_visual_studio_code_installed() {

    is_application_installed "$VISUAL_STUDIO_CODE"
}

install_visual_studio_code() {

    if ! is_application_installed "$VISUAL_STUDIO_CODE"
    then
        echo -e "  $INSTALLING_PREFIX Installing $VISUAL_STUDIO_CODE"
        brew cask install visual-studio-code
    else
        echo -e "  $SKIPPING_PREFIX Skipping $VISUAL_STUDIO_CODE (already installed)"
    fi
}

# Postman

is_postman_installed() {

    is_application_installed "$POSTMAN"
}

install_postman() {

    if ! is_application_installed "$POSTMAN"
    then
        echo -e "  $INSTALLING_PREFIX Installing $POSTMAN"
        brew cask install postman
    else
        echo -e "  $SKIPPING_PREFIX Skipping $POSTMAN (already installed)"
    fi
}

# iTerm

is_iterm_installed() {

    is_application_installed "$ITERM"
}

install_iterm() {

    if ! is_application_installed "$ITERM"
    then
        echo -e "  $INSTALLING_PREFIX $ITERM"
        brew cask install iterm2
    else
        echo -e "  $SKIPPING_PREFIX $ITERM (already installed)"
    fi
}

# Oh My Zsh

is_oh_my_zsh_installed() {

    test ! -d "$HOME/.oh-my-zsh"    
}

install_oh_my_zsh() {

    if [ ! is_oh_my_zsh_installed ]
    then
        echo -e "  $INSTALLING_PREFIX Installing $OH_MY_ZSH"

        # Install Oh My Zsh
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

        # Download plugin to highlight commands
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

        # Download plugin to have suggestions
        git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        
        # Install Pure ZSH prompt
        npm install --global pure-prompt

        # Override settings
        curl -s https://raw.githubusercontent.com/pallocchi/mac/master/config/.zshrc --output $HOME/.zshrc

        # Download custom functions
        curl -s https://raw.githubusercontent.com/pallocchi/mac/master/tools.zsh --output ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/tools.zsh
    
    else
        echo -e "  $SKIPPING_PREFIX Skipping $OH_MY_ZSH (already installed)"
	fi
}

# Maven

is_maven_installed() {

    command -v mvn
}

install_maven() {
    
    if [ ! is_maven_installed ]
    then
		echo -e "  $INSTALLING_PREFIX $MAVEN"
        brew install maven
    else
        echo -e "  $SKIPPING_PREFIX Skipping $MAVEN (already installed)"
	fi
}

# Java 8

is_java8_installed() {

    java -version 2>&1 >/dev/null | grep 'java version' | awk '{print $3}' | grep '1.8'
}

install_java8() {
    
    if [ ! is_java8_installed ]
    then
		echo -e "  $INSTALLING_PREFIX $JAVA8"
        brew cask install java8
    else
        echo -e "  $SKIPPING_PREFIX Skipping $JAVA8 (already installed)"
	fi
}

print_status() {

    local app=$1
    local is_installed=$2

    if [ is_installed ]
    then
		echo -e "  $SKIPPING_PREFIX $app is installed"
    else
        echo -e "  $INSTALLING_PREFIX $app is not installed"
	fi
}

status() {

    echo "Check applications..."

    print_status "$OH_MY_ZSH" is_oh_my_zsh_installed
    print_status "$ITERM" is_iterm_installed
    print_status "$JAVA8" is_java8_installed
    print_status "$MAVEN" is_maven_installed
    print_status "$GOOGLE_CHROME" is_google_chrome_installed
    print_status "$INTELLIJ_IDEA" is_intellij_idea_installed
    print_status "$VISUAL_STUDIO_CODE" is_visual_studio_code_installed
    print_status "$POSTMAN" is_postman_installed
}

install() {

    echo "Installing applications..."

    install_oh_my_zsh
    install_iterm
    install_java8
    install_maven
    install_google_chrome
    install_intellij_idea
    install_visual_studio_code
    install_postman
}

while test $# -gt 0
do
    case "$1" in
        --status)
        status
        exit 0
            ;;
        --install) 
        install
        exit 0
            ;;
    esac
    shift
done

echo "  Usage:"
echo -e "   \033[1m--status\033[0m  : Check if applications are installed."
echo -e "   \033[1m--install\033[0m : Install missing applications."

exit 1
