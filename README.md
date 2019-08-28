# train-telnet - Train Plugin for connecting via Telnet

This plugin allows applications that rely on Train to communicate via Telnet.

Of course you already know that this is an insecure protocol - but if you look
for this plugin, you probably have some specific needs. Right? If not, please
try the default SSH transport included in Train.

## Installation

You will have to build this gem yourself to install it as it is not yet on
Rubygems.Org. For this there is a rake task which makes this a one-liner:

```bash
rake install:local
```

## Transport parameters

| Option            | Explanation                  | Default          |
| ----------------- | ---------------------------- | ---------------- |
| `host`            | Hostname                     | (required)       |
| `user`            | Username to connect          | (required)       |
| `password`        | Password to connect          | (required)       |
| `port`            | Remote port                  | `23`             |
| `login_prompt`    | Username prompt on login     | `Username: `     |
| `password_prompt` | Password prompt on login     | `Password: `     |
| `setup`           | Commands to issue on open    | ` `              |
| `teardown`        | Commands to issue on close   | ` `              |
| `raw_output`      | Suppress stdout processing   | `false`          |
| `error_pattern`   | Regex to match error lines   | `ERROR.*`        |
| `prompt_pattern`  | Regex to match device prompt | `[-a-zA-Z0-9]+(?:\((?:config\|config-[a-z]+\|vlan)\))?[#>]\s*$` |

## Example use

This will work for a Cisco IOS XE device with Telnet enabled:
```ruby
require "train"
train  = Train.create("telnet", {
            host:     "10.0.0.1",
            user:     "username",
            password: "password",
            setup:    "terminal length 0\n",
            logger:   Logger.new($stdout, level: :info)
         })
conn   = train.connection
result = conn.run_command("show version\n")
conn.close
