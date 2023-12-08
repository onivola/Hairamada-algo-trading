



	
	

def GetAPIallTicker(): #all json signal and price
#alert(interval)
	#Exchange Information
		nbdom=0
	form2 = new FormData()
settings2 =:
  "url": "https:#api.binance.com/api/v3/ticker/price",
  "method": "GET",
  "timeout": 0,
  "headers"::
    "Content-Type": "application/x-www-form-urlencoded"
  ,
  "processData": false,
  "mimeType": "multipart/form-data",
  "contentType": false,
  "data": form2


$.ajax(settings2).done(def (response):

  json=JSON.parse(response)
 
   
)



	#print(valueFastK0)
	#print(valueFastK1)
	#print(valueFastD2)

#INDICATOR 
apikey = "QBCJ2GT21JRSDVTS"
apikeytaapi = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFuZHJ5YXJpdm9sYUB5bWFpbC5jb20iLCJpYXQiOjE2MjExNDg4MTEsImV4cCI6NzkyODM0ODgxMX0.yi0xqrH-lONs06NDwudBDm4TunRiTQ-NvDk9gUjOvxs"
def GetIndicator(indicator,symbol,interval,time_period=10):
	#Time interval: 1min, 5min, 15min, 30min, 60min
	#Number of data points used to calculate each RSI value. Positive integers are accepted (e.g., time_period=60, time_period=200)
	#servertime = servertime-1000
	form = new FormData()
	url = ""
	if(indicator=='rsi'): 
		#url = "https:#www.alphavantage.co/query?def="+indicator+"&symbol="+symbol+"&interval="+interval+"&time_period="+time_period+"&series_type=open&apikey="+apikey
		#taapi
		url = "https:#api.taapi.io/rsi?secret="+apikeytaapi+"&exchange=binance&symbol="+symbol+"&interval="+interval+"&backtracks=10"
	 else if(indicator=='macd'):
		#url = "https:#www.alphavantage.co/query?def="+indicator+"&symbol="+symbol+"&interval="+interval+"&series_type=open&apikey="+apikey
		url = "https:#api.taapi.io/macd?secret="+apikeytaapi+"&exchange=binance&symbol="+symbol+"&interval="+interval+"&backtracks=10"
	 else: #stockastic
		#url = "https:#www.alphavantage.co/query?def="+indicator+"&symbol="+symbol+"&interval="+interval+"&time_period="+time_period+"&series_type=open&fastkperiod=3&fastdmatype=3&apikey="+apikey
		url = "https:#api.taapi.io/stochrsi?secret="+apikeytaapi+"&exchange=binance&symbol="+symbol+"&interval="+interval+"&backtracks=10"
	
	#print(url)
	  $.ajax({
            url: url,
            crossOrigin: true,
            type: 'GET',
            xhrFields:: withCredentials: true ,
            accept: 'application/json'
        ).done(def (data):
            alert(data)                
        ).fail(def (xhr, textStatus, error):
            title, message
            switch (xhr.status):
                case 403:
                    title = xhr.responseJSON.errorSummary
                    message = 'Please login to your server before running the test.'
                    break
                default:
                    title = 'Invalid URL or Cross-Origin Request Blocked'
                    message = 'You must explictly add this site (' + window.location.Origin + ') to the list of allowed websites in your server.'
                    break
            
        )
		
		


def GetAPIexchange():
	#Exchange Information
	form2 = new FormData()
settings2 =:
  "url": "https:#api.binance.com/api/v3/exchangeInfo",
  "method": "GET",
  "timeout": 0,
  "headers"::
    "Content-Type": "application/x-www-form-urlencoded"
  ,
  "processData": false,
  "mimeType": "multipart/form-data",
  "contentType": false,
  "data": form2


$.ajax(settings2).done(def (response):
  print(response)
)




def GetBalance(servertime):
	
	#servertime = servertime-1000
	form = new FormData()
	signature = CryptoJS.HmacSHA256("timestamp="+servertime, "XNxaEybB7C7ZM6Cp3quHLd7JE3X1W7LpbrebaGqjgKrKj0aJzPsURzJ62j9eG67h")
	
	settings =:
	  "url": "https:#fapi.binance.com/fapi/v2/balance?timestamp="+servertime+"&signature="+signature,
	  "method": "GET",
	  "timeout": 0,
	  "headers"::
		"X-MBX-APIKEY": "3SceW1GlaSuFTOAZNBqBM2MNjNrBhTuYKG5mzmeiH4V2oL2ODUaYa74JjzXdkcHe",
		"Content-Type": "application/x-www-form-urlencoded"
	  ,
	  "processData": false,
	  "mimeType": "multipart/form-data",
	  "contentType": false,
	  "data": form
	

	$.ajax(settings).done(def (response):
	objJSON = JSON.parse(response)
	#print(objJSON)
	#  print(objJSON[1].asset) #USDT
	#  print(objJSON[1].balance) #BALANCE
	  balance = parseFloat(objJSON[1].balance,10)
	  $("#td_balanceUSDT").text(balance.toFixed(3)+" USDT")
	)

#GetLastPrice("BTCUSDT")
/*form = new FormData()
form.append("positionSide", "SHORT")
print(form)*/
def TakeProfit(symbol,stopPrice,type,side,time):
	signature = CryptoJS.HmacSHA256("closePosition=true&stopPrice="+stopPrice+"&type="+type+"&symbol="+symbol+"&side="+side+"&timestamp="+time, "XNxaEybB7C7ZM6Cp3quHLd7JE3X1W7LpbrebaGqjgKrKj0aJzPsURzJ62j9eG67h")
	
	form2 = new FormData()

	
	/*form.append("positionSide", "SHORT")
	form.append("Type", "MARKET")
	form.append("quantity",0.1)
	form.append("symbol",symbol)*/
	
		
	
	$.ajax({
	  url: "https:#fapi.binance.com/fapi/v1/order?closePosition=true&stopPrice="+stopPrice+"&type="+type+"&symbol="+symbol+"&side="+side+"&timestamp="+time+"&signature="+signature,
	 #data:: timestamp: time, signature : signature ,
	  processData: false,
	  contentType: false,
	  type: 'POST',
	  headers::
		"X-MBX-APIKEY": "3SceW1GlaSuFTOAZNBqBM2MNjNrBhTuYKG5mzmeiH4V2oL2ODUaYa74JjzXdkcHe",
		"Content-Type": "application/x-www-form-urlencoded",
		"Access-Control-Allow-Origin": "*"
	  ,
	  success: def(data){
		print(data)
	  
	)


def GETAllOpenOrder(symbol,time):
	signature = CryptoJS.HmacSHA256("recvWindow=5000&timestamp="+time, "XNxaEybB7C7ZM6Cp3quHLd7JE3X1W7LpbrebaGqjgKrKj0aJzPsURzJ62j9eG67h")
	
	form2 = new FormData()

	
	/*form.append("positionSide", "SHORT")
	form.append("Type", "MARKET")
	form.append("quantity",0.1)
	form.append("symbol",symbol)*/
	form2.append("timestamp", "1622451304393")
	form2.append("signature", signature)
		
	
	$.ajax({
	  url: "https:#fapi.binance.com/fapi/v1/openOrders?recvWindow=5000&timestamp="+time+"&signature="+signature,
	 #data:: timestamp: time, signature : signature ,
	  processData: false,
	  contentType: false,
	  type: 'GET',
	  headers::
		"X-MBX-APIKEY": "3SceW1GlaSuFTOAZNBqBM2MNjNrBhTuYKG5mzmeiH4V2oL2ODUaYa74JjzXdkcHe",
		"Content-Type": "application/x-www-form-urlencoded",
		"Access-Control-Allow-Origin": "*"
	  ,
		success: def(data){
		print(data)
	  
	)


def CancelAllOpenOrder(minQty,symbol,side,time):
	form = new FormData()
	signature = CryptoJS.HmacSHA256("timestamp="+time+"&symbol="+symbol, "XNxaEybB7C7ZM6Cp3quHLd7JE3X1W7LpbrebaGqjgKrKj0aJzPsURzJ62j9eG67h")
	
	
	 
	$.ajax({
    url:  "https:#fapi.binance.com/fapi/v1/allOpenOrders?timestamp="+time+"&symbol="+symbol+"&signature="+signature,
    type: 'DELETE',
	 headers::
		"X-MBX-APIKEY": "3SceW1GlaSuFTOAZNBqBM2MNjNrBhTuYKG5mzmeiH4V2oL2ODUaYa74JjzXdkcHe",
		"Content-Type": "application/x-www-form-urlencoded",
		"Access-Control-Allow-Origin": "*"
	  ,
    success: def(result):
       print(result)
	   AddPositionApi(minQty,symbol,side)
    ,
	  error: def(request,msg,error):
         print(request)
         print(msg)
         print(error)
    
)


def changeLeverage(symbol,leverage,time):

	signature = CryptoJS.HmacSHA256("leverage="+leverage+"&symbol="+symbol+"&timestamp="+time, "XNxaEybB7C7ZM6Cp3quHLd7JE3X1W7LpbrebaGqjgKrKj0aJzPsURzJ62j9eG67h")
	
	form2 = new FormData()

	
	/*form.append("positionSide", "SHORT")
	form.append("Type", "MARKET")
	form.append("quantity",0.1)
	form.append("symbol",symbol)*/
	form2.append("timestamp", "1622451304393")
	form2.append("signature", signature)
		
	
	$.ajax({
	  url: "https:#fapi.binance.com/fapi/v1/leverage?leverage="+leverage+"&symbol="+symbol+"&timestamp="+time+"&signature="+signature,
	 #data:: timestamp: time, signature : signature ,
	  processData: false,
	  contentType: false,
	  type: 'POST',
	  headers::
		"X-MBX-APIKEY": "3SceW1GlaSuFTOAZNBqBM2MNjNrBhTuYKG5mzmeiH4V2oL2ODUaYa74JjzXdkcHe",
		"Content-Type": "application/x-www-form-urlencoded",
		"Access-Control-Allow-Origin": "*"
	  ,
	  success: def(data){
		print(data)
		
		#GETAllOpenOrder(symbol,time)
		
		
	  ,
	    error: def(request,msg,error):
         print(request)
         print(msg)
         print(error)
    
	)

def NewOrderMARKET(symbol,price,quantity,side,time):
	#servertime = servertime-1000
	#alert(timestamp)
	#&positionSide=SHORT&Type=MARKET&quantity="+0.1+"&symbol="+symbol
	signature = CryptoJS.HmacSHA256("quantity="+quantity+"&type=MARKET&symbol="+symbol+"&side="+side+"&timestamp="+time, "XNxaEybB7C7ZM6Cp3quHLd7JE3X1W7LpbrebaGqjgKrKj0aJzPsURzJ62j9eG67h")
	
	form2 = new FormData()

	
	/*form.append("positionSide", "SHORT")
	form.append("Type", "MARKET")
	form.append("quantity",0.1)
	form.append("symbol",symbol)*/
		
	
	$.ajax({
	  url: "https:#fapi.binance.com/fapi/v1/order?quantity="+quantity+"&type=MARKET&symbol="+symbol+"&side="+side+"&timestamp="+time+"&signature="+signature,
	 #data:: timestamp: time, signature : signature ,
	  processData: false,
	  contentType: false,
	  type: 'POST',
	  headers::
		"X-MBX-APIKEY": "3SceW1GlaSuFTOAZNBqBM2MNjNrBhTuYKG5mzmeiH4V2oL2ODUaYa74JjzXdkcHe",
		"Content-Type": "application/x-www-form-urlencoded",
		"Access-Control-Allow-Origin": "*"
	  ,
	  success: def(data){
		print(data)
		
		#GETAllOpenOrder(symbol,time)
		
		
	  ,
	    error: def(request,msg,error):
         print(request)
         print(msg)
         print(error)
    
	)



def GetAPImillisecond():
	form2 = new FormData()
	settings2 =:
	  "url": "https:#api.binance.com/api/v3/time",
	  "method": "GET",
	  "timeout": 0,
	  "headers"::
		"Content-Type": "application/x-www-form-urlencoded"
	  ,
	  "processData": false,
	  "mimeType": "multipart/form-data",
	  "contentType": false,
	  "data": form2
	
	
	
	$.ajax(settings2).done(def (response):
		time = JSON.parse(response)
		print(time)
	  GetBalance(time.serverTime)
	)
	


def QueryAllOrder(minQty,symbol,side,servertime):
	#servertime = servertime-1000
	form = new FormData()
	signature = CryptoJS.HmacSHA256("symbol="+symbol+"&timestamp="+servertime, "XNxaEybB7C7ZM6Cp3quHLd7JE3X1W7LpbrebaGqjgKrKj0aJzPsURzJ62j9eG67h")
	
	settings =:
	  "url": "https:#fapi.binance.com/fapi/v1/openOrders?symbol="+symbol+"&timestamp="+servertime+"&signature="+signature,
	  "method": "GET",
	  "timeout": 0,
	  "headers"::
		"X-MBX-APIKEY": "3SceW1GlaSuFTOAZNBqBM2MNjNrBhTuYKG5mzmeiH4V2oL2ODUaYa74JjzXdkcHe",
		"Content-Type": "application/x-www-form-urlencoded"
	  ,
	  "processData": false,
	  "mimeType": "multipart/form-data",
	  "contentType": false,
	  "data": form
	

	$.ajax(settings).done(def (response):
	objJSON = JSON.parse(response)
	  print(objJSON)
	  
	  if(checkOrder(objJSON)==false): #add position
		CancelAllOpenOrder(minQty,symbol,side,servertime) #cancell all open position
		
		/* print(checkOrder(objJSON))
		print(objJSON.length)*/
	   else: #not allowed to add position
		print('not allowed to add position')
	  
	  
	)



def AddPosition(minQty,symbol,side):
	#Exchange Information
	form2 = new FormData()
	settings2 =:
	  "url": "https:#fapi.binance.com/fapi/v1/time",
	  "method": "GET",
	  "timeout": 0,
	  "headers"::
		"Content-Type": "application/x-www-form-urlencoded"
	  ,
	  "processData": false,
	  "mimeType": "multipart/form-data",
	  "contentType": false,
	  "data": form2
	

	$.ajax(settings2).done(def (response):
	 # print(response)
		objJSON = JSON.parse(response)
		print(objJSON.serverTime)
		QueryAllOrder(minQty,symbol,side,objJSON.serverTime)
		 
	)


def AddPositionApi(minQty,symbol,side):
	#Exchange Information
	form2 = new FormData()
	settings2 =:
	  "url": "https:#fapi.binance.com/fapi/v1/time",
	  "method": "GET",
	  "timeout": 0,
	  "headers"::
		"Content-Type": "application/x-www-form-urlencoded"
	  ,
	  "processData": false,
	  "mimeType": "multipart/form-data",
	  "contentType": false,
	  "data": form2
	

	$.ajax(settings2).done(def (response):
	 # print(response)
		objJSON = JSON.parse(response)
		print(objJSON.serverTime)
		 GetLastPrice(minQty,symbol,side,objJSON.serverTime)
	)
	



def GetAllsymbolBinance():
	#Exchange Information
	form2 = new FormData()
settings2 =:
  "url": "https:#fapi.binance.com/fapi/v1/exchangeInfo?symbol=BTCUSDT",
  "method": "GET",
  "timeout": 0,
  "headers"::
    "Content-Type": "application/x-www-form-urlencoded"
  ,
  "processData": false,
  "mimeType": "multipart/form-data",
  "contentType": false,
  "data": form2


$.ajax(settings2).done(def (response):
 # print(response)
	objJSON = JSON.parse(response)
	#print(objJSON.symbols)
	  EachAllUSDT(objJSON.symbols)
)
