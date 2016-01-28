default_packages:
    pkg.installed:
        - pkgs: {{ pillar.get('default_packages', []) }}