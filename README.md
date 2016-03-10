# Comandi Devstack

The Comandi Devstack aims to provide a standardized development stack
that is mostly the same as the production environment.

## Usage

After the development stack is set up, you can use it. You will have the following URLs available:

 * [https://project.my.dev](https://project.my.dev) and others at `http://<project>.my.dev`.
 * [MailCatcher](http://mail.my.dev), which catches all mail sent from the dev enviromnent.

Furthermore, in order to use XDebug, you will need a browser extension:

 * [Chrome: Xdebug helper](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc)
 * [Firefox: The easiest Xdebug](https://addons.mozilla.org/en-US/firefox/addon/the-easiest-xdebug/)
 * or equivalent for other browsers (send a pull request if you want to include it!).

## Setting it up

There are quite a few steps to be taken to set up the development stack:

 1. Setting up VirtualBox and Vagrant 
 1. Set up DNS resolution
 1. Configure PHPStorm

## Building the base box

 * Download and install [Packer](https://www.packer.io/downloads.html)
 * Run `packer build debian-docker.json` in the `packer/` directory

## Setting up VirtualBox and Vagrant

 * First, download and install both [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/downloads.html).
 * Execute this command: `vagrant box add --name comandi-dev packer/debian-8.3.0-amd64_virtualbox.box`


## Set up DNS resolution

In order to reach the devstack, you need to make sure that your workstation can actually find the websites.
Therefore, you need to set up DNS resolution. This process differs between Windows and Mac/Linux.

### On Windows

*NOTE:* These instructions are untested!

Download and install [DNSAgent](https://github.com/stackia/DNSAgent/releases/latest).

Use the following in rules.cfg:

```
[
    {
        "Pattern": "^(.*\\.)?my\.dev$",
        "NameServer": "172.31.255.254"
    }
]
```


Run these commands on the command prompt:

```
netsh interface ip set dns name="Local Area Connection" source=static addr=none
netsh interface ip add dns name="Local Area Connection" addr=127.0.0.1 index=1
```


### On OS X

Create the directory `/etc/resolver` and add the file `/etc/resolver/my.dev` with the following line:

```
nameserver 172.31.255.254
```

### On Linux

Install dnsmasq. Add the following to the dnsmasq config file (usually in `/etc/dnsmasq`):

```
server=/my.dev/172.31.255.254
```

## Configure PHPStorm

### Configure deployment server

 1. Open the Settings dialog in PHPStorm
 1. Go to `Build, Execution, Deployment > Deployment`, and click on `+`.
 1. Give the name `Comandi Dev` and type `SFTP`.

On the _Connection_ tab:

 1. Set _SFTP host_ to `172.31.255.254` and _Root path_ to `/home/vagrant/src
 1. The username and password are both `vagrant`.
 1. Set _Web server root URL_ to `http://project.my.dev`

 On the _Mappings_ tab:

 1. Click on _Add another mapping_
 1. In the second row: find `project.my.dev` under _Local Path_ and _Deployment Path_ and set _Web Path_ also to `/`.

On the _Excluded Paths_ tab:

 1. Add deployment path `/cache`

Click _OK_ to save these settings.

 1. Click on the `Tools > Deployment > Automatic upload` menu item

### Update deployment settings

 1. Open `Tools > Deployment > Options`
 1. Uncheck `Overwrite Up-to-date files`
 1. Check the `Delete target...`, `Create empty directories` and `Prompt when overwriting...` options
 1. Set `Upload changed files...` to `Always`
 1. Check `Upload external changes`

### Configure run settings

 1. Open the `Run > Edit Configurations` menu item.
 1. Click on _+_ and choose the _PHP Web Application_ type.
 1. Enter the following values:
 
  * Name: `Comandi V1`
  * Server: `Comandi Dev`
  * Start URL: `/`
