//AS3///////////////////////////////////////////////////////////////////////////
// 
// Roman by Big Spaceship. 2010.03.18
// 
// Copyright 2010 Big Spaceship, LLC
// To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
// 
////////////////////////////////////////////////////////////////////////////////

package com.bigspaceship.utils
{
	/**
	 * The <code>Roman()</code> is a one function class to convert from binary (decimal) to roman numerals.
	 * 
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0.0
	 * 
	 * @version		1.0
	 * 
	 * @author Stephen Koch
	 * @since  2010.03.18
	 */
	public class Roman
	{
		//http://www.roseindia.net/java/java-tips/45examples/misc/roman/roman.shtml
		// Parallel arrays used in the conversion process.
		private static const RCODE = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"];
		private static const BVAL  = [1000, 900, 500, 400,  100, 90,   50,   40,  10,   9,    5,   4,    1];

		/**
		*	@param $decimal The decimal to convert (lower than 4000).
		*
		*	@return String	Roman Numeral
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function decimalToRoman($decimal:uint):String
		{
			if ($decimal <= 0 || $decimal >= 4000)
			{
				throw new Error("Value outside roman numeral range.");
			}
			var roman:String = "";

			// Loop from biggest value to smallest, successively subtracting,
			// from the binary value while adding to the roman representation.
			for(var i:uint = 0; i < RCODE.length; i++)
			{
				while($decimal >= BVAL[i])
				{
					$decimal -= BVAL[i];
					roman += RCODE[i];
				}
			}
			return roman;
		};
		
	};
};
