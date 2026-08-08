## Requirements

You need to download and install:

- [Docker CE](https://www.docker.com/get-started).

To test your installation, run the following command in the terminal:

    docker run hello-world

## Backtesting

Each backtesting is achieved by running `docker` command followed by the container name ([`ea31337/ea-tester`](https://hub.docker.com/r/ea31337/ea-tester/)).

For example:

    docker run ea31337/ea-tester run_backtest -e TestEnvelopes -v

After running above command, the results should be printed on the terminal screen.

### Backtesting EA31337

    docker run ea31337/ea-tester:EURUSD-2019-DS run_backtest -v -e https://github.com/EA31337/EA31337/releases/download/v1.079/EA31337-Lite-v1.079.ex4

Here is the visual demo:

[![asciicast](https://asciinema.org/a/233268.svg)](https://asciinema.org/a/233268)

#### Backtesting specific version

1. Go to [release page](https://github.com/EA31337/EA31337/releases) and copy the link to `.ex4` file which you'd like to test, then follow above method by altering the command.

## Notes

Container homepage: [`ea31337/ea-tester`](https://hub.docker.com/r/ea31337/ea-tester/).

## Troubleshooting

- For help, run: `docker ea31337/ea-tester help`