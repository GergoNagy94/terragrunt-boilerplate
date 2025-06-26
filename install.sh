#!/bin/bash

set -e

VERSION="v0.6.3"
BINARY_NAME="boilerplate"
INSTALL_DIR="/usr/local/bin"
REPO_URL="https://github.com/gruntwork-io/boilerplate/releases/download"

detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "darwin";;
        CYGWIN*|MINGW*|MSYS*) echo "windows";;
        *)          echo "unknown";;
    esac
}

detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)   echo "amd64";;
        i386|i686)      echo "386";;
        aarch64|arm64)  echo "arm64";;
        armv7l)         echo "arm";;
        *)              echo "unknown";;
    esac
}

OS=$(detect_os)
ARCH=$(detect_arch)

echo "Detected: $OS $ARCH"

if [[ "$OS" == "unknown" ]] || [[ "$ARCH" == "unknown" ]]; then
    echo "Error: Unsupported platform"
    exit 1
fi

BINARY_SUFFIX="${OS}_${ARCH}"
if [[ "$OS" == "windows" ]]; then
    BINARY_SUFFIX="${BINARY_SUFFIX}.exe"
fi

DOWNLOAD_URL="${REPO_URL}/${VERSION}/${BINARY_NAME}_${BINARY_SUFFIX}"
TEMP_FILE="/tmp/${BINARY_NAME}"

echo "Downloading from: $DOWNLOAD_URL"

curl -L -o "$TEMP_FILE" "$DOWNLOAD_URL"

chmod +x "$TEMP_FILE"

if [[ ! -w "$INSTALL_DIR" ]]; then
    echo "Installing with sudo..."
    sudo mv "$TEMP_FILE" "$INSTALL_DIR/$BINARY_NAME"
else
    mv "$TEMP_FILE" "$INSTALL_DIR/$BINARY_NAME"
fi

echo "Installation complete!"
echo "Try: boilerplate --version"