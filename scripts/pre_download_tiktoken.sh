#!/bin/bash

#
# Pre-download (populate) tiktoken cache, so tiktoken can be used offline.
# See also README.tiktoken.md
#

set -xeu
set -o pipefail

if [ -z "${TIKTOKEN_CACHE_DIR:-}" ]; then
    echo "ERROR: TIKTOKEN_CACHE_DIR is not set or empty"
    exit 1
fi

mkdir -p "${TIKTOKEN_CACHE_DIR}"

#
# Download tiktoken files
#
function download_tiktoken_file() {
    #
    # Python code in tiktoken:
    #
    # >>> import hashlib
    # >>> blobpath = "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken"
    # >>> cache_key = hashlib.sha1(blobpath.encode()).hexdigest()
    # >>> print(cache_key)
    #
    local url="${1}"
    local filename="$(echo -n "${url}" | sha1sum | awk '{print $1}')"
    echo "Download ${url} to ${TIKTOKEN_CACHE_DIR}/${filename}"
    wget -O "${TIKTOKEN_CACHE_DIR}/${filename}" "${url}"
}

# These URLs are from site-packages/tiktoken_ext/openai_public.py
download_tiktoken_file "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken"
download_tiktoken_file "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken"
download_tiktoken_file "https://openaipublic.blob.core.windows.net/encodings/p50k_base.tiktoken"
download_tiktoken_file "https://openaipublic.blob.core.windows.net/encodings/r50k_base.tiktoken"
download_tiktoken_file "https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/encoder.json"
download_tiktoken_file "https://openaipublic.blob.core.windows.net/gpt-2/encodings/main/vocab.bpe"
