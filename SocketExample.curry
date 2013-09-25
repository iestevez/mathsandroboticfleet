module SocketExample where
import Socket
import IO
import ReadNumeric

iosocket = listenOn 4000

sendData = do
		socket <- iosocket
		(clientstr,handle) <- socketAccept socket
		hPutStr handle "a=[1,2,3];b=[4,5,6.0];"
		hClose handle
		sClose socket
		return "Finish"

receiveData = do
	        handle <- connectToSocket "localhost" 4040
		str <- hGetContents handle
		putStrLn str
		return "Finish"

readInts str = (tail . snd) $
	       	  until (((==) Nothing) . fst)
	       	     (\ (a,b) -> let (Just (val,str1)) = a in
		     	      	   (readInt str1,b++[val])) ((Just (0,str),[]))
		