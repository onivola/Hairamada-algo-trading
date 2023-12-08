#coding:utf-8

#import fonction
import requests
import json
import pyautogui
import mouse
import time



		 #
###############################################################focntion RSI qui verifier l'indicateur ##########################################################

def check_3_sma(SMA_MAINTSO_0,SMA_MAINTSO_1,SMA_MAINTSO_2,SMA_MAINTSO_3,SMA_MAINTSO_4,SMA_MAINTSO_5,SMA_MAINTSO_6,SMA_MAINTSO_7,SMA_MAINTSO_8,SMA_MAINTSO_9,SSMA_MENA_0,SSMA_MENA_1,SSMA_MENA_2,SSMA_MENA_3,SSMA_MENA_4,SSMA_MENA_5,SSMA_MENA_6,SSMA_MENA_7,SSMA_MENA_8,SSMA_MENA_9,SMA_MAVO_0,SMA_MAVO_1,SMA_MAVO_2,SMA_MAVO_3,SMA_MAVO_4):
	"""if(SMA200_0>SMA_MAINTSO_0 and SMA200_0>SSMA_MENA_0):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_1>SMA_MAINTSO_1 and SMA200_1>SSMA_MENA_1):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_2>SMA_MAINTSO_2 and SMA200_2>SSMA_MENA_2):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_3>SMA_MAINTSO_3 and SMA200_3>SSMA_MENA_3):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_4>SMA_MAINTSO_4 and SMA200_4>SSMA_MENA_4):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_5>SMA_MAINTSO_5 and SMA200_5>SSMA_MENA_5):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_6>SMA_MAINTSO_6 and SMA200_6>SSMA_MENA_6):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_7>SMA_MAINTSO_7 and SMA200_7>SSMA_MENA_7):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_8>SMA_MAINTSO_8 and SMA200_8>SSMA_MENA_8):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")
	if(SMA200_9>SMA_MAINTSO_9 and SMA200_9>SSMA_MENA_9):
		print("200 au dessus de lente et rapide")
	else:
		print("200 au dessous de lente et rapide")"""
	print("maintso:"+str(SMA_MAINTSO_0)+" mena:"+str(SSMA_MENA_0))
	if(SMA_MAINTSO_0==SSMA_MENA_0):
		print(" maintso == mena")
	elif (SMA_MAINTSO_0<SSMA_MENA_0):
		print("maintso ambany mena")
	
	elif (SMA_MAINTSO_0>SSMA_MENA_0):
		print("maintso ambony mena")
	else:
		print("maintso ambany mena ")
	if(SMA_MAINTSO_1==SSMA_MENA_1):
		print(" maintso == mena")
	elif(SMA_MAINTSO_1>SSMA_MENA_1):
		print("maintso ambony mena")
	else:
		print("maintso ambany mena")
	if (SMA_MAINTSO_2>SSMA_MENA_2):
		print("maintso ambony mena")
	else:
		print("maintso ambany mena")
	if (SMA_MAINTSO_3>SSMA_MENA_3):
		print("maintso ambony mena")
	else:
		print("maintso ambany mena")
	if (SMA_MAINTSO_4>SSMA_MENA_4):
		print("maintso ambony mena")
	else:
		print("maintso ambany mena")
	if (SMA_MAINTSO_5>SSMA_MENA_5):
		print("maintso ambony mena")
	else:
		print("maintso ambany mena")
	if (SMA_MAINTSO_6>SSMA_MENA_6):
		print("maintso ambony mena")
	else:
		print("maintso ambany mena")
	if (SMA_MAVO_0==SMA_MAINTSO_0):
		print("mavo == mena")
	elif (SMA_MAVO_0>SMA_MAINTSO_0):
		print("mavo ambony maintso")
	else:
		print("mavo ambany maintso")
	if (SMA_MAVO_1>SMA_MAINTSO_1):
		print("mavo ambony maintso")
	else:
		print("mavo ambany maintso")
	if (SMA_MAVO_2>SMA_MAINTSO_2):
		print("mavo ambony maintso")
	else:
		print("mavo ambany maintso")

	print("mavo"+str(SMA_MAVO_0)+"maintso"+str(SMA_MAINTSO_0)+"mena"+str(SSMA_MENA_0))

	if(SMA_MAVO_1<SSMA_MENA_1 and SMA_MAVO_1<SMA_MAINTSO_1 and SMA_MAVO_2<SSMA_MENA_2 and SMA_MAVO_2<SMA_MAINTSO_2 and SSMA_MENA_2>SMA_MAINTSO_2  and SSMA_MENA_0-SMA_MAINTSO_0>=-0.00001):
		print("Miakatra 1:"+str(SSMA_MENA_0-SMA_MAINTSO_0))
		return 1
	elif(SMA_MAVO_1>SSMA_MENA_1 and SMA_MAVO_1>SMA_MAINTSO_1 and SMA_MAVO_2>SSMA_MENA_2 and SMA_MAVO_2>SMA_MAINTSO_2 and SSMA_MENA_2<SMA_MAINTSO_2  and SMA_MAINTSO_0-SSMA_MENA_0>=-0.00001):
		print("Midina 2:"+str(SMA_MAINTSO_0-SSMA_MENA_0))
		return 2

	if(SMA_MAVO_2>SMA_MAINTSO_2 and SMA_MAVO_1>SMA_MAINTSO_1 and SMA_MAINTSO_0-SMA_MAVO_0>=-0.00001):
		print("Miakatra 11:"+str(SSMA_MENA_0-SMA_MAINTSO_0))
		return 11
	elif(SMA_MAVO_2<SMA_MAINTSO_2 and SMA_MAVO_1<SMA_MAINTSO_1 and SMA_MAVO_0-SMA_MAINTSO_0>=-0.00001):
		print("Midina 22:"+str(SMA_MAINTSO_0-SSMA_MENA_0))
		return 22

	else:
		return False

################################fonction Befor click#####################################################


def BeforClick(newTime,i):
	if(newTime-tempSygnal[i]<180):
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

######################################foction coordonne####################################################################

def clic_fonction(indicator_3_sma,upX,upY,downX,downY):
	print("anaty fonction click")
	print(indicator_3_sma)
	if indicator_3_sma == 11 or indicator_3_sma==1:
		print("Click miakatra")
		pyautogui.click(upX ,upY)
		time.sleep(180)
	elif indicator_3_sma == 22 or indicator_3_sma==2:
		print("Click midina")
		pyautogui.click(downX,downY)
		time.sleep(180)
	else:
    	 return 2


nb = 1

#api key manoa 0e52450de7c74b8f9bb06a9f83408e48
# api key 01   3a529b2c00bb4c44a54d1827f5e9c1c9
"""a7f183acd87e4e1b98abfe720b799ccc
fanoavanarami@gmail.com"""
abisciseUp = [600,1264,1310,622,962,1310,622,962,1310]
ordonneUP = [323,290,224,410,410,410,603,603,603]
abisciseDown = [600,1264,1310,622,962,1310,622,962,1310]
ordonneDown = [375,344,260,410,410,410,634,634,634]
tempSygnal = [400,400,400,400,400,400,400,400,400]

SYMBOL = ["EUR/USD","GBP/USD","GBP/JPY","EUR/JPY","GBP/USD","AUD/CHF","AUD/USD","USD/CAD","AUD/JPY"]

img=pyautogui.screenshot()
rgb = img.getpixel((100,200))
print(img);
print(rgb);

while 1:	
		for element in range(1):
			tl0 = time.time()
			
		
			print('indice'+str(element)+'symbol'+SYMBOL[element])
			r = requests.get('https://api.twelvedata.com/sma?symbol='+SYMBOL[element]+'&interval=1min&time_period=9&apikey=3a529b2c00bb4c44a54d1827f5e9c1c9')
			y= requests.get('https://api.twelvedata.com/sma?symbol='+SYMBOL[element]+'&interval=1min&time_period=21&apikey=3a529b2c00bb4c44a54d1827f5e9c1c9')
			z = requests.get('https://api.twelvedata.com/sma?symbol='+SYMBOL[element]+'&interval=1min&time_period=50&apikey=3a529b2c00bb4c44a54d1827f5e9c1c9')



			data_sma9 = r.json()
			#print(data_sma9)

			SMA_MAINTSO_0 = float((data_sma9["values"][0]["sma"]))
			SMA_MAINTSO_1 = float((data_sma9["values"][1]["sma"]))
			SMA_MAINTSO_2 = float((data_sma9["values"][2]["sma"]))
			SMA_MAINTSO_3 = float((data_sma9["values"][3]["sma"]))
			SMA_MAINTSO_4 = float((data_sma9["values"][4]["sma"]))
			SMA_MAINTSO_5 = float((data_sma9["values"][5]["sma"]))
			SMA_MAINTSO_6 = float((data_sma9["values"][6]["sma"]))
			SMA_MAINTSO_7 = float((data_sma9["values"][7]["sma"]))
			SMA_MAINTSO_8 = float((data_sma9["values"][8]["sma"]))
			SMA_MAINTSO_9 = float((data_sma9["values"][9]["sma"]))
			"""SMA_MAINTSO_10 = float((data_sma9["values"][10]["sma"]))
												SMA_MAINTSO_11 = float((data_sma9["values"][11]["sma"]))
												SMA_MAINTSO_12 = float((data_sma9["values"][12]["sma"]))
												SMA_MAINTSO_13 = float((data_sma9["values"][13]["sma"]))"""
  
			data_sSMA_MENA = y.json()
			#print(data_sSMA_MENA)

			sSMA_MENA_0 = float((data_sSMA_MENA["values"][1]["sma"]))
			sSMA_MENA_1 = float((data_sSMA_MENA["values"][1]["sma"]))
			sSMA_MENA_2 = float((data_sSMA_MENA["values"][2]["sma"]))
			sSMA_MENA_3 = float((data_sSMA_MENA["values"][3]["sma"]))
			sSMA_MENA_4 = float((data_sSMA_MENA["values"][4]["sma"]))
			sSMA_MENA_5 = float((data_sSMA_MENA["values"][5]["sma"]))
			sSMA_MENA_6 = float((data_sSMA_MENA["values"][6]["sma"]))
			sSMA_MENA_7 = float((data_sSMA_MENA["values"][7]["sma"]))
			sSMA_MENA_8 = float((data_sSMA_MENA["values"][8]["sma"]))
			sSMA_MENA_9 = float((data_sSMA_MENA["values"][9]["sma"]))
			"""sSMA_MENA_10 = float((data_sSMA_MENA["values"][10]["sma"]))
												sSMA_MENA_11 = float((data_sSMA_MENA["values"][11]["sma"]))
												sSMA_MENA_12 = float((data_sSMA_MENA["values"][12]["sma"]))
												sSMA_MENA_13 = float((data_sSMA_MENA["values"][13]["sma"]))"""


			

			data_sma200 = z.json()
			#print(data_rsi)
			#print(y.json())
			print(data_sma200)
			sma200_0 = float((data_sma200["values"][0]["sma"]))
			sma200_1 = float((data_sma200["values"][1]["sma"]))
			sma200_2 = float((data_sma200["values"][2]["sma"]))
			sma200_3 = float((data_sma200["values"][3]["sma"]))
			sma200_4 = float((data_sma200["values"][4]["sma"]))
			"""
			sma200_5 = float((data_sma200["values"][5]["sma"]))
			sma200_6 = float((data_sma200["values"][6]["sma"]))
			sma200_7 = float((data_sma200["values"][5]["sma"]))
			sma200_8 = float((data_sma200["values"][5]["sma"]))
			sma200_9 = float((data_sma200["values"][5]["sma"]))
			sma200_10 = float((data_sma200["values"][5]["sma"]))
												sma200_11 = float((data_sma200["values"][5]["sma"]))
												sma200_12 = float((data_sma200["values"][5]["sma"]))
												sma200_13 = float((data_sma200["values"][5]["sma"]))"""
			####################################################### RSI ########################################################

			Indicator_3_sma = check_3_sma(SMA_MAINTSO_0,SMA_MAINTSO_1,SMA_MAINTSO_2,SMA_MAINTSO_3,SMA_MAINTSO_4,SMA_MAINTSO_5,SMA_MAINTSO_6,SMA_MAINTSO_7,SMA_MAINTSO_8,SMA_MAINTSO_9,sSMA_MENA_0,sSMA_MENA_1,sSMA_MENA_2,sSMA_MENA_3,sSMA_MENA_4,sSMA_MENA_5,sSMA_MENA_6,sSMA_MENA_7,sSMA_MENA_8,sSMA_MENA_9,sma200_0,sma200_1,sma200_2,sma200_3,sma200_4)
			if(Indicator_3_sma == 1 or Indicator_3_sma == 11 or Indicator_3_sma == 2 or Indicator_3_sma == 22):
				print('SMA = :{}'.format(Indicator_3_sma))
				if(BeforClick(time.time(),element)==True):
					clic_fonction(Indicator_3_sma,abisciseUp[element],ordonneUP[element],abisciseDown[element],ordonneDown[element])
			else :
				print('Simple Moving Average = :{}'.format(Indicator_3_sma))
			print("nb_request="+str(nb))
			if(nb%1==0):
				tl1 = time.time()
				sleep = 60 - (tl1-tl0)
				for item in range(1,sleep):
					print(item)
					time.sleep(1)
				print("++++++++++SLEEP+++++++++++")
			
			nb+=1
			


