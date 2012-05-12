package components.files
{
	import mx.collections.ArrayCollection;

	public class FileManager
	{

		public function FileManager()
		{
		}

		/**
		 * fileModelのリストを作成します。
		 * @param directories
		 * @return
		 */
		public function createFileModelList(directories:Array):ArrayCollection
		{
			var fileModelList:ArrayCollection = new ArrayCollection();

			for (var i:int = 0; i < directories.length; i++)
			{
				if (!directories[i].isHidden)
				{
					var model:FileModel = new FileModel;
					model.enumerateFiles(directories[i]);
					model.name = directories[i].name;
					model.size = calcAllFileSize(model.fileList);
					fileModelList.addItem(model);
				}
			}

			return fileModelList;
		}



		/**
		 * ファイルサイズの合計を算出します。
		 * @param files
		 * @return ファイルサイズ(KB)
		 */
		public function calcAllFileSize(files:Array):Number
		{
			var size:Number = 0;
			for (var i:int = 0; i < files.length; i++)
			{
				size += files[i].size;
			}
			
			return Math.round(size/1024);
		}

	}
}
