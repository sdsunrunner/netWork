package netWork
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import netWork.event.ConnectionEvent;
	import netWork.event.SocketDataEvent;
	
	/**
	 * socket连接封装 
	 * @author songdu.greg
	 * 
	 */	
	public class SocketConnection extends EventDispatcher
	{
		private var _socket:Socket = null;//socket连接 
	
		private var _host:String = "";//服务端 主机
		private var _port:Number = 0;//服务端 端口
		private var _connected:Boolean = false;//连接状态
		private var receiveMessage:SocketMessage;//通信数据强类型		
		private static var HEAD_LENGTH:Number = 36;//包头长度
		
//==============================================================================
//	public property
//	包内容长度   加密   压强    版本   协议ID		包内容
//   00000      0000   0000   0000	  0000		 XX...
//==============================================================================
		public function SocketConnection(target:IEventDispatcher=null)
		{
			super(target);
			init();
			initListener();
		}
		
		public function get connected():Boolean
		{
			return _connected;	
		}
		
		/**
		 * 以google序列化格式发送数据 
		 * @param message
		 * 
		 */		
		public function sendProtoBufMessage(bytes:ByteArray):void
		{
			try
			{
				this._socket.writeBytes(bytes, 0, bytes.length);
				this._socket.flush();
			}
			catch(error:Error)
			{
				trace("send error!");
				this.conectErrorHandler();
			}
		}
		
		public function connect(host:String, port:int = 0):void
		{
			_host = host;
			_port = port;
			this._socket.connect(host,port);
		}
		
		public function dispose():void
		{
			this.removeListeners();
			try
			{
				_socket.close();
				_connected = false;
			}
			catch(error:Error)
			{
//				throw new NetworkError(NetworkError.SOCKET_CLOSE_ERROR);
			}
			_socket = null;
		}
		
//====================================================================
//	private method
//====================================================================
		
		/**
		 * 初始化 
		 */		
		private function init():void
		{
			_socket = new Socket();
		}
		
		/**
		 * 初始化化监听器 
		 */		
		private function initListener():void
		{
			_socket.addEventListener(Event.CONNECT, socketConnectedHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, socketIOErrorHandler);
			_socket.addEventListener(ProgressEvent.PROGRESS,socketProgressHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,socketGetDataHandler);
			_socket.addEventListener(Event.CLOSE, socketConnectionCloseHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,socketSecurityErrorHandler);
		}
		
		private function removeListeners():void
		{
			_socket.removeEventListener(Event.CONNECT, socketConnectedHandler);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR, socketIOErrorHandler);
			_socket.removeEventListener(ProgressEvent.PROGRESS,socketProgressHandler);
			_socket.removeEventListener(Event.CLOSE, socketConnectionCloseHandler);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,socketSecurityErrorHandler);
		}
		
//==============================================================================
//	listener event handler
//==============================================================================
		
		/**
		 * Socket连接成功 
		 */		
		private function socketConnectedHandler(evt:Event):void
		{
			_connected = true;
			
			this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_CONNECTED));
		}
		
		private function socketIOErrorHandler(evt:IOErrorEvent):void
		{
			_connected = false;
			this._socket.close();
			this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_CONNECT_FAIL));
			trace("Socket status:" + "Socket IOError");
		}
		
		/**
		 * 连接中断处理 
		 */		
		private function socketConnectionCloseHandler(evt:Event):void
		{
			trace("Socket status:" + "Socket Connection Close");
			this.conectErrorHandler();
		}
		
		private function socketSecurityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace("Socket status:" + "socket Security Error"+evt.type, evt.text);
			this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_SECURITY_ERROR));
		}	
		
		private function conectErrorHandler():void
		{
			trace("Socket status:" + "Socket Connection Close");
			_connected = false;
			this._socket.close();
			this.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_CONNECT_CLOSE));
		}		
		
		private function socketProgressHandler(evt:ProgressEvent):void
		{
//			infoCh("Socket status", "Socket rogressing");
		}
		
	
		
		private function reqStatusErrorHandler(errorMsg:String):void
		{
			var event:ConnectionEvent = new ConnectionEvent(ConnectionEvent.CALL_BACK_STATUS_ERROR);			
			this.dispatchEvent(event);
		}
		
		private function initNewMessage():void
		{
			receiveMessage = new SocketMessage();
		}
		
		/**
		 * 解包 Socket服务端返回数据 
		 */		
		private function socketGetDataHandler(evt:ProgressEvent):void
		{	
			trace("socket get msg");
			var writeLength:Number = 0;
			var count:Number = 0;
			var bytesAvailable:Number = _socket.bytesAvailable;
			var data_list:Array = new Array();			
			var _tmpBytes:ByteArray=new ByteArray();			
			_socket.readBytes(_tmpBytes, 0 , bytesAvailable);			
			
			do
			{
				if(receiveMessage == null)
				{
					initNewMessage();
				}
				
				if(receiveMessage.receiveHeadOffset == HEAD_LENGTH && receiveMessage.socketTextLength < 0)
				{	
					//读包头部分
					var heads:Array = [];
					var headItem:int= 0;
					var tempBytes:ByteArray = new ByteArray();
					receiveMessage.headByte.position = 0;
					do
					{
						receiveMessage.headByte.readBytes(tempBytes, 0, 4);
						headItem = getByteToInt(tempBytes);
						heads.push(headItem);
					}
					while(receiveMessage.headByte.position < 20);
					
					receiveMessage.socketTextLength = heads[0];
					receiveMessage.encryptType = heads[1];
					receiveMessage.compressType = heads[2];
					receiveMessage.version = heads[3];
					receiveMessage.cmdIndex = heads[4];
					
					if(heads[0] < 0)
					{
						return;
					}
					
					tempBytes.position = 0;					
					//MD5
					receiveMessage.headByte.position = 20;	
					receiveMessage.headByte.readBytes(receiveMessage.md5Array, 0, 16);	
				}
				
				if(HEAD_LENGTH - receiveMessage.receiveHeadOffset > 0)
				{
					if(bytesAvailable - writeLength >= HEAD_LENGTH - receiveMessage.receiveHeadOffset)
					{
						count = HEAD_LENGTH - receiveMessage.receiveHeadOffset;
						receiveMessage.headByte.writeBytes(_tmpBytes, writeLength, count);			
						writeLength += count;
						receiveMessage.receiveHeadOffset += count;	
					}	
					else
					{
						count = bytesAvailable - writeLength;				
						receiveMessage.headByte.writeBytes(_tmpBytes,writeLength,count);
						writeLength += 	count;
						receiveMessage.receiveHeadOffset += count;	
					}					
				}
				else
				{
					if(receiveMessage.socketTextLength - receiveMessage.dataBytes.length <= bytesAvailable - writeLength)
					{
						count = receiveMessage.socketTextLength - receiveMessage.dataBytes.length;
						receiveMessage.dataBytes.writeBytes(_tmpBytes,  writeLength , count);
						
						writeLength += count;
						this.restanceMesage(receiveMessage);
						data_list.push(receiveMessage);//输出
						initNewMessage();
					}
					else if(receiveMessage.socketTextLength - receiveMessage.dataBytes.length > bytesAvailable - writeLength)
					{
						receiveMessage.dataBytes.writeBytes(_tmpBytes,  writeLength , bytesAvailable - writeLength);
						writeLength += bytesAvailable - writeLength;
					}
				}
				
				if(writeLength > bytesAvailable)
				{
					trace("*********** 消息长度不正常 **************");
					break;
				}				
			}
			while(writeLength != bytesAvailable);
			
		}
		
		/**
		 * Socket服务端返回消息 
		 */		
		private function restanceMesage(data:SocketMessage):void
		{
//			if(data.isMD5())
//			{
				var evt:SocketDataEvent = new SocketDataEvent(SocketDataEvent.SOCKET_MESSAGE_EVENT);
				evt.socketMsg = data;
				this.dispatchEvent(evt);
//				trace("消息内容数据包:"+ ByteArraryUtil.toHex(data.dataBytes));
//			}
//			else
//			{
//				trace("消息内容数据包:"+ ByteArraryUtil.toHex(data.dataBytes));
//				trace("md5 error cmdIndex:" + data.cmdIndex);
//				trace("md5 error socketTextLength:" + data.socketTextLength);
//			}
		}
//==============================================================================
//	const
//==============================================================================
	
		public static function getByteToInt(bytes:ByteArray):int
		{
			bytes.position = 0;				
			var sun:int = bytes.readUnsignedByte();			
			sun += bytes.readUnsignedByte() << 8;				
			sun += bytes.readUnsignedByte() << 16;				
			sun += bytes.readUnsignedByte() << 24;
			
			return sun;
		}
	}
}