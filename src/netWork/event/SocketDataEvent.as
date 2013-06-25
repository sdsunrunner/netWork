package netWork.event
{
	import flash.events.Event;
	
	import netWork.SocketMessage;
	
	/**
	 * socket 获取数据事件 
	 * @author songdu.greg
	 * 
	 */	
	public class SocketDataEvent extends Event
	{
		/**
		 * Socket消息 
		 */		
		public static const SOCKET_MESSAGE_EVENT:String = "socketMessageEvent";
		
		
		//socket返回消息			
		public var socketMsg:SocketMessage = null;		
//==============================================================================
// Public Functions
//==============================================================================
		public function SocketDataEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
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