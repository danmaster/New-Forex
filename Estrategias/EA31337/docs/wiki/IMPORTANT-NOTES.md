Please trade responsively and follow the following safety hints to avoid any surprises.

### Basics

- **Do not expect this or any EA to solve your financial problems, it won't.** No system, including this EA, is the "holy grail" of trading; it's a tool that requires understanding, strategy, and risk management to potentially yield success. Remember, Forex is the world's largest financial market, where you're up against the largest banks and seasoned professionals.
- **Do not invest money you cannot afford to lose.**
- **Familiarize yourself with the EA** and its settings. This isn't a 'set and forget' tool. Understanding how to operate it is crucial, akin to learning how to drive a high-performance car.
- **Test before use.** We strongly recommend taking time to backtest thoroughly first across different scenarios, and demo trade for several weeks (do not rush), to deeply understand understand functionality and performance before risking any capital.

### Risk Management

- **Always conduct backtesting** with current settings for several weeks before transitioning to live trading.
- **Avoid manual trading** if you lack experience or struggle with trading stress. Let the EA handle the trades unless you're confident in your skills.
- **Resist manually increasing lot sizes or risk settings** even during successful streaks. The EA will adjust these as your balance grows. Remember, Forex markets can be deceptively calm before volatile movements.
- **Realistic expectations are important.** With sensible goals, hard work educating yourself, and risk management awareness - tools like this can assist skilled traders in developing their own methodologies.

### Backtesting & Optimization

- **Backtest results are not future predictions.** They are for risk management and strategy adaptability analysis. It demonstrates how well EA can manage the risk and adjust to different market conditions in general. Past results are no guarantee of future performance.
- **Backtest results can vary.** The outcomes depend on various factors: account leverage, deposit, broker's spread and commissions, contract/lot sizes, symbol's parameters like EURUSD and many more.
- **Higher market spreads can lead to more losses**, especially during volatility when spreads might widen. Optimal spread is 1 pip or less, with a maximum of 2 pips for viable trading. Spreads can be broker specific.
- **MetaTrader 4 Backtesting**: Use the M1 timeframe for backtesting to process more data points. Otherwise use MetaTrader 5 for better backtest reliability.
- **When backtest results are poor, reassess your method** or consider optimization. Proper backtesting can be complex; ensure your approach is reliable.
- Check [[Backtesting|Home#backtesting]] docs for further details.

### Real-Time Trading

- **Ensure continuous operation on a VPS** for reliability. Avoid frequent restarts as this can reset important statistical data affecting strategy performance.
- **Profits cannot be guaranteed**. Test on a demo for weeks to ensure the EA performs to your satisfaction before going live.
- **Timeframe independence**: You can attach the EA to any chart timeframe as it can processes data independently.
- **Use EA on EURUSD only** unless you've optimized and backtested for other pairs or are testing on a demo.
- **When running multiple EAs on the same account** (which is strongly not recommended), ensure magic numbers in the parameters are different to avoid conflicts, otherwise it can significantly affect trades. Further more, running multiple EAs can affect strategies and their logic, because some can rely on the account equity and free margin left to calculate the risk and lot sizes. Since they both sharing the same account (same balance and equity), when one EA starts losing (generating larger drawdown), another one could trigger unnecessary safety measures due to account underperformance situation, or even worse, it is going to stop trading till margin gets back to normal levels.
- **It is strongly recommended to run EA on EURUSD pair only.** Unless you did successful optimisation work to perform on other pairs, or you're running it on the demo account. For multi-currency trading using one EA, you could use EA31337 Elite.

### Broker

- **Adjust leverage according to your risk tolerance.** Account leverage increases both potential gains and risks. E.g. high leverage like 1:200 means doubled profits, but also doubled losses.
- **Be aware of scam brokers.** Always check your broker at [FPA](http://www.forexpeacearmy.com/). Especially, when they communicate with you via chat or calling you often on your mobile, promising amazing results, and their website doesn't have any numbers that you can actually call for support, most likely your broker is a scam. If you're not sure, check reviews about them (not the fake ones), validate their address and contact numbers (by actually calling them). Ask them if they're financially regulated and to send you the proof. It's difficult to spot scammers these days (they're good at it), especially if you're not experienced enough, so do the proper research about them, it won't hurt.
- **Beware of high spreads**; they can erode profits significantly, especially during volatile periods and economic events. In general, **avoid high-spread accounts** above 2 pips unless optimized for such conditions. Normally 1 pip is equivalent to 10 points on 5-digit quotes and to 1 point on 4-digit quotes (in majority of the pairs). **High broker spreads can kill your profits gradually.** Therefore monitor EA during high volatility period and be aware of how your broker's spread changes during different periods.
- **Ensure your broker supports hedging**, as the EA requires this feature to function correctly. **If your broker doesn't support hedging, don't use this EA.**
- **Monitor your broker's spread and commissions** from the start.
- **Opt for a broker offering micro lot trading** (e.g., 0.01 lots for 5-digit precision pairs). Micro lot trading is recommended for better trade management flexibility, it allows the EA to better calibrate its strategy to market conditions and to enhance its performance. Using larger minimum lot sizes can lead to increased losses. For example, backtesting indicates that a minimum lot size of 0.1 can lead to increased losses due to reduced trading flexibility.

----

Read next: [[Legal]]