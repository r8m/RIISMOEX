#' @title download market data from MOEX Exchange using ISS engine
#'
#' @description download market data from MOEX Exchange using ISS engine
#' @param ticker   ticker name
#' @param from     start date
#' @param to       end date
#' @param period candle period \code{day, hour, 10min, 1min}
#' @return data.table
#' @examples
#' #ETF
#' getMOEXData(ticker = 'FXCN',from='2020-09-01',to='2020-09-10', period = 'day')
#' #Futures
#' getMOEXData(ticker = 'SiZ0',from='2020-09-01',to='2020-09-10', period = 'day')
#' #Stock
#' getMOEXData(ticker = 'SBER',from='2006-01-01',to='2020-09-10', period = 'day')
#' #Option
#' getMOEXData(ticker = 'Si70000BL0',from='2020-09-01',to='2020-09-10', period = 'day')
#' #Currency
#' getMOEXData(ticker = 'USD000000TOD',from='2020-09-01',to='2020-09-10', period = 'day')
#' #Depository receipts
#' getMOEXData(ticker = 'FIVE',from='2020-09-01',to='2020-09-10', period = 'day')
#' #Bonds
#' getMOEXData(ticker = 'RU000A101FG8',from='2020-09-01',to='2020-09-10', period = 'day')

#usethis::use_package("jsonlite")
#usethis::use_package("curl")

#' @export
getMOEXData<-function(ticker='SBER', from=Sys.Date()-2, to=Sys.Date(), period='1min'){

  periods = c('day'=24, 'hour'=60, '10min'=10, '1min'=1)
  interval = periods[period]

  check_ticker_url <- paste0('https://iss.moex.com/iss/securities.json?q=',ticker)
  res<-jsonlite::fromJSON(txt=check_ticker_url)
  res<-data.table::data.table(res$securities$data)[V2==ticker]

  if(length(res)==0)
    return(NULL)

  engine <- res[1,strsplit(V14,'_')][1]
  market <- res[1,strsplit(V14,'_')][2]

  if(engine=='stock' & market!='bonds')
    market <- 'shares'

  board  <- res[1,V15]

  pos <- 0
  baseurl   <- 'https://iss.moex.com/iss/engines/'
  marketurl <-paste0(engine,'/markets/',market,'/boards/',board)

  url <- paste0(baseurl,
               marketurl,
               '/securities/',
               ticker,
               '/candles.csv?from=',
               from,
               '&till=',
               to,
               '&interval=',
               interval,
               '&start=',pos)

  dt<-data.table::data.table()
  tdt<-data.table::fread(url)

  if(tdt[,.N]==0)
    return(NULL)

  tdt[,timestamp:=as.POSIXct(begin)]

  maxPB <-as.numeric(difftime(as.POSIXct(to),
                              as.POSIXct(from),
                              units = 'secs'))
  dt<-rbind(dt, tdt)
  while(tdt[,.N]!=0){
    pos <- pos+tdt[,.N]
    url <- paste0(baseurl,
                 marketurl,
                 '/securities/',
                 ticker,
                 '/candles.csv?from=',
                 from,
                 '&till=',
                 to,
                 '&interval=',interval,
                 '&start=',pos)
    tdt = data.table::fread(url)
    if(tdt[,.N]){
      tdt[,timestamp:=as.POSIXct(begin)]
      dt<-rbind(dt, tdt)
    }
  }
  dt[,.(timestamp,open,high,low, close,volume)]
}
