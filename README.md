# CloudStack BOSH Cloud Provider Interface

## Bringing the world’s most popular open source platform-as-a-service to the world’s most popular open source infrastructure-as-a-service platform

This repo contains software designed to manage the deployment of Cloud Foundry on top of CloudStack, using Cloud Foundry BOSH. Say what?

## CloudStack

CloudStack is a collection of interrelated open source projects that, together, form a pluggable framework for building massively-scalable infrastructure as a service clouds.

## Cloud Foundry

Cloud Foundry is the leading open source platform-as-a-service (PaaS) offering with a fast growing ecosystem and strong enterprise demand.

## BOSH

Cloud Foundry BOSH is an open source tool chain for release engineering, deployment and lifecycle management of large scale distributed services. In this manual we describe the architecture, topology, configuration, and use of BOSH, as well as the structure and conventions used in packaging and deployment.

 * BOSH Source Code: https://github.com/cloudfoundry/bosh
 * BOSH Documentation: https://github.com/cloudfoundry/oss-docs/blob/master/bosh/documentation.md

## CloudStack and Cloud Foundry, Together using BOSH

Cloud Foundry BOSH defines a Cloud Provider Interface API that enables platform-as-a-service deployment across multiple cloud providers - initially VMWare's vSphere and AWS. We (Tongtech) implemented the CPI for CloudStack, opening up Cloud Foundry deployment to an entire ecosystem of public and private CloudStack deployments.

Using a popular cloud-services client written in Ruby, the CloudStack CPI manages the deployment of a set of virtual machines and enables applications to be deployed dynamically using Cloud Foundry. A common image, called a stem-cell, allows Cloud Foundry BOSH to rapidly build new virtual machines enabling rapid scale-out.
