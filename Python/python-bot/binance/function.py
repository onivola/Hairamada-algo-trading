import apitappi
import order
from pygame import mixer  # Load the popular external library


def Alarm(boole):
	mixer.init()
	if(boole==True):
		mixer.music.load('alarm/3up.mp3')
		mixer.music.play()
	elif(boole==False):
		mixer.music.load('alarm/3down.mp3')
		mixer.music.play()
	else:
		mixer.music.load('alarm/notif.mp3')
		mixer.music.play()
def GetNbVirgul(n):
    n = str(n)
    lst = n.split('.')

    nbvig = len(lst[1])
    print(lst)
    if(lst[1]=='0'):
        return 0
    else:
        print(lst)
        print(nbvig)
        return nbvig
"""
n=GetNbVirgul(15.3211)
print(n)
x = round(5.16543, n)
print(x)
"""

def UsdToQuantity(price,minQty,usd,levier):
    #priusd = 1btc
    #usd = ?
    price = float(price)
    minQty = float(minQty)
    usd = float(usd)*levier
    n=GetNbVirgul(minQty)
    quantity = '{:.20f}'.format((usd/price))
    print(n)
    if(n==0 and float(quantity)<=1):
        quantity = round(float(quantity),1)
        print(quantity)
    elif(n==0 and float(quantity)>1):
    	quantity = round(float(quantity))
    else:
        quantity = round(float(quantity),n)
    return quantity




quantity=1
JsonPrice = order.GetPrice('BTCUSDT')
Ptime = JsonPrice['time']
Bprice = float(JsonPrice['price'])
print(Bprice)
quantity = UsdToQuantity(Bprice,float(quantity),50000,20)
print(quantity)
#order.NewOrderMARKET('BTCUSDT',1,'BUY',Ptime)





"""
usd = UsdToQuantity(0.38569,1,2,20)
print(usd)
"""
def LoopCheckMacd(symbol,interval,backtracks,side):
	while(1):
		JsonMacd = apitappi.Macd(symbol,interval,backtracks)
		if(JsonMacd!=0):
			print(symbol)
			tm = apitappi.tmtMACD(JsonMacd)
			print(tm)
			if(tm==side):
				return True
def LoopCheckRSI(symbol,interval,backtracks,side):
	while(1):
		JsonRsi = apitappi.Rsi(symbol,interval,backtracks)
		if(JsonRsi!=0):
			print(symbol)
			tm = apitappi.StopRsi(JsonRsi)
			print(tm)
			if(tm==side):
				return True
def GetSideByBool(boole):
	if(boole):
		return 'BUY'
	else:
		return 'SELL'
#LoopCheckMacd('BTC/USDT','1m',10,True)
#LoopCheckRSI('BTC/USDT','1m',10,False)
def NotBinance(symbol):


	tbsymbol = ['LTO_USDT','DNT_USDT','ROSE/USDT','TRU/USDT','BEAM/USDT','GTO/USDT','LSK_USDT','IOTX_USDT','WAN_USDT','FORTH/USDT','JUV/USDT','FORTH/USDT','HIVE/USDT','XVS/USDT','IRIS/USDT','ACM/USDT','POND/USDT','CKB/USDT','ORN/USDT','ANT_USDT','AR/USDT','LTCUP/USDT','FIS/USDT','MFT/USDT','STX/USDT','NANO/USDT','CTXC/USDT','DATA/USDT','ASR/USDT','WIN/USDT','GBP/USDT','LUNA/USDT','BURGER/USDT','VTHO/USDT','PAXG/USDT','BUSD/USDT','MITH/USDT','WTC/USDT','CTSI/USDT','MDX/USDT','MASK/USDT','FET/USDT','TUSD/USDT','REP/USDT','RIF/USDT','EUR/USDT','HARD/USDT','NMR/USDT','KMD/USDT',"SUSD/USDT","MIR/USDT","PAX/USDT","USDC/USDT","PERL/USDT","MBL/USDT","JST/USDT","AUDIO/USDT","PUNDIX/USDT"]
	tbnotinapi = ['BTCST/USDT','1000SHIB/USDT','DEFI/USDT','DAI/USDT','HC/USDT','BNBBULL/USDT','AVA/USDT','ETHBEAR/USDT','BEAR/USDT','VEN/USDT','BCC/USDT','BCHSV/USDT','BCHABC/USDT','USDS/USDT','ERD/USDT','USDSB/USDT','ERD/USDT','NPXS/USDT','STORM/USDT','HC/USDTHC/USDT','MCO/USDT','BULL/USDT','ETHBULL/USDT','EOSBULL/USDT','EOSBEAR/USDT','XRPBULL/USDT','XRPBEAR/USDT','STRAT/USDT','BNBBULL/USDT].','BNBBEAR/USDT','XZC/USDT','LEND/USDT','BKRW/USDT']
	"""for(i=0i<tbsymbol.lengthi++):

	if(symbol==tbsymbol[i]):
	return False

	"""
	for x in range(0,len(tbnotinapi)):

		if(symbol==tbnotinapi[x]):
			return False
	return True
def CreateList(Json):
   
    #print(len(Json))
    for x in range(len(Json)-1,0,-1):
        #print(x)
        #print(Json[x]['isBuyerMaker'])
        if(Json[x]['isBuyerMaker']==True):
            TradeBuy.append(float(Json[x]['price']))
            TradeBuyQT.append(float(Json[x]['qty']))
        else:
            TradeSell.append(float(Json[x]['price']))
            TradeSellQT.append(float(Json[x]['qty']))
    return [TradeBuy,TradeSellQT]
def CheckIndicator(macd,rsi,stoch):
    if(macd==1 and rsi==1 and stoch==1):
        return True
    elif(macd==0 and rsi==0 and stoch==0):
        return False
    elif(macd+rsi+stoch==22 or (macd==0 and rsi==0) or (macd==0 and stoch==0) or (rsi==0 and stoch==0)):
    	return 2
    else:
    	return 20
def AddSlashUSDT(entstring):
	sygnal1 =  entstring[:len(entstring)-4]
	sygnal2 =  entstring[-4:]
	result = sygnal1+"/"+sygnal2
	#print(result)
	return result
def CheckMacdRsiStoch(JsonMacd,JsonRsi,JsonStoch):
	if(len(JsonMacd)>2 and len(JsonRsi)>2 and len(JsonStoch)>2):
		CkMacd = apitappi.tmtMACD(JsonMacd)
		CkStockrsi = apitappi.tmtSTOCHRSI(JsonStoch)
		CkTsi = apitappi.tmtRSI(JsonRsi)
		return [CkMacd,CkTsi,CkStockrsi]

	else:
		return [100,100,100]
#AddSlashUSDT('BTCDDDUSDT')
"""
symbol = 'BTCUSDT'
print(symbol[-4:])
"""

#apitappi.Rsi('QTUM/USDT','1m',10,False)

"""
if(LoopCheckRSI('SAND/USDT','1m',10,False)):
	Alarm(True)
"""