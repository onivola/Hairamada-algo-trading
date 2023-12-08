#coding:utf-8

#import fonction
import requests
import json
import pyautogui
import time
import random





###########################################################fonction macd qui verifier l'indicateur ####################################################################

def check_macd (MACD0,MACD1,MACD2,MACD3,MACD4,MACD5,MACD6,MACD7,MACD8,MACD9,MACD10,MACD11,SIGNAL0,SIGNAL1,SIGNAL2,SIGNAL3,SIGNAL4,SIGNAL5,SIGNAL6,SIGNAL7,SIGNAL8,SIGNAL9,SIGNAL10,SIGNAL11,HIST0,HIST1,HIST2,HIST3,HIST4,HIST5,HIST6,HIST7,HIST8,HIST9,HIST10,HIST11):
	
	if(MACD0 < SIGNAL0):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD1 < SIGNAL1):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD2 < SIGNAL2):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD3 < SIGNAL3):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD4 < SIGNAL4):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD5 < SIGNAL5):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD6 < SIGNAL6):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD7 < SIGNAL7):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD8 < SIGNAL8):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD9 < SIGNAL9):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD10 < SIGNAL10):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	if(MACD11 < SIGNAL11):
		print('BLEU<RED')
	else:
		print("RED<BLEU")
	
	print(SIGNAL11)
	if HIST1<0 and HIST2<0 and HIST3<0 and HIST4<0 and HIST5<0 and HIST6<0 and HIST7<0 and HIST8<0 and HIST9<0 and HIST10<0 and HIST11<0 and MACD0-SIGNAL0 >=0 and MACD1<SIGNAL1 and MACD2<SIGNAL2 and MACD3<SIGNAL3 and MACD4<SIGNAL4 and MACD5<SIGNAL5 and MACD6<SIGNAL6 and MACD7<SIGNAL7 and MACD8<SIGNAL8 and MACD9<SIGNAL9 and MACD10<SIGNAL10:
				print("tafiditra if 2")
				return True
		#up  
	elif HIST1>0 and HIST2>0 and HIST3>0 and HIST4>0 and HIST5>0 and HIST6>0 and HIST7>0 and HIST8>0 and HIST9>0 and HIST10>0 and HIST11>0 and SIGNAL0-MACD0>=0 and MACD1>SIGNAL1 and MACD2>SIGNAL2 and MACD3>SIGNAL3 and MACD4>SIGNAL4 and MACD5>SIGNAL5 and MACD6>SIGNAL6 and MACD7>SIGNAL7 and MACD8>SIGNAL8 and MACD9>SIGNAL9 and MACD10>SIGNAL10:
		print("midina")
		return False 
		#down
	else:
		return 2


def clic_fonction(Indi_macd,upX,upY,downX,downY):
	print("anaty fonction CLICKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK")
	print(Indi_macd)
	if Indi_macd == True :
		print("miakatra")
		pyautogui.click(upX ,upY)
	elif Indi_macd == False :
		print("midina")
		pyautogui.click(downX,downY)
	else:
    	 return 2




################################fonction Befor click#####################################################
def BeforClick(newTime,i):
	if(newTime-tempSygnal[i]<300):
		print("tsy afaka mclick satri")
		print(newTime-tempSygnal[i])
		print(i)
		return False
	
	else:
		print("1111111111111111111")
		'''if(tempSygnal[i]!=400):
			pyautogui.click(neworderX[i],neworderY[i]-5)'''
		tempSygnal[i]=newTime
		return True
def GetRsi(data,length):
	rsi=[]
	for r in range(length):
		#print(r)
		#print(data_rsi["values"][0]["rsi"])
		rsi.append(float((data["values"][r]["rsi"])))
		print(rsi[r])
	return rsi
	

######################################foction coordonne####################################################################
#api key manoa 0e52450de7c74b8f9bb06a9f83408e48
# api key 01   3a529b2c00bb4c44a54d1827f5e9c1c9


nb = 1

neworderX = [622,962,1310,622,962,1310,622,962,1310]
neworderY = [260,260,260,410,410,410,634,634,634]

tempSygnal = [400,400,400,400,400,400,400,400,400]

''''abisciseUp = [622,962,1310,622,962,1310,622,962,1310]
ordonneUP = [224,224,224,410,410,410,603,603,603]
abisciseDown = [622,962,1310,622,962,1310,622,962,1310]
ordonneDown = [260,260,260,410,410,410,634,634,634]'''

abisciseUp = [1517,1505,1310,622,962,1310,622,962,1310]
ordonneUP = [379,664,224,410,410,410,603,603,603]
abisciseDown = [1503,1507,1310,622,962,1310,622,962,1310]
ordonneDown = [446,724,724,410,410,410,634,634,634]

#SYMBOL = ["EUR/USD","AUD/USD","GBP/JPY","EUR/JPY","GBP/USD","AUD/CHF","AUD/USD","USD/CAD","AUD/JPY"]
SYMBOL = ["EUR/JPY","AUD/CAD","GBP/JPY","EUR/JPY","GBP/USD","AUD/CHF","AUD/USD","USD/CAD","AUD/JPY"]
Apikey = ["63d51fe89a7c421f9f8039318636d9fd"]
while 1:	
	for element in range(2):

		print('indice'+str(element)+'symbol'+SYMBOL[element])
		
		y = requests.get('https://api.twelvedata.com/macd?symbol='+SYMBOL[element]+'&interval=1min&apikey='+Apikey[0])
		
		r = requests.get('https://api.twelvedata.com/rsi?symbol='+SYMBOL[element]+'&interval=1min&apikey='+Apikey[0])
		data_macd = y.json()
		data_rsi = r.json()
		#print(data_rsi)
		GetRsi(data_rsi,10)
	
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


		indicator_MACD = check_macd(macd0,macd1,macd2,macd3,macd4,macd5,macd6,macd7,macd8,macd9,macd10,macd11,macd_signal0,macd_signal1,macd_signal2,macd_signal3,macd_signal4,macd_signal5,macd_signal6,macd_signal7,macd_signal8,macd_signal9,macd_signal10,macd_signal11,macd_hist0,macd_hist1,macd_hist2,macd_hist3,macd_hist4,macd_hist5,macd_hist6,macd_hist7,macd_hist8,macd_hist9,macd_hist10,macd_hist11)

			

		if(indicator_MACD == True or indicator_MACD == False):
			print('MACD = :{}'.format(indicator_MACD))
			if(BeforClick(time.time(),element)==True):
				clic_fonction(indicator_MACD,abisciseUp[element],ordonneUP[element],abisciseDown[element],ordonneDown[element])
		else :
			print('MACD = :{}'.format(indicator_MACD))
		print("nb_request="+str(nb))
		if(nb%2==0):
			for item in range(1,30):
				print(item)
				time.sleep(1)
			print("++++++++++SLEEP+++++++++++")
			
		nb+=1
