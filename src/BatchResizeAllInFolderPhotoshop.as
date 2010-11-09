package 
{
	import com.adobe.csawlib.photoshop.Photoshop;
	import com.adobe.photoshop.*;
	
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	
	public class BatchResizeAllInFolderPhotoshop
	{
		
		private var imgFolder:String;
		private var ext:String;
		private var targetWidth:Number;
		private var targetHeight:Number;
		private var saveAsACopy:Boolean;
		private var fileList:Array;
		private var outDir:String;
		
		
		public static function run():void {
			var app:Application = Photoshop.app;
		}
		
		public function BatchResizeAllInFolderPhotoshop(folder:String, extension:String, width:Number, height:Number, saveAsCopy:Boolean, outputFolder:String) {
			this.imgFolder = folder;
			this.ext = extension;
			this.targetWidth = width;
			this.targetHeight = height;
			this.saveAsACopy = saveAsCopy;
			this.outDir = outputFolder;
			fileList = new Array();
		}
		
		public function run():void {
			this.selectImages();
			var app:Application = Photoshop.app;
			var resampleMethod:ResampleMethod = ResampleMethod.NONE;			
			for each (var f:File in fileList) {
				app.load(f);
				app.activeDocument.resizeImage(this.targetWidth, this.targetHeight);
				app.activeDocument.close(SaveOptions.SAVECHANGES);
			}
		}
		
		public function selectImages():void {
			var f:File = new File(imgFolder);
			if (!f.isDirectory) {
				throw new IllegalOperationError();
			}
			
			var files:Array = f.getDirectoryListing();
			if (files.length == 0) {
				trace("no files in folder");
			}
			var out:File = new File().resolvePath(outDir);
			for each (var f:File in files) {
				if (!f.isDirectory && f.extension.toLowerCase() == this.ext) {
					if (saveAsACopy && outDir != null) {
						var tf = new File(out.nativePath + File.separator + f.name);
						f.copyTo(tf,true);
						this.fileList.push(tf);
					} else {
						this.fileList.push(f);
					}
				}
			}
		}
	}
}