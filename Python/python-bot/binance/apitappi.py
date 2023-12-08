import requests
import httpx
import aiohttp
import asyncio
import time
interval = '1m'
ApiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im9uaW50c29hcHJmc2xAZ21haWwuY29tIiwiaWF0IjoxNjI5OTgxODY5LCJleHAiOjc5MzcxODE4Njl9.T0Gm-3PhdxvvgrJMSACShQbAITwvdWX0y59ypefvzR8'



def AsyncMacdRsiStoch(symbol,interval,backtracks):
	loop = asyncio.get_event_loop()
	future1 = loop.run_in_executor(None, requests.get, 'https://api.taapi.io/macd?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
	future2 = loop.run_in_executor(None, requests.get, 'https://api.taapi.io/rsi?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
	future3 = loop.run_in_executor(None, requests.get, 'https://api.taapi.io/stochrsi?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
	future4 = loop.run_in_executor(None, requests.get, 'https://api.taapi.io/sma?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
	
	response1 = yield from future1
	response2 = yield from future2
	response3 = yield from future3
	response4 = yield from future4
	#print(response4.json())
	JsonMacd = response1.json()
	JsonRsi = response2.json()
	JsonStoch = response3.json()
	#print(JsonRsi)
	return [JsonMacd,JsonRsi,JsonStoch]

def GetMacdRsiStoch(symbol,interval,backtracks):
	loop = asyncio.get_event_loop()
	JsonData = loop.run_until_complete(AsyncMacdRsiStoch(symbol,interval,backtracks))
	return JsonData

#GetMacdRsiStoch('BTC/USDT','1m',10)
     
def StochRsi(symbol,interval,backtracks):
	while(1):
		try:
			response = requests.get('https://api.taapi.io/stochrsi?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
			response.raise_for_status()
		except requests.exceptions.RequestException as err:
			print("OOps: Something Else")
			pass
			time.sleep(3)
		except requests.exceptions.HTTPError as errh:
			print("Http Error:")
			pass
			time.sleep(3)
		except requests.exceptions.ConnectionError as errc:
			print("Error Connecting:")
			pass
			time.sleep(3)
		except requests.exceptions.Timeout as errt:
			print("Timeout Error:")
			pass  
			time.sleep(3)
		else:
			dataJson = response.json()
			#print(dataJson)
			return dataJson

def Macd(symbol,interval,backtracks):
	while(1):
		try:
			response = requests.get('https://api.taapi.io/macd?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
			response.raise_for_status()
		except requests.exceptions.RequestException as err:
			print("OOps: Something Else")
			pass
			time.sleep(3)
		except requests.exceptions.HTTPError as errh:
			print("Http Error:")
			pass
			time.sleep(3)
		except requests.exceptions.ConnectionError as errc:
			print("Error Connecting:")
			pass
			time.sleep(3)
		except requests.exceptions.Timeout as errt:
			print("Timeout Error:")
			pass  
			time.sleep(3)
		else:
			dataJson = response.json()
			#print(dataJson)
			return dataJson
def Rsi(symbol,interval,backtracks):
	while(1):
		try:
			response = requests.get('https://api.taapi.io/rsi?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
			response.raise_for_status()
		except requests.exceptions.RequestException as err:
			print("OOps: Something Else")
			pass
			time.sleep(3)
		except requests.exceptions.HTTPError as errh:
			print("Http Error:")
			pass
			time.sleep(3)
		except requests.exceptions.ConnectionError as errc:
			print("Error Connecting:")
			pass
			time.sleep(3)
		except requests.exceptions.Timeout as errt:
			print("Timeout Error:")
			pass  
			time.sleep(3)
		else:
			dataJson = response.json()
			#print(dataJson)
			return dataJson

#def TRAITMENT INDICATEUR
def tmtMACD(json): 
	#direction 0down 1up
	#console.log(json)	
	bleu0 = json[0]['valueMACD']
	red0 = json[0]['valueMACDSignal']
	hist0 = json[0]['valueMACDHist']
	bleu1 = json[1]['valueMACD']
	red1 = json[1]['valueMACDSignal']
	hist1 = json[1]['valueMACDHist']
	minx=-0.01
	maxx=0.01
	if(interval=="1m"): 
		minx=-0.03
		maxx=0.03

	if(interval=="3m"): 
		minx=-0.2
		maxx=0.2

	if(interval=="5m"): 
		minx=-0.4
		maxx=0.4

	"""console.log(minx)
	console.log(maxx)"""
	if(bleu0<red0 and bleu1>=red1):  #Down
		"""console.log(bleu0)		#BLEU
		console.log(red0) #RED	
		console.log(hist0)	#HIST
		console.log(0)	#HIST"""
		return 0
	elif(bleu0>red0  and bleu1<=red1): 
		"""console.log(bleu0)		#BLEU
		console.log(red0) #RED
		console.log(hist0)	#HIST
		console.log(1)	#HIST"""
		return 1
	else:
		return 20
def StopRsi(json):
	maxx =70 #70 ligne
	smax =70 #70 ligne
	midle=50 #50 ligne
	minx=30 #30 ligne
	sminx=30 #30 ligne
	rsi0=json[0]['value']
	rsi1=json[1]['value']
	rsi2=json[2]['value']
	rsi3=json[3]['value']
	if(rsi0>smax):  #Down
		return 1
	elif(rsi0<sminx):  #Down
		return 0
	else: 
		return 20
def CheckByValueRsi(json,value):
	maxx =70 #70 ligne
	vmax =75 #70 ligne
	midle=50 #50 ligne
	minx=30 #30 ligne
	vminx=25 #30 ligne
	rsi0=json[0]['value']
	print(rsi0)
	rsi1=json[1]['value']
	rsi2=json[2]['value']
	rsi3=json[3]['value']
	if(rsi0>value):  #Down
		return 0
	elif(rsi0<value):  #Down
		return 1
	else: 
		return 20
def MaxRsi(json):
	maxx =70 #70 ligne
	vmax =72 #70 ligne
	midle=50 #50 ligne
	minx=30 #30 ligne
	vminx=25 #30 ligne
	rsi0=float(json[0]['value'])
	print("rsi="+str(rsi0))
	rsi1=json[1]['value']
	rsi2=json[2]['value']
	rsi3=json[3]['value']
	if(rsi0>vmax):  #Down
		return 0
	elif(rsi0<vminx):  #Down
		return 1
	else: 
		return 20
def tmtRSI(json): 
	#console.log(json)
	#console.log(json[0].value)
	#console.log(json[0].value)
	maxx =70 #70 ligne
	midle=50 #50 ligne
	minx=30 #30 ligne
	rsi0=json[0]['value']
	rsi1=json[1]['value']
	rsi2=json[2]['value']
	rsi3=json[3]['value']

	#check direction up
	if(rsi0>midle and (rsi1<midle or rsi2<midle or rsi3<midle) and rsi0<maxx):  #Down
		return 1
	elif(rsi0<midle and (rsi1>midle or rsi2>midle or rsi3>midle) and rsi0>minx):  #Down
		return 0
	else: 
		return 20


def tmtSTOCHRSI(json): 

	maxx =70 #70 ligne
	midle=50 #50 ligne
	minx=30 #30 ligne

	valueFastK0 = json[0]['valueFastK'] #bleu
	valueFastD0= json[0]['valueFastD'] #red

	valueFastK1=json[1]['valueFastK']
	valueFastK2=json[2]['valueFastK']
	valueFastK3=json[3]['valueFastK']

	valueFastD1= json[1]['valueFastD'] #red
	valueFastD2= json[2]['valueFastD'] #red
	valueFastD3= json[3]['valueFastD'] #red

	if(valueFastK0>minx and valueFastK0<maxx and  (valueFastK1<minx or valueFastK2<minx or valueFastK3<minx)
	and valueFastD0>minx and valueFastD0<maxx and  (valueFastD1<minx or valueFastD2<minx or valueFastD3<minx)):  #Down
		return 1


	elif(valueFastK0<maxx and valueFastK0>minx and  (valueFastK1>maxx or valueFastK2>maxx or valueFastK3>maxx)
	and valueFastD0<maxx and valueFastD0>minx and  (valueFastD1>maxx or valueFastD2>maxx or valueFastD3>maxx)):  #Down
		return 0


	else: 
		return 20

#d = StochRsi('BTC/USDT','1m',10)

#print(len(d))
"""
JsonStoch = StochRsi('BTC/USDT','1m',10)
JsonRsi = Rsi('BTC/USDT','1m',10)
JsonMacd = Macd('BTC/USDT','1m',10)
CkMacd = tmtMACD(JsonMacd)
CkStockrsi = tmtSTOCHRSI(JsonStoch)
CkTsi = tmtRSI(JsonRsi)
print(CkMacd)
print(CkStockrsi)
print(CkTsi)
"""