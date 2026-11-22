# Function to login and export AWS SSO credentials
aws-login() {
    local profile=${1:-default} # Defaults to 'default' if no profile is provided

    echo "Logging into SSO for profile: $profile..."
    if aws sso login --profile "$profile" --no-browser; then
        echo "Login successful. Exporting credentials..."
        # This part extracts the credentials and exports them to the current shell
        eval $(aws configure export-credentials --profile "$profile" --format env)
        echo "Credentials exported! You can now use tools like Terraform or legacy CLI."
        return 0
    else
        echo "SSO Login failed."
        return 1
    fi
}

aws-export-cred() {
    local profile=${1:-default} # Defaults to 'default' if no profile is provided
    eval $(aws configure export-credentials --profile "$profile" --format env)
}

# Launch Claude Code with the team OAuth token decrypted from a gpg-encrypted file.
# The token is passed only to this process (not exported to the shell), and
# CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 strips credentials from Bash/hook/MCP subprocesses.
# Create the file with: gpg --symmetric --cipher-algo AES256 -o ~/.config/claude/token.gpg
claude() {
    local token_file="$HOME/.config/claude/token.gpg"
    local token
    if [[ ! -f "$token_file" ]]; then
        echo "claude: $token_file not found" >&2
        return 1
    fi
    token="$(gpg -q -d "$token_file")" || { echo "claude: could not decrypt token" >&2; return 1; }
    [[ -n "$token" ]] || { echo "claude: decrypted token is empty" >&2; return 1; }
    CLAUDE_CODE_OAUTH_TOKEN="$token" CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1 command claude "$@"
}
