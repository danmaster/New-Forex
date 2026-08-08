
## Parameters

The EA provides the following basic input parameters.

### Active strategy

-   **Strategy on M(X)** (enum) - Activates the selected strategy on the given M(X) timeframe.

    Default configuration of strategies is optimized for EURUSD. If you use EA on different symbol or change default strategies, you've to backtest EA to ensure it's still producing the expected results.

-   **Filter** (int) (Advanced/Rider only) - Sets filter for active strategies. Its combined bitwise sum tells EA which strategies needs to be active.

    This parameter is useful during optimization. It allows you to identify less performant strategies. Use it at the end of your optimization process to validate your configuration.

    By default 2047 will keep all active strategies active (it won't filter anything). If you set to 0, it's going to filter all of them (resulting in 0 trades).
    To activate specific strategies, you set the sum of their corresponding filter number that you want to activate (where 2047 means all of them).
    For example if you want to enable only 2nd M5 and 4th M30 strategy, you set the value to 10 (2+8).

    Please note that the filters takes always precedence. That means your strategies are going to be filtered if value is set below 2047, no matter what you've set elsewhere.

### Risk Management

-   **Max margin to risk** (float) - Sets percentage of account's margin to risk. When reached based on equity, no new orders are opened.

### Trade Parameters

-   **Lot size** (float) - Sets a size for each newly opened orders/positions (trading volume).

    Default 0 for auto calculation based on the available account's margin. It's strongly not recommended to change it to higher values as this may generate huge losses in the short amount of time. Change this at your own risk.

-   **Max spread to trade** (float) - Maximum spread to allow new orders to be opened (in pips, set 0 to disable).

    Normally 1 pip is equivalent to 10 points on 5-digit quotes and to 1 point on 4-digit quotes.
-   **Starting EA magic number** - Unique number assigned to EA's strategies.

    Change this number when running multiple EAs on the same account at least by few thousands, since each strategy has its own number assigned per each timeframe to be able to identify their own trades for independent management. For example 100 strategies on 20 different timeframes are going to use around 2000 magic numbers starting from the number being set by user.

### Logging

-   **Level of log verbosity** (enum) - Sets verbosity level of printed/logged messages.

    Use it if you want to print debug or trace messages. This is only useful when you're debugging EA. This doesn't affect trading in any way.
    When debug mode is activated, list of strategies and their stats are going to be listed on the chart.

-   **Display EA details on chart** (bool) - Activates detailed statistics on the chart. It's enabled by default.

    It's enabled by default for the visual mode. When doing non-visual backtesting or optimization, it gets disabled automatically for performance reasons. The only reason you may want to disable it, is when its printing text overlaps with another EA or indicator, or it's obfuscating your chart view.

### Signal filters (Advanced, Rider, Elite)

The following shared parameters are used in *Advanced*, *Rider* and *Elite* versions.

-   **Signal Open Filter** [SOF] (int) - Sets a trading open signal filter for all strategies.

    - 0 - disabled
    - 1 - avoid opening multiple trades in the same strategy's candle
    - 2 - open trades only with the main trend
    - 4 - open trades when price is above pivot point of the current strategy's candle
    - 8 - do not open trades when there are opposite active trades (hedging)
    - 16 - open trades only on candle's peak prices
    - 32 - do not open trades when there are better one already opened in the same direction
    - 64 - do not open trades when account's equity is lower than 1%
    - -64 - do not open trades when account's equity is higher than 1%

    Notes:
    - To combine filters, set the sum.
    - When combining filters by a sum, OR operation applies.
    - Negative values will negate filter.


-   **Signal Close Filter** [SCF] (int) - Sets a trading close signal filter for all strategies.

    - 0 - disabled
    - 1 - avoid closing multiple trades in the same strategy's candle
    - 2 - avoid closing trades in the direction with the main trend
    - 4 - avoid closing trades when price is above pivot point of the current strategy's candle
    - 8 - close trades only when open price is below or above the previous highs/lows
    - 16 - close trades only on candle's peak prices
    - 32 - avoid closing trades when there are better one already opened in the same direction
    - 64 - avoid closing trades when account's equity is not higher than 1%
    - -64 - avoid closing trades when account's equity is not lower than 1%

    Notes:
    - To combine filters, set the sum.
    - When combining filters by a sum, OR operation applies.
    - Negative values will negate filter.

-   **Signal Time Filter** (int) - Sets a market hours trading filter for all strategies. When 0, filter is disabled.

    - 0 - disabled
    - 1 - CHGO: Chicago's trading hours (14-23 GMT)
    - 2 - FR: Frankfurt's trading hours (7-16 GMT)
    - 4 - HK: Hong Kong's trading hours (1-10 GMT)
    - 8 - LON: London's trading hours (8-17 GMT)
    - 16 - NY: New York's trading hours (13-22 GMT)
    - 32 - SYD: Sydney's trading hours (22-7 GMT)
    - 64 - TYJ: Tokyo's trading hours (0-9 GMT)
    - 128 - WGN: Wellington's trading hours (22-6 GMT)

    Notes:
    - To combine filters, set the sum (e.g. 24 value will apply London and New York hours at the same time).
    - When combining filters by a sum, by default OR operation applies.
    - Negative values will negate filter. E.g. -8 won't trade on London's market hours.

<!-- // Not implemented in v3.000

-   **Signal Strategy Filter** (int) - Sets a strategy filter for additional signal verification.

    - 0 - disabled
    - 1 - on multiple signals per timestamp, only first is processed
    - 2 - minute-based strategies can only open trades on confirmed signal from any of hour-based strategies

    Notes:

    - To combine filters, set the sum (e.g. 3 will apply 1st and 2nd filter at once).
    - Available only in v2.013 and v2.005.
-->

-   **Signal Tick Filter** (int) - Sets a tick filter (which ticks should be processed). When 0, filter is disabled.

    - 0 - process all ticks
    - 1 - ticks on every each minute are processed
    - 2 - low and high ticks of the bar are processed
    - 4 - peak prices of each minute are processed
    - 8 - unique ticks are processed (avoid duplicates)
    - 16 - ticks in the middle of the bar/candle
    - 32 - bar open price ticks
    - 64 - every 10th of the bar/candle
    - 128 - process tick on every 10 second
    - Note: When combining filters by a sum, OR operation applies for positive values, AND for negative.

    Notes:

    - To combine filters, set the sum (e.g. 3 will apply 1 and 2 at once).
    - Positive values combines tick filters using AND operator, negative values with OR operator. So with AND operator, some combinations are exclusive, therefore not producing any trades.

<!-- // Not implemented in v3.000

-   *S-Filter* - *Strategy filter* (int) - Sets a strategy filter (which strategies should be activated).

    - 0 - Disables all strategies.
    - 1 - Enables only strategy on M1.
    - 2 - Enables only strategy on M5.
    - 4 - Enables only strategy on M15.
    - 8 - Enables only strategy on M30.
    - 16 - Enables only strategy on H1.
    - 32 - Enables only strategy on H2.
    - 64 - Enables only strategy on H3.
    - 128 - Enables only strategy on H4.
    - 256 - Enables only strategy on H6.
    - 512 - Enables only strategy on H8.
    - 1024 - Enables only strategy on H12.
    - 2047 - Enables all above strategies.

    Notes:

    - To combine strategies, set the sum (e.g. 3 will apply 1st and 2nd strategy at once).
    - When 2047 is set, it means all, because it's a sum of all of the above.
    - This filter is useful for optimization test to find the best configuration of strategies and identify which ones are the weakest.
    - Hint: Do not forget to reset it back to 2047 when you finish optimization to avoid confusion which one are disabled and which are not.
    - Hint: To find the best enabled M-based strategies, optimize between 2032 and 2047.
-->

### Tasks (Advanced & Rider)

The following condition-action based tasks parameters are used in *Advanced* and *Rider*.

-   **X: Task's condition** (enum) - Sets a condition to check.
-   **X: Task's to execute** (enum) - Sets an action to execute when the above condition is met.

    For example, you can configure a task to close all active trades when EA's equity reaches certain %.

-   **Tasks' Filter** (int) - Sets filter for active tasks. Its combined bitwise sum tells EA which tasks needs to be active.

    This parameter is useful during optimization. It allows you to identify misbehaving tasks. Use it at the end of your optimization process to validate your configuration.

    By default 31 will keep all active tasks active (it won't filter anything). If you set to 0, it's going to filter all of them.
    To activate specific tasks, you set the sum of their corresponding filter number that you want to activate (where 31 means all of them).
    For example if you want to enable only 2nd and 4th tasks, you set value to 10 (2+8).

    Please note that the filters takes always precedence. That means your tasks are going to be filtered if value is set below 31, no matter what you've set elsewhere.

### Orders' limits (Advanced)

The following parameters are *Advanced* specific.

<!--
-   **EA's Stops on M(X)** (enum) - Overrides trailing stop method to be controlled by the given strategy for the given timeframe.
    Default: (None) - which means to not override the stops and use the current strategy stops.
-->

-   **Close loss** (float) - Sets a maximum fixed closing loss (in pips) for each opened order.

    It allows you to close orders before their original targets set by strategies.When this value is positive, orders are going to be automatically closed in loss when reaching X number of pips for the given order. Setting it at certain levels prevents orders from generating too much loss. These configured stop-loss values are hidden from your broker and are internally tracked by EA (stealth mode). To disable this functionality, set to 0.

-   **Close profit** (float) - Sets a maximum fixed closing profit (in pips) for each opened order.

    It allows you to close orders before their original targets set by strategies. When this value is positive, orders are going to be automatically closed in profit when reaching X number of pips for the given order. Setting it at certain levels prevents orders from missing its original take profit levels. These configured take-profit values are hidden from your broker and are internally tracked by EA (stealth mode). To disable this functionality, set to 0.

-   **Close time** (int) - Sets a closing time for each opened orders.

    When value is positive, the value is set in minutes, otherwise when value is negative, it sets number of bars.
    Time is tracked individually for each opened order.
    For example to close orders after 24h, set it to 1440. To close orders after 10 candles, set it to -10 (which means 10 candles for strategy on M1 timeframe - 10 minutes; 10 candles for strategy on H1 timeframe - 10 hours).

### Strategies' stops

The following parameters are *Rider* specific.

-   **Stop loss strategy** (enum) - Sets trailing stop method to be controlled by the given strategy.
-   **Stop loss timeframe** (enum) - Sets a timeframe for the selected trailing stop.