package netWork.event
{
	import flash.events.Event;
	
	/**
	 * 连接事件 
	 * @author songdu.greg
	 * 
	 */	
	public class ConnectionEvent extends Event
	{
		/**
		 * 连接成功 
		 */		
		public static const CONNECTION_CONNECTED:String = "CONNECTION_CONNECTED";
		
		/**
		 * 连接失败
		 */		
		public static const CONNECTION_CONNECT_FAIL:String = "CONNECTION_CONNECT_FAIL";
		
		/**
		 * 连接终中断
		 */		
		public static const CONNECTION_CONNECT_CLOSE:String = "CONNECTION_CONNECT_CLOSE";
		
		/**
		 * 连接安全错误
		 */		
		public static const CONNECTION_SECURITY_ERROR:String = "CONNECTION_SECURITY_ERROR";
		
		/**
		 * 请求超时
		 */		
		public static const REQ_TIME_OUT:String = "REQ_TIME_OUT";
		
		/**
		 * 状态错误
		 */		
		public static const CALL_BACK_STATUS_ERROR:String = "CALL_BACK_STATUS_ERROR";
		
		/**
		 * socket获取到数据 
		 */		
		public static const SOCKET_GET_DATA:String = "SOCKET_GET_DATA";
		
		/**
		 * 接收到的数据 
		 */		
		public var interacterData:Object = null;	
//==============================================================================
// Public Functions
//==============================================================================
		public function ConnectionEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}	
//------------------------------------------------------------------------------
// Private
//------------------------------------------------------------------------------

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Event
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-	
	}
}