module SocketExample where
import Socket
import IO

iosocket = listenOn 4000

sendData = do
		socket <- iosocket
		(clientstr,handle) <- socketAccept socket
		hPutStr handle "a=[1,2,3];b=[4,5,6.0];"
		hClose handle
		return "Finish"