
import pyautogui
import time
import threading
import requests
import json
def GetNextModulo(temp,b):

	while(temp%50!=0):
		#print(temp)
		if(b):
			temp+=1
		else:
			temp-=1
	return temp

def NotBinance(symbol):
	

	tbsymbol = ['LTOUSDT','DNTUSDT','ROSEUSDT','TRUUSDT','BEAMUSDT','GTOUSDT','LSKUSDT','IOTXUSDT','WANUSDT','FORTHUSDT','JUVUSDT','FORTHUSDT','HIVEUSDT','XVSUSDT','IRISUSDT','ACMUSDT','PONDUSDT','CKBUSDT','ORNUSDT','ANTUSDT','ARUSDT','LTCUPUSDT','FISUSDT','MFTUSDT','STXUSDT','NANOUSDT','CTXCUSDT','DATAUSDT','ASRUSDT','WINUSDT','GBPUSDT','LUNAUSDT','BURGERUSDT','VTHOUSDT','PAXGUSDT','BUSDUSDT','MITHUSDT','WTCUSDT','CTSIUSDT','MDXUSDT','MASKUSDT','FETUSDT','TUSDUSDT','REPUSDT','RIFUSDT','EURUSDT','HARDUSDT','NMRUSDT','KMDUSDT',"SUSDUSDT","MIRUSDT","PAXUSDT","USDCUSDT","PERLUSDT","MBLUSDT","JSTUSDT","AUDIOUSDT","PUNDIXUSDT"]
	for i in range(0,len(tbsymbol)):
		if(symbol==tbsymbol[i]):
		 return False
	return True
def GetOrderBook(List,boole):
	x=0
	ListData = [0]
	print(List)
	while(x<len(List)-1):
		PriceTP = GetNextModulo(int(float(List[x][0]))+1,boole)
		quantite = 0
		#print(List[x][0])
		print(PriceTP)
		x=x+1
		#print(len(List)-1)
		#print(x)
		#print("TP"+str(int(float(sell[x][0]))+1))
		print("PriceTP"+str(PriceTP))
		print("P"+str(List[x][0]))
		while(float(List[x][0])<=PriceTP and x<len(List)-1):
			#print(sell[x][0])
			#quantite = quantite+float(List[x][1])
			#x=x+1
		#ListData.append(float(List[x][0]))
		#ListData.append(quantite)
	return ListData


ListNotBinance=[]
print('mande ny robine')
def RunBot(symbol,t):
	#while(1):
	print('manaraka')
	
	orderbk = requests.get('https://fapi.binance.com/fapi/v1/depth?symbol='+symbol+'&&limit=1000')
	dataobk = orderbk.json()
	if(len(dataobk)>=3):
		sell =  dataobk["asks"]
		buy = dataobk["bids"]
		
		
		#ListSell =GetOrderBook(sell,True)
		ListBuy =GetOrderBook(buy,False)
		#print(symbol+"Price"+str(ListSell[0]))
		#print(symbol+"SellQT"+str(ListSell[1]))
		#print(symbol+"BuyQT"+str(ListBuy[1]))
	else:
		print(symbol+"not in binance")
		ListNotBinance.append(symbol)
def thread(d,g):
	while(1):
		
		orderbk = requests.get('https://fapi.binance.com/fapi/v1/ticker/price?symbol=BTCUSDT')
		dataobk = orderbk.json()
		price[0]=float(dataobk['price'])
		lbPrice["text"]="Price="+str(price[0])
		CheckGain(float(dataobk['price']))

#test = float('0.100')
#test = float('1.000')

List = '[{"symbol":"SNXUSDT","price":"8.656","time":1626984574027},{"symbol":"LUNAUSDT","price":"7.3610","time":1626984577372},{"symbol":"MTLUSDT","price":"1.4785","time":1626984574838},{"symbol":"DGBUSDT","price":"0.03696","time":1626984569867},{"symbol":"BANDUSDT","price":"5.0515","time":1626984577490},{"symbol":"NKNUSDT","price":"0.18860","time":1626984577115},{"symbol":"ETHUSDT","price":"2023.29","time":1626984577248},{"symbol":"SKLUSDT","price":"0.19517","time":1626984573593},{"symbol":"ICXUSDT","price":"0.7647","time":1626984576882},{"symbol":"XTZUSDT","price":"2.492","time":1626984557495},{"symbol":"YFIUSDT","price":"28549.0","time":1626984577427},{"symbol":"ADAUSDT","price":"1.18850","time":1626984577427},{"symbol":"IOTAUSDT","price":"0.6565","time":1626984575774},{"symbol":"CELRUSDT","price":"0.02498","time":1626984575694},{"symbol":"ZRXUSDT","price":"0.6343","time":1626984565424},{"symbol":"CHZUSDT","price":"0.22907","time":1626984577187},{"symbol":"SOLUSDT","price":"27.7650","time":1626984577500},{"symbol":"OGNUSDT","price":"0.6905","time":1626984551659},{"symbol":"HBARUSDT","price":"0.16927","time":1626984576826},{"symbol":"ZILUSDT","price":"0.06246","time":1626984565435},{"symbol":"ATOMUSDT","price":"11.449","time":1626984570600},{"symbol":"LINAUSDT","price":"0.02877","time":1626984576656},{"symbol":"XMRUSDT","price":"198.83","time":1626984576588},{"symbol":"ETHUSDT_210924","price":"2041.34","time":1626984568396},{"symbol":"DOGEUSDT","price":"0.191160","time":1626984577431},{"symbol":"ENJUSDT","price":"1.11050","time":1626984575328},{"symbol":"LRCUSDT","price":"0.20834","time":1626984574584},{"symbol":"TOMOUSDT","price":"2.4889","time":1626984577131},{"symbol":"BELUSDT","price":"1.43790","time":1626984577071},{"symbol":"GRTUSDT","price":"0.54949","time":1626984570676},{"symbol":"XLMUSDT","price":"0.26313","time":1626984573470},{"symbol":"BTCBUSD","price":"32289.2","time":1626984574588},{"symbol":"HOTUSDT","price":"0.004901","time":1626984570261},{"symbol":"BZRXUSDT","price":"0.1782","time":1626984569989},{"symbol":"NEARUSDT","price":"1.9300","time":1626984572886},{"symbol":"FLMUSDT","price":"0.3540","time":1626984569682},{"symbol":"IOSTUSDT","price":"0.019723","time":1626984577313},{"symbol":"QTUMUSDT","price":"5.599","time":1626984566861},{"symbol":"RENUSDT","price":"0.31816","time":1626984574461},{"symbol":"UNIUSDT","price":"17.4550","time":1626984572801},{"symbol":"ONTUSDT","price":"0.6240","time":1626984558011},{"symbol":"COTIUSDT","price":"0.10778","time":1626984564475},{"symbol":"KAVAUSDT","price":"3.9464","time":1626984576011},{"symbol":"BAKEUSDT","price":"1.7271","time":1626984576857},{"symbol":"BLZUSDT","price":"0.13940","time":1626984577011},{"symbol":"SCUSDT","price":"0.010686","time":1626984575157},{"symbol":"DODOUSDT","price":"0.903","time":1626984544232},{"symbol":"RVNUSDT","price":"0.05434","time":1626984552637},{"symbol":"RLCUSDT","price":"2.3516","time":1626984569880},{"symbol":"GTCUSDT","price":"5.830","time":1626984573238},{"symbol":"TLMUSDT","price":"0.1819","time":1626984574491},{"symbol":"VETUSDT","price":"0.068110","time":1626984568874},{"symbol":"BTCUSDT","price":"32282.40","time":1626984576575},{"symbol":"RUNEUSDT","price":"4.5730","time":1626984577434},{"symbol":"SXPUSDT","price":"1.5442","time":1626984576973},{"symbol":"KSMUSDT","price":"173.320","time":1626984574525},{"symbol":"FILUSDT","price":"46.023","time":1626984565414},{"symbol":"TRBUSDT","price":"32.080","time":1626984577113},{"symbol":"CVCUSDT","price":"0.20483","time":1626984573396},{"symbol":"BTCDOMUSDT","price":"1085.4","time":1626984563853},{"symbol":"SFPUSDT","price":"0.7558","time":1626984577318},{"symbol":"OCEANUSDT","price":"0.37617","time":1626984577328},{"symbol":"DEFIUSDT","price":"1410.3","time":1626984562745},{"symbol":"DOTUSDT","price":"13.134","time":1626984574224},{"symbol":"DENTUSDT","price":"0.001860","time":1626984568952},{"symbol":"1000SHIBUSDT","price":"0.006512","time":1626984573117},{"symbol":"BTCUSDT_210924","price":"32474.9","time":1626984558611},{"symbol":"DASHUSDT","price":"142.77","time":1626984574380},{"symbol":"UNFIUSDT","price":"6.882","time":1626984576273},{"symbol":"ONEUSDT","price":"0.06500","time":1626984577149},{"symbol":"KEEPUSDT","price":"0.2507","time":1626984577189},{"symbol":"ALPHAUSDT","price":"0.56760","time":1626984575653},{"symbol":"ICPUSDT","price":"34.39","time":1626984572178},{"symbol":"NEOUSDT","price":"29.061","time":1626984574716},{"symbol":"HNTUSDT","price":"11.0750","time":1626984571204},{"symbol":"AKROUSDT","price":"0.01766","time":1626984573304},{"symbol":"SUSHIUSDT","price":"7.6890","time":1626984577517},{"symbol":"LITUSDT","price":"2.557","time":1626984577002},{"symbol":"RSRUSDT","price":"0.021533","time":1626984573566},{"symbol":"ZECUSDT","price":"96.44","time":1626984565288},{"symbol":"TRXUSDT","price":"0.05492","time":1626984568350},{"symbol":"EGLDUSDT","price":"78.330","time":1626984574014},{"symbol":"LTCUSDT","price":"120.18","time":1626984572308},{"symbol":"WAVESUSDT","price":"14.1400","time":1626984574421},{"symbol":"XEMUSDT","price":"0.1442","time":1626984575514},{"symbol":"YFIIUSDT","price":"2561.1","time":1626984571128},{"symbol":"1INCHUSDT","price":"1.9828","time":1626984576968},{"symbol":"BCHUSDT","price":"440.81","time":1626984575312},{"symbol":"CTKUSDT","price":"1.04500","time":1626984539374},{"symbol":"ALICEUSDT","price":"6.002","time":1626984575415},{"symbol":"AXSUSDT","price":"24.77900","time":1626984577469},{"symbol":"MANAUSDT","price":"0.5885","time":1626984556890},{"symbol":"ANKRUSDT","price":"0.060480","time":1626984571075},{"symbol":"MATICUSDT","price":"0.89570","time":1626984576520},{"symbol":"THETAUSDT","price":"4.5630","time":1626984577077},{"symbol":"STMXUSDT","price":"0.01556","time":1626984577311},{"symbol":"ETCUSDT","price":"43.233","time":1626984577444},{"symbol":"FTMUSDT","price":"0.185460","time":1626984576817},{"symbol":"SRMUSDT","price":"2.7450","time":1626984562064},{"symbol":"ETHBUSD","price":"2023.38","time":1626984555885},{"symbol":"XRPUSDT","price":"0.5968","time":1626984577445},{"symbol":"AVAXUSDT","price":"10.8150","time":1626984576598},{"symbol":"CRVUSDT","price":"1.520","time":1626984550650},{"symbol":"COMPUSDT","price":"408.50","time":1626984575423},{"symbol":"BATUSDT","price":"0.5133","time":1626984548014},{"symbol":"ZENUSDT","price":"48.287","time":1626984577272},{"symbol":"BALUSDT","price":"18.061","time":1626984565032},{"symbol":"MKRUSDT","price":"2457.70","time":1626984571827},{"symbol":"CHRUSDT","price":"0.2819","time":1626984576783},{"symbol":"BTTUSDT","price":"0.002149","time":1626984532029},{"symbol":"STORJUSDT","price":"0.7733","time":1626984563381},{"symbol":"REEFUSDT","price":"0.012839","time":1626984576994},{"symbol":"OMGUSDT","price":"3.5706","time":1626984562704},{"symbol":"BNBUSDT","price":"294.130","time":1626984577414},{"symbol":"LINKUSDT","price":"16.070","time":1626984576672},{"symbol":"AAVEUSDT","price":"279.000","time":1626984575773},{"symbol":"KNCUSDT","price":"1.30000","time":1626984575817},{"symbol":"EOSUSDT","price":"3.569","time":1626984576399},{"symbol":"BTSUSDT","price":"0.03650","time":1626984573326},{"symbol":"ALGOUSDT","price":"0.7804","time":1626984547992},{"symbol":"SANDUSDT","price":"0.49876","time":1626984577239}]'
ListSymbol = json.loads(List)
threads = [] 
#print(ListSymbol[i]['symbol'])
#print(i)
#if(NotBinance(ListSymbol[i]['symbol'])):
t = threading.Thread(target=RunBot,args=("BTCUSDT",1))
t.start()
#t.join()
threads.append(t)




#t = threading.Thread(target=thread,args=(1,1))
#t.start()

#print(len(NotBinance))
"""
try:
    print(int("sdfsdf"))
except (ValueError, RuntimeError, TypeError, NameError):
    print("Unable to process your request dude!!")
else:
    print(123)
"""

#ask red down
#bids green up