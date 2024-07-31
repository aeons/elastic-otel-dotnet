#!/bin/sh
set -e

# guess OS_TYPE if not provided
if [ -z "$OS_TYPE" ]; then
  case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    cygwin_nt*|mingw*|msys_nt*)
      OS_TYPE="windows"
      ;;
    linux*)
      if [ "$(ldd /bin/ls | grep -m1 'musl')" ]; then
        OS_TYPE="linux-musl"
      else
        OS_TYPE="linux-glibc"
      fi
      ;;
    darwin*)
      OS_TYPE="macos"
      ;;
  esac
fi

case "$OS_TYPE" in
  "linux-glibc"|"linux-musl"|"macos"|"windows")
    ;;
  *)
    echo "Set the operating system type using the OS_TYPE environment variable. Supported values: linux-glibc, linux-musl, macos, windows." >&2
    exit 1
    ;;
esac

# guess OS architecture if not provided
if [ -z "$ARCHITECTURE" ]; then
  case $(uname -m) in
    x86_64)  ARCHITECTURE="x64" ;;
    aarch64) ARCHITECTURE="arm64" ;;
  esac
fi

case "$ARCHITECTURE" in
  "x64"|"arm64")
    ;;
  *)
    echo "Set the architecture type using the ARCHITECTURE environment variable. Supported values: x64, arm64." >&2
    exit 1
    ;;
esac

test -z "$OTEL_DOTNET_AUTO_HOME" && OTEL_DOTNET_AUTO_HOME="$HOME/.otel-dotnet-auto"
test -z "$VERSION" && VERSION="v1.7.0"

DOWNLOAD_DIR="${DOWNLOAD_DIR:=${TMPDIR:=$(mktemp -d)}}"

RELEASES_URL="https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases"
ARCHIVE="opentelemetry-dotnet-instrumentation-$OS_TYPE.zip"

# In case of Linux, use architecture in the download path
if echo "$OS_TYPE" | grep -q "linux"; then
  ARCHIVE="opentelemetry-dotnet-instrumentation-$OS_TYPE-$ARCHITECTURE.zip"
fi

LOCAL_PATH="${LOCAL_PATH:=$DOWNLOAD_DIR/$ARCHIVE}"
if [ ! -f "${LOCAL_PATH}" ]; then
  (
    cd "$DOWNLOAD_DIR"
    echo "Downloading $VERSION for $OS_TYPE ($LOCAL_PATH)..."
    curl -sSfLo "$LOCAL_PATH" "$RELEASES_URL/download/$VERSION/$ARCHIVE"
  )
else
  echo "Using local installation archive: $LOCAL_PATH"
fi

rm -rf "$OTEL_DOTNET_AUTO_HOME"
unzip -q "$LOCAL_PATH" -d "$OTEL_DOTNET_AUTO_HOME"
