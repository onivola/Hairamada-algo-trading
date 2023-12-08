#!/usr/bin/env python

# WS client example
from tkinter import * 
import asyncio
import websocket
import json
import time
import threading
import requests
import hmac
import hashlib
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from zigzag import *
from pandas_datareader import get_data_yahoo

apiKey = "vP73wQqNbY7OPHfEw2JrJsUkcgFkkXIrnpTcqOg5u907lHeeHGMoHLimSpgTjXWR"
#secretKey = "ew9HEKnr5ysHs3bA4TgdJ8CVXpM3NRnyXIPPkirIQcntAKveuzNw1UmtCRrVn3yw"
secretKey = "PIhdEQVvuLIGbyw2FDwwfjV2MGGpsef2KYcW2NmoEqj5pc7h8lomk0NZdVON7CwI"


def HashMac(message,secretKey):
	signature = hmac.new(bytes(secretKey , 'latin-1'), msg = bytes(message , 'latin-1'), digestmod = hashlib.sha256).hexdigest()
	return signature
def GetListPrice(symbol,interval):
	
	try:
		orderbk = requests.get('https://fapi.binance.com/fapi/v1/markPriceKlines?symbol='+symbol+'&interval='+interval)
		dataobk = orderbk.json()
		return dataobk
	except ConnectionError as e:    # This is the correct syntax
		#print(e)
		r = "No response"
		return 0
def GetPrice(symbol):
	try:
		orderbk = requests.get('https://fapi.binance.com/fapi/v1/ticker/price?symbol='+symbol)
		dataobk = orderbk.json()
		return dataobk
	except ConnectionError as e:    # This is the correct syntax
		#print(e)
		r = "No response"
		return 0


def TakeProfit(symbol,stopPrice,type2,side,time):
	message = "closePosition=true&stopPrice="+str(stopPrice)+"&type="+type2+"&symbol="+symbol+"&side="+side+"&timestamp="+str(time)

	signature=HashMac(message,secretKey)
	print(signature)
	url = "https://fapi.binance.com/fapi/v1/order?closePosition=true&stopPrice="+str(stopPrice)+"&type="+type2+"&symbol="+symbol+"&side="+side+"&timestamp="+str(time)+"&signature="+signature

	
	headers = {
		'X-MBX-APIKEY': apiKey,
		'Content-Type': 'application/x-www-form-urlencoded',
		'Access-Control-Allow-Origin': '*'
	}

	response = requests.request("POST",url,headers=headers)

	print("*****"+type2+"******")
	print(response.text)



def ClosePosition(symbol,quantity,side,time):
	message ="reduceOnly=true&quantity="+str(quantity)+"&type=MARKET&symbol="+symbol+"&side="+side+"&timestamp="+str(time)
	signature=HashMac(message,secretKey)
	url = "https://fapi.binance.com/fapi/v1/order?reduceOnly=true&quantity="+str(quantity)+"&type=MARKET&symbol="+symbol+"&side="+side+"&timestamp="+str(time)+"&signature="+signature
	headers = {
		'X-MBX-APIKEY': apiKey,
		'Content-Type': 'application/x-www-form-urlencoded',
		'Access-Control-Allow-Origin': '*'
	}
	response = requests.request("POST",url,headers=headers)
	print("+++++++++++++NEW ORDER++++++++")
	print(response.text)
	return response.json()





def NewOrderMARKET(symbol,quantity,side,time):

	message ="quantity="+str(quantity)+"&type=MARKET&symbol="+symbol+"&side="+side+"&timestamp="+str(time)
	signature=HashMac(message,secretKey)
	url = "https://fapi.binance.com/fapi/v1/order?quantity="+str(quantity)+"&type=MARKET&symbol="+symbol+"&side="+side+"&timestamp="+str(time)+"&signature="+signature
	headers = {
		'X-MBX-APIKEY': apiKey,
		'Content-Type': 'application/x-www-form-urlencoded',
		'Access-Control-Allow-Origin': '*'
	}
	response = requests.request("POST",url,headers=headers)
	print("+++++++++++++NEW ORDER++++++++")
	print(response.text)
	return response.json()





def GetBalance(servertime):
	message = "timestamp="+str(servertime)

	signature=HashMac(message,secretKey)
	print("sin=" +signature)

	url = "https://fapi.binance.com/fapi/v2/balance?timestamp="+str(servertime)+"&signature="+signature

	headers = {
		'X-MBX-APIKEY': apiKey,
		'Content-Type': 'application/x-www-form-urlencoded',
		'Access-Control-Allow-Origin': '*'
	}

	response = requests.request("GET",url,headers=headers)
	print(response.text)
	data = response.json()
	#print(round(float(data[1]['balance']),2))

	return round(float(data[1]['balance']),2)

def GetIndicator(servertime):
	message = "timestamp="+str(servertime)+"&symbol=BTCUSDT"

	signature=HashMac(message,secretKey)
	print("sin=" +signature)

	url = "https://fapi.binance.com/fapi/v1/apiTradingStatus?timestamp="+str(servertime)+"&symbol=BTCUSDT&signature="+signature

	headers = {
		'X-MBX-APIKEY': apiKey,
		'Content-Type': 'application/x-www-form-urlencoded',
		'Access-Control-Allow-Origin': '*'
	}

	response = requests.request("GET",url,headers=headers)
	print(response.text)
	#data = response.json()
	##print(round(float(data[1]['balance']),2))

	#return round(float(data[1]['balance']),2)

def GetSizeByUsdt(usdt,curentprice,levier):

	value = round((usdt/curentprice)*levier,3)
	return value


def TakeProfitClose(symbol,quantity,side):
	data = GetPrice(symbol)
	time2=data["time"]	
	ClosePosition(symbol,quantity,side,time2)


def addPosition(symbol,pricex,tp,sl,quantity,side):

	data = GetPrice(symbol)
	time=data["time"]
	price = float(data["price"])
	#up = price+diff
	#down = price-diff
	#quantity = GetSizeByUsdt(usdt,price,20)
	#print("prc="+objJSON.price)
	#print(symbol)
	#print("qt="+quantity)
	#print("qt="+quantity)
	#print("t="+time)
	CancellOrder(symbol,time)
	NewOrderMARKET(symbol,quantity,side,time)

	#CancelAllOpenOrder(symbol,time)
	tpslside = ""
	if(side=="BUY"):
		tpslside="SELL"
		TakeProfit(symbol,price+tp,"TAKE_PROFIT_MARKET","SELL",time)
		TakeProfit(symbol,price-sl,"STOP_MARKET","SELL",time)
	else:
		tpslside="BUY"
		TakeProfit(symbol,price-tp,"TAKE_PROFIT_MARKET","BUY",time)
		TakeProfit(symbol,price+sl,"STOP_MARKET","BUY",time)


	return True

#def addTakeProfit():



def CancellOrder(symbol,time):
	message = "timestamp="+str(time)+"&symbol="+symbol
	print(time)
	signature2=HashMac(message,secretKey)
	print("sin=" +signature2)
	"""payload = {
		'symbol':symbol,
		'timestamp':time,
		'signature':str(signature2)
	}"""
	headers = {
		'X-MBX-APIKEY': apiKey,
		'Content-Type': 'application/x-www-form-urlencoded',
		'Access-Control-Allow-Origin': '*'
	}
	url = "https://fapi.binance.com/fapi/v1/allOpenOrders?timestamp="+str(time)+"&symbol="+symbol+"&signature="+str(signature2)
	response = requests.request("DELETE", url, headers=headers)

	print(response.text)


#print(ListPrice)

def GetPriceNunpy(ListPrice):
	list = []
	for x in range(0,len(ListPrice)):
		#print((ListPrice[x][2]))
		list.append(float(ListPrice[x][2]))
	
	return list
def CancellActiveOrder(symbol,orderId,time):
	message = "symbol="+symbol+"&orderId="+str(orderId)+"&timestamp="+str(time)
	print(time)
	signature=HashMac(message,secretKey)
	print("sin=" +signature)

	headers = {
		'X-MBX-APIKEY': apiKey,
		'Content-Type': 'application/x-www-form-urlencoded',
		'Access-Control-Allow-Origin': '*'
	}
	url = "https://fapi.binance.com/fapi/v1/order?symbol="+symbol+"&orderId="+str(orderId)+"&timestamp="+str(time)+"&signature="+str(signature)
	response = requests.request("DELETE", url,headers=headers)

	print(response.text)
	return response.json()

def plot_pivots(X, pivots):
	plt.xlim(0, len(X))
	plt.ylim(X.min()*0.99, X.max()*1.01)
	plt.plot(np.arange(len(X)), X, 'k:', alpha=0.5)
	plt.plot(np.arange(len(X))[pivots != 0], X[pivots != 0], 'k-')
	g=plt.scatter(np.arange(len(X))[pivots == 1], X[pivots == 1], color='g')
	r=plt.scatter(np.arange(len(X))[pivots == -1], X[pivots == -1], color='r')
	
	print(g.get_offsets())
	print(r.get_offsets())
	
	plt.draw()
def plotUpdate(symbol,interval,sleep):
	plt.ion()
	fig = plt.figure()
	while(1):
		ListPrice = GetListPrice(symbol,interval)
		X = np.array(GetPriceNunpy(ListPrice))
		print(X[0])
		plt.clf()
		pivots = peak_valley_pivots(X, 0.0020, -0.0020)
		plt.xlim(0, len(X))
		plt.ylim(X.min()*0.99, X.max()*1.01)
		plt.plot(np.arange(len(X)), X, 'k:', alpha=0.5)
		plt.plot(np.arange(len(X))[pivots != 0], X[pivots != 0], 'k-')
		g=plt.scatter(np.arange(len(X))[pivots == 1], X[pivots == 1], color='g')
		r=plt.scatter(np.arange(len(X))[pivots == -1], X[pivots == -1], color='r')
		print(g.get_offsets())
		print(r.get_offsets())
		fig.canvas.draw()
		fig.canvas.flush_events()
		plt.pause(sleep)


#plotUpdate("BTCUSDT","1m",5)

"""
modes = pivots_to_modes(pivots)
print(pd.Series(X).pct_change().groupby(modes).describe().unstack())

ZIGZAG = np.array(compute_segment_returns(X, pivots))

print(ZIGZAG)
print(ZIGZAG[0])
print(ZIGZAG[1])







def zigZag(arr, n):
    # Flag true indicates relation "<" is expected,
    # else ">" is expected. The first expected relation
    # is "<"
    flag = True
    for i in range(n-1):
        # "<" relation expected
        if flag is True:
            # If we have a situation like A > B > C,
            # we get A > B < C
            # by swapping B and C
            if arr[i] > arr[i+1]:
                arr[i],arr[i+1] = arr[i+1],arr[i]
            # ">" relation expected
        else:
            # If we have a situation like A < B < C,
            # we get A < C > B
            # by swapping B and C    
            if arr[i] < arr[i+1]:
                arr[i],arr[i+1] = arr[i+1],arr[i]
        flag = bool(1 - flag)
    print(arr)
 
# Driver program
arr = [4, 3, 7, 8, 6, 2, 1]
n = len(ZIGZAG)
zigZag(ZIGZAG, n)

plt.plot(ZIGZAG) # plotting by columns
#plt.show()
"""
#plot_pivots(X, pivots)










"""
symbol = "BTCUSDT"
price = GetPrice(symbol)
print(price)
print(price['time'])

CancellActiveOrder(symbol,"3231321",price['time'])


	1628078340000,
        "38136.50000000",
        "38140",ambony
        "38135.91524600",ambany
        "38139.92000000",
        "0",
        1628078399999,
        "0",
        33,
        "0",
        "0",
        "0"

"""