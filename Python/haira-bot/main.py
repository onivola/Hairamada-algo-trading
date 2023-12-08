#coding:utf-8

#import ApiTaapi
#import Fonction
import requests
import json
#import pyautogui
#import mouse
import time

#print(Fonction.check_rsi(1,50,50))

tempSygnal = [400,400,400,400,400,400,400,400,400]
abisciseUp = [616,956,1302,614,959,1311,619,959,1308]
abisciseDown = [615,962,1304,616,961,1308,618,958,1308]
ordonneUP = [193,199,198,381,380,381,572,569,573]
ordonneDown = [228,231,233,416,416,420,609,604,607]



# Define indicator
indicator = "rsi"
  
# Define endpoint 
endpoint = f"https://api.taapi.io/{indicator}"
  
# Define a parameters dict for the parameters to be sent to the API 
parameters = {
    'secret': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFuZHJ5YXJpdm9sYUB5bWFpbC5jb20iLCJpYXQiOjE2MjExNDg4MTEsImV4cCI6NzkyODM0ODgxMX0.yi0xqrH-lONs06NDwudBDm4TunRiTQ-NvDk9gUjOvxs',
    'exchange': 'binance',
    'symbol': 'BTC/USDT',
    'interval': '1h'
    } 
  
# Send get request and save the response as response object 
response = requests.get(url = endpoint, params = parameters)
result = response.json() 
print(result)
response = requests.get(url = endpoint, params = parameters)
  
# Extract data in json format 


# Print result


SYMBOL = ["EUR/USD","AUD/GBP","GBP/JPY","EUR/JPY","GBP/USD","AUD/CAD","AUD/USD","USD/CAD","AUD/JPY"]


''''while 1:	
		for element in range(9):
		 #print(element)
		 	#print(SYMBOL[element])
			r = requests.get('https://api.twelvedata.com/rsi?symbol={}&interval=1min&apikey=3a529b2c00bb4c44a54d1827f5e9c1c9'.format (SYMBOL[element]))
			y = requests.get('https://api.twelvedata.com/macd?symbol={}&interval=1min&apikey=3a529b2c00bb4c44a54d1827f5e9c1c9'.format (SYMBOL[element]))
			z = requests.get('https://api.twelvedata.com/stoch?symbol={}&interval=1min&apikey=3a529b2c00bb4c44a54d1827f5e9c1c9'.format (SYMBOL[element]))

			data_rsi = r.json()
			#print(y.json())
			rsi0 = float((data_rsi["values"][0]["rsi"]))
			rsi1 = float((data_rsi["values"][1]["rsi"]))
			rsi2 = float((data_rsi["values"][2]["rsi"]))

			####################################################### RSI ########################################################


			data_macd = y.json()
			#macd = green line 
			macd0 = float((data_macd["values"][0]["macd"]))
			macd1 = float((data_macd["values"][1]["macd"]))
			macd2 = float((data_macd["values"][2]["macd"]))
			macd3 = float((data_macd["values"][3]["macd"]))
			macd4 = float((data_macd["values"][4]["macd"]))
			macd5 = float((data_macd["values"][5]["macd"]))
			macd6 = float((data_macd["values"][6]["macd"]))
			macd7 = float((data_macd["values"][7]["macd"]))
			macd8 = float((data_macd["values"][8]["macd"]))
			macd9 = float((data_macd["values"][9]["macd"]))
			macd10 = float((data_macd["values"][10]["macd"]))
			macd11 = float((data_macd["values"][11]["macd"]))




			#macd_signal =  red  line 
			macd_signal0 = float((data_macd["values"][0]["macd_signal"]))
			macd_signal1 = float((data_macd["values"][1]["macd_signal"]))
			macd_signal2 = float((data_macd["values"][2]["macd_signal"]))
			macd_signal3 = float((data_macd["values"][3]["macd_signal"]))
			macd_signal4 = float((data_macd["values"][4]["macd_signal"]))
			macd_signal5 = float((data_macd["values"][5]["macd_signal"]))
			macd_signal6 = float((data_macd["values"][6]["macd_signal"]))
			macd_signal7 = float((data_macd["values"][7]["macd_signal"]))
			macd_signal8 = float((data_macd["values"][8]["macd_signal"]))
			macd_signal9 = float((data_macd["values"][9]["macd_signal"]))
			macd_signal10 = float((data_macd["values"][10]["macd_signal"]))
			macd_signal11 = float((data_macd["values"][11]["macd_signal"]))





			macd_hist0 = float((data_macd["values"][0]["macd_hist"]))
			macd_hist1 = float((data_macd["values"][1]["macd_hist"]))
			macd_hist2 = float((data_macd["values"][2]["macd_hist"]))
			macd_hist3 = float((data_macd["values"][3]["macd_hist"]))
			macd_hist4 = float((data_macd["values"][4]["macd_hist"]))
			macd_hist5 = float((data_macd["values"][5]["macd_hist"]))
			macd_hist6 = float((data_macd["values"][6]["macd_hist"]))
			macd_hist7 = float((data_macd["values"][7]["macd_hist"]))
			macd_hist8 = float((data_macd["values"][8]["macd_hist"]))
			macd_hist9 = float((data_macd["values"][9]["macd_hist"]))
			macd_hist10 = float((data_macd["values"][10]["macd_hist"]))
			macd_hist11= float((data_macd["values"][11]["macd_hist"]))



			############################################################MACD#####################################################
			############################################################MACD#####################################################

			data_stoch = z.json()

			stoch_Slow_k0 = float((data_stoch["values"][0]["slow_k"]))
			stoch_Slow_k1 = float((data_stoch["values"][1]["slow_k"]))
			stoch_Slow_k2 = float((data_stoch["values"][2]["slow_k"]))
			stoch_Slow_k3 = float((data_stoch["values"][3]["slow_k"]))
			stoch_Slow_k4 = float((data_stoch["values"][4]["slow_k"]))

			##STOCH %K = BLEU LINE 
			## STOCH %D = RED LINE

			stoch_Slow_d0 = float((data_stoch["values"][0]["slow_d"]))
			stoch_Slow_d1 = float((data_stoch["values"][1]["slow_d"]))
			stoch_Slow_d2 = float((data_stoch["values"][2]["slow_d"]))
			stoch_Slow_d3 = float((data_stoch["values"][3]["slow_d"]))
			stoch_Slow_d4 = float((data_stoch["values"][4]["slow_d"]))




			indicator_RSI = check_rsi(rsi0,rsi1,rsi2)
			indicator_MACD = check_macd(macd0,macd1,macd2,macd3,macd4,macd5,macd6,macd7,macd8,macd9,macd10,macd11,macd_signal0,macd_signal1,macd_signal2,macd_signal3,macd_signal4,macd_signal5,macd_signal6,macd_signal7,macd_signal8,macd_signal9,macd_signal10,macd_signal11,macd_hist0,macd_hist1,macd_hist2,macd_hist3,macd_hist4,macd_hist5,macd_hist6,macd_hist7,macd_hist8,macd_hist9,macd_hist10,macd_hist11)
			indicator_STOCH = check_stoch(stoch_Slow_k0,stoch_Slow_k1,stoch_Slow_k2,stoch_Slow_k3,stoch_Slow_d0,stoch_Slow_d1,stoch_Slow_d2,stoch_Slow_d3)
			

			click = verificetion_position(indicator_RSI,indicator_STOCH,indicator_MACD)
			if(click==True or click==False):
				if(BeforClick(time.time(),element)==True):
					clic_fonction(click,abisciseUp[element],ordonneUP[element],abisciseDown[element],ordonneDown[element])
			'''