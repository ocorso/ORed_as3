package net.ored.views
{
	/**
	 * All states must implement the <code>IState</code> interface.
	 *  
	 * @author Owen Corso
	 */
	public interface IScreen
	{
		function show():void;
		function hide():void;
		function get id():String;
	}
}