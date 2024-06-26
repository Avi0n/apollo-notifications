# apollo-notifications

A simple python script that polls your reddit inbox for new comments/messages
and then sends notifications via ntfy.

## install dependencies

````
pip3 install -r requirements.txt
````

## setup

1. create a "personal use script" app here: https://old.reddit.com/prefs/apps/

note the client id/secret

2. go to https://ntfy.sh and create a topic

3. download the ntfy app and subscribe to the topic you created

4. copy `config.yaml.example` and rename the new file to `config.yaml`

5. Edit `config.yaml` with the appropriate values


Note: On first run, you'll get notified for almost every message in your inbox. After this initial run, you'll only get notified if you have a new reply/DM
