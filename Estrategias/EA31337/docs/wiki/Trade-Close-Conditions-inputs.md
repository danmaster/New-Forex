
![image](https://github.com/EA31337/EA31337/assets/15697629/9967135a-6ed8-4efc-9698-9ce5bad1e368)


There are a few ways how trades can be closed automatically.

* Close loss/profit input parameters (when set to non-zero value). These values works in stealth mode, checked periodically, so not visible on SL/TP). Set it to zero to disable.
* Close time input parameter (when set to non-zero value) which closes trades based after selected time or number of candles. Set it to zero to disable.
* EA's tasks (Advanced and Rider): Orders are closed when action based on condition is met. To disable, disable closing actions or use tasks' filter (Advanced).
* Opposite signal of the strategy. E.g. when strategy signals Buy, all managed Sell orders from that strategy for the given timeframe are closed and other way round (Sell signal closes Buys). To postpone closure of that kind, you can set Close Filter to non-zero value, which will close trades based on the selected filters. To completely disable opposite signals, this should be disabled as part of the strategy (code only) as of now.
* Closure on SL/TP which is calculated by the given strategy based on the main indicator values. For example, MA strategy could close orders when price hits MA line, Bands and Envelopes strategies on price hitting its bands. Basically it's an integral part of each strategy logic.

To identify how the trade was closed, you should look at the trade's closure comment.