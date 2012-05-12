package components
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	
	
	public class ExcelManager
	{
		public function ExcelManager()
		{
		}

		
		public function createSheet():void {
			var sheet:Sheet = new Sheet();
			var xls:ExcelFile = new ExcelFile();
			
			sheet.resize(10, 10);
			
			sheet.setCell(1, 1, "Today's date:");
			sheet.setCell(1, 2, new Date());
			
			xls.sheets.addItem(sheet);
			var bytes:ByteArray = xls.saveToByteArray();
			
			var file:FileReference = new FileReference();
			file.addEventListener(Event.COMPLETE, comp);
			file.addEventListener(IOErrorEvent.IO_ERROR, error);
			file.save(bytes,"test.cvs");
		}
		
		private function comp(event:Event):void {
			Alert.show("成功");
		}
		
		private function error(event:IOErrorEvent):void {
			
		}
		
		
	}
}