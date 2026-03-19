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
