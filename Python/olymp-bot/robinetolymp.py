#coding:utf-8
from tkinter import * 
import websocket
import json
import time
import threading
import requests

def GetListPrice(symbol,interval):
	try:
		orderbk = requests.get('https://fapi.binance.com/fapi/v1/markPriceKlines?symbol='+symbol+'&interval='+interval)
		dataobk = orderbk.json()
		return dataobk
	except ConnectionError as e:    # This is the correct syntax
		#print(e)
		r = "No response"
		return 0


order = requests.get('https://api.twelvedata.com/sma?symbol={}&interval=1min&apikey=3a529b2c00bb4c44a54d1827f5e9c1c9'.format (SYMBOL[element]))


def RequestOrderBook(symbol):
    try:
        orderbk = requests.get('https://fapi.binance.com/fapi/v1/depth?symbol='+symbol+'&&limit=1000')
        return orderbk
    except ConnectionError as e:    # This is the correct syntax
        #print(e)
        r = "No response"
        return 0
def RunBot(symbol,t):
    ListQTBuy = []
    ListQTSell = []
    while(1):
        #print('manaraka')
        orderbk = RequestOrderBook(symbol)
        if(orderbk!=0):
            dataobk = orderbk.json()
            if(len(dataobk)>=3):
                sell =  dataobk["asks"]
                buy = dataobk["bids"]
                
                
                ListSell =GetOrderBookSELL(sell,True)
                ListBuy =GetOrderBookBUY(buy,False)

                LbBuyPC["text"] =  "SELL="+ str(round(ListSell[0]))+" || QT="+ str(round(ListSell[1],2))
                LbSellPC["text"] = "BUY="+ str(round(ListBuy[0])) +" || QT="+ str(round(ListBuy[1],2))
               # LbBuyPC1["text"] = "SELL="+ str(round(ListSell[2])) +" || QT="+ str(round(ListSell[3],2))
               # LbSellPC1["text"] = "BUY="+ str(round(ListBuy[2])) +" || QT="+ str(round(ListBuy[3],2))

                ListQTBuy.append(ListBuy[1])
                ListQTSell.append(ListSell[1])

                #print(symbol+"PriceSELL==="+str(ListSell[0]))
                #print(symbol+"SellQT"+str(ListSell[1]))
                #print(symbol+"PriceBUY==="+str(ListBuy[0]))
                #print(symbol+"BuyQT"+str(ListBuy[1]))
                QTdata = CheckQuantite(float(ListBuy[1]),float(ListSell[1]))


                LbBuyTP["text"] = "BTP = "+str(ListBuyTP)
                LbBuyEP["text"] = "BEP = "+str(ListLouckBuy)
                LbBuySL["text"] = "BSL = "+str(ListBuySL)


                LbSellTP["text"] = "STP = "+str(ListSellTP)
                LbSellEP["text"] = "SEP= "+str(ListLouckSell)
                LbSellSL["text"] = "SSL = "+str(ListSellSL)


                if(len(ListLouckBuy)>0 or len(ListLouckSell)>0):
                    NBSELL[0] = 0
                    NBBUY[0]=0
                    LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                    LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                    CheckNewGain(price[0],ListSell[0],ListSell[1],ListBuy[0],ListBuy[1])
                else:
                    if(QTdata[0]==2 and CheckValueList(ListQTSell,100) and price[0]<ListSell[0] and len(ListBuySLQT)==0 and len(ListSellSLQT)==0): #miakatra
                        NBBUY[0] = NBBUY[0]+1
                        NBSELL[0]=0
                        LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                        LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                        
                        if(NBBUY[0]==3):
                            ListQTBuy.clear()
                            ListQTSell.clear()
                            #print("++++++++++++++++++++++++++++++")
                            ListLouckBuy.append(price[0])
                            #ListBuyTP.append(ListSell[0])
                            ListBuyTP.append(price[0]+60)
                            #ListBuySL.append(ListBuy[0])
                            ListBuySL.append(price[0]-30)

                            ListBuyTPQT.append(ListSell[1])
                            ListBuyTPQT2.append(ListSell[3])
                            ListBuySLQT.append(ListBuy[1])
                            ListBuyRESISTANCE.append(ListSell[0])
                            #order.addPosition(symbol,price[0],60,20,2,"BUY")
                            
                            #print(ListBuyTP)
                            #print(ListLouckBuy)
                            #print(ListBuySL)
                            #print(ListBuyTPQT)
                            #print(ListBuySLQT)
                        
                        
                    elif(QTdata[0]==1 and CheckValueList(ListQTBuy,100) and price[0]>ListBuy[0] and len(ListSellSLQT)==0 and len(ListBuySLQT)==0): #midina
                        NBSELL[0] = NBSELL[0]+1
                        NBBUY[0]=0
                        LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                        LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                        if(NBSELL[0]==3):
                            ListQTBuy.clear()
                            ListQTSell.clear()
                            #print("------------------------------")
                            ListLouckSell.append(price[0])
                            #ListSellTP.append(ListBuy[0])
                            ListSellTP.append(price[0]-60)
                            #ListSellSL.append(ListSell[0])
                            ListSellSL.append(price[0]+30)
                            ListSellTPQT.append(ListBuy[1])
                            ListSellTPQT2.append(ListBuy[3])
                            ListSellSLQT.append(ListSell[1])
                            ListSellRESISTANCE.append(ListBuy[0])
                            #order.addPosition(symbol,price[0],60,20,2,"SELL")
                            #print(ListSellTP)
                            #print(ListLouckSell)
                            #print(ListSellSL)
                            #print(ListSellTPQT)
                            #print(ListSellSLQT)
                    else:

                        print("---TSY VAKY---")
            else:
                #print(symbol+"not in binance")
                ListNotBinance.append(symbol)
def RequestOrderBook(symbol):
    try:
        orderbk = requests.get('https://fapi.binance.com/fapi/v1/depth?symbol='+symbol+'&&limit=1000')
        return orderbk
    except ConnectionError as e:    # This is the correct syntax
        #print(e)
        r = "No response"
        return 0

def GetOrderBookSELL(List,boole):
    x=0
    ListData = []
    #print(List)
    while(x<len(List)-1):
        PriceTP = GetNextModulo(int(float(List[x][0]))+1,boole)
        quantite = 0
        #print(List[x][0])
        #print(PriceTP)
        #x=x+1
        #print(len(List)-1)
        #print(x)
        #print("TP"+str(int(float(sell[x][0]))+1))
        #print("PriceTP"+str(PriceTP))
        #print("P"+str(List[x][0]))
        while(float(List[x][0])<=PriceTP and x<len(List)-1):
            #print(List[x][0])
            quantite = quantite+float(List[x][1])
            x=x+1
        ListData.append(float(PriceTP))
        ListData.append(quantite)
    return ListData
def GetOrderBookBUY(List,boole):
    x=0
    ListData = []
    #print(List)
    while(x<len(List)-1):
        PriceTP = GetNextModulo(int(float(List[x][0]))-1,boole)
        quantite = 0
        #print(List[x][0])
        #print(PriceTP)
        #x=x+1
        #print(len(List)-1)
        #print(x)
        #print("TP"+str(int(float(sell[x][0]))+1))
        #print("PriceTP"+str(PriceTP))
        #print("P"+str(List[x][0]))
        while(float(List[x][0])>=PriceTP and x<len(List)-1):
            #print(List[x][0])
            quantite = quantite+float(List[x][1])
            x=x+1
        ListData.append(float(PriceTP))
        ListData.append(quantite)
    return ListData    



def GetNextModulo(temp,b):

	while(temp%50!=0):
		#print(temp)
		if(b):
			temp+=1
		else:
			temp-=1
	return temp