# rctf-scemario4

## How to run it?

### Download and compile the image:

```bash
git clone https://github.com/aliasrobotics/rctf-scenario4
cd rctf-scenario4
docker build -t rctf-scenario4 .
```

### Play with the scenario:

#### In one terminal:

```bash
docker run -it -p 8080:8080 rctf-scenario4
```

#### In another terminal, list the current running docker images, select the image id for the rctf-scenario4 and run it:

```bash
docker ps
----------
 CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
caccd5e51f6f        rctf-scenario4           "/root/launch_script…"   8 minutes ago       Up 8 minutes        0.0.0.0:8080->8080/tcp, 11345/tcp   stupefied_nightingale
-----------
docker exec -it caccd5e51f6f bash
```

#### Check the simulation, open a web browser and copy the following URL:

```bash
127.0.0.1:8080
```
