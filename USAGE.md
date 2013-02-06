# BOSH CloudStack Cloud Provider Interface
# Copyright (c) 2012 Tongtech, Inc.


## Options

These options are passed to the CloudStack CPI when it is instantiated.

### CloudStack options

* `cloudstack_host` (required)
  Host of the CloudStack Manager server endpoint to connect to
* `cloudstack_port` (required)
  Port of the CloudStack Manager server endpoint to connect to
* `cloudstack_api_key` (required)
  CloudStack API key
* `cloudstack_secret_access_key` (required)
  CloudStack secret access key due to access API
* `cloudstack_scheme` (optional)
  CloudStack Manager server http/https model. Default is https
* `default_key_name` (required)
  default CloudStack ssh key name to assign to created virtual machines
* `default_security_groups` (optional)
  default CloudStack security group to assign to created virtual machines


### Registry options

The registry options are passed to the CloudStack CPI by the BOSH director based on the settings in `director.yml`, but can be overridden if needed.

* `endpoint` (required)
  CloudStack registry URL
* `user` (required)
  CloudStack registry user
* `password` (required)
  rCloudStack egistry password

### Agent options

Agent options are passed to the CloudStack  CPI by the BOSH director based on the settings in `director.yml`, but can be overridden if needed.

### Resource pool options

These options are specified under `cloud_options` in the `resource_pools` section of a BOSH deployment manifest.

* `instance_type` (required)
  which type of instance (CloudStack flavor Medium Instance|Small Instance|Large Instance) the VMs should belong to


### Network options

These options are specified under `cloud_options` in the `networks` section of a BOSH deployment manifest.
Network configure interface of BOSH CPI is unimplemented.


 

## Example

This is a sample of how CloudStack specific properties are used in a BOSH deployment manifest:

    ---
    name: sample
    director_uuid: 38ce80c3-e9e9-4aac-ba61-97c676631b91

    ...

    networks:
      - name: nginx_network
        type: vip
        cloud_properties: {}
      - name: default
        type: dynamic
        cloud_properties:
          security_groups:
          - default

    ...

    resource_pools:
      - name: common
        network: default
        size: 3
        stemcell:
          name: bosh-stemcell
          version: 0.0.
        cloud_properties:
          instance_type: "Medium Instance"

    ...

    properties:
      cloudstack:
        cloudstack_host: 168.1.43.14
        cloudstack_port: 8080
        cloudstack_api_key: hHdIgGdz6V-6I9Dc0dqhgUKutGJX-7_XTurvjd89SWAXPFiMZEy_Gb0uGfzbTyzS1rrdcwwZq81nxWS3UW8IcQ
        cloudstack_secret_access_key: zKao312dFgDKFdSI04Kh2axSuiWDXLDXj848GFxXRvRZPjiEuA6UfQq4uGdEHxrvuaYoNpv3_SBWfRqX6lPIwg
        cloudstack_scheme: http
        default_security_groups: ["default"]
        


## Example of micro bosh deployment(A successful deployement list):
---
name: micro-bosh-cloudstack-ly-0.0.1
network:
  name: nginx_network
  type: vip
  ip: 168.1.41.197
  cloud_properties: {}
resources:
  persistent_disk: Medium
  cloud_properties:
    instance_type: 'Medium Instance'
    disk: 5120
cloud:
  plugin: cloudstack
  properties:
    cloudstack:
      cloudstack_host: 168.1.41.1
      ssh_user: root
      ssh_password: root
      cloudstack_port: 8080
      cloudstack_api_key: "XX0jrqLQwAzwsctzzQDo_sR5TK04TcNBI0erFC7Hy8Zr_QVf-FwbSb-Tp7jPFfg1tvEnWkbQ1KDgr11ZpNBKSQ"
      cloudstack_secret_access_key: "XpbTAZFrLHQdO_ohdMW7PFNQjMBLbWpucNwtEgZJ5AwWdajPzpd7QY1b698fHVNBEgkPN3V4zgC1WnIG4RDyzQ"
      cloudstack_scheme: http
      default_security_groups: ["default"]
      zone_id: '594f2bca-fe25-49a5-a0af-d483f07e02ed'
    registry:
      endpoint: http://admin:admin@168.1.43.121:25889
      user: admin
      password: admin
    stemcell:
      url: 'http://168.1.41.105/micro-bosh.vhd.bz2'
env:
  bosh:
    password: c1oudc0w
    
## Example of cloudfoundry deployment list.

---
name: bosh
director_uuid: 64f85692-d6ae-4a44-8359-ea17fc0330ca
release:
  name: bosh-dev
  version: 10.5-dev
networks:
- name: default
  type: dynamic
  cloud_properties: {}
- name: dynamic
  type: dynamic
  cloud_properties: {}
resource_pools:
- name: small
  stemcell:
    name: bosh-stemcell
    version: 0.0.1
  network: default
  size: 7
  cloud_properties:
    disk: 5120
    instance_type: 'Small Instance'
  env:
    bosh:
      # password generated using mkpasswd -m sha-512
      password: $6$66pTgip9$1FgWAj2uKEUUQj1cnJKXm9xdnhd.jJKmERB/o4Mc/8PPOp8ba6zysz0OfXxV0
update:
  canaries: 1
  canary_watch_time: 60000
  update_watch_time: 60000
  max_in_flight: 1
  max_errors: 2
compilation:
  workers: 4
  network: dynamic
  cloud_properties:
    instance_type: 'Small Instance'
    disk: 5120
jobs:
- name: nats
  template: nats
  instances: 1
  cloud_properties: {}
  resource_pool: small
  networks:
  - name: default
- name: postgres
  template: postgres
  instances: 1
  resource_pool: small
  networks:
  - name: default
- name: redis
  template: redis
  instances: 1
  resource_pool: small
  #persistent_disk: 5120
  networks:
  - name: default
- name: director
  template: director
  instances: 1
  resource_pool: small
  persistent_disk: 5120
  networks:
  - name: default
- name: blobstore
  template: blobstore
  instances: 1
  resource_pool: small
  persistent_disk: 5120
  networks:
  - name: default
- name: health_monitor
  template: health_monitor
  instances: 1
  resource_pool: small
  networks:
  - name: default
- name: cloudstack_registry
  template: cloudstack_registry
  instances: 1
  resource_pool: small
  networks:
  - name: default
properties:
  env:
    #http_proxy: "http://<proxy>"
    #https_proxy: "http://<proxy>"
    #no_proxy: ""
  blobstore:
    port: 25251
    backend_port: 25552
    agent:
      user: root
      password: password
    director:
      user: root
      password: password
  networks:
    apps: default
    management: default
  nats:
    user: root
    password: password
    port: 4222
  postgres:
    user: root
    password: password
    port: 5432
    database: bosh
  redis:
    port: 25255
    password: password
  director:
    name: bosh_director
    port: 25555
  hm:
    http:
      port: 25923
      user: root
      password: password
    director_account:
      user: root
      password: password
    intervals:
      poll_director: 60
      poll_grace_period: 30
      log_stats: 300
      analyze_agents: 60
      agent_timeout: 180
      rogue_agent_alert: 180
    loglevel: debug
    plugins:
      name: email
      options:
        recipients:
          zhanggl@tongtech.com
        smtp:
          from: applaud_test@163.com
          host: smtp.163.com
          port: 25
          auth: plain
          user: applaud_test
          password: tongweb123
          domain: localdomain
  cloudstack_registry:
      http:
        port: 25777
        user: admin
        password: admin
  cloudstack:
      cloudstack_host: 168.1.41.1
      ssh_user: root
      ssh_password: root
      cloudstack_port: 8080
      cloudstack_api_key: "XX0jrqLQwAzwsctzzQDo_sR5TK04TcNBI0erFC7Hy8Zr_QVf-FwbSb-Tp7jPFfg1tvEnWkbQ1KDgr11ZpNBKSQ"
      cloudstack_secret_access_key: "XpbTAZFrLHQdO_ohdMW7PFNQjMBLbWpucNwtEgZJ5AwWdajPzpd7QY1b698fHVNBEgkPN3V4zgC1WnIG4RDyzQ"
      cloudstack_scheme: http
      default_security_groups: ["default"]
      zone_id: '594f2bca-fe25-49a5-a0af-d483f07e02ed'
  stemcell:
      url: 'http://168.1.41.105/micro-bosh.vhd.bz2'
      zoneid: 'c3dafbd3-6823-43e1-8a07-371753fa6093'
env:
  bosh:
    password: c1oudc0w
