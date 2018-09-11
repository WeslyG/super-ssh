# Super SSH 

#### From https://telegra.ph/Super-SSH-ili-moj-velosiped-dlya-komfortnoj-raboty-s-konsolyu-09-11

### Install 

##### Download 

```
curl https://raw.githubusercontent.com/WeslyG/super-ssh/master/sssh.sh --output sssh
```

##### Chmod

```
chmod +x sssh
```

##### Add to patch

for example copy sssh to /usr/local/sbin

```
cp ./sssh /usr/local/sbin
```

##### alias? 

vi ~/.bashrc

alias s='sssh'


### Usage

Super SSH

Usage:

ssh example:

s youre-machine-name

s youre-machine-name -p 8080


scp example

s file.txt my-vm:/tmp

s my-vm:/tmp/file.txt /tmp

s -p 23 my-vm:/tmp/file.txt /tmp


ssh tunnel example

s -N my-vm -L 3000:localhost:3000 -L 2000:localhost:2000
