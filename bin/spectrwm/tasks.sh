xdotool search --onlyvisible --classname URxvtTasks windowunmap || urxvt -name URxvtTasks -geometry 55x15+50+50 -hold -e sh -c "todo.sh;bash --rcfile .bashrctasks"
