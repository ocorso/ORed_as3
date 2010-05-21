package net.ored.controllers
{
	import org.robotlegs.mvcs.Mediator;

	public class HomepageController extends Mediator
	{
		public function HomepageController()
		{
			super();
		}
		protected function _slideClicked(e:MouseEvent):void{
			var locStateName:String = e.target.parent.stateName;
			Out.status(this, "you clicked on : "+locStateName);
			
			switch (locStateName){
				case "intro": navigateToURL(new URLRequest(_m.baseURL), "_self");
					break;
				case "party" : navigateToURL(new URLRequest("http://www.marykay.com/whatsnew/itsyourparty/default.aspx?ab=ad_sm_hostaparty"));
					break;
				case "spring" : navigateToURL(new URLRequest(_m.baseURL+"/Tips/?id=1"), "_self");
					break;
				case "diy" : navigateToURL(new URLRequest(_m.baseURL+"/Tips/?id=2"), "_self");
					break;
				case "anti" : navigateToURL(new URLRequest(_m.baseURL+"/Tips/?id=3"), "_self");
					break;
				default : trace("what the hell state is this?");
				
			}//end switch
		}//end slide clicked
	}//end class
}//end package