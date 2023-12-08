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

def addPosition(symbol,price,tp,sl,usdt,side):

	data = GetPrice(symbol)
	time=data["time"]
	#price = float(data["price"])
	#up = price+diff
	#down = price-diff
	quantity = GetSizeByUsdt(usdt,price,20)
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
def CancellActiveOrder(symbol,orderId,time):
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
	url = "https://fapi.binance.com/fapi/v1/order?timestamp"=+str(time)+"&symbol="+symbol+"&signature="+str(signature2)
	response = requests.request("DELETE", url, headers=headers)

	print(response.text)
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

ListPrice = GetListPrice('BTCUSDT','1m')
#print(ListPrice)

def GetPriceNunpy(ListPrice):
	list = []
	for x in range(0,len(ListPrice)):
		#print((ListPrice[x][2]))
		list.append(float(ListPrice[x][2]))
	print(list)
	return list



price = GetListPrice(symbol,interval)
print(price['time'])
symbol = "BTCUSDT"
CancellActiveOrder(symbol,"3231321",price['time'])







"""
X = np.array(GetPriceNunpy(ListPrice))
#X = np.cumprod(X)
print(X)

#X = np.cumprod(1 + np.random.randn(100) * 0.01)
#X = np.array([1, 2, 3, 4, 5]) 
#X=np.array(X) # i
print(X)
pivots = peak_valley_pivots(X, 0.0020, -0.0020)
pivots01 = peak_valley_pivots(X, 0.00020, -0.00020)


#print(X)

def plot_pivots(X, pivots):
    plt.xlim(0, len(X))
    plt.ylim(X.min()*0.99, X.max()*1.01)
    plt.plot(np.arange(len(X)), X, 'k:', alpha=0.5)
    plt.plot(np.arange(len(X))[pivots != 0], X[pivots != 0], 'k-')
    plt.scatter(np.arange(len(X))[pivots == 1], X[pivots == 1], color='g')
    plt.scatter(np.arange(len(X))[pivots == -1], X[pivots == -1], color='r')
    plt.show()
plot_pivots(X, pivots)
plot_pivots(X, pivots01)


"""

"""
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