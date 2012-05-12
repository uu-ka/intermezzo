package views.mainWindow
{
	import components.ExcelManager;
	import components.files.FileManager;
	import components.files.FileModel;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import modules.CapacityBarChartModule;
	import modules.CapacityPieChartModule;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.IMXMLObject;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;

	public class MainWindowController implements IMXMLObject
	{
		private var page:MainWindow;
		private var fileManager:FileManager = new FileManager();
		private var model:ArrayCollection = new ArrayCollection();

		public function MainWindowController()
		{
		}

		public function initialized(document:Object, id:String):void
		{
			page = document as MainWindow;
			page.addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}

		public function creationCompleteHandler(event:FlexEvent):void
		{
			/* ツリー  */
			page.routeTree.addEventListener(MouseEvent.MOUSE_DOWN, routeTreeSelectedHandler);

			page.checkButton.addEventListener(MouseEvent.CLICK, checkButtonClickHandler);

			/* データグリッド  */
			//page.dataGrid.columns = [page.dataGrid.nameColumn, page.dataGrid.typeColumn, page.dataGrid.sizeColumn];

			/* リサイズボタン */
//			page.resizeButton.addEventListener(MouseEvent.CLICK, resizeButtonClickHandler);
			
			/* グラフ切り替えボタン */
			page.barChartButton.addEventListener(MouseEvent.CLICK, barChartButtonClickHandler);
			page.pieChartButton.addEventListener(MouseEvent.CLICK, pieChartButtonClickHandler);

			//page.excelButton.addEventListener(MouseEvent.CLICK, excelButtonClickHandler);

			/* module */
			page.moduleLoader.url = "modules/capacityPieChartModule.swf";
			page.moduleLoader.addEventListener(ModuleEvent.READY, readyHandler);

		}
//		
//		/**
//		 * リサイズボタンをクリックしたときのハンドラ
//		 * @param event MouseEvent
//		 */		
//		private function resizeButtonClickHandler(event:MouseEvent):void
//		{
//			if(page.resizeButton.hideLabel == "拡大")
//			{
//				page.resizeButton.label = "縮小";
//				page.resizeButton.hideLabel = "縮小";
//			}
//			else
//		    {
//		    	page.resizeButton.label = "拡大";
//				page.resizeButton.hideLabel = "拡大";	
//			}
//		}

		/**
		 * readyEventのハンドラ
		 * @param event ModuleEvent
		 */
		private function readyHandler(event:ModuleEvent):void
		{
			var barChartModule:CapacityBarChartModule = page.moduleLoader.child as CapacityBarChartModule;
			var pieChartModule:CapacityPieChartModule = page.moduleLoader.child as CapacityPieChartModule;

			if (barChartModule != null)
			{
				barChartModule.addEventListener(FlexEvent.CREATION_COMPLETE, setChartData);
			}
			else if (pieChartModule != null)
			{
				pieChartModule.addEventListener(FlexEvent.CREATION_COMPLETE, setChartData);
			}
		}

		/**
		 * グラフデータをセットします。
		 * @param event FlexEvent
		 */
		private function setChartData(event:FlexEvent):void
		{
			var barChartModule:CapacityBarChartModule = page.moduleLoader.child as CapacityBarChartModule;
			var pieChartModule:CapacityPieChartModule = page.moduleLoader.child as CapacityPieChartModule;
			
			if (barChartModule != null && barChartModule.capacityBarChart != null)
			{
				barChartModule.capacityBarChart.dataProvider = model;
			}
			else if (pieChartModule != null && pieChartModule.capacityPieChart != null)
			{
				pieChartModule.capacityPieChart.dataProvider = model;
			}
		}

		/**
		 * エクセルボタンを押したときのハンドラ
		 * @param event
		 */
		private function excelButtonClickHandler(event:MouseEvent):void
		{
			var excelManager:ExcelManager = new ExcelManager();
			excelManager.createSheet();
		}

		/**
		 * barChartボタンを押したときのハンドラ
		 * @param event MouseEvent
		 */
		private function barChartButtonClickHandler(event:MouseEvent):void
		{
			page.moduleLoader.url = "modules/capacityBarChartModule.swf";
		}

		/**
		 * pieChartボタンを押したときのハンドラ
		 * @param event　MouseEvent
		 */
		private function pieChartButtonClickHandler(event:MouseEvent):void
		{
			page.moduleLoader.url = "modules/capacityPieChartModule.swf";
		}

		/**
		 * 選択したディレクトリ直下にあるファイル・ディレクトリのサイズを計算します。
		 * @param directory
		 */
		private function capacityCheck(directory:File):void
		{
			//TODO フォーカス当たってるときにチェックすれば必要ない？
			if (!directory.isDirectory)
			{
				Alert.show("ディレクトリを選択してください。");
				return;
			}
			
			if (directory.parent == null)
			{
				Alert.show("ルートディレクトリはチェック出来ません。。。");
				return;
			}
			
			/* フォルダ直下にあるフォルダorファイル */
			var files:Array = directory.getDirectoryListing();

			if (files.length == 0)
			{
				Alert.show("ファイル又はフォルダがありません。");
				return;
			}

			/* モデル作成 */
			model = fileManager.createFileModelList(files);


			var barChartModule:CapacityBarChartModule = page.moduleLoader.child as CapacityBarChartModule;
			var pieChartModule:CapacityPieChartModule = page.moduleLoader.child as CapacityPieChartModule;

			/* グラフデータのセット */
			if (barChartModule != null)
			{
				barChartModule.capacityBarChart.dataProvider = model;
			}
			else if (pieChartModule != null)
			{
				pieChartModule.capacityPieChart.dataProvider = model;
			}

			page.dataGrid.directory = directory;
			page.dataGrid.sizeColumn.labelFunction = sizeColumnLabelFunction;
			page.path.text = directory.nativePath;
		}

		/**
		 * サイズカラムのラベルファンクション
		 * @param item
		 * @param column
		 * @return
		 */
		private function sizeColumnLabelFunction(item:File, column:DataGridColumn):String
		{
			/* 行番号を取得 */
//			var index:int = page.dataGrid.dataProvider.getItemIndex(item);
			var fileName:String = item.name;
			
			for each (var file:FileModel in model)
			{
				if(fileName == file.name)
				{
					return file.size + "KB";
				}
			}
			
			return "-";
		}

		/**
		 * ツリー選択時のハンドラ
		 * @param event
		 */
		private function routeTreeSelectedHandler(event:MouseEvent):void
		{
			if (page.routeTree.selectedItem != null)
			{
				var file:File = new File();
				file.nativePath = page.routeTree.selectedItem.nativePath;
				
				/* チェックボタンの有無効切り替え */
				if (file.isDirectory && file.parent != null)
				{
					page.checkButton.enabled = true;
				}
				else
				{
					page.checkButton.enabled = false;
				}
			}
		}

		/**
		 * キャパシティチェック
		 * @param event
		 */
		private function checkButtonClickHandler(event:MouseEvent):void
		{
			capacityCheck(page.routeTree.selectedItem as File);

			var file:File = new File();
			file.nativePath = page.routeTree.selectedItem.nativePath
			page.path.text = " " + page.routeTree.selectedItem.nativePath;

		}

	}
}