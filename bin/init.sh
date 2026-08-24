#!/bin/bash
set -e  # Stop on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if project name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: getting project name: Project name is required${NC}"
    echo -e "${BLUE}Purpose: create a new Go project based on the template${NC}"
    echo -e "${BLUE}Usage: $0 <project-name>${NC}"
    exit 1
fi

# define variable
lTPL_URL="https://github.com/abtransitionit/go-tpl-lib.git"
lPRJ_NAME=$1
lPRJ_URL="https://github.com/abtransitionit/${lPRJ_NAME}.git"
lMODULE_GO_ID_ROOT="github.com/abtransitionit"
lTEMP_USER_NAME="Template User"
lTEMP_USER_EMAIL="template@tpl.com"

# Clone template project
git clone ${lTPL_URL} ${lPRJ_NAME}

# Remove the template's .git history
rm -rf -- "${lPRJ_NAME}/.git"
echo "${GREEN}Removed unneded folder bin (${lPRJ_NAME}/.git)${NC}"

# Remove unneded folder bin
rm -rf -- "${lPRJ_NAME}/bin"
echo "${GREEN}Removed unneded folder bin (${lPRJ_NAME}/bin)${NC}"

# Replace the module id in go.mod
lMODULE_GO_ID="${lMODULE_GO_ID_ROOT}/${lPRJ_NAME}"
(
    cd -- "$lPRJ_NAME" || exit 1
    go mod edit -module="$lMODULE_GO_ID"
)
echo "${GREEN}Updated go.mod${NC}"

# Replace go-tpl-lib references in the README
## on the line containing <h1 align
sed -i -E "/<h1 align/s/go-tpl-lib/${lPRJ_NAME}/g" ${lPRJ_NAME}/README.md
## on the line containing Main CI
sed -i -E "/Main CI/s/go-tpl-lib/${lPRJ_NAME}/g" ${lPRJ_NAME}/README.md
echo "${GREEN}Updated README${NC}"

# workaround the previous sed to work on both Linux and Mac needs to create a backup file that needs to be deleted
rm -rf -- "${lPRJ_NAME}/README.md-E"
echo "${GREEN}workaround: Removed backup file (${lPRJ_NAME}/README.md-E)${NC}"


# Initialize a fresh Git repository (.git directory)
git -C "$lPRJ_NAME" init -b main
echo "${GREEN}Initialized fresh Git repository (${lPRJ_NAME}/.git)${NC}"


# Configure temporary Git identity to avoid warnings
git -C "$lPRJ_NAME" config user.name "$lTEMP_USER_NAME"
git -C "$lPRJ_NAME" config user.email "$lTEMP_USER_EMAIL"
echo "${GREEN}Configured temporary user identity to ${lTEMP_USER_NAME} <${lTEMP_USER_EMAIL}>${NC}"

# Configure the new remote GitHub repo as origin.
git -C "$lPRJ_NAME" remote add origin https://github.com/abtransitionit/${lPRJ_NAME}.git
echo "${GREEN}Configured remote origin${NC}"

# Commit changes
git -C "$lPRJ_NAME" add .
git -C "$lPRJ_NAME" commit -m "initial setup after cloning the template"
echo  "${GREEN}Committed changes${NC}"

# create the remote GitHub repository using the GitHub CLI (gh)
## check the cli is installed
if ! command -v gh >/dev/null 2>&1; then
    echo -e "${RED}Error: running GitHub CLI (gh): cli is not installed.${NC}"
    exit 1
fi

## check the cli is authenticated (gh auth status)
if ! gh auth status >/dev/null 2>&1; then
    echo -e "${RED}Error: login with the GITHUB cli (gh): cli is not authenticated.${NC}"
    echo "Run: gh auth login (and follow the instructions)"
    exit 1
fi

## create the new remote repository on GitHub, set it as private, and push the local code to it
# gh repo create "$lPRJ_NAME" --private --source=. --remote=origin --push
gh repo create "$lPRJ_URL" --private
echo  -e "${GREEN}Created remote repository${NC}"

# Push to remote
git -C "$lPRJ_NAME" push -u origin main
echo -e "${GREEN}Pushed to remote${NC}"
echo -e "${BLUE}You now have a new private repository at https://github.com/abtransitionit/${lPRJ_NAME}.git${NC}"
echo -e "${BLUE}You should 1. update user.name and user.email configuration in ${lPRJ_NAME}/.git/config${NC}"
echo -e "${BLUE}You should 2. update the README.md file with your project information${NC}"
