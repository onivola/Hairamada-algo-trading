def tmtMACD(json):
	bleu0 = json[0].valueMACD
	red0 = json[0].valueMACDSignal
	hist0 = json[0].valueMACDHist
	min=-0.01
	max=0.01
	if(interval=="1m"):
		min=-0.03
		max=0.03

	if(interval=="3m"):
		min=-0.2
		max=0.2

	if(interval=="5m"):
		min=-0.4
		max=0.4

	if(bleu0<red0 && bleu0>max && red0>max ):
		print(red0) #RED	
		print(hist0)	#HIST
		print(0)	#HIST''''
		return 0
	else if(bleu0>red0 && bleu0<min && red0<min):
		''''print(bleu0)		#BLEU
		print(red0) #RED
		print(hist0)	#HIST
		print(1)	#HIST''''
		return 1
	else: 
		return 20 


def tmtRSI(json):
	#print(json)
	#print(json[0].value)
	#print(json[0].value)
	max =70 #70 ligne
	midle=50 #50 ligne
	min=30 #30 ligne
	rsi0=json[0].value
	rsi1=json[1].value
	rsi2=json[2].value
	rsi3=json[3].value

	#check direction up
	if(rsi0>midle && (rsi1<midle || rsi2<midle || rsi3<midle) && rsi0<max): #Down
		return 1
	else if(rsi0<midle && (rsi1>midle || rsi2>midle || rsi3>midle) && rsi0>min): #Down
		return 0
	else:
		return 20
	

 def tmtSTOCHRSI(json):

	max =70 #70 ligne
	midle=50 #50 ligne
	min=30 #30 ligne

	valueFastK0 = json[0].valueFastK #bleu
	valueFastD0= json[0].valueFastD #red

	valueFastK1=json[1].valueFastK
	valueFastK2=json[2].valueFastK
	valueFastK3=json[3].valueFastK

	valueFastD1= json[1].valueFastD #red
	valueFastD2= json[2].valueFastD #red
	valueFastD3= json[3].valueFastD #red

	if(valueFastK0>min && valueFastK0<max &&  (valueFastK1<min || valueFastK2<min || valueFastK3<min)
	&& valueFastD0>min && valueFastD0<max &&  (valueFastD1<min || valueFastD2<min || valueFastD3<min)): #Down
		return 1


	else if(valueFastK0<max && valueFastK0>min &&  (valueFastK1>max || valueFastK2>max || valueFastK3>max)
	&& valueFastD0<max && valueFastD0>min &&  (valueFastD1>max || valueFastD2>max || valueFastD3>max)): #Down
		return 0


	else:
		return 20





def play1():
			  
	'''' Audio link for notification ''''
	mp3 = '<source src="assets/alarm/3up.mp3" type="audio/mpeg">'
	document.getElementById("sound1").innerHTML = 
	'<audio autoplay="autoplay">' + mp3 + "</audio>"

def play2():
	  
	'''' Audio link for notification ''''
	mp3 = '<source src="assets/alarm/3down.mp3" type="audio/mpeg">'
	document.getElementById("sound2").innerHTML = 
	'<audio autoplay="autoplay">' + mp3 + "</audio>"

def play3():
	  
	'''' Audio link for notification ''''
	mp3 = '<source src="assets/alarm/notif.mp3" type="audio/mpeg">'
	document.getElementById("sound3").innerHTML = 
	'<audio autoplay="autoplay">' + mp3 + "</audio>"

def play4():
	'''' Audio link for notification ''''
	mp3 = '<source src="assets/alarm/rsistoch.mp3" type="audio/mpeg">'
	document.getElementById("sound3").innerHTML = 
	'<audio autoplay="autoplay">' + mp3 + "</audio>"
	
def GetSlTpDefault(intval):
	if(intval=='1m'):
		return [0.04,0.25]
	 else if(intval=='3m'):
		return [0.1,0.3]
	
	else if(intval=='5m'):
		return [0.2,0.5]
	
	else if(intval=='15m'):
		return [0.3,25]
	
	else :
		return [4,2]



Callichimoku(1,1,'SOL/USDT',"30m","ichimoku")
  def Callichimoku(minQty,nb_simbol,symbol,interval,indicateur):
	$('#in_result').load('Curl.php',{symbol:symbol,interval:interval,indicateur:indicateur, def(): #send table
	 currentSpanA
		print($('#in_result').text())
	currentSpanB
		result = $('#in_result').text()
	
		
	)

def ReturnIndicatorDom(i_tr,macd,rsi,stochrsi):
	
	
	if(macd==1):
		$('#macd_buy'+i_tr).text("true")
	  if(rsi==1):
		$('#rsi_buy'+i_tr).text("true")
	  if(stochrsi==1):
		$('#stochrsi_buy'+i_tr).text("true")
	  if(macd==0):
		$('#macd_sell'+i_tr).text("true")
	  if(rsi==0):
		$('#rsi_sell'+i_tr).text("true")
	 if(stochrsi==0):
		$('#stochrsi_sell'+i_tr).text("true")
	
	if(macd+rsi+stochrsi==2): #up2true
		$('#tr'+i_tr).removeClass("up3true down2true down3true").addClass( "up2true" )
	 else if(macd+rsi+stochrsi==3): #up3true
	
	$('#tr'+i_tr).removeClass("up2true down2true down3true").addClass( "up3true" )
	 else if(macd+rsi+stochrsi==1): #down2true
	
	$('#tr'+i_tr).removeClass("up2true up3true  down3true").addClass( "down2true" )
	 else if(macd+rsi+stochrsi==0): #down3true
	
	$('#tr'+i_tr).removeClass("up2true up3true down2true ").addClass( "down3true" )
	
	 else if((macd+rsi+stochrsi)>10):
		$('#tr'+i_tr).removeClass("up2true up3true down2true down3true")
		#alert(macd+rsi+stochrsi)
	
def notif(notif):
	if(notif=="foo3up"):
		
		foo3up.start()
		foo3up.init(100, false)
	 else if(notif=="foo3down"):
		
		foo3down.start()
		foo3down.init(100, false)
	 else:
			foo2notif = new Sound("assets/alarm/notif.mp3",100, true)
		foo2notif.start()
		foo2notif.init(100, false)
	



#play3()
#alert($('#macd_buy'+0).text())
play4()
def DefaultSignal(entstring):
	sygnal1 =  entstring.substring(0,entstring.length-5)
	sygnal2 =  entstring.substring(entstring.length - 4)
	islash = entstring.length - 4
	romy = sygnal1+""+sygnal2
	return romy

#print(DefaultSignal("BTC/USDT"))
nb_true = 0
def ResultDom(minQty,symbol,i_tr,indicator,result):
	#print(i_tr)
	#print(indicator)
	if(indicator=="macd"):
		if(result==1):
		$('#macd_buy'+i_tr).text("true")
		 else if(result==0):
		
			$('#macd_sell'+i_tr).text("true")
		 
	 else if(indicator=="rsi"):
		if(result==1):
			$('#rsi_buy'+i_tr).text("true")
		 else  if(result==0):
			$('#rsi_sell'+i_tr).text("true")
		 
	 else:
		if(result==1):
			$('#stochrsi_buy'+i_tr).text("true")
		 else if(result==0):
			$('#stochrsi_sell'+i_tr).text("true")
			
		
		
	
	
	''''if($('#stochrsi_buy'+i_tr).text()=="true" && $('#rsi_buy'+i_tr).text()=="true" && $('#macd_buy'+i_tr).text()=="false"):
		play1()
		$('#stochrsi_buy'+i_tr).addClass( "uprsistoch" )
		$('#rsi_buy'+i_tr).addClass( "uprsistoch" )
		RedirectBinance(symbol)
	
	if($('#stochrsi_sell'+i_tr).text()=="true" && $('#rsi_sell'+i_tr).text()=="true" && $('#macd_sell'+i_tr).text()=="false"):
		play2()
		$('#stochrsi_sell'+i_tr).addClass( "downrsistoch" )
		$('#rsi_sell'+i_tr).addClass( "downrsistoch" )
		RedirectBinance(symbol)
	''''
	
	
	
	if(($('#macd_buy'+i_tr).text()=="true" && $('#rsi_buy'+i_tr).text()=="true") || ($('#rsi_buy'+i_tr).text()=="true" && $('#stochrsi_buy'+i_tr).text()=="true") || ($('#macd_buy'+i_tr).text()=="true" && $('#stochrsi_buy'+i_tr).text()=="true")):
		play3()
		$('#tr'+i_tr).removeClass("up3true down2true down3true").addClass( "up2true" )
		
		
		
		
	
	if($('#macd_buy'+i_tr).text()=="true" && $('#rsi_buy'+i_tr).text()=="true" && $('#stochrsi_buy'+i_tr).text()=="true"):
		$('#tr'+i_tr).removeClass("up2true down2true down3true").addClass( "up3true" )
		
		#RedirectBinance(symbol)
		#alert(symbol)
		nb_true++
		print(nb_true)
		if(nb_true<=nb_position):
		play1()
			AddPosition(minQty,DefaultSignal(symbol),"BUY") #new order BUY
			
		
		
		
	
	
	if(($('#macd_sell'+i_tr).text()=="true" && $('#rsi_sell'+i_tr).text()=="true") || ($('#macd_sell'+i_tr).text()=="true" && $('#stochrsi_sell'+i_tr).text()=="true") || ($('#rsi_sell'+i_tr).text()=="true" && $('#stochrsi_sell'+i_tr).text()=="true")):
		play3()
		$('#tr'+i_tr).removeClass("up2true up3true  down3true").addClass( "down2true" )
		
		
	
	if($('#macd_sell'+i_tr).text()=="true" && $('#rsi_sell'+i_tr).text()=="true" && $('#stochrsi_sell'+i_tr).text()=="true"):
	#play2()
		$('#tr'+i_tr).removeClass("up2true up3true down2true ").addClass( "down3true" )
		
		nb_true++
		print(nb_true)
		if(nb_true<=nb_position):
			play2()
			AddPosition(minQty,DefaultSignal(symbol),"SELL") #new order SELL
		
		
		
	
	#print(i_tr)
	#print(parseInt($('#nb_symbol').text()))
	#print(nbdom)
	if(parseInt($('#nb_symbol').text())==i_tr+1):
		nbdom++
		#print(nbdom)
		if(nbdom==3):
			nbdom=0
			$("#dv_symbol").text("")
			GetAllsymbolBinance()
			return 0
		
		#alert(12313)
		
	
	

	

#CallIndicators(0,'BTC/USDT','15m','rsi')
def AfterGetIndicator(minQty,symbol,i_tr,indicator,json):

	#print(json)
	if(indicator=="macd"):
		macd = tmtMACD(json)
		#print(macd)
		ResultDom(minQty,symbol,i_tr,indicator,macd)
	 else if(indicator=="rsi"):
		rsi = tmtRSI(json)
		ResultDom(minQty,symbol,i_tr,indicator,rsi)
		#print(rsi)
	 else: #machrsi
		stochrsi = tmtSTOCHRSI(json)
		ResultDom(minQty,symbol,i_tr,indicator,stochrsi)
		#print(stochrsi)
	


def NotBinance(symbol):
	

	tbsymbol = ['LTO_USDT','DNT_USDT','ROSE/USDT','TRU/USDT','BEAM/USDT','GTO/USDT','LSK_USDT','IOTX_USDT','WAN_USDT','FORTH/USDT','JUV/USDT','FORTH/USDT','HIVE/USDT','XVS/USDT','IRIS/USDT','ACM/USDT','POND/USDT','CKB/USDT','ORN/USDT','ANT_USDT','AR/USDT','LTCUP/USDT','FIS/USDT','MFT/USDT','STX/USDT','NANO/USDT','CTXC/USDT','DATA/USDT','ASR/USDT','WIN/USDT','GBP/USDT','LUNA/USDT','BURGER/USDT','VTHO/USDT','PAXG/USDT','BUSD/USDT','MITH/USDT','WTC/USDT','CTSI/USDT','MDX/USDT','MASK/USDT','FET/USDT','TUSD/USDT','REP/USDT','RIF/USDT','EUR/USDT','HARD/USDT','NMR/USDT','KMD/USDT',"SUSD/USDT","MIR/USDT","PAX/USDT","USDC/USDT","PERL/USDT","MBL/USDT","JST/USDT","AUDIO/USDT","PUNDIX/USDT"]
	tbnotinapi = ['BTCST/USDT','1000SHIB/USDT','DEFI/USDT','DAI/USDT','HC/USDT','BNBBULL/USDT','AVA/USDT','ETHBEAR/USDT','BEAR/USDT','VEN/USDT','BCC/USDT','BCHSV/USDT','BCHABC/USDT','USDS/USDT','ERD/USDT','USDSB/USDT','ERD/USDT','NPXS/USDT','STORM/USDT','HC/USDTHC/USDT','MCO/USDT','BULL/USDT','ETHBULL/USDT','EOSBULL/USDT','EOSBEAR/USDT','XRPBULL/USDT','XRPBEAR/USDT','STRAT/USDT','BNBBULL/USDT].','BNBBEAR/USDT','XZC/USDT','LEND/USDT','BKRW/USDT']
	''''for(i=0i<tbsymbol.lengthi++):
	
		if(symbol==tbsymbol[i]):
		 return false
		
	''''
	for(i=0i<tbnotinapi.lengthi++):
	
		if(symbol==tbnotinapi[i]):
		 return false
		
	
	return true



def EachAllUSDT(json): #each all usdt from sygnal
	#print(json)
	nb_simbol=1 #nombre total signal
	#foo2notif.start()
	$.each(json, def(i, item):
		symbol = AddSlashUSDT(json[i].symbol)
		price = json[i].price
		minQty = json[i].filters[2].minQty
		maxQty = json[i].filters[2].maxQty
		#GetUsdtBySize(minQty,0.05,objJSON.price,20)
		''''print("maxquantity="+json[i].filters[2].minQty) #min quantity
		print("minquantity="+json[i].filters[2].maxQty) #max quantity''''
		#GetLastPrice(json[i].symbol,123)
		if(symbol.substring(symbol.length -4)=="USDT" && NotBinance(symbol)==true):
			#print(nb_simbol)
			#print(symbol)
			#print(interval)
			#print(price)
			#CallIndicators(0,nb_simbol,symbol,'1m',"macd")
				#CallIndicators(symbol,interval,"macd")
				#sleep(1000)
				#CallIndicators('BTC/USDT','1m',"macd")
				#print("next")
			
			
					
				#jsonSI = CallIndicators(nb_simbol,symbol,interval,"rsi")
				#jsonSTOCHRSI = CallIndicators(nb_simbol,symbol,interval,"stochrsi")
				#ReturnIndicatorDom(1,0,0,0)
				
				$('#dv_symbol').append("<tr id='tr"+nb_simbol+"'><td>"+symbol+"</td><td id='"+nb_simbol+"'>"+minQty+"</td><td>"+interval+"</td><td id='macd_buy"+nb_simbol+"'>false</td></td><td id='rsi_buy"+nb_simbol+"'>false</td></td><td id='stochrsi_buy"+nb_simbol+"'>false</td></td><td id='macd_sell"+nb_simbol+"'>false</td></td><td id='rsi_sell"+nb_simbol+"'>false</td></td><td id='stochrsi_sell"+nb_simbol+"'>false</td></td></tr>")
			#ReturnIndicatorDom(nb_simbol,tmtMACD(jsonMACD),tmtRSI(jsonSI),tmtSTOCHRSI(jsonSTOCHRSI))
			
			CallIndicators(minQty,nb_simbol,symbol,interval,"macd")
			CallIndicators(minQty,nb_simbol,symbol,interval,"rsi")
			CallIndicators(minQty,nb_simbol,symbol,interval,"stochrsi")
			nb_simbol++
			
			
			
			#CallIndicators(0,1,'BTC/USDT','1m',"macd")
				
				#sleep(5000)
			#
			
		
		
	)
		
	$('#nb_symbol').text(nb_simbol+" symbol")
	


#def TRAITMENT INDICATEUR

	


#SIMPLE def
def SlashSygnalUSDT(entstring):
	sygnal1 =  entstring.substring(0,entstring.length-4)
	sygnal2 =  entstring.substring(entstring.length - 4)
	islash = entstring.length - 4
	romy = sygnal1+"/"+sygnal2
	return romy


def RedirectBinance(sygnal):
	#window.open("https:#www.binance.com/en/futures/"+BarSygnalUSDT(sygnal), '_blank')
	window.open("http:#localhost/hairabot/curl.php?symboltab="+sygnal+"&interval="+interval, '_blank')

def BarSygnalUSDT(entstring):
	sygnal1 =  entstring.substring(0,entstring.length-5)
	sygnal2 =  entstring.substring(entstring.length - 4)
	islash = entstring.length - 4
	romy = sygnal1+"_"+sygnal2
	return romy

def calculate(sleep,resquestSecond):
#1s = 1000ms
for(i=1i<=resquestSecondi++): 
	print(i) #send request


    setTimeout(def(){ calculate(sleep,resquestSecond) , sleep)

#calculate(1000,10)
#BINANCE def


#Time Utc millisecond


def AddSlashUSDT(entstring):
	sygnal1 =  entstring.substring(0,entstring.length-4)
	sygnal2 =  entstring.substring(entstring.length - 4)
	islash = entstring.length - 4
	romy = sygnal1+"/"+sygnal2
	#print(romy)
	return romy



def nbVirgule(nombre):
     chaine = nombre.toString() 
     position = chaine.search(/[.,]\d+$/) 
	 
	  if(position<0):
		return 0
	
    
	 return chaine.substring(position+1).length

def checkOrder(objJSON):
	i=0
	nb=0
	while(i<objJSON.length):
		if(objJSON[i].origType=="TAKE_PROFIT_MARKET" || objJSON[i].origType=="STOP_MARKET"):
			nb++
		
		print(objJSON[i].origType)
		i++
	
	print(nb)
	if(nb>=2):
		nb_true--
		return true #position active
	 else:
		return false #no position
	
	''''if(objJSON.length>=2):
		return true
		
	 else:
		return false
	''''

def GetStopUP(price,prcent):
	price = parseFloat(price,10)
	tpvalue = price+((prcent*price)/100)
	print("TP="+tpvalue.toFixed(nbVirgule(price)))
	return tpvalue.toFixed(nbVirgule(price))

def GetStopDOWN(price,prcent):
price = parseFloat(price,10)
	slvalue = price-((prcent*price)/100)
	print("SL="+slvalue.toFixed(nbVirgule(price)))
	return slvalue.toFixed(nbVirgule(price))


def GetUsdtBySize(quantite,marge,curentprice,levier):
	#1BTC = 37171USDT
	value = ((quantite*curentprice)/levier)
	value = (value+marge).toFixed(2) #add some amount for variation
	print(parseFloat(value,10))
	return parseFloat(value,10)

def GetSizeByUsdt(usdt,curentprice,levier):
	#1BTC = 37171USDT
	value = ((usdt/curentprice)*levier).toFixed(4)
	print(parseFloat(value,10))
	return parseFloat(value,10)
