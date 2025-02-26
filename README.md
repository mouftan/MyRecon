# MyRecon

MyRecon is a Bash script for Subdomain Enumeration.

## Installation

# First, install the package

```bash
sudo apt install -y golang
```

# Then add the following to your .bashrc
```bash
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

# Reload your .bashrc
```bash
source .bashrc
```

```bash
git clone https://github.com/mouftan/MyRecon.git
```

```bash
cd MyRecon
```
```bash
sudo chmod +x install.sh
```
```bash
./install.sh
```

## Usage

```python
Usage: mr [options]

Options:
  -h, --help              Display help information
  -d, --domain <domain>   Single domain
  -f, --file <filename>   File containing multiple domains
  -o, --output <folder>   Specify output folder for scan results (default: ./output)
```
