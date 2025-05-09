# habtra
Yet another habit tracker

## Installation
#### Download the script and make it executable:
```
mkdir -p ~/Skripte && cd ~/Skripte && git clone https://github.com/zuiraito/habtra.git && chmod +x ~/Skripte/habtra/habits.sh 
```
#### Make the command `habits` execute the script:
On bash (most linux distros)
```
echo "alias habits='~/Skripte/habtra/habits.sh'" >> ~/.bashrc && source ~/.bashrc
```
On zsh (MacOS)
```
echo "alias habits='~/Skripte/habtra/habits.sh'" >> ~/.zshrc && source ~/.zshrc
```
## Usage
Run the program with
```
$ habits
```
You can add an entry for the day before with
```
$ habits yesterday
``` 
Here you can ender a habit you did today, optionally with an numeric value. For example:
```
Which habits did you do today (2025-05-09)?
(Type one, then press enter. Type 'done' to finish.)
> swimming
```
If the habit is entered for the first time, you will get prompted if you want to create it. Press `y` and then enter to add the habit. The habit log files are saved in `~/Habits`.<br>
To exit the program, type
```
> done
```
