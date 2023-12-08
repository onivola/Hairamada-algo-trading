#!/usr/bin/env python

# WS client example
from tkinter import * 
import asyncio
import websocket
import json
import time
import threading
import requests
cc='btcusdt'
interval = '1m'


price=[0.01]

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


ListSens = []
ListPrice = []
ListGain = []
ListTP = []
ListSL = []

gain = [28]
perte = [28]
#animals.remove('rabbit')


mijanona = [False]
root = Tk()
root.title('Robine')
root.geometry('500x500+500+200')


#####################GUI######################
lbPrice = Label(root, text='Price='+str(price[0]))
lbPrice.pack(ipadx=10, ipady=10)
#LbBuyQT = Label(root, text='BuyQT='+str(price[0]))
#LbBuyQT.pack(ipadx=10, ipady=10)
LbBuyPC = Label(root, text='BuyPC='+str(price[0]))
LbBuyPC.pack(ipadx=10, ipady=10)
#LbSellQT = Label(root, text='SellQT='+str(price[0]))
#LbSellQT.pack(ipadx=10, ipady=10)
LbSellPC = Label(root, text='SellPC='+str(price[0]))
LbSellPC.pack(ipadx=10, ipady=10)

LbGain = Label(root, text='Gain='+str(price[0]))
LbGain.pack(ipadx=10, ipady=10)
LbPerte = Label(root, text='Perte='+str(price[0]))
LbPerte.pack(ipadx=10, ipady=10)

LbBuyEP = Label(root, text='Perte='+str(price[0]))
LbBuyEP.pack(ipadx=10, ipady=10)
LbBuyTP = Label(root, text='Perte='+str(price[0]))
LbBuyTP.pack(ipadx=10, ipady=10)
LbBuySL = Label(root, text='Perte='+str(price[0]))
LbBuySL.pack(ipadx=10, ipady=10)

LbSellEP = Label(root, text='Perte='+str(price[0]))
LbSellEP.pack(ipadx=10, ipady=10)
LbSellTP = Label(root, text='Perte='+str(price[0]))
LbSellTP.pack(ipadx=10, ipady=10)
LbSellSL = Label(root, text='Perte='+str(price[0]))
LbSellSL.pack(ipadx=10, ipady=10)
###########################################



def WriteFile():
	f = open("gain.txt", "a")
	f.write("Gain = "+str(gain[0])+"\n")
	f.write("perte = "+str(perte[0])+"\n")
	f.close()

sctOrderbk = f'wss://stream.binance.com:9443/ws/{cc}@depth@100ms'
sctPrice = 'wss://fstream.binance.com/ws/btcusdt@markPrice'
#print(socket)
def TotalQuantit(list):
	quantit = 0
	for x in range(0,len(list)):
		quantit = quantit+float(list[x][1])
	return quantit
def checkIntervalPrice(buy,sell,interval):
	#print(buy)
	#print(sell)
	print(price)
	buy= float(buy)
	sell= float(sell)
	if(sell>price[0]+2 and sell<price[0]+8  and buy>price[0]-8 and buy<price[0]-2): #price
	#if(sell<price[0]+20  and buy>price[0]-20): #price
		return True
	else:
		return False
def on_close(ws):
	print('connection closed')

def on_orderbook(ws,message):
	dataJS = json.loads(message)
	#print(dataJS[])
	#print("sell"+str(dataJS['a'][0])) #asc  sell
	#print("Price = "+str(price[0]))
	#print("buy"+str(dataJS['b'][0])) #Bids  buy
	#print("buy"+str(TotalQuantit(dataJS['b'])))



	

	LbBuyPC["text"] = "BuyPC="+ str(dataJS['b'][0])
	LbSellPC["text"] = "SellPC="+ str(dataJS['a'][0])

	if(checkIntervalPrice(dataJS['b'][0][0],dataJS['a'][0][0],5)):
		print("tamiditra")
		result = CheckQuantite(dataJS['b'][0],dataJS['a'][0])
		#print(result)
		if(result[0]==2 and mijanona[0]==False): #miakatra
			print("++++++++++++++++++++++++++++++")
			ListLouckBuy.append(price[0])
			ListBuyTP.append(float(dataJS['a'][0][0]))
			ListBuySL.append(float(dataJS['b'][0][0]))
			#print("order")
			
			#print("BuyTP="+str(ListBuyTP[len(ListBuyTP)-1]))
			#print("LouckBuy="+str(ListLouckBuy[len(ListLouckBuy)-1]))
			#print("BuySL="+str(ListBuySL[len(ListBuySL)-1]))

			ListBuyTPQT.append(float(dataJS['a'][0][1]))
			ListBuySLQT.append(float(dataJS['b'][0][1]))

			#time.sleep(30)
		if(result[0]==1 and mijanona[0]==False): #midina
			print("---------------------------------")
			ListLouckSell.append(price[0])
			ListSellTP.append(float(dataJS['b'][0][0]))
			ListSellSL.append(float(dataJS['a'][0][0]))
			#print("order")
			
			#print("SellSL"+str(ListSellSL[len(ListSellSL)-1]))
			#print("LouckSell"+str(ListLouckSell[len(ListLouckSell)-1]))
			#print("SellTP"+str(ListSellTP[len(ListSellTP)-1]))

			ListSellTPQT.append(float(dataJS['b'][0][1]))
			ListSellSLQT.append(float(dataJS['a'][0][1]))
			#time.sleep(30)
	else:
		print("tsy miditra")
	
	#print("sell"+str(TotalQuantit(dataJS['a'])))
	#print((dataJS['a']))
	#print("sell"+str(dataJS['a'][0])) #Asks  sell
	

def CheckQuantite(buy,sell):
	if(len(buy)>0 and len(sell)>0):
		buyPrice = float(buy[0])
		sellPrice = float(sell[0])
		Price = float(price[0])
		if(float(buy[1])>float(sell[1]) and float(buy[1])>=2 and float(sell[1])<0.004): #quantite
			return [2,float(sell[0])] #miakatra
		elif(float(buy[1])<float(sell[1]) and float(sell[1])>=2 and float(buy[1])<0.004):
			return [1,float(buy[0])] #midina
		else:
			return [0,0]
	else:
		return [0,0]

def CheckGain(Pricex):
	price[0]=Pricex
	mijanona[0] =True
	print("price price price price="+str(price))
	#cp = price[0]
	#print("buy len")
	#print(ListLouckBuy)
	#print(ListBuyTP)
	#print(ListBuySL)
	#print("Sell len")
	#print(ListLouckSell)
	#print(ListSellTP)
	#print(ListLouckBuy)
	LbBuyEP["text"] = str(ListLouckBuy)
	LbBuyTP["text"] = str(ListBuyTP)
	LbBuySL["text"] = str(ListBuySL)

	LbSellEP["text"] = str(ListLouckSell)
	LbSellTP["text"] = str(ListSellTP)
	LbSellSL["text"] = str(ListSellSL)


	lenbuy = len(ListLouckBuy)
	lensell = len(ListLouckSell)
	if(len(ListLouckBuy)==len(ListBuyTP) and len(ListLouckBuy)==len(ListBuySL) and len(ListBuyTP)==len(ListBuySL)):
		for x in range(0,lenbuy):
			
			if(price[0]>float(ListBuyTP[x])):
				print("price = "+str(price[0]))
				print("buy = "+str(float(ListBuyTP[x])))
				gain[0] = gain[0] + 1
				
				
				WriteFile()
				f2 = open("gainlIST.txt", "a")
				f2.write("++++++++++++++GAIN BUY+++++++++++++\n")
				f2.write("EPTP"+str(abs(ListLouckBuy[x]-ListBuyTP[x]))+"EPSL="+str(abs(ListLouckBuy[x]-ListBuySL[x]))+"\n")
				f2.write("Take Profit= "+str(ListBuyTP[x])+"QT="+str(ListBuyTPQT[x])+"\n")
				f2.write("Enter Price = "+str(ListLouckBuy[x])+"\n")
				f2.write("Stop Lost = "+str(ListBuySL[x])+"QT="+str(ListBuySLQT[x])+"\n")
				f2.write("Close Price = "+ str(price[0])+"\n")
				f2.close()
				ListLouckBuy.remove(ListLouckBuy[x])
				ListBuyTP.remove(ListBuyTP[x])
				ListBuySL.remove(ListBuySL[x])
				ListBuyTPQT.remove(ListBuyTPQT[x])
				ListBuySLQT.remove(ListBuySLQT[x])
				mijanona[0] =False
				return True
				#time.sleep(30)
			elif(price[0]<float(ListBuySL[x])):
				print("price = "+str(price[0]))
				print("buy = "+str(float(ListBuySL[x])))
				perte[0] = perte[0] + 1
				
				WriteFile()
				f2 = open("gainlIST.txt", "a")
				f2.write("---------------PERTE BUY----------------\n")
				f2.write("EPTP"+str(abs(ListLouckBuy[x]-ListBuyTP[x]))+"EPSL="+str(abs(ListLouckBuy[x]-ListBuySL[x]))+"\n")
				f2.write("Take Profit= "+str(ListBuyTP[x])+"QT="+str(ListBuyTPQT[x])+"\n")
				f2.write("Enter Price = "+str(ListLouckBuy[x])+"\n")
				f2.write("Stop Lost = "+str(ListBuySL[x])+"QT="+str(ListBuySLQT[x])+"\n")
				f2.write("Close Price = "+ str(price[0])+"\n")
				f2.close()
				ListLouckBuy.remove(ListLouckBuy[x])
				ListBuyTP.remove(ListBuyTP[x])
				ListBuySL.remove(ListBuySL[x])
				ListBuyTPQT.remove(ListBuyTPQT[x])
				ListBuySLQT.remove(ListBuySLQT[x])
				mijanona[0] =False
				return True
				#time.sleep(30)
	if(len(ListLouckSell)==len(ListSellTP) and len(ListLouckSell)==len(ListSellSL) and len(ListSellTP)==len(ListSellSL)):
		for s in range(0,lensell):
			
			if(price[0]<float(ListSellTP[s])):
				print("price = "+str(price[0]))
				print("sell = "+str(float(ListSellTP[s])))
				gain[0] = gain[0] + 1
				
				WriteFile()
				f2 = open("gainlIST.txt", "a")
				f2.write("++++++++++++++GAIN SELL+++++++++++++\n")
				f2.write("EPTP"+str(abs(ListLouckSell[s]-ListSellTP[s]))+"EPSL="+str(abs(ListLouckSell[s]-ListSellSL[s]))+"\n")
				f2.write("Take Profit= "+str(ListSellTP[s])+"QT="+str(ListSellTPQT[s])+"\n")
				f2.write("Enter Price = "+str(ListLouckSell[s])+"\n")
				f2.write("Stop Lost = "+str(ListSellSL[s])+"QT="+str(ListSellSLQT[s])+"\n")
				f2.write("Close Price = "+ str(price[0])+"\n")
				f2.close()
				ListLouckSell.remove(ListLouckSell[s])
				ListSellTP.remove(ListSellTP[s])
				ListSellSL.remove(ListSellSL[s])
				ListSellTPQT.remove(ListSellTPQT[s])
				ListSellSLQT.remove(ListSellSLQT[s])
				mijanona[0] =False
				return True
				#time.sleep(30)
			elif(price[0]>float(ListSellSL[s])):
				print("price = "+str(price[0]))
				print("sell = "+str(float(ListSellSL[s])))
				perte[0] = perte[0] + 1
				
				f2 = open("gainlIST.txt", "a")
				f2.write("++++++++++++++PERTE SELL+++++++++++++\n")
				f2.write("EPTP"+str(abs(ListLouckSell[s]-ListSellTP[s]))+"EPSL="+str(abs(ListLouckSell[s]-ListSellSL[s]))+"\n")
				f2.write("Take Profit= "+str(ListSellTP[s])+"QT="+str(ListSellTPQT[s])+"\n")
				f2.write("Enter Price = "+str(ListLouckSell[s])+"\n")
				f2.write("Stop Lost = "+str(ListSellSL[s])+"QT="+str(ListSellSLQT[s])+"\n")
				f2.write("Close Price = "+ str(price[0])+"\n")
				f2.close()
				WriteFile()
				ListLouckSell.remove(ListLouckSell[s])
				ListSellTP.remove(ListSellTP[s])
				ListSellSL.remove(ListSellSL[s])
				ListSellTPQT.remove(ListSellTPQT[s])
				ListSellSLQT.remove(ListSellSLQT[s])
				mijanona[0] =False
				return True
				#time.sleep(30)
	#print("gain="+str(gain[0]))
	#print("perte="+str(perte[0]))
	mijanona[0] =False
	LbGain["text"] = "Gain="+ str(gain[0])
	LbPerte["text"] = "Perte="+ str(perte[0])
	return True

def thread(d,g):
	while(1):
		
		orderbk = requests.get('https://fapi.binance.com/fapi/v1/ticker/price?symbol=BTCUSDT')
		dataobk = orderbk.json()
		price[0]=float(dataobk['price'])
		lbPrice["text"]="Price="+str(price[0])
		CheckGain(float(dataobk['price']))
		
#def Add order
def thread2(d,f):
	ws = websocket.WebSocketApp(sctOrderbk,on_message=on_orderbook,on_close=on_close)
	ws.run_forever()
t = threading.Thread(target=thread,args=(1,1))
t.start()
t2 = threading.Thread(target=thread2,args=(1,1))
t2.start()






root.mainloop()


print(1111111111111)

