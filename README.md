# iTerm2 Touchbar Party

iTerm2 Touchbar Party is a combination of scripts that make your Mac's Touchbar userful when using iTerm2.

![iTerm2 Touchbar Party Preview](./preview.png)

## Installation

### Homebrew Installation (Preferred)

1. Tap the i2tp repository
    ```shell
    brew tap snooc/iterm2-touchbar-party
    ```

2. Run brew install
    ```shell
    brew install iterm2-touchbar-party
    ```

3. Add i2tp to your `.bash_profile`
    ```shell
    if [[ -f "/usr/local/opt/iterm2-touchbar-party/share/iterm2-touchbar-party.sh" ]]; then
        source "/usr/local/opt/iterm2-touchbar-party/share/iterm2-touchbar-party.sh"
        export PROMPT_COMMAND="__i2tp"
    fi
    ```

### Manual Installation (Using git)

1. Clone this repository
    ```shell
    git clone git@github.com:snooc/iterm2-touchbar-party.git
    ```
2. Source `iterm2-touchbar-party.sh` and add i2tp to your `PROMPT_COMMAND` in `~/.bash_profile`
    ```shell
    source path/to/iterm2-touchbar-party.sh
    export PROMPT_COMMAND="__i2tp"
    ```

## Configuration

i2tp offers a few basic configuration options to configure the status bar display. These options may be set in your
using the `export` shell command in your `.bash_profile` (before or after the `source` and `PROMPT_COMMAND`, as i2tp
runs just before your bash prompt displays.)

#### Example:

```shell
export I2TP_STATUS_GIT=false
```

### Configuration Options

Name | Description | Values | Default Value
---- | ----------- | ------ | -------------
`I2TP_STATUS` | Enable/disable status display | `true`/`false` | `true`
`I2TP_STATUS_PWD` | Enable/disable displaying current working directory | `true`/`false` | `true`
`I2TP_STATUS_GIT` | Enable/disable displaying current git branch | `true`/`false` | `true`
`I2TP_STATUS_KUBERNETES` | Enable/disable displaying current Kubernetes context | `true`/`false` | `true`

## License

[MIT License](./LICENSE)
