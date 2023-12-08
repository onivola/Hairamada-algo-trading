import pyautogui
import time
import threading
import requests
import pyautogui
import json
from tkinter import * 
from requests.exceptions import ConnectionError


abisciseUp=1273
ordonneUP=510
abisciseDown=1273
ordonneDown=572
longeur = 10

root = Tk()
root.title('Robine')
root.geometry('500x500+500+200')
sommeselltK1 = Label(root, text='ask=')
sommeselltK1.pack(ipadx=10, ipady=10)
sommebuytK1 = Label(root, text='SellQt=')
sommebuytK1.pack(ipadx=10, ipady=10)

sommeselltK3 = Label(root, text='ask=')
sommeselltK3.pack(ipadx=10, ipady=10)
sommebuytK3 = Label(root, text='SellQt=')
sommebuytK3.pack(ipadx=10, ipady=10)

sommeselltK5 = Label(root, text='ask=')
sommeselltK5.pack(ipadx=10, ipady=10)
sommebuytK5 = Label(root, text='SellQt=')
sommebuytK5.pack(ipadx=10, ipady=10)

sommeselltK7 = Label(root, text='ask=')
sommeselltK7.pack(ipadx=10, ipady=10)
sommebuytK7 = Label(root, text='SellQt=')
sommebuytK7.pack(ipadx=10, ipady=10)

bsommesell = Label(root, text='ask=')
bsommesell.pack(ipadx=10, ipady=10)
bsommebuy = Label(root, text='SellQT=')
bsommebuy.pack(ipadx=10, ipady=10)

#sommeselltK20 = Label(root, text='ask=')
#sommeselltK20.pack(ipadx=10, ipady=10)
#sommebuytK20 = Label(root, text='SellQt=')
#sommebuytK20.pack(ipadx=10, ipady=10)

#https://api.kraken.com/0/public/Trades?pair=eurusd&since=1559350785297011119
#from datetime import datetime

#dt_obj = datetime.strptime('20.12.2016 09:38:42,76',
                           #'%d.%m.%Y %H:%M:%S,%f')
#millisec = dt_obj.timestamp() * 1000

#print(millisec)
############3click fonction 
def clic_fonction(quantite,upX,upY,downX,downY):
	#print("anaty fonction click")
	#print(indicator_3_sma)
	if quantite == 2:
		print("Click miakatra")
		pyautogui.click(upX ,upY)
		time.sleep(60)
	elif quantite == 1:
		print("Click midina")
		pyautogui.click(downX,downY)
		time.sleep(60)
	else:
    	 return 0

############click fonction 

ListLouckBuy = []
ListBuyTP = []
ListBuySL = []
ListBuyTPQT = []
ListBuySLQT = []


ListLouckSell = []
ListSellTP = []
ListSellSL = []

ListSellTPQT = []
ListSellSLQT = []

mijanona = [False]

orderbk=[]
listasks=[]
priceAsks=[]
quantityAsks=[]
SYMBOL ="EURUSD"

def RequestOrderBook(symbol):
    try:
        orderbk = requests.get('https://api.kraken.com/0/public/Depth?pair='+symbol+'&&limit=1000')
        data = orderbk.json()
        #print(data)
        return data
    except ConnectionError as e:    # This is the correct syntax
        print(e)
        r = "No response"
        return 0

def position_standard (valeurS1,valeurS3,valeurB1,valeurB3):
	diff_01 = valeurS1 - valeurB1
	diff_03 = valeurS3 - valeurB3
	diff_midina_01 = valeurB1 - valeurS1
	diff_midina_03 = valeurB3 - valeurS3
	print(valeurS1)
	print(valeurB1)
	print(valeurS3)
	print(valeurB3)

	print('diff_01 :' + str(diff_01))
	print('diff_03 :' + str(diff_03))
	print('diff_midina_01 :' + str(diff_midina_01))
	print('diff_midina_03 :' + str(diff_midina_03))
	if diff_01 >= 1000  and diff_03 >= 1000:
		print('diff_01 :' + str(diff_01))
		print('diff_03 :' + str(diff_03))

		print('miakatra position standard')
		return 2

	elif diff_midina_01 >= 1000 and   diff_midina_03>= 1000:
		print('diff_midina_01 :' + str(diff_midina_01))
		print('diff_midina_03 :' + str(diff_midina_03))


		print('midina position standard')
		return 1
	else :
		return 0

def good_Position (valeurS1,valeurS3,valeurS5,valeurS7,valeurS10,valeurB1,valeurB3,valeurB5,valeurB7,valeurB10):
	print ('tafiditra ato good position ')
	if valeurS1 <= 0.001 and 1500 <= valeurB1 >= 1000:
		print ('midina')
		return 1
	elif valeurB1 <= 0.001 and 1500 <= valeurB1 >=1000:
		print ('miakatra')
		return 2
	else :
		return 0



#print('ASK = ' + str(sell))
#print('buy :'+ str(buy))
def getOrder(lists,boole,endd):
	x=0
	listsell=[]
	for x in range (0,endd):
		listsell.append(lists[x][1])
	#print(listsell)
	return listsell
#print('sell quantity :' + str(cell))

def sumSell(listfotsiny,bool,endd):
	x=0
	sum = 0
	for x in range (0,endd):
		sum = sum + float(listfotsiny[x])
	return sum


def RunBot(symbol,t):
	while(1):
		print('mande')
		brute_data = RequestOrderBook(symbol)
		sell = brute_data["result"]["ZEURZUSD"]["asks"]
		buy = brute_data["result"]["ZEURZUSD"]["bids"]

		##############20###############
		#listSell20=getOrder(sell,True,20)
		#listBuy20=getOrder(buy,True,20)
		#sommesellx20 =sumSell(listSell20,True,20)
		#sommebuyx20= sumSell(listBuy20,True,20)
        ###############20###############

         ###############10###############
		listSell=getOrder(sell,True,longeur)
		listBuy=getOrder(buy,True,longeur)
		sommesellx =sumSell(listSell,True,longeur)
		sommebuyx = sumSell(listBuy,True,longeur)
		print('sell 10 :'+str(sommesellx))
		print('buy 10 :' +str(sommebuyx))
         ###############10###############

         ###############7###############

		listSell7 =getOrder(sell,True,7)
		listBuy7=getOrder(buy,True,7)
		sommesellx7 =sumSell(listSell,True,7)
		sommebuyx7= sumSell(listBuy,True,7)
		#print(sommebuyx7)  
		print('sell 7 :'+str(sommesellx7))
		print('buy 7 :' +str(sommebuyx7))

		listSell5=getOrder(sell,True,5)
		listBuy5=getOrder(buy,True,5)
		sommesellx5 =sumSell(listSell,True,5)
		sommebuyx5= sumSell(listBuy,True,5)
		print('sell 5 :'+str(sommesellx5))
		print('buy 5 :' +str(sommebuyx5))

		listSell3=getOrder(sell,True,3)
		listBuy3=getOrder(buy,True,3)
		sommesellx3 =sumSell(listSell,True,3)
		sommebuyx3= sumSell(listBuy,True,3)

		print('sell 3 :'+str(sommesellx3))
		print('buy 3 :' +str(sommebuyx3))

		listSell1=getOrder(sell,True,1)
		listBuy1=getOrder(buy,True,1)
		sommesellx1 =sumSell(listSell,True,1)
		sommebuyx1= sumSell(listBuy,True,1)
		print('sell 1 :'+str(sommesellx1))
		print('buy 1 :' +str(sommebuyx1))

		verifed = good_Position(sommesellx1,sommesellx3,sommesellx5,sommesellx7,sommesellx,sommebuyx1,sommebuyx3,sommebuyx5,sommebuyx7,sommebuyx)
		clic_fonction(verifed,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
		verification_var = position_standard (sommesellx1,sommesellx3,sommebuyx1,sommebuyx3)
		clic_fonction(verification_var,abisciseUp,ordonneUP,abisciseDown,ordonneDown)

#########################10
		sommesell = int(sommesellx)
		sommebuy  = int(sommebuyx)
		bsommesell['text'] = "sell 10 :"+str(sommesell)
		bsommebuy['text'] = "buy 10 : "+str(sommebuy)
#########################7
		sommesellTK7 = int(sommesellx7)
		sommebuyTK7  = int(sommebuyx7)
		sommeselltK7['text'] = "sell 7 :"+str(sommesellTK7)
		sommebuytK7['text'] = "buy 7 : "+str(sommebuyTK7)
#########################5
		sommesellTK5 = int(sommesellx5)
		sommebuyTK5  = int(sommebuyx5)
		sommeselltK5['text'] = "sell 5 :"+str(sommesellTK5)
		sommebuytK5['text'] = "buy 5 : "+str(sommebuyTK5)
################################333333333333333
		sommesellTK3 = int(sommesellx3)
		sommebuyTK3 = int(sommebuyx3)
		sommeselltK3['text'] = "sell 3 :"+str(sommesellTK3)
		sommebuytK3['text'] = "buy 3 : "+str(sommebuyTK3)

##################01111111111111111111111111
		sommesellTK1= int(sommesellx1)
		sommebuyTK1  = int(sommebuyx1)
		sommeselltK1['text'] = "sell 1 :"+str(sommesellTK1)
		sommebuytK1['text'] = "buy 1 : "+str(sommebuyTK1)
##################20
		#sommesellTK20= int(sommesellx20)
		#sommebuyTK20  = int(sommebuyx20)
		#sommeselltK20['text'] = "sell 20 :"+str(sommesellTK20)
		#sommebuytK20['text'] = "buy 20 : "+str(sommebuyTK20)




		#print(sommesell)
		#print(sommebuy)

TOrder = threading.Thread(target=RunBot,args=(SYMBOL,1))
TOrder.start()
root.mainloop()
