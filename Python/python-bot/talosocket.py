#!/usr/bin/env python

# WS client example

import asyncio
import websocket
import json
import time

cc='btcusdt'
interval = '1m'

sctOrderbk = f'wss://stream.binance.com:9443/ws/{cc}@depth@100ms'
sctPrice = 'wss://fstream.binance.com/ws/btcusdt@markPrice'
#print(socket)
def TotalQuantit(list):
	quantit = 0
	for x in range(0,len(list)):
		quantit = quantit+float(list[x][1])
	return quantit
def on_price(ws,message):
	dataJS = json.loads(message)
	#print(dataJS[])
	print(dataJS["p"])
	#print("buy"+str(dataJS['b'][0])) #Bids  buy
	#print("buy"+str(TotalQuantit(dataJS['b'])))
	#print("sell"+str(dataJS['a'][0])) #Bids  buy
	#print("sell"+str(TotalQuantit(dataJS['a'])))
	#print((dataJS['a']))
	#print("sell"+str(dataJS['a'][0])) #Asks  sell
	#time.sleep(10)
def on_close(ws):
	print('connection closed')

def on_orderbook(ws,message):
	dataJS = json.loads(message)
	#print(dataJS[])
	print("buy"+str(dataJS['b'][0])) #Bids  buy
	print("buy"+str(TotalQuantit(dataJS['b'])))
	print("sell"+str(dataJS['a'][0])) #Bids  buy
	print("sell"+str(TotalQuantit(dataJS['a'])))
	#print((dataJS['a']))
	#print("sell"+str(dataJS['a'][0])) #Asks  sell
	#time.sleep(10)
ws1 = websocket.WebSocketApp(sctPrice,on_message=on_price,on_close=on_close)
ws2 = websocket.WebSocketApp(sctOrderbk,on_message=on_orderbook,on_close=on_close)

ws1.run_forever()
ws2.run_forever()