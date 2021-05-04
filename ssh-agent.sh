# PURPOSE:
# If when I commit via Git,
# I am annoyingly asked for the password to my ssh key,
# run this. I'll have to input the password once, but not at each commit.
# It will only last for that Bash session.

ssh-agent bash
ssh-add
