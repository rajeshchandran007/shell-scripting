#!/bin/sh

# Colors are of 2 types `FOREGROUND` & `BACKGROUND` Color.
# Colors       Foreground          Background

# Red               31                  41
# Green             32                  42
# Yellow            33                  43
# Blue              34                  44
# Magenta           35                  45
# Cyan              36                  46
# ```

# Syntax : echo -e "\e[COLORCODEm  Your Text \e[0m"
# Syntax for backGround  
# echo -e "\e[COLORCODEm  Your Text \e[0m"

echo -e "\e[33m Font color = Yellow. Background color = None \e[0m"
echo -e "\e[43;31m Font color = Red. Background color = Yellow  \e[0m"
echo -e "\e[32m Font color = Green. Background color = None  \e[0m"
echo -e "\e[34m Font color = Blue. Background color = None  \e[0m"
echo -e "\e[35m Font color = Magenta. Background color = None  \e[0m"
echo -e "\e[36m Font color = Cyan. Background color = None  \e[0m"
