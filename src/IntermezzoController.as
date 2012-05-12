package
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindowResize;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.Application;
	import mx.core.IMXMLObject;
	import mx.core.WindowedApplication;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;

	public class IntermezzoController implements IMXMLObject
	{
		private const app:WindowedApplication = Application.application as WindowedApplication;
		private var page:intermezzo;
		private const DRAG_AREA:int = 40;

		public function IntermezzoController()
		{
		}

		public function initialized(document:Object, id:String):void
		{
			page = document as intermezzo;
			page.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationCompleteHandler);
			page.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}

		public function applicationCompleteHandler(event:FlexEvent):void
		{
			app.stage.addEventListener(MouseEvent.MOUSE_DOWN, startMoveOrResize);
//			app.stage.addEventListener(MouseEvent.MOUSE_MOVE, changeButtonMode);
			createContextMenu();
		}

		public function creationCompleteHandler(event:FlexEvent):void
		{
			page.mainWindow.addEventListener(CloseEvent.CLOSE, closeEventHandler);
		}

		/**
		 * アプリケーションの終了
		 * @param event
		 */
		private function closeEventHandler(event:CloseEvent):void
		{
			// mainWindowでクローズボタンを押すと自動的にイベントが発生するので
			// ディスパッチすると何度もイベントを送ってしまってオーバーフローになる
			app.exit();
		}

		/**
		 * マウス操作による移動・リサイズシーケンスを開始します。
		 * @param event
		 */
		private function startMoveOrResize(event:MouseEvent):void
		{
			var resizeFrom:String = "";
			
			
			
			if (event.stageY < 55 /*&& app.stage.mouseX > 34 && app.stage.mouseX < 990*/)
			{
				app.stage.nativeWindow.startMove();
			}
//			else if (app.stage.mouseY > (app.stage.height - dragArea) && app.stage.mouseX < dragArea)
//			{
//				app.stage.nativeWindow.startResize(NativeWindowResize.BOTTOM_LEFT);
//			}
			//else
//			 if (app.stage.mouseY > (app.stage.height - DRAG_AREA) && app.stage.mouseX > app.stage.width - DRAG_AREA)
//			{
//					page.mainWindow.buttonMode = true;
//					app.stage.nativeWindow.startResize(NativeWindowResize.BOTTOM_RIGHT);
//			}
////			
			/**
			 * もしBUTOOMとLEFTが引っかかった場合、LBと入力し
			 * 
			 */
			
			//if (event.localY < app.stage.height * .05) {
//				resizeFrom = NativeWindowResize.TOP;
				//app.stage.nativeWindow.startMove();
			//} 
			/*
			else if (event.localY > app.stage.height * .66) {
				resizeFrom = NativeWindowResize.BOTTOM;
			}
			
			if (event.localX < app.stage.width * .33) {
				resizeFrom += NativeWindowResize.LEFT;
			}
			else if (event.localX < app.stage.width * .66) {
				resizeFrom += NativeWindowResize.RIGHT;
			}
			*/
			
			/*
			if (event.localY > app.stage.height * .66 && event.localX < app.stage.width * .33) {
				resizeFrom = NativeWindowResize.BOTTOM_LEFT;
			}
			else if (event.localY > app.stage.height * .99 && event.localX < app.stage.width * .66) {
				resizeFrom = NativeWindowResize.BOTTOM_RIGHT;
			}
			*/
				
		}
		
		/**
		 * ボタンモードを変更します。
		 * @param event MouseEvent
		 */				
//		private function changeButtonMode(event:MouseEvent):void
//		{
//			if (app.stage.mouseY > (app.stage.height - DRAG_AREA) && app.stage.mouseX > app.stage.width - DRAG_AREA)
//			{
//				page.mainWindow.buttonMode = true;
//			}
//			else
//			{
//				page.mainWindow.buttonMode = false;
//			}
//		}

		/**
		 * 右クリックメニューを作成します。
		 */
		private function createContextMenu():void
		{
			/* ルートメニュー */
			var rootMenu:NativeMenu = new NativeMenu();

			/* サブメニュー */
			var sizeMenu:NativeMenu = new NativeMenu();

			/* メニューアイテム */
			var sizeMenuItem:NativeMenuItem = rootMenu.addSubmenu(new NativeMenu(), "サイズ");
			var maxSizeMenuItem:NativeMenuItem = new NativeMenuItem("最大化");
			var minSizeMenuItem:NativeMenuItem = new NativeMenuItem("最小化");
			var restoreMenueItem:NativeMenuItem = new NativeMenuItem("元に戻す");
			var exitMenuItem:NativeMenuItem = new NativeMenuItem("閉じる");

			/* サブメニューにアイテムを追加 */
			sizeMenu.addItem(maxSizeMenuItem);
			sizeMenu.addItem(minSizeMenuItem);
			sizeMenu.addItem(restoreMenueItem);

			/* アイテムを追加 */
			rootMenu.addItem(exitMenuItem);
			sizeMenuItem.submenu = sizeMenu;

			/* 作ったメニューをコンテキストメニューに追加 */
			page.contextMenu = rootMenu;
//			page.mainWindow.contextMenu = rootMenu;

			/* イベントの設定 */
			maxSizeMenuItem.addEventListener(Event.SELECT, maxSizeMenuSelectedHandler);
			minSizeMenuItem.addEventListener(Event.SELECT, minSizuMenuSelectedHandler);
			restoreMenueItem.addEventListener(Event.SELECT, restoreMenuSelectedHandler);
			exitMenuItem.addEventListener(Event.SELECT, exitMenuSelectedHandler);
		}

		/**
		 * 右メニューの”最大化”を選択した時のハンドラ
		 * @param event
		 */
		private function maxSizeMenuSelectedHandler(event:Event):void
		{
			app.stage.nativeWindow.maximize();
		}

		/**
		 * 右メニューの”最小化”を選択した時のハンドラ
		 * @param event
		 */
		private function minSizuMenuSelectedHandler(event:Event):void
		{
			app.stage.nativeWindow.minimize();
		}
		
		/**
		 * 右メニューの"元に戻す"を選択した時のハンドラ
		 * @param event
		 */		
		private function restoreMenuSelectedHandler(event:Event):void
		{
			app.stage.nativeWindow.restore();
		}

		/**
		 * 右メニューの”閉じる”を選択した時のハンドラ
		 * @param event
		 */
		private function exitMenuSelectedHandler(event:Event):void
		{
			app.exit();
		}

	}
}