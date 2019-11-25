# -*- coding: utf-8 -*-
"""
Created on Fri Nov  8 13:29:04 2019

@author: parkerj12
"""

# -*- coding: utf-8 -*-
"""
Created on Sat Oct 19 12:38:56 2019

@author: parkerj12

TO add:
    MQL4 waits to the signal to take trades before executing for first time otherwise u gotta wait for new bar.
    Delete files before use. DataOld/Signal Files or all.
    Signal Power Support.
    Differientation for different Time frame trades.
    Add Acurracy Prediction/More AI type of functions for data used.
"""

from sklearn import datasets
from sklearn import tree
from sklearn import svm
from sklearn.model_selection import train_test_split as tts
import my_datasets
import my_filedata2
import time

symbols = ['EURUSD','USDCHF','GBPUSD','USDJPY','USDCAD','EURAUD','EURCHF','EURJPY','AUDUSD','GBPCHF','CADJPY','GBPJPY','AUDNZD','AUDCAD','AUDCHF','EURGBP','EURAUD','EURCHF','CHFJPY','AUDJPY','EURNZD','EURCAD','CADCHF','NZDJPY','NZDUSD']#,
#symbols = ['BTCUSD','NEOUSD','ZECUSD','LTCUSD','XRPUSD','XMRUSD','IOTAUSD']
while(True):
        for s in symbols:
            print(s)
            file1 ='C:/Users/parkerj12/AppData/Roaming/MetaQuotes/Terminal/Common/Files/Data'+s+'.txt'
            file2 ='C:/Users/parkerj12/AppData/Roaming/MetaQuotes/Terminal/Common/Files/signal'+s+'.txt'
          #  file3 = 'C:/Users/parkerj12/AppData/Roaming/MetaQuotes/Terminal/Common/Files/signalPower'+s+'.txt'
            mfd = my_filedata2.my_online(s)
            features = mfd[0]
            labels = mfd[1]
    

            predictions = []
        
        
    
    
    
    #Get LIVE DATA
            x=0
            count=0
            while(x<500):
               
                train_feats, test_feats, train_labels, test_labels = tts(features, labels, test_size=0.2)
                
                #clf = svm.SVC()
                clf = tree.DecisionTreeClassifier()
                
                #train
                clf.fit(train_feats, train_labels)
                try:
                    f= open(file1,"r")
                    data = f.readline(-1)
                    data = data.split(",")
                
                        
                    test_feats = [[data[0],data[1],data[2],data[3],data[4],data[5],data[6]]]
                  
                    #predictions
                    predictions.append(clf.predict(test_feats))
                    
                   
                #Write Signal
                    f.close()
                    x = x+1
                except IOError:
                        print("file opened data")
            print(test_feats)
            countBuy = 0
            countSell =0
            countZero =0
            for pre in predictions:
                if(pre == 1):
                    countBuy = countBuy+1
                elif(pre == -1):
                    countSell = countSell+1
                else:
                    countZero = countZero+1
                    
            countBuy = countBuy/5#10#/10
            countSell = countSell/5
            countZero = countZero/5
            f= open(file2,"w")
           # f1= open(file3,"w")
            if(countSell>=80 and countBuy<40):
                sell = 'sell'
                f.write(sell)
             #   f1.write('.05')
                print(sell)
            elif(countSell>=70 and countBuy<40):
                sell = 'sell'
                f.write(sell)
               # f1.write('.04')
                print(sell)
            elif(countSell>=60 and countBuy<40):
                sell = 'sell'
                f.write(sell)
             #   f1.write('.03')
                print(sell)
            elif(countSell>=50 and countBuy<40):
                sell = 'sell'
                f.write(sell)
              #  f1.write('.02')
                print(sell)
            elif(countSell>=40 and countBuy<40):
                sell = 'sell'
                f.write(sell)
              #  f1.write('.01')
                print(sell)
            if(countBuy<40 and countSell<40):
                nuetral = 'nuetral'
                f.write(nuetral)
                print(nuetral)
            if(countBuy>=40 and countSell<40):
                buy = 'buy'
                f.write(buy)
              #  f1.write('.01')
                print(buy)
            elif(countBuy>=50 and countSell<40):
                buy = 'buy'
                f.write(buy)
            #    f1.write('.02')
                print(buy)
            elif(countBuy>=60 and countSell<40):
                buy = 'buy'
                f.write(buy)
              #  f1.write('.03')
                print(buy)    
            elif(countBuy>=70 and countSell<40):
                buy = 'buy'
                f.write(buy)
              #  f1.write('.04')
                print(buy)
            elif(countBuy>=80 and countSell<40):
                buy = 'buy'
                f.write(buy)
              #  f1.write('.05')
                print(buy)   
            f.close()
            print("Predictions")
            print ("Buy: "+str(countBuy) + "Sell: "+str(countSell)+ "Zero: "+str(countZero))
            score =0
           # time.sleep(.1)
            
