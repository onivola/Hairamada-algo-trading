
import pyautogui
import time
import threading
import requests
import json
from tkinter import * 
from requests.exceptions import ConnectionError
import win32gui, win32con



hide = win32gui.GetForegroundWindow()
win32gui.ShowWindow(hide , win32con.SW_HIDE)



price=[0]

########################GUI####################
root = Tk()
root.title('Robine')
root.geometry('500x500+500+200')

lbPrice = Label(root, text='Price='+str(price[0]))
lbPrice.pack(ipadx=10, ipady=10)
#LbBuyQT = Label(root, text='BuyQT='+str(price[0]))
#LbBuyQT.pack(ipadx=10, ipady=10)
LbNBBuy = Label(root, text='NB BUY='+str(price[0]))
LbNBBuy.pack(ipadx=10, ipady=10)
LbNBSell = Label(root, text='NB SELL='+str(price[0]))
LbNBSell.pack(ipadx=10, ipady=10)


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


LbBuyTP = Label(root, text='Perte='+str(price[0]))
LbBuyTP.pack(ipadx=10, ipady=10)
LbBuyEP = Label(root, text='Perte='+str(price[0]))
LbBuyEP.pack(ipadx=10, ipady=10)
LbBuySL = Label(root, text='Perte='+str(price[0]))
LbBuySL.pack(ipadx=10, ipady=10)
LbSellSL = Label(root, text='Perte='+str(price[0]))
LbSellSL.pack(ipadx=10, ipady=10)
LbSellEP = Label(root, text='Perte='+str(price[0]))
LbSellEP.pack(ipadx=10, ipady=10)
LbSellTP = Label(root, text='Perte='+str(price[0]))
LbSellTP.pack(ipadx=10, ipady=10)

###########################################


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

gain = [21]
perte = [5]
NBBUY = [0]
NBSELL = [0]
def WriteFile():
    f = open("gain.txt", "a")
    f.write("Gain = "+str(gain[0])+"\n")
    f.write("perte = "+str(perte[0])+"\n")
    f.close()

def GetNextModulo(temp,b):

	while(temp%50!=0):
		#print(temp)
		if(b):
			temp+=1
		else:
			temp-=1
	return temp

def NotBinance(symbol):
	

	tbsymbol = ['LTOUSDT','DNTUSDT','ROSEUSDT','TRUUSDT','BEAMUSDT','GTOUSDT','LSKUSDT','IOTXUSDT','WANUSDT','FORTHUSDT','JUVUSDT','FORTHUSDT','HIVEUSDT','XVSUSDT','IRISUSDT','ACMUSDT','PONDUSDT','CKBUSDT','ORNUSDT','ANTUSDT','ARUSDT','LTCUPUSDT','FISUSDT','MFTUSDT','STXUSDT','NANOUSDT','CTXCUSDT','DATAUSDT','ASRUSDT','WINUSDT','GBPUSDT','LUNAUSDT','BURGERUSDT','VTHOUSDT','PAXGUSDT','BUSDUSDT','MITHUSDT','WTCUSDT','CTSIUSDT','MDXUSDT','MASKUSDT','FETUSDT','TUSDUSDT','REPUSDT','RIFUSDT','EURUSDT','HARDUSDT','NMRUSDT','KMDUSDT',"SUSDUSDT","MIRUSDT","PAXUSDT","USDCUSDT","PERLUSDT","MBLUSDT","JSTUSDT","AUDIOUSDT","PUNDIXUSDT"]
	for i in range(0,len(tbsymbol)):
		if(symbol==tbsymbol[i]):
		 return False
	return True
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
        ListData.append(float(List[x][0]))
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
        ListData.append(float(List[x][0]))
        ListData.append(quantite)
    return ListData    

ListNotBinance=[]
print('mande ny robine')
def RequestOrderBook(symbol):
    try:
        orderbk = requests.get('https://fapi.binance.com/fapi/v1/depth?symbol='+symbol+'&&limit=1000')
        return orderbk
    except ConnectionError as e:    # This is the correct syntax
        print(e)
        r = "No response"
        return 0
def GetSLTP(boole,price):
	pcent = 5*100/price #0,0438144329896907  
	if(boole):
		return ((pcent*price)/100)+price
	else:
		return price-((pcent*price)/100)

def RunBot(symbol,t):

    while(1):
        print('manaraka')
        orderbk = RequestOrderBook(symbol)
        if(orderbk!=0):
            dataobk = orderbk.json()
            if(len(dataobk)>=3):
                sell =  dataobk["asks"]
                buy = dataobk["bids"]
                
                
                ListSell =GetOrderBookSELL(sell,True)
                ListBuy =GetOrderBookBUY(buy,False)

                LbBuyPC["text"] = "SELL="+ str(round(ListSell[1],2))
                LbSellPC["text"] = "BUY="+ str(round(ListBuy[1],2))

                print(symbol+"PriceSELL==="+str(ListSell[0]))
                print(symbol+"SellQT"+str(ListSell[1]))
                print(symbol+"PriceBUY==="+str(ListBuy[0]))
                print(symbol+"BuyQT"+str(ListBuy[1]))
                QTdata = CheckQuantite(float(ListBuy[1]),float(ListSell[1]))
                
                if(QTdata[0]==2 and price[0]<ListSell[0] and len(ListBuySLQT)==0 and len(ListSellSLQT)==0): #miakatra
                    NBBUY[0] = NBBUY[0]+1
                    NBSELL[0]=0
                    LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                    LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                    
                    if(NBBUY[0]==3):
                        print("++++++++++++++++++++++++++++++")
                        ListLouckBuy.append(price[0])
                        #ListBuyTP.append(ListSell[0])
                        ListBuyTP.append(GetSLTP(True,price[0]))
                        #ListBuySL.append(ListBuy[0])
                        ListBuySL.append(GetSLTP(False,price[0]))

                        ListBuyTPQT.append(ListSell[1])
                        ListBuySLQT.append(ListBuy[1])
                        
                        print(ListBuyTP)
                        print(ListLouckBuy)
                        print(ListBuySL)
                        print(ListBuyTPQT)
                        print(ListBuySLQT)
                    
                    
                elif(QTdata[0]==1 and price[0]>ListBuy[0] and len(ListSellSLQT)==0 and len(ListBuySLQT)==0): #midina
                    NBSELL[0] = NBSELL[0]+1
                    NBBUY[0]=0
                    LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
                    LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
                    if(NBSELL[0]==3):
                        print("------------------------------")
                        ListLouckSell.append(price[0])
                        #ListSellTP.append(ListBuy[0])
                        ListSellTP.append(GetSLTP(False,price[0]))
                        #ListSellSL.append(ListSell[0])
                        ListSellSL.append(GetSLTP(True,price[0]))
                        ListSellTPQT.append(ListBuy[1])
                        ListSellSLQT.append(ListSell[1])
                        
                        print(ListSellTP)
                        print(ListLouckSell)
                        print(ListSellSL)
                        print(ListSellTPQT)
                        print(ListSellSLQT)
                else:
                    print("---TSY VAKY---")
            else:
                print(symbol+"not in binance")
                ListNotBinance.append(symbol)

def CheckGain(Pricex):
    price[0]=Pricex
    mijanona[0] =True
    print("price price price price="+str(price))
    
    LbBuyTP["text"] = "BTP = "+str(ListBuyTP)
    LbBuyEP["text"] = "BEP = "+str(ListLouckBuy)
    LbBuySL["text"] = "BSL = "+str(ListBuySL)

    
    LbSellTP["text"] = "STP = "+str(ListSellTP)
    LbSellEP["text"] = "SEP= "+str(ListLouckSell)
    LbSellSL["text"] = "SSL = "+str(ListSellSL)


    lenbuy = len(ListLouckBuy)
    lensell = len(ListLouckSell)
    for x in range(0,lenbuy):

        if(price[0]>=float(ListBuyTP[x])):
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
            NBSELL[0] = 0
            NBBUY[0]=0
            return True
            #time.sleep(30)
        elif(price[0]<=float(ListBuySL[x])):
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
            NBSELL[0] = 0
            NBBUY[0]=0
            return True
        #time.sleep(30)
    for s in range(0,lensell):

        if(price[0]<=float(ListSellTP[s])):
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
            NBSELL[0] = 0
            NBBUY[0]=0
            return True
            #time.sleep(30)
        elif(price[0]>=float(ListSellSL[s])):
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
            NBSELL[0] = 0
            NBBUY[0]=0
            return True
            #time.sleep(30)
            #print("gain="+str(gain[0]))
            #print("perte="+str(perte[0]))
            mijanona[0] =False
    LbNBSell["text"] = "NB SELL="+ str(NBSELL[0])
    LbNBBuy["text"] = "NB BUY="+ str(NBBUY[0])
    LbGain["text"] = "Gain="+ str(gain[0])
    LbPerte["text"] = "Perte="+ str(perte[0])
    return True
def ThreadPrice(d,g):
    while(1):
        orderbk = RequestPrice()
        if(orderbk!=0):
            dataobk = orderbk.json()
            price[0]=float(dataobk['price'])
            lbPrice["text"]="Price="+str(price[0])
            print("price================================"+str(str(price[0])))
            CheckGain(price[0])

def CheckQuantite(buyQT,sellQT):
    if(buyQT>sellQT and buyQT>8 and sellQT<=8): #quantite
        return [2,2] #miakatra
    if(sellQT>buyQT and sellQT>8 and buyQT<=8): #quantite
        return [1,1] #midina
    else:
        return [0,0]
        
def RequestPrice():
    try:
        orderbk = requests.get('https://fapi.binance.com/fapi/v1/ticker/price?symbol=BTCUSDT')
        return orderbk
    except ConnectionError as e:    # This is the correct syntax
        print(e)
        r = "No response"
        return 0
   

TOrder = threading.Thread(target=RunBot,args=("BTCUSDT",1))
TPrice = threading.Thread(target=ThreadPrice,args=("BTCUSDT",1))
TOrder.start()
TPrice.start()

root.mainloop()

