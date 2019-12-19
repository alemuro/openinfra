nginx-install:
  pkg.installed:
    - pkgs:
      - nginx

nginx-config:
  file.managed:
    - name: /etc/nginx/sites-available/default
    - source: 'salt://nginx/templates/fathom.conf'
    - user: root
    - group: root
    - mode: 644
    - force: true