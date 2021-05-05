# macOS Configuration

[![CircleCI](https://circleci.com/gh/matteocodogno/mac_os-config.svg?style=svg)](https://circleci.com/gh/matteocodogno/mac_os-config)

Shell scripts for customized macOS machine setup and configuration.

This project provides a highly opinionated default configuration built upon the
[macOS](https://www.alchemists.io/projects/mac_os) project. Should the configuration provided by
this project not be to your liking, feel free to fork and customize for your specific needs.

## Features

Due to the amount of tooling used, the following features are broken down into subsections for
easier navigation.

### Homebrew Formulas

Installs the following link:https://brew.sh[formulas]:

### Homebrew Casks

Installs the following link:https://brew.sh[casks]:

### App Store Applications

Installs the following link:https://www.apple.com/app-store[App Store] applications:


### Non-App Store Applications

Installs the following macOS applications which are not located in the App Store:

### Application Extensions

Installs the following extensions to existing applications:


### Node Packages

Installs the following link:https://nodejs.org[Node] link:https://www.npmjs.com[packages]:



## Setup

To install, run:

```bash
git clone https://github.com/matteocodogno/mac_os-config.git
cd mac_os-config
git checkout 18.1.1
```

## Usage

The following will walk you through the steps of installing/re-installing your machine.

### Pre-Install

Double check you have the following in place:

- Ensure a backup of your Apple, NAS, backup, and Dropbox credentials are available.
- Ensure a recent backup of your machine exists and works properly.
- Ensure Xcode installed per macOS requirements.
- Ensure link:https://support.apple.com/en-us/HT208198[Startup Security Utility] is disabled.
  - Turn on or restart your machine then press and hold `POWER` (Silicon) or `COMMAND + R` (Intel) buttons immediately upon boot or restart.
  - Select Utilities → Startup Security Utility from the main menu.
  - Select _Secure Boot: No Security_.
  - Select _External Boot: Allow booting from external media_.
  - Click _Turn Off Firmware Password_.
  - Quit the utility and restart the machine.
- You are now ready to boot your system with the macOS Boot Disk, erase/format your drive, and start
the install process.

### Install

See the [macOS](https://www.alchemists.io/projects/mac_os#_usage) project for usage as it
provides the command line interface for running the configuration defined by this project.

### Post-Install

The following are additional steps, not easily automated, that are worth completing after the
install scripts have completed:

- System Preferences
  - Apple ID
    - Configure iCloud.
    - Enable Find My Mac.
  - Security & Privacy
    - General
      - Require password immediately after sleep or screen saver begins.
      - Enable message when screen is locked. Example: `<url> | <email> | <phone>`.
      - Allow your Apple Watch to unlock your Mac.
    - FileVault
      - Enable FileVault and save the recovery key in a secure location (i.e. 1Password).
    - Firewall
      - Enable.
      - Automatically allow signed software.
      - Enable stealth mode.
  - Internet Accounts
    - Add all accounts.
  - Touch ID
    - Rename fingerprint.
  - Keyboard
    - Keyboard
      - Slide _Key Repeat_ to _Fast_ (max).
      - Slide _Delay Until Repeat_ to _Short_ (max).
    - Shortcuts
      - Select _Launchpad and Dock_ and uncheck _Turn Dock Hiding On/Off_.
      - Select _Mission Control_ and assign `CONTROL + OPTION + COMMAND + N` to _Show Notification Center_.
      - Select _Screenshots_ and uncheck all boxes.
  - Desktop and Screen Saver
    - Select _Desktop_, click `+`, and choose custom image.
    - Select _Screen Saver_, select _Message_, enter custom message, start after 10 minutes, and check _show with clock_.
  - Bluetooth
    - Reconnect keyboard, mouse, and earbuds.
  - Network
    - Configure Wi-Fi.
  - Printers & Scanners
    - Add printer/scanner.
  - Users & Groups
    - Update avatar image.
    - Remove unused login items.
    - Disable guest account.
  - Wallet and Apple Pay
    - Reenable all accounts and assign default card.
  - Sound
    - Sound Effects
      - Uncheck _Play sound on startup_.
      - Uncheck _Play user interface sound effects_.
    - Battery
      - Click on _Battery_ and uncheck _Show battery status in menu bar_.
      - Click on _Power Adapter_ and check _Prevent computer from sleeping automatically when the display is off_.
  - Notifications
    - Do Not Disturb
      - Enable _Do Not Disturb_ from 9pm to 7am.
      - Enable _When display is sleeping_.
      - Enable _When screen is locked_.
      - Enable _When mirroring_.
      - Disable _Allow calls from everyone_.
      - Enable allow repeated calls.
    - Applications
      - Select _Banners_ for all apps.
      - Disable _Show notifications on lock screen_.
      - Disable _Play sounds for notifications_.
- Ensure link:https://support.apple.com/en-us/HT208198[Startup Security Utility] is enabled.
  - Restart your machine then press and hold `COMMAND + R` immediately after seeing the Apple logo.
  - Select _Secure Boot: Full Security_.
  - Select _External Boot: Disallow booting from external or removable media_.
  - Click _Turn On Firmware Password_.
  - Quit the utility and restart the machine.

### Keyboard Shortcuts

Several applications provide global hotkey support. These are the associations I use (which are also
captured in the `restore.bom` as well):

### Newsyslog

Native to macOS, [newsyslog](https://www.freebsd.org/cgi/man.cgi?newsyslog.conf(5)) can be used
to configure system-wide log rotation across multiple projects. It’s a good recommendation to set
this up so that disk space is carefully maintained. Here’s how to configure it for your system,
start by creating a configuration for your projects in the `/etc/newsyslog.d` directory. In my
case, I use the following configurations:

`/etc/newsyslog.d/alchemists.conf`

```
  # logfilename                                            [owner:group]    mode   count   size  when  flags
  /Users/matteocodogno/Dropbox/Development/Work/**/log/*.log                    644    2       5120  *     GJN
```

`/etc/newsyslog.d/homebrew.conf`

```
  # logfilename                   [owner:group]    mode   count   size    when  flags
  /usr/local/var/log/**/*.log                      644    2       5120    *     GJN
```

These configurations ensure that logs are rotated every 5MB (5120KB). In order to test that these
configurations are valid, run:

```
sudo newsyslog -nvv
```

If you don’t see any errors in the output, then your configuration settings are correct.

The last thing to do is to add a launch configuration to ensure the log rotations happen at
regularly scheduled intervals. To do this create the following file:
`$HOME/Library/LaunchAgents/com.apple.newsyslog.plist`. It should have the following content:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.apple.newsyslog</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/sbin/newsyslog</string>
  </array>
  <key>LowPriorityIO</key>
  <true/>
  <key>Nice</key>
  <integer>1</integer>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Minute</key>
    <integer>30</integer>
  </dict>
</dict>
</plist>
```

That’s it. System-wide log rotation is setup for your projects.

### Customization

While this project’s configuration is opinionated and tailored for my setup, you can easily fork
this project and customize it for your environment. Start by editing the files found in the `bin`
and `lib` directories. Check out the
[macOS Customization Documentation](https://www.alchemists.io/projects/mac_os/#_customization)
for further details.

> _TIP_: The installer determines which applications/extensions to install as defined in the
> `settings.sh` script. Applications defined with the "`APP_NAME`" suffix and extensions defined
> with the "`EXTENSION_PATH`" suffix inform the installer what to care about. Removing/commenting out
> these applications/extensions within the `settings.sh` file will cause the installer to skip these
> applications/extensions.

## Development

To contribute, run:

```bash
git clone https://github.com/matteocodogno/mac_os-config.git
cd mac_os-config
```

## Versioning

Read [Semantic Versioning](https://semver.org) for details. Briefly, it means:

* Major (X.y.z) - Incremented for any backwards incompatible public API changes.
* Minor (x.Y.z) - Incremented for new, backwards compatible, public API enhancements/fixes.
* Patch (x.y.Z) - Incremented for small, backwards compatible, bug fixes.

## Contributions & Code of Conduct

Read [CONTRIBUTING](./CONTRIBUTING.md) for details.

## License

Read [LICENSE](./LICENSE.md) for details.

## History

Read [CHANGES](./CHANGELOG.md) for details.

## Credits

Engineered by [Brooke Kuhlmann](https://www.alchemists.io/team/brooke_kuhlmann).
