alias towindows='cd /mnt/c/Users/Dans'
alias k="kubectl"
alias ssh='TERM=xterm-256color \ssh'
alias tmux='TERM=xterm-256color tmux'
alias vi='nvim'
alias clip='win32yank.exe -i --crlf'
alias ftwind="$HOME/script/bash/ftwind"
alias grep='rg'
alias env-db-preprod="source $HOME/script/bash/db-export"
alias tree-sitter="$HOME/.local/bin/"
alias fzf-lua="nvim -l '$HOME/.local/share/nvim/lazy/fzf-lua/scripts/cli.lua' files --no_ignore=true follow=true hidden=true"
alias tsel-proxy="nohup sthp -p 8444 -s localhost:8443 > /dev/null 2>&1 &"
alias gensign-prep="node $HOME/script/node/generate-siganture-preprod.js"

# Function to login and export AWS SSO credentials
aws-login() {
    local profile=${1:-default} # Defaults to 'default' if no profile is provided

    echo "Logging into SSO for profile: $profile..."
    if aws sso login --profile "$profile"; then
        echo "Login successful. Exporting credentials..."
        
        # This part extracts the credentials and exports them to the current shell
        eval $(aws configure export-credentials --profile "$profile" --format env)
        printenv | grep -i aws
        echo "Credentials exported! You can now use tools like Terraform or legacy CLI."
    else
        echo "SSO Login failed."
        return 1
    fi
}
