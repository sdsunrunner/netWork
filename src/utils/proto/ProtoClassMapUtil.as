package utils.proto
{
	import flash.utils.getQualifiedClassName;

	/**
	 * 协议和类名映射解析工具 
	 * @author songdu.greg
	 * 
	 */	
	public class ProtoClassMapUtil
	{
//==============================================================================
// Public Functions
//==============================================================================
		/**
		 * 获取类名（非类全名） 
		 * @return 
		 * 
		 */		
		public static function getClassName(instance:Object):String
		{
			var className:String = getQualifiedClassName(instance);
			className = className.replace("::", ".");			
			var nameStrArr:Array = className.split(".");
			
			return nameStrArr[nameStrArr.length-1];
		}
//------------------------------------------------------------------------------
// Private
//------------------------------------------------------------------------------

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Event
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	}
}