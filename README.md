# RMOEX
Provides easy access to market data from Moscow exchage using  ISS engine API https://www.moex.com/a2920

# Usage
```
devtools::install_github('r8m/RMOEX')

# ETF
getMOEXData(ticker = 'FXCN',from='2020-09-01',to='2020-09-10', period = 'day')
#Futures
getMOEXData(ticker = 'SiZ0',from='2020-09-01',to='2020-09-10', period = 'day')
#Stock
getMOEXData(ticker = 'SBER',from='2006-01-01',to='2020-09-10', period = 'day')
#Option
getMOEXData(ticker = 'Si70000BL0',from='2020-09-01',to='2020-09-10', period = 'day')
#Currency
getMOEXData(ticker = 'USD000000TOD',from='2020-09-01',to='2020-09-10', period = 'day')
#Depository receipts
getMOEXData(ticker = 'FIVE',from='2020-09-01',to='2020-09-10', period = 'day')
#Bonds
getMOEXData(ticker = 'RU000A101FG8',from='2020-09-01',to='2020-09-10', period = 'day')

```


