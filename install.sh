#!/bin/bash

# Rename and move MyRecon.sh file to /usr/bin/mr
sudo cp MyRecon.sh /usr/bin/mr

# Make the MyRecon file executable
sudo chmod u+x /usr/bin/mr

echo "MyRecon has been installed successfully! Now Enter the command 'mr' to run the tool."
