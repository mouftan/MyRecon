# MyRecon

MyRecon is a Bash script for Subdomain Enumeration.

## Installation


```bash
# First, install the Go
sudo apt install -y golang
```


```bash
# Then add the following to your .bashrc
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```


```bash
# Reload your .bashrc
source .bashrc
```

```bash
# git clone:
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
