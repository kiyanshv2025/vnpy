#!/usr/bin/env bash

python=$1
pypi_index=$2
shift 2


[[ -z $python ]] && python=python3
[[ -z $pypi_index ]] && pypi_index=https://pypi.vnpy.com

$python -m pip install --upgrade pip wheel --index $pypi_index

# Function to install packages with fallback to official PyPI
function install-with-fallback()
{
    local package=$1
    echo "Attempting to install $package from $pypi_index..."
    
    # Try vnpy mirror first with a timeout
    if ! timeout 60 $python -m pip install "$package" --index $pypi_index --default-timeout=30 2>&1; then
        echo "Failed to install $package from $pypi_index (timeout or error)"
        echo "Falling back to official PyPI..."
        $python -m pip install "$package" --default-timeout=100
    else
        echo "Successfully installed $package from $pypi_index"
    fi
}

# Get and build ta-lib
function install-ta-lib()
{   
    # install numpy first
    $python -m pip install numpy==2.2.3 --index $pypi_index

    pushd /tmp
    wget https://pip.vnpy.com/colletion/ta-lib-0.6.4-src.tar.gz
    tar -xf ta-lib-0.6.4-src.tar.gz
    cd ta-lib-0.6.4
    ./configure --prefix=/usr/local
    make -j1
    sudo make install
    popd

    $python -m pip install ta-lib==0.6.4 --index $pypi_index
}
function ta-lib-exists()
{
    /usr/local/bin/ta-lib-config --libs > /dev/null 2>&1
}
ta-lib-exists || install-ta-lib

# Install local Chinese language environment
sudo locale-gen zh_CN.GB18030 2>/dev/null || true

# Install Qt packages first with fallback (these often fail on vnpy mirror)
echo "Installing Qt packages..."
install-with-fallback "shiboken6==6.8.2.1"
install-with-fallback "PySide6-Essentials==6.8.2.1"
install-with-fallback "pyside6==6.8.2.1"

# Install VeighNa with both mirrors (vnpy as primary, official PyPI as fallback)
echo "Installing VeighNa..."
echo "Using vnpy mirror as primary and official PyPI as fallback..."
$python -m pip install . --index-url $pypi_index --extra-index-url https://pypi.org/simple --default-timeout=100
