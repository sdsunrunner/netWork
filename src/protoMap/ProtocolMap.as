package protoMap
{
	import flash.utils.Dictionary;
	
	public class ProtocolMap
	{
		private var _minIndex:Number = NaN;
		private var _maxIndex:Number = NaN;		
		
		private var _protoMap:Dictionary = new Dictionary();
		private var _protoNameMap:Dictionary = new Dictionary();		
//==============================================================================
// Public Functions
//==============================================================================
		public function ProtocolMap()
		{
		}
		
		public function setMinIndex(index:Number):void
		{
			_minIndex = index;
		}
		
		public function setMaxIndex(index:Number):void
		{
			_maxIndex = index;
		}
		
		/**
		 * 保存协议索引和协议名字相互映射关系 
		 * @param index
		 * @param name
		 * 
		 */		
		public  function addItem(index:Number, name:String):void
		{
			if(index >= _minIndex && index <= _maxIndex)
			{
				_protoMap[index] = name;
				_protoNameMap[name] = index;
			}
		}
		
		/**
		 * 由协议索引获取协议名 
		 * @param index
		 * 
		 */		
		public function getProtoNameByIndex(index:Number):String
		{
			return _protoMap[index];
		}
		
		/**
		 * 由协议名获取协议索引 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getProtoIndexByName(name:String):Number
		{
			return _protoNameMap[name];
		}	
//------------------------------------------------------------------------------
// Private
//------------------------------------------------------------------------------

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// Event
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
	}
}