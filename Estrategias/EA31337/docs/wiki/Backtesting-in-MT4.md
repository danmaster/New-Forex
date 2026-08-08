# Windows

## Requirements

The following applications are required to be installed on your Windows PC:

- MetaTrader 4 platform - can be found on your broker website (e.g. [XM](https://www.xm.co.uk/mt4)).
- Install [7-Zip](http://www.7-zip.org/) or similar file archiver.

You need at least 5GB of free space on the drive.

## Manual method

Here are the steps to perform backtesting of the EA in MetaTrader 4 on Windows:

1. In order to download backtest dataset files, go to https://github.com/FX-Data, select historical data from the list for a symbol (such as [`FX-Data-EURUSD-DS`](https://github.com/FX-Data/FX-Data-EURUSD-DS)).
1. On the repo page, click on the _releases_ tab and choose the year or period (e.g. [`2017`](https://github.com/FX-Data/FX-Data-EURUSD-DS/releases/tag/2017)).
1. Download all HST files (ending with `hst.gz`) from the list (consisting [OHLC data](https://en.wikipedia.org/wiki/Open-high-low-close_chart) for each timeframe indicated by minutes).

    <sup>Note: You can hold _Control_ key and click each file ending with `hst.gz`, or use [_Linkclump_ Chrome extension](https://chrome.google.com/webstore/detail/linkclump/lfpjkncokllnfokkgpkobnkbkmelfefj) for easier multiple selection of the files.</sup>

1. Download at least one FXT file (ending with `fxt.gz`) consisting tick data from the list. Ideally associated with the timeframe which you're going to use for testing. If you're not sure, choose `XXXYYY1_0.fxt.gz`, as it's going to be converted automatically for the right timeframe by the platform.
1. If you downloaded all of the files for the given period, it's still fine.
1. When finished, open containing folder with the files.
1. Extract all files (with `.gz` extension). E.g. by selecting them, then selecting _7-Zip_ menu (or similar tool) from the context menu (right click of the mouse) and choose _Extract Here_. This will extract `.gz` files into files with `.hst` and `.fxt` extension, so `.gz` files won't be needed anymore.

    <sup>Note: If _7-Zip_ is not present, make sure you install it first (check _Requirements_ section).</sup>

1. Locate and open the platform data folder. For example by running the _MetaTrader_ terminal or _MetaEditor_ and select from the application menu: _File_, _Open Data Folder_ (leave the folder window open). Then quit the platform in order to avoid altering any existing files while moving them (especially when connected to the broker).

1. Now move all previously extracted HST files (`.hst`) to the `history/default` folder (replace/remove any existing files if required).

    <sup>Note: For easier selection, you may sort by _Type_. If you've multiple profiles setup in your platform, use your profile name instead of `default`.</sup>

1. Using the same way, move all previously extracted FXT file(s) to the `tester/history` folder (e.g. _Cut_ and _Paste_).

    <sup>Note: You don't need to set your file in read-only, but in case your tick or timeframe data files gets polluted with your broker data while platform running and it's online, you may need to replace the file(s) again.</sup>

1. Run the _MetaTrader_ platform and _Open Offline_ chart from _File_ menu to verify the existence and correct period of your tick data. You can also check where the data is stored (which file) when you hover your mouse pointer on the row.

    When the period is not correct (wrong file or got corrupted), you need to delete the existing FXT file(s) from the `tester/history` folder and copy/move/extract the file(s) again.

1. Open _Strategy Tester_ from the _View_ menu (<kbd>Control</kbd>+<kbd>R</kbd>).
1. Configure the settings as suggested below and hit Start.

    - Select _EA_ and _Symbol_ (according to downloaded files such as `EURUSD`). Set Model to _Every tick_.
    - _Use date_ according to the downloaded period (or shorter).
    - Suggested Period is M15 or M30, but any other should work exactly the same way.
    - For Spread, ideally, use between 10 and 20 points (don't use _Current_).
    - For _Expert properties_ use the default one unless you want to adjust or optimize it.

1. While running, check the progress by changing the tabs (_Results_, _Graph_ or _Journal_ for a log).
1. When finish, check the _Report_ tab for the results.
1. In case of any issues, check for any errors in the log file (_Journal_ tab).
1. If you need any help or guidance, raise a [new issue](https://github.com/EA31337/EA31337/issues/new), or ask at [@EA31337](https://t.me/EA31337).