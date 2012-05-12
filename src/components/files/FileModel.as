package components.files
{
	import flash.filesystem.File;


	public class FileModel
	{
		public var fileList:Array = new Array();
		public var size:Number;
		public var name:String;

		public function FileModel()
		{
		}

		/**
		 * ファイルを列挙します。
		 * @param direcotries
		 * @return
		 */
		public function enumerateFiles(direcotry:File):void
		{
			if (direcotry.isDirectory)
			{
				var files:Array = direcotry.getDirectoryListing();

				for (var i:int = 0; i < files.length; i++)
				{
					if (files[i].isDirectory)
					{
						enumerateFiles(files[i]); // 再帰処理
					}
					else
					{
						fileList.push(files[i]);
					}
				}
			}
			else
			{
				fileList.push(direcotry);
			}
		}

	}
}
