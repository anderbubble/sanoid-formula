# https://github.com/jimsalterjrs/sanoid/blob/master/INSTALL.md

include:
  - systemd.reload

https://github.com/jimsalterjrs/sanoid.git:
  git.detached:
    - target: /opt/sanoid
    - rev: {{ pillar['sanoid']['rev'] }}

/etc/sanoid:
  file.directory:
    - user: root
    - group: root
    - mode: 0755

/etc/sanoid/sanoid.defaults.conf:
  file.managed:
    - source: /opt/sanoid/sanoid.defaults.conf
    - user: root
    - group: root
    - mode: 0644
    - require:
      - git: https://github.com/jimsalterjrs/sanoid.git

/etc/sanoid/sanoid.conf:
  file.managed:
    - source: salt://sanoid/sanoid.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 0644

/etc/systemd/system/sanoid.service:
  file.managed:
    - source: salt://sanoid/sanoid.service
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - cmd: reload_systemd_configuration

/etc/systemd/system/sanoid-prune.service:
  file.managed:
    - source: salt://sanoid/sanoid-prune.service
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - cmd: reload_systemd_configuration

/etc/systemd/system/sanoid.timer:
  file.managed:
    - source: salt://sanoid/sanoid.timer
    - user: root
    - group: root
    - mode: 0644
    - watch_in:
      - cmd: reload_systemd_configuration

sanoid-prune.service:
  service.enabled:
    - enable: True
    - require:
      - file: /etc/systemd/system/sanoid-prune.service

sanoid.timer:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/sanoid.timer
