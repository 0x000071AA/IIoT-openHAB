Future Tasks:
- Proxy for Docker Deamon Socket (= Kubernetes Security Policies)
- Security: Influxdb Image is run as root
- Create seperate user in Dockerfile?
- Backup Swarm
- Backup openHAB

Influxdb config:
  influxdb:
    image: docker.io/influxdb:latest
    environment:
      - INFLUXDB_DB=prometheus
    volumes:
      - ./influxdb.conf:/etc/influxdb/influxdb.conf
    command:
      - '-config'
      - '/etc/influxdb/influxdb.conf'


Sources:

- https://github.com/openhab/openhab-docker/blob/master/2.5.9/debian/Dockerfile

- https://cloud.google.com/solutions/best-practices-for-building-containers

- https://github.com/Tecnativa/docker-socket-proxy/blob/master/haproxy.cfg
	
- https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html
	
- https://pythonspeed.com/articles/root-capabilities-docker-security/

- https://docs.influxdata.com/kapacitor/v1.5/nodes/swarm_autoscale_node/


TODO:

Crete non root USER in Dockerfile!
checck docker volumes best practise


Fekgm7Gi -> 8 * 62 -> ld(62)*8 -> 5,95*8

log10(x)/log10(2)

000000000000000000000000000000000000000000000000000001100001011101000010000001100100011000010111011101101110 -> m
100111100001110001011111011100001010011001011010110001010001100101000101100011100111111001010011111100110110 -> c (09e1c5f70a65ac519458e7e53f36)
100111100001110001011111011100001010011001011010110000110000111000000111100010000011100001000100100001011000 -k (9E1C5F70A65AC30E07883844858)