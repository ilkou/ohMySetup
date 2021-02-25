#!/bin/sh
# ohMyZsh

# Dependencies

## JQ

jq_exe=jq
jq_version=jq-1.6

curl -L -o $jq_exe "https://github.com/stedolan/jq/releases/download/$jq_version/jq-osx-amd64"

chmod +x $jq_exe

# Install tools

setup_install()
{
	tool_name=$(cat config.json | ./$jq_exe -r ".setup[$1].name")
	echo "Installing $tool_name..."
	COMMANDS_LENGTH=$(cat config.json | ./$jq_exe ".setup[$1].commands | length")
	for (( col=0; col<$COMMANDS_LENGTH; col++ ))
	do
		command=$(cat config.json | ./$jq_exe -r ".setup[$1].commands | .[$col]")
		eval "$command"
	done
}

SETUP_LENGTH=$(cat config.json | ./$jq_exe '.setup | length')
for (( row=0; row<$SETUP_LENGTH; row++ ))
do
	if [[ $(cat config.json | ./$jq_exe ".setup[$row].to_install") = true ]]; then
		setup_install $row
	fi
done

echo "Please open a new shell to finish installation !"

# Free up

rm -rf $jq_exe

# End
