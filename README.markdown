[![Build Status](https://travis-ci.org/mkrakowitzer/puppet-bamboo.svg)](https://travis-ci.org/mkrakowitzer/puppet-bamboo)
#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with bamboo](#setup)
    * [What bamboo affects](#what-bamboo-affects)
    * [Beginning with bamboo](#beginning-with-bamboo)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

THIS MODULE IS CURRENTLY UNDER DEVELOPMENT

WORK IN PROGRESS

This is the puppet module for Atlassian Bamboo continious integration server. 

Bamboo does more than just run builds and tests. It connects issues, commits, test results, and deploys so the whole picture is available to your entire product team.

## Module Description

This module installs and configures Atlassian Bamboo continious integration server.

## Setup

### What bamboo affects

If installing to an existing Bamboo instance, it is your responsibility to backup your database. We also recommend that you backup your Bamboo home directory and that you align your current Bamboo version with the version you intend to use with puppet Bamboo module.

You must have your database setup with the account user that Bamboo will use. This can be done using the puppetlabs-postgresql and puppetlabs-mysql modules.

When using this module to upgrade Bamboo, please make sure you have a database/Bamboo home backup.

### Beginning with bamboo

The very basic steps needed for a user to get the module up and running. 

If your most recent release breaks compatibility or requires particular steps for upgrading, you may wish to include an additional section here: Upgrading (For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Put the classes, types, and resources for customizing, configuring, and doing the fancy stuff with your module here. 

## Reference

Here, list the classes, types, providers, facts, etc contained in your module. This section should include all of the under-the-hood workings of your module so people know what the module is touching on their system but don't need to mess with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

See CONTRIBUTING.md

## Contributors

See CONTRIBUTORS
