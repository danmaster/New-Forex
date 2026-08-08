The optimization of the EA can be a very challenging task. Find below some optimization tips.

## General

### Platform

- Recommended platform for optimization tests is MT5 (which is significantly better, quicker, and has better tick processing), not MT4 (older, and no longer supported). Default broker tick data from MT5 is more reliable than MT4 data downloaded from _History center_ (not recommended for tick-based tests).
- For reliable backtesting/optimization in MT4, see: [[Backtesting in MT4]]. Basically you need to download tick data from broker and convert it to FXT/HST formats.
- The test results done in MT5 can be different to MT4 due to differences in data and tick processing and its algorithms, differences in indicator implementations, broker data and settings, and many more variables. So if you're optimizing in MT5 to run in MT4, verify your results back in MT4.

### Modelling

- Always compare or confirm the final setup with _Every tick_ modelling (not OHLC/Control points), as the results can be different.

### Make all trades equal

All trades along the test should be equal as possible, so they're not dependent on the previous success or rely on the current balance, so:

- Use fixed lots (e.g. set your lot size to the minimum like _0.01_), so the results are not influenced by auto increase.
- Use *Close time* to close trades after certain amount of time or number of candles, so you can find signals which are more reliable (not based on luck).

    If the trades are open for too long (Lite/Advanced), the conditions used to open the trade are no longer relevant (based on technical indicator data), so they cannot be trusted anymore (support, resistance and pivot points are different each day). Otherwise, you're relying your trading based on luck (not technicals) which won't repeat in the future.

### Make it simple

- Always test one strategy at a time. Then merge them at the final test.
- Avoid enabling any unnecessary params which can influence other params.

### Use large datasets

- When optimizing params, always test on the larger dataset giving your trades as much as possible scenarios and different market conditions. Recommended period is 2 years at least or more.

### Troubleshooting

- When you've less than 1 trade per day on average (especially on minute-based signals), that's a bad sign. Either your market data that you're using to test is not reliable, or you've enabled too many filters. In this case results can be not reliable.
- When your optimization tests are too slow, try to split into smaller parts. For quicker runs, try to use _1 minute OHLC_/_Control points_ modelling (not recommended) to have some rough idea which param values are better, but the results could not be reliable.

## Optimization

- **Avoid Over-Optimization**: Ensure that backtesting does not result in an over-optimized EA that performs exceptionally on historical data but fails in real-time trading. Use walk-forward optimization to test the EA's robustness.

Read more at:

- [How to pick & prioritize optimization parameters since we can't simply do all of them at once][GH-285].

[GH-285]: https://github.com/EA31337/EA31337/issues/285