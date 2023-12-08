import pyautogui
import time
import threading
import requests
import pyautogui
import json
from tkinter import * 
from requests.exceptions import ConnectionError
import matplotlib.pyplot as plt
from numpy import random
import win32gui, win32con
import apibinance
import apitappi
import function
import httpx
import aiohttp
import asyncio
import order
from pygame import mixer  # Load the popular external library






"""
res = get("https://fapi.binance.com/fapi/v1/time")
print(res)
"""

#hide = win32gui.GetForegroundWindow()
#win32gui.ShowWindow(hide , win32con.SW_HIDE)

Cymbol = 'BTC/USD'
xsymbol='usd'
NBBUY = [0]
NBSELL = [0]
LbNBSell=[0]
LbNBBuy=[0]
abisciseUp = 1275
ordonneUP = 547
abisciseDown = 1275
ordonneDown = 608

root = Tk()
root.title('Robine')
root.geometry('500x500+500+200')


Lb10Sell = Label(root, text='Price=--')
Lb10Sell.pack(ipadx=10, ipady=10)
Lb10Buy = Label(root, text='Price=--')
Lb10Buy.pack(ipadx=10, ipady=10)



##########ORDER BOOK###########3

LbNBSell = Label(root, text='SellQT=--')
LbNBSell.pack(ipadx=10, ipady=10)
LbNBBuy = Label(root, text='SellQT=--')
LbNBBuy.pack(ipadx=10, ipady=10)



LbOB = Label(root, text='############ORDER BOOK############')
LbOB.pack(ipadx=10, ipady=10)


LbSellQT = Label(root, text='SellQT=--')
LbSellQT.pack(ipadx=10, ipady=10)
LbSellMn = Label(root, text='SellQT=--')
LbSellMn.pack(ipadx=10, ipady=10)
LbBuyQT = Label(root, text='BuyQT=--')
LbBuyQT.pack(ipadx=10, ipady=10)
LbBuyMn = Label(root, text='SellQT=--')
LbBuyMn.pack(ipadx=10, ipady=10)

##########TRDE##############
LbTD = Label(root, text='##############TRADE###############')
LbTD.pack(ipadx=10, ipady=10)
lbTmaxSell = Label(root, text='Price=--')
lbTmaxSell.pack(ipadx=10, ipady=10)
lbTotalSell = Label(root, text='Price=--')
lbTotalSell.pack(ipadx=10, ipady=10)
lbTmaxBuy = Label(root, text='Price=--')
lbTmaxBuy.pack(ipadx=10, ipady=10)
lbTotalBuy = Label(root, text='Price=--')
lbTotalBuy.pack(ipadx=10, ipady=10)

LbAllSELL = Label(root, text='trade=--')
LbAllSELL.pack(ipadx=10, ipady=10)
LbAllBUY = Label(root, text='trade=--')
LbAllBUY.pack(ipadx=10, ipady=10)







sell_list=[]
buy_list=[]
#####foction price

enterPrice = []
enterTime = []
openSide = []
###TRADE
TradeBuy = []
TradeBuyQT = []
TradeSell = []
TradeSellQT = []
def check_gain(curentTime,OlympTime):
    for x in range(0,len(enterPrice)):
        if(abs(enterTime[x]-curentTime)>=OlympTime):
           
            amount = coin_prix('usd')
            
            if(enterPrice[x]<amount and openSide[x]==True):
                enterPrice.remove(enterPrice[x])
                enterTime.remove(enterTime[x])
                openSide.remove(openSide[x])
                return True #Gain Buy
            elif(enterPrice[x]>=amount and openSide[x]==True):
                enterPrice.remove(enterPrice[x])
                enterTime.remove(enterTime[x])
                openSide.remove(openSide[x])
                return False #perte Buy
            elif(enterPrice[x]>amount and openSide[x]==False):
                enterPrice.remove(enterPrice[x])
                enterTime.remove(enterTime[x])
                openSide.remove(openSide[x])
                return True #gain Sell

            elif(enterPrice[x]<=amount and openSide[x]==False):
                enterPrice.remove(enterPrice[x])
                enterTime.remove(enterTime[x])
                openSide.remove(openSide[x])
                return False #perte Sell
        print("Time = "+ str(abs(enterTime[x]-curentTime)))
    return 2
def verifier_liste(listee,cell):
    if len(listee) >= 1:
        if (listee[len(listee)-1] == cell):
            return listee
        elif (listee[len(listee)-1] != cell):
            listee.append(cell)
            return listee
        else:
            return listee
    else:
        listee.append(cell)
        return listee

def coin_prix(x):
    try:
        price = requests.get('https://api.coinbase.com/v2/prices/spot?currency='+x)
        pricex = price.json()
        print(pricex)
        z = float(pricex['data']['amount'])
        print(z)
        return z

    except ConnectionError as e:    # This is the correct syntax
        #print(e)
        r = "No response"
        return 0

########################GUI fenetre ####################

#lbPrice = Label(root, text='Price='+str(price[0]))
#lbPrice.pack(ipadx=10, ipady=10)
#LbBuyQT = Label(root, text='BuyQT='+str(listBUY1))
#LbBuyQT.pack(ipadx=10, ipady=10)
#LbSellQT = Label(root, text='SellQT='+str(listSELL1))
#LbSellQT.pack(ipadx=10, ipady=10)


#LbBuyPC = Label(root, text='BuyPC='+str(price[0]))
#LbBuyPC.pack(ipadx=10, ipady=10)
#LbSellQT = Label(root, text='SellQT='+str(price[0]))
#LbSellQT.pack(ipadx=10, ipady=10)
#LbSellPC = Label(root, text='SellPC='+str(price[0]))
#LbSellPC.pack(ipadx=10, ipady=10)



###########################################
##############################focntion moyenne#####
def moyenne(liste):
    somme= 0
    moyen =0
    for x in range (0,len(liste)):
        somme = somme+ liste[x]
    moyen = somme / len(liste)
    print('     moyenne = ' +str(moyen))
    if (moyen < 100):
        return [True,moyen]
    else:
        return [False,moyen]
#####################check value in list###########""""
def check_value(liste):
    for x in range (0,len(liste)):
        if (liste[x] >= 100):
            print("     value = True")
            return [True,liste[x]]
    print("     value = False")
    return [False,0]
########################fonction click
def clic_fonction(quantite,upX,upY,downX,downY):
	#print("anaty fonction click")
	#print(indicator_3_sma)
	if quantite == 2:
		#print("Click miakatra")
		pyautogui.click(upX ,upY)
		#time.sleep(90)
	elif quantite == 1:
		#print("Click midina")
		pyautogui.click(downX,downY)
		#time.sleep(90)
	else:
    	 return 0
########################################


#################fonction request######################

def RequestTrade(symbol):
    try:
       # orderbk = requests.get('https://api.kraken.com/0/public/Depth?pair='+symbol+'&&limit=1000')
        #dataobk = orderbk.json()
        #return orderbk

        #url = 'https://api.kraken.com/0/public/Depth?pair='+symbol+'&&limit=1000'
        url = 'https://fapi.binance.com/fapi/v1/trades?symbol='+symbol
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded'
        }

        response = requests.request("GET",url,headers=headers)
        #print(response.json())
        return response.json()


    except ConnectionError as e:    # This is the correct syntax
        print(e)
        r = "No response"
        return 

def RequestOrderBook(symbol):
    try:
       # orderbk = requests.get('https://api.kraken.com/0/public/Depth?pair='+symbol+'&&limit=1000')
        #dataobk = orderbk.json()
        #return orderbk

        #url = 'https://api.kraken.com/0/public/Depth?pair='+symbol+'&&limit=1000'
        url = 'https://fapi.binance.com/fapi/v1/depth?symbol=BTCUSDT'
        headers = {
            'Content-Type': 'application/x-www-form-urlencoded'
        }

        response = requests.request("GET",url,headers=headers)
        #print(response.json())
        return response.json()


    except ConnectionError as e:    # This is the correct syntax
        print(e)
        r = "No response"
        return 0
##return orderbk orderbook or 0 if connection error 
########################################



#####################GetNextModulo######################""""
def GetNextModulo(temp,b,v):#ito le fonction manao order book

	while(temp%v!=0):
		#print(temp)
		if(b):
			temp+=1
		else:
			temp-=1
	return temp
#######################"""foction return temp"####

#########################GetOrderBookSELL return ListData qui fait appel a la fonction GetNextModulo
def GetOrderBookSELL(List,boole,v):
    x=0
    ListData = []
    #print(List)
    while(x<len(List)-1):
        PriceTP = GetNextModulo(int(float(List[x][0]))+1,boole,v)
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
def GetOrderBookBUY(List,boole,v):
    x=0
    ListData = []
    #print(List)
    while(x<len(List)-1):
        PriceTP = GetNextModulo(int(float(List[x][0]))-1,boole,v)
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

###################"fonction qui verifier la quantite 
def CheckQuantite(buyQT,sellQT):
    if(sellQT<=5 and buyQT>=15): #quantite if 100 3 et 10 or if 50 orderbook 7 et 2
        return 2 #miakatra
    if( buyQT<=5 and sellQT>=15): #quantite
        return 1 #midina
    else:
        return 0
def QuantiteX(buyQT,sellQT):
    if (buyQT>sellQT):
        return 2
    if (buyQT<sellQT):
        return 1
    else:
        return 0
##########fonction principal ##########Runbot########### deux parametres symbol et t
def WriteFile(QTBuy,QTSell,ValueBUY,ValueSell,MoyenneBuy,MoyenneSell,listBuy,ListSell,prixsell,prixbuy):
    f = open("gain.txt", "a")
    f.write("ListSell = "+str(ListSell)+"\n")
    f.write("prixsell = "+str(prixsell)+"\n")
    f.write("QTSell = "+str(QTSell)+"\n")
    f.write("ValueSell = "+str(ValueSell)+"\n")
    f.write("MoyenneSell = "+str(MoyenneSell)+"\n")
    f.write("MoyenneBuy = "+str(MoyenneBuy)+"\n")
    f.write("ValueBUY = "+str(ValueBUY)+"\n")
    f.write("listBuy = "+str(ListSell)+"\n")
    f.write("QTBuy = "+str(QTBuy)+"\n")
    f.write("prixbuy = "+str(prixbuy)+"\n")
    f.write("listBuy = "+str(listBuy)+"\n")
    f.close()
def WriteFile_b(booll):
    f = open("gain.txt", "a")
    if (booll == True ):
        f.write("++++++++++++++gain++++++++++++++++\n")
    elif(booll == False ):
        f.write("-------------------------------perte--------------\n")
    else:
        return 0

def test():
    global buy_list
    buy_list+=[2,3,5]
    print(buy_list)


def UpdateResSup(OldSell,OldBuy,NewSell,NewBuy):
    global buy_list
    global sell_list
    #buy_list+=[2,3,5]
    #print(buy_list)
    if(OldSell==NewSell and OldBuy==NewBuy): # no change
        return False
    elif(OldSell==NewBuy): #UP
        buy_list.clear()
        buy_list+=sell_list
        sell_list.clear()
        return True
    elif(OldBuy==NewSell): #UP
        #print("in up"+str(sell_list))
        sell_list.clear()
        sell_list+=buy_list
        buy_list.clear()
        return True 
    else: 
        return False

def TotalOrderBook(list,limit):
    somme = 0
    for x in range(0,limit-1):
        x=x+1
        if(x%2==0):
            x = x-1
            print(x)
            
            somme = somme + list[x]
        else:
            x = x-1
    return somme


def RunBot(symbol,t):

    OldSell=0
    OldBuy=0
    NewSell =0
    NewBuy = 0
    xi = 1
    NBBUY = [0]
    NBSELL = [0]
    timenb=0
    while(1):
        print('****************************')
        orderbook = RequestOrderBook(Cymbol)###miantso RequestOrderBook return orderbk
        if(orderbook!=0):#si different a zero 
            dataobk = orderbook
            #print(len(dataobk))
            if(len(dataobk)>=2):
                #sell =  dataobk['result']['BTC/USD']['asks']
                #buy = dataobk["result"]['BTC/USD']["bids"]
                sell =  dataobk['asks']
                buy = dataobk["bids"]
                #print(sell)
                #print('vita sellllllllllllllllllllllllllllll')
                #print(buy)
                ListSell =GetOrderBookSELL(sell,True,50)
                ListBuy =GetOrderBookBUY(buy,False,50)
                
                List10Sell =GetOrderBookSELL(sell,True,20)
                List10Buy =GetOrderBookBUY(buy,False,20)
                
                #totalTrade()
                SellTTLObook = List10Sell[1]+List10Sell[3]
                BuyTTLObook = List10Buy[1]+List10Buy[3]
                
                

                OldSell=ListSell[0]
                OldBuy=ListBuy[0]

                SELL = ListSell[1]
                BUY = ListBuy[1]
                #print(SELL)
                #print(BUY)

                Lb10Buy['text'] = str(List10Buy[0])+"+"+str(List10Buy[2])+"="+str(BuyTTLObook)
                Lb10Sell['text'] = str(List10Sell[0])+"+"+str(List10Sell[2])+"="+str(SellTTLObook)
                if(xi%2==0):
                    NewSell=ListSell[0]
                    NewBuy=ListBuy[0]

                else:
                    OldSell=ListSell[0]
                    OldBuy=ListBuy[0]

                if(xi==1):
                    NewSell=ListSell[0]
                    NewBuy=ListBuy[0]
                    OldSell=ListSell[0]
                    OldBuy=ListBuy[0]

                xi=xi+1
              
                print("OldSell"+str(OldSell))
                print("NewSell"+str(NewSell))
                print("OldBuy"+str(OldBuy))
                print("NewBuy"+str(NewBuy))
                
                

               
                up = UpdateResSup(OldSell,OldBuy,NewSell,NewBuy)
                if(up==True):
                    NBBUY[0]=0
                    NBSELL[0]=0
                    LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                    LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                sell_list.append(SELL)
                buy_list.append(BUY)

                print("     up = "+str(up))
                QTdata = CheckQuantite(float(ListBuy[1]),float(ListSell[1]))
                print('#-#-#SELL :' + str(ListSell[0]) + '|| QT='+str(ListSell[1])) #ambony 
                #print(sell_list)
                
                moyenne_sell = moyenne(sell_list)
                value_sell = check_value(sell_list)
                print("     NB_BUY = "+str(NBBUY[0]))
                print('#+#+#BUY  :'+ str(ListBuy[0]) + '|| QT='+str(ListBuy[1])) #ambany
                #print(buy_list)
                moyenne_buy = moyenne(buy_list)
                value_buy = check_value(buy_list)
                ListTrade = run_trade('BTCUSDT',1)
                print("     NB_SELL = "+str(NBSELL[0]))
                WriteFile_b(check_gain(time.time(),60))
                print("     Le manja mahay manisa be ="+str(abs(timenb-time.time())))
                
                LbBuyQT['text']='BUY Quantite = '+str(round(ListBuy[1],2))
                LbBuyMn['text']='BUY Moyenne = '+str(round(moyenne_buy[1],2))
                LbSellQT['text']='SELL Quantite = '+str(round(ListSell[1],2))
                LbSellMn['text']='SELL Moyenne = '+str(round(moyenne_sell[1],2))
                
                

                
                
                print(ListTrade)
                TDOSellMax = ListTrade[0]
                TDOSellTTL = ListTrade[1]
                TDOBuyMax = ListTrade[2]
                TDOBuyTTL =ListTrade[3]
                TDdiffTTLBuy = CheckDiffValue(TDOSellTTL,TDOBuyTTL,10,10,True)
                TDdiffTTLSell = CheckDiffValue(TDOSellTTL,TDOBuyTTL,10,10,False)
                TDdiffSTRSBuy = CheckDiffValue(SellTTLObook,BuyTTLObook,10,10,True)
                TDdiffSTRSSell = CheckDiffValue(SellTTLObook,BuyTTLObook,10,10,False)
                
                ALLBUY = ListBuy[1]+BuyTTLObook+TDOBuyTTL
                ALLSELL = ListSell[1]+SellTTLObook+TDOSellTTL
                
                                
                LbAllBUY['text']='All BUY = '+str(ListBuy[1]+BuyTTLObook+TDOBuyTTL)
                LbAllSELL['text']='All SELL = '+str(ListSell[1]+SellTTLObook+TDOSellTTL)
                GT = 0
                if(ALLBUY-ALLSELL>=70 and ALLSELL<=70):
                    #clic_fonction(2,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
                    #time.sleep(60)
                    GT = 2
                elif(ALLSELL-ALLBUY>=70 and ALLBUY<=70):
                    #clic_fonction(1,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
                    #time.sleep(60)
                    GT = 1
                else:
                    GT = 0
                

                if(ListTrade[4]==True):
                    time.sleep(160)
                """if(timenb>0 and abs(timenb-time.time())>=30):
                    NBBUY[0]=0
                    NBSELL[0]=0
                    timenb=0
                    LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                    LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                """
                if(QTdata == 2 and len(enterTime)==0 and value_sell[0] == True): #miakatra
                    NBBUY[0] = NBBUY[0]+1
                    timenb = time.time()
                    NBSELL[0]=0
                    LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                    LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])

                    #if(NBBUY[0]==3 and ((moyenne_sell[1]<=90 and moyenne_buy[1]>=100 and TDOBuyTTL>TDOSellTTL)  or (moyenne_sell[1]<moyenne_buy[1] and TDdiffTTLBuy==True))):
                    if(NBBUY[0]>=1 and TDdiffSTRSBuy==True):
                        print('+++++++++++++BUY+++++++++++++')
                        #NBBUY[0] = NBBUY[0]+1
                        WriteFile(ListBuy[1],ListSell[1],value_buy[1],value_sell[1],moyenne_buy[1],moyenne_sell[1],buy_list,sell_list,ListSell[0],ListBuy[0])
                        #clic_fonction(QTdata,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
                        enterPrice.append(coin_prix(xsymbol))
                        #enterPrice.append(prix(symbol))
                        enterTime.append(time.time())
                        openSide.append(True)

                        
                        sell_list.clear()
                        buy_list.clear()
                        NBBUY[0]=0
                        #time.sleep(60)

                        #NBSELL[0]=0
                        LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                        LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                        
                        #if(NBBUY[0]==3):
                            #print("++++++++++++++++++++++++++++++")
                            #########click miakatra 
                            #clic_fonction(QTdata,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
                    elif(NBBUY[0]==20 and TDdiffTTLBuy==False):
                        NBBUY[0]=0
                        LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                        LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                elif(QTdata ==1 and value_buy[0] == True and len(enterTime)==0): #midina
                    NBSELL[0] = NBSELL[0]+1
                    timenb = time.time()
                    NBBUY[0]=0
                    LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                    LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                    #if(NBSELL[0]==3  and ((moyenne_sell[1]>=100 and moyenne_buy[1]<=90 and TDOBuyTTL<TDOSellTTL)  or (moyenne_sell[1]>moyenne_buy[1]  and TDdiffTTLSell==True))):
                    if(NBSELL[0]>=1 and TDdiffSTRSSell==True):
                        print("-----------SELL-------------")
                        #NBBUY[0] = NBBUY[0]+1
                        WriteFile(ListBuy[1],ListSell[1],value_buy[1],value_sell[1],moyenne_buy[1],moyenne_sell[1],buy_list,sell_list,ListSell[0],ListBuy[0])

                        #clic_fonction(QTdata,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
                        enterPrice.append(coin_prix(xsymbol))
                        enterTime.append(time.time())
                        openSide.append(False)
                        
                        
                        sell_list.clear()
                        buy_list.clear()
                        NBSELL[0]=0
                        #time.sleep(60)
                        LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                        LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                    """elif(NBSELL[0]==3 and TDdiffTTLSell==False):
                        NBSELL[0]=0
                        LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                        LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])"""
                else:
                    print("---TSY VAKY---")
            else:
                print(symbol+"not in list")
 

               #ListNotBinance.append(symbol)

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
    #print(TradeBuyQT)
    #print(TradeSellQT)

def GetMaxList(List,isBuyer,limit):
    newList = []
    for x in range(limit-1,0,-1):
        newList.append(List[x])
    #print(newList)
    return max(newList)
def moyenneTrade(liste,limit):
    somme= 0
    moyen =0
    for x in range (limit-1,0,-1):
        somme = somme+ liste[x]
    return somme / len(liste)
def totalTrade(liste,limit):
    somme=0
    for x in range (0,limit-1):
        somme = somme+ liste[x]
    return somme
def groupList(ListPrix,ListQt,limit):
    NewQTList = []
    totalqt=0
    for x in range(0,limit-1):
        temp = int(ListPrix[x])
        totalqt = ListQt[x]
        x=x+1
        print(x)
        while(temp!=ListPrix[x]):
            totalqt = totalqt+ListQt[x]
            NewQTList.append(ListQt)
            x=x+1
    
    print(NewQTList)


def CheckDiffValue(SellQT,BuyQt,diff,marge,bol):
    if(SellQT-BuyQt>=diff and SellQT>=marge and bol==False):
        return True
    elif(BuyQt-SellQT>=diff and BuyQt>=marge and bol==True):
        return True
    else:
        return False
def run_trade(symbol,d):
    Jsondata = RequestTrade(symbol)
    #print(Jsondata)
    if(Jsondata!=0):
        #print(Jsondata)
        TradeBuy.clear()
        TradeBuyQT.clear()
        TradeSell.clear()
        TradeSellQT.clear()
        CreateList(Jsondata)
        
        ########################SELL TRADE########################
        Slim = len(TradeSell)
        MTradeSellQT = moyenneTrade(TradeSellQT,len(TradeSellQT))
        MXTradeSellQT = GetMaxList(TradeSellQT,True,len(TradeSellQT))
        TTLTradeSellQT = totalTrade(TradeSellQT,len(TradeSellQT))
        TIntvalSell = GetIntvalPrice(TradeSell,Slim-1)
        print("***--**TRADE Sell***--**")
        print("//Lim="+str(Slim)+"//["+str(TIntvalSell[0])+","+str(TIntvalSell[1])+"]/////") 
        print("     TMoyenne Sell = "+str(MTradeSellQT)) 
        print("     TMAX Sell = "+str(MXTradeSellQT))
        print("     TTOTAL Sell = "+str(TTLTradeSellQT))
        #groupList(TradeSell,TradeSellQT,Slim)
        ########################BUY TRADE########################
        Blim = len(TradeBuy)
        MTradeBuyQT = moyenneTrade(TradeBuyQT,len(TradeBuyQT))
        MXTradeBuyQT = GetMaxList(TradeBuyQT,True,len(TradeBuyQT))
        TTLTradeBuyQT = totalTrade(TradeBuyQT,len(TradeBuyQT))
        TIntvalBuy = GetIntvalPrice(TradeBuy,Blim-1)
        print("**++***TRADE BUY***++**")
        print("//Lim="+str(Blim)+"//["+str(TIntvalBuy[0])+","+str(TIntvalBuy[1])+"]/////") 
        print("     TMoyenne Buy = "+str(MTradeBuyQT)) 
        print("     TMAX Buy = "+str(MXTradeBuyQT))
        print("     TTOTAL BUY = "+str(TTLTradeBuyQT))

        
        lbTmaxBuy["text"] = "BUY MAX = "+str(round(MXTradeBuyQT,2))
        lbTotalBuy["text"] = "BUY TOTAL ="+str(round(TTLTradeBuyQT,2))

        lbTmaxSell["text"] = "SELL MAX = "+str(round(MXTradeSellQT,2))
        lbTotalSell["text"] = "SELL TOTAL ="+str(round(TTLTradeSellQT,2))
        


        if(MXTradeBuyQT>=50):
            clic_fonction(2,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
            return [MXTradeSellQT,TTLTradeSellQT,MXTradeBuyQT,TTLTradeBuyQT,True]

        if(MXTradeSellQT>=50):
            clic_fonction(1,abisciseUp,ordonneUP,abisciseDown,ordonneDown)
            return [MXTradeSellQT,TTLTradeSellQT,MXTradeBuyQT,TTLTradeBuyQT,True]
        
        return [MXTradeSellQT,TTLTradeSellQT,MXTradeBuyQT,TTLTradeBuyQT,False]

        #time.sleep(1)

def GetIntvalPrice(list,limit):
    if(list[0]>=list[limit]):
        return [list[limit],list[0]]
    else:
        return [list[0],list[limit]]

#order.NewOrderMARKET('BTCUSDT',1,'BUY',3213215)


def MousePosition():
    while(1):
        print(pyautogui.position())
def AddPosition(symbol,symboltapi,quantity,side):
    pside = function.GetSideByBool(side)
    
    print("quantity="+str(quantity))
    print("pside="+str(pside))
    print("symbolapi="+str(symboltapi))
    if(function.LoopCheckMacd(symboltapi,'1m',10,side)):
        Json = apitappi.Rsi(symboltapi,'1m',10)
        if(apitappi.CheckByValueRsi(Json,50)==side):
            print('+++++++++ADD POSITION+++++++++++')
            #function.Alarm(True)
            JsonPrice = order.GetPrice(symbol)
            Ptime = JsonPrice['time']
            Bprice = float(JsonPrice['price'])
            quantity = function.UsdToQuantity(Bprice,float(quantity),3,20)
            order.NewOrderMARKET(symbol,quantity,pside,Ptime)
            if(function.LoopCheckRSI(symboltapi,'1m',10,side)):
                print('+++++++++TAKE PROFIT+++++++++++')
                #function.Alarm(False)
                JsonPrice = order.GetPrice(symbol)
                Ptime = JsonPrice['time']
                Bprice = JsonPrice['price']
                if(pside=="BUY"):
                    tpslside="SELL"
                    order.ClosePosition(symbol,quantity,tpslside,Ptime)
                else:
                    tpslside="BUY"
                    order.ClosePosition(symbol,quantity,tpslside,Ptime)
        else:
            print('invalid RSI')
def EachExchange(JsonExInfo):
    JsonSymbol = JsonExInfo['symbols']
    #print(JsonSymbol)
    tb = time.time()
    print(tb)
    for x in range(0,len(JsonSymbol)):
        symbolO = JsonSymbol[x]['symbol']
        symbol = function.AddSlashUSDT(JsonSymbol[x]['symbol'])
       
        minQty = JsonSymbol[x]['filters'][2]['minQty']
        print("min="+str(minQty))
        maxQty = JsonSymbol[x]['filters'][2]['maxQty']
        if(symbol[-4:]=="USDT" and function.NotBinance(symbol)==True and symbol!='XMR/USDT'):
            print(symbol)  
            JsonIndicator = apitappi.GetMacdRsiStoch(symbol,'1m',10)
            
            Indicator = function.CheckMacdRsiStoch(JsonIndicator[0],JsonIndicator[1],JsonIndicator[2])
            if(Indicator[0]!=100):
                Check = function.CheckIndicator(Indicator[0],Indicator[1],Indicator[2])
                print(Indicator)
                print(Check)
                print("Maxrsi="+str(apitappi.MaxRsi(JsonIndicator[1])))
                if(apitappi.MaxRsi(JsonIndicator[1])==1):
                    print('+++++++++++++')
                    function.Alarm(True)
                    time.sleep(10)
                    #AddPosition(symbolO,symbol,minQty,True)
                if(apitappi.MaxRsi(JsonIndicator[1])==0):
                    print('------------')
                    function.Alarm(False)
                    #AddPosition(symbolO,symbol,minQty,False)
                    time.sleep(10)

            """if(Check==True):
                print('+++++++++++++')
                function.Alarm(True)
                time.sleep(60)
            elif(Check ==False):
                print('------------')
                function.Alarm(False)
                time.sleep(60)
            elif(Check==2):
                function.Alarm(2)
            #run_trade(symbol,1)"""
            
    print(time.time()-tb)
def ThreadIndicator(a,b):
    print(1)

    JsonExInfo = apibinance.ExchangeInfo()
    while(1):
        EachExchange(JsonExInfo)


"""
TOrder = threading.Thread(target=ThreadIndicator,args=("BTCUSD",1))
TOrder.start()
"""
ThreadIndicator(1,2)
root.mainloop()

#MousePosition()



