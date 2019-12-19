fathom-user:
  user.present:
    - name: fathom
    - fullname: fathom
    - shell: /bin/bash
    - home: /opt/fathom/

fathom-download:
  cmd.run:
    - name: |
        wget https://github.com/usefathom/fathom/releases/download/v1.2.1/fathom_1.2.1_linux_amd64.tar.gz -O /tmp/fathom.tar.gz \
        && tar -C /usr/local/bin -xzf /tmp/fathom.tar.gz \
        && chmod +x /usr/local/bin/fathom
    - unless: ls /usr/local/bin/fathom

fathom-service:
  file.managed:
    - name: /etc/systemd/system/fathom.service
    - source: 'salt://fathom/templates/fathom.service'
  service.enabled:
    - name: fathom

fathom-config:
  file.managed:
    - name: /opt/fathom/.env
    - source: 'salt://fathom/templates/fathom.conf'
    - user: fathom
    - group: fathom
    - makeDirs: true