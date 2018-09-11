# Super SSH 

## From https://telegra.ph/Super-SSH-ili-moj-velosiped-dlya-komfortnoj-raboty-s-konsolyu-09-11

### Install 

##### Download 

```
curl https://github.com/WeslyG/super-ssh/sssh.sh
```

##### Chmod

```
chmod +x sssh.sh
```

##### Add to patch

for example copy sssh.sh to /usr/local/sbin

```
cp ./sssh.sh /usr/local/sbin
```

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