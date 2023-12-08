import requests

interval = '1m'
ApiKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6IjAxZmFub3V4QGdtYWlsLmNvbSIsImlhdCI6MTYyOTk3MTY3MCwiZXhwIjo3OTM3MTcxNjcwfQ.qBSCHFwpPZg4UrLf64_fbVQ-Dzf8ACZ1hFVbLn3wzyA'
def StochRsi(symbol,interval,backtracks):
    try:
        data = requests.get('https://api.taapi.io/stochrsi?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
        dataJson = data.json()
        print(dataJson)
        return dataJson

    except ConnectionError as e:    # This is the correct syntax
        #print(e)
        r = "No response"
        return 0

def Macd(symbol,interval,backtracks):
    try:
        data = requests.get('https://api.taapi.io/macd?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
        dataJson = data.json()
        print(dataJson)
        return dataJson

    except ConnectionError as e:    # This is the correct syntax
        #print(e)
        r = "No response"
        return 0
def Rsi(symbol,interval,backtracks):
    try:
        data = requests.get('https://api.taapi.io/rsi?secret='+ApiKey+'&exchange=binance&symbol='+symbol+'&interval='+interval+'&backtracks='+str(backtracks))
        dataJson = data.json()
        print(dataJson)
        return dataJson

    except ConnectionError as e:    # This is the correct syntax
        #print(e)
        r = "No response"
        return 0



#def TRAITMENT INDICATEUR
def tmtMACD(json): 
	#direction 0down 1up
	#console.log(json)	
	bleu0 = json[0]['valueMACD']
	red0 = json[0]['valueMACDSignal']
	hist0 = json[0]['valueMACDHist']
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

	"""console.log(min)
	console.log(max)"""
	if(bleu0<red0 and bleu0>max and red0>max ):  #Down
		"""console.log(bleu0)		#BLEU
		console.log(red0) #RED	
		console.log(hist0)	#HIST
		console.log(0)	#HIST"""
		return 0
	elif(bleu0>red0 and bleu0<min and red0<min): 
		"""console.log(bleu0)		#BLEU
		console.log(red0) #RED
		console.log(hist0)	#HIST
		console.log(1)	#HIST"""
		return 1
	else:
		return 20

def tmtRSI(json): 
	#console.log(json)
	#console.log(json[0].value)
	#console.log(json[0].value)
	max =70 #70 ligne
	midle=50 #50 ligne
	min=30 #30 ligne
	rsi0=json[0]['value']
	rsi1=json[1]['value']
	rsi2=json[2]['value']
	rsi3=json[3]['value']

	#check direction up
	if(rsi0>midle and (rsi1<midle or rsi2<midle or rsi3<midle) and rsi0<max):  #Down
		return 1
	elif(rsi0<midle and (rsi1>midle or rsi2>midle or rsi3>midle) and rsi0>min):  #Down
		return 0
	else: 
		return 20


def tmtSTOCHRSI(json): 

	max =70 #70 ligne
	midle=50 #50 ligne
	min=30 #30 ligne

	valueFastK0 = json[0]['valueFastK'] #bleu
	valueFastD0= json[0]['valueFastD'] #red

	valueFastK1=json[1]['valueFastK']
	valueFastK2=json[2]['valueFastK']
	valueFastK3=json[3]['valueFastK']

	valueFastD1= json[1]['valueFastD'] #red
	valueFastD2= json[2]['valueFastD'] #red
	valueFastD3= json[3]['valueFastD'] #red

	if(valueFastK0>min and valueFastK0<max and  (valueFastK1<min or valueFastK2<min or valueFastK3<min)
	and valueFastD0>min and valueFastD0<max and  (valueFastD1<min or valueFastD2<min or valueFastD3<min)):  #Down
		return 1


	elif(valueFastK0<max and valueFastK0>min and  (valueFastK1>max or valueFastK2>max or valueFastK3>max)
	and valueFastD0<max and valueFastD0>min and  (valueFastD1>max or valueFastD2>max or valueFastD3>max)):  #Down
		return 0


	else: 
		return 20

	
	
JsonStoch = StochRsi('BTC/USDT','1m',10)
JsonRsi = Rsi('BTC/USDT','1m',10)
JsonMacd = Macd('BTC/USDT','1m',10)
CkMacd = tmtMACD(JsonMacd)
CkStockrsi = tmtSTOCHRSI(JsonStoch)
CkTsi = tmtRSI(JsonRsi)
print(CkMacd)
print(CkStockrsi)
print(CkTsi)
