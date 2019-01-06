# rctf-scenario4

The Robotics Capture the Flag (RCTF) is an online playground to challenge robot security from your browser. It is designed to be an online game, available 24/7, launchable through your browser and designed to learn robot hacking step by step.

## Play online
Go to https://rctf.aliasrobotics.com and select scenario 4.

### Run it locally
Do you prefer to experimient locally, we've dockerized it for you. Try:

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
