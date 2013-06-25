package utils
{
	import flash.utils.ByteArray;
	
	/**
	 * ByteArray工具类
	 * @author Kenny
	 */
	public class ByteArraryUtil
	{
		/**
		 * 把 ByteArray 转换为 16 进制。
		 * 格式为 "BB BB BB BB BB BB BB BB|BB BB..."，"BB" 表示一个字节。 
		 * @param bytes ByteArray
		 * @return 把 ByteArray 转换为16进制后的字符串。
		 */
		public static function toHex(bytes:ByteArray):String 
		{ 
			var pos:int = bytes.position; 
			bytes.position = 0; 
			var result:String = ""; 
			while(bytes.bytesAvailable >= 8) {  
				result +=  toHexNum(bytes.readUnsignedByte()) 
					+ " "   +   toHexNum(bytes.readUnsignedByte()) 
					+ " "   +   toHexNum(bytes.readUnsignedByte()) 
					+ " "   +   toHexNum(bytes.readUnsignedByte()) 
					+ " "   +   toHexNum(bytes.readUnsignedByte()) 
					+ " "   +   toHexNum(bytes.readUnsignedByte()) 
					+ " "   +   toHexNum(bytes.readUnsignedByte()) 
					+ " "   +   toHexNum(bytes.readUnsignedByte()) 
					+ "|"; 
			} 
			while(bytes.bytesAvailable>1) {  
				result += toHexNum(bytes.readUnsignedByte()) + " " 
			} 
			if(bytes.bytesAvailable) {  
				result += toHexNum(bytes.readUnsignedByte()); 
			} 
			bytes.position = pos; return result;
		}
			
			/** 
			 * @private *  
			 * 把 1 个字节转换为 16 进制的字符串。 *  
			 * @param n 1 个字节。 
			 * @return 16 进制的字符串。 
			 */
			private static function toHexNum(n:uint):String 
			{ 
				return n <= 0xF ? "0" + n.toString(16) : n.toString(16);
			}

		
	}
}