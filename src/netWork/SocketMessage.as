package netWork
{
	import flash.utils.ByteArray;
	
	import utils.md5.MD5;
	
	/**
	 * Socket通信数据结构 
	 * @author Kenny
	 */	
	public class SocketMessage
	{
		/**
		 * 包内容长度 
		 */		
		public var socketTextLength:Number = -1;	
		
		/**
		 * 加密 
		 */		
		public var encryptType:Number = 0;
		
		/**
		 * 压缩 
		 */		
		public var compressType:Number = 0;
		
		/**
		 * 版本 
		 */		
		public var version:Number = 0;
		
		/**
		 * 协议ID 
		 */		
		public var cmdIndex:Number = NaN;
		
		
		/**
		 * 消息内容MD5
		 */		
		public var md5Array:ByteArray = new ByteArray();	
		
		
		/**
		 * 消息协议名称 
		 */		
		public var type:String = "";
		
		/**
		 * 消息内容 
		 */		
		public var dataBytes:ByteArray = new ByteArray();	
		
		/**
		 * 包头 
		 */		
		internal var headByte:ByteArray = new ByteArray();
		
		/**
		 * 已经读包头长度 
		 */		
		internal var receiveHeadOffset:Number = 0;
		
		/**
		 * 获得消息key值，消息ID对应用户注册的协议名称
		 */		
		public function getCmdName():String
		{
			return "";
		}
		
		
		public function isMD5():Boolean
		{
			var md5:ByteArray = MD5.hashBytesByC(dataBytes);
			var isS:Boolean = true;
			md5.position = 0;
			md5Array.position = 0;
			for(var i:Number = 0 ; i < 4 ; i++)
			{
				if(md5.readInt() != md5Array.readInt())
				{
					return false;
				}
			}
			return isS;
		}
	
	}
}