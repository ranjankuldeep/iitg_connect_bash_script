You can run script either Manually or As a Cron jobs or As a Systemd service. 

## Dependency:
  1. Bash Shell (defautl in linux)
  2. curl installed (default in most linux distro) 

# steps to run on a bash shell (Manually).
Step 1. \
  Place the script file (.sh) in home directory (recommended). \

Step 2. \
  Open the .sh file with any text editor and Add your login credentials specified in the script.
  
  
  ![Screenshot 2024-01-07 at 17 54 35](https://github.com/ranjankuldeep/iitg_connect_bash_script/assets/95350799/053c2859-d323-452c-acbd-ffc0bf458e14)


Step 3. \
Run the script as sudo user with the following command. 
```
  sudo bash iitgconnect.sh
```
For exit you can just press 'ctrl+c', it will logged you out. 

# steps to run as a systemd service.

Step 1.
  Create a systemd service with the follwing command.
  ```
    sudo nano /etc/systemd/system/iitgconnect.service
  ```
Step 2.
  Add the following lines to editor opened. 
  
  Make sure to add correct path to your script file. \
  For eg, if your username is "abc" then your path will be "/home/abc/iitgconnect.sh". 
  ```
[Unit]
Description=IITG autologin bash script file

[Service]
ExecStart=/path/to/your/script.sh 
Restart=always  # This line enables automatic restart
RestartSec=10   # Time to wait before restarting, in seconds
TimeoutSec=30   # Timeout second for stopping the service befor forcefully killing with SIGKILL

[Install]
WantedBy=multi-user.target
    
```
Step 3.
  Reload systemd for the changes to take effect.
  ```
    sudo reload systemd for the changes to take effect
  ```
Step 4.
  Enable the service to start automatically on startup.
  ```
    sudo systemctl start iitgconnect.service
  ```
Step 5.
  To check the status, type the following command.
  ```
    sudo systemctl status iitgconnect.service
  ```
Done!!
