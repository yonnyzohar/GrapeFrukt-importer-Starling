﻿package src
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.display.Image;
	
	public class AnimationNodeMatrix extends Sprite
	{
		private var totalFiles:int;
		
		
		
		
		private var imageTexture:Texture;
		private var img:Image;
		
		private var _assetName:String;
		private var _assetWidth:Number;
		private var _assetHeight:Number;
		private var _path:String;
		private var _registrationPointX:Number;
		private var _registrationPointY:Number;
		private var _zIndex:int;
		private var _image:Bitmap;
		private var animation:Array = new Array();
		
		public var spriteSheet:Boolean = false;
		
		public var frameCount:int;
		public var frameWidth:Number;
		public var frameHeight:Number;
		public var columns:int;
		
		private var canvas:Bitmap;
		private var bd:BitmapData;
		
		public var curIndex:int = 0;
		public var innerIndex:int = 0;
		
		private var rect:Rectangle = new Rectangle();
		
		var xPlace:int;
		var yPlace:int;
		
		public function AnimationNodeMatrix()
		{
		
		}
		
		public function parseFrames(lst:XMLList):void
		{
			totalFiles = lst.length();
			
			for (var i:int = 0; i < totalFiles; i++)
			{
				var obj:Object = new Object();
				
				obj.index = lst[i].@index;
				obj.a = lst[i].@a;
				obj.b = lst[i].@b;
				obj.c = lst[i].@c;
				obj.d = lst[i].@d;
				obj.tx = lst[i].@tx;
				obj.ty = lst[i].@ty;
				
				animation.push(obj);
				
			}
		}
		
		public function get assetName():String
		{
			return _assetName;
		}
		
		public function set assetName(value:String):void
		{
			_assetName = value;
		}
		
		public function get assetWidth():Number
		{
			return _assetWidth;
		}
		
		public function set assetWidth(value:Number):void
		{
			_assetWidth = value;
		}
		
		public function get assetHeight():Number
		{
			return _assetHeight;
		}
		
		public function set assetHeight(value:Number):void
		{
			_assetHeight = value;
		}
		
		public function get path():String
		{
			return _path;
		}
		
		public function set path(value:String):void
		{
			_path = value;
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImageComplete);
			
			var url:String = "lib/" + _path;
			trace(url);
			l.load(new URLRequest(url));
		}
		
		private function onLoadImageComplete(e:Event):void
		{
			image = Bitmap(e.target.content);
			imageTexture = Texture.fromBitmap(image);
			img = new Image(imageTexture);
			
			if (columns)
			{
				trace("yey!");
				
				canvas = new Bitmap(new BitmapData(frameWidth, frameHeight, true, 0xE730F2));
				bd = new BitmapData(image.width, image.height, true, 0xE730F2);
				bd.draw(image);
				

				handleBlitting();
				
				canvas.smoothing = true;
			}
			else
			{
				addChild(img);
				image.smoothing = true;
			}
			
			img.x -= _registrationPointX;
			img.y -= _registrationPointY;
		
		}
		
		public function get registrationPointX():Number
		{
			return _registrationPointX;
		}
		
		public function set registrationPointX(value:Number):void
		{
			_registrationPointX = value;
		}
		
		public function get registrationPointY():Number
		{
			return _registrationPointY;
		}
		
		public function set registrationPointY(value:Number):void
		{
			_registrationPointY = value;
		}
		
		public function get zIndex():int
		{
			return _zIndex;
		}
		
		public function set zIndex(value:int):void
		{
			_zIndex = value;
		}
		
		public function get image():Bitmap
		{
			return _image;
		}
		
		public function set image(value:Bitmap):void
		{
			_image = value;
		}
		
		public function playAnim(count:int):void
		{
			var proceed:Boolean = false;
			
			for (var i:int = 0; i < animation.length; i++)
			{
				if (count == animation[i].index)
				{
					proceed = true;
					break;
				}
			}
			
			if (proceed)
			{
				if (curIndex < animation.length)
				{
					visible = true;
					
					var myMatrix:Matrix = new Matrix( );
									
					myMatrix.a = animation[curIndex].a;
					myMatrix.b = animation[curIndex].b;
					myMatrix.c = animation[curIndex].c;
					myMatrix.d = animation[curIndex].d;
					myMatrix.tx = animation[curIndex].tx;
					myMatrix.ty = animation[curIndex].ty;
					
					this.transformationMatrix.a = myMatrix.a;
					this.transformationMatrix.b = myMatrix.b;
					this.transformationMatrix.c = myMatrix.c;
					this.transformationMatrix.d = myMatrix.d;
					this.transformationMatrix.tx = myMatrix.tx;
					this.transformationMatrix.ty = myMatrix.ty;
					
					//this.transform.matrix = myMatrix;

					
					if (columns)
					{
						handleBlitting();
					}
					
					curIndex++;
				}
				
			}
			else
			{
				visible = false;
			}
		
		}
		
		
		
		private function handleBlitting():void
		{
			if (bd)
			{
				if (contains(img))
				{
					removeChild(img);
					img = null;
				}
				
				xPlace = frameWidth * (innerIndex % columns);
				yPlace = frameHeight * (Math.floor(innerIndex / columns));
				
				rect.x = xPlace;
				rect.y = yPlace;
				rect.width = frameWidth;
				rect.height = frameHeight;
				
				canvas.bitmapData.fillRect(canvas.bitmapData.rect, 0);
				
				canvas.bitmapData.lock();
				canvas.bitmapData.fillRect(new Rectangle(xPlace, yPlace, frameWidth, frameHeight), 0xE730F2);
				
				canvas.bitmapData.copyPixels( bd, rect, new Point( 0, 0 ), null, null, true );
			
				canvas.bitmapData.unlock();
				
				imageTexture = Texture.fromBitmap(canvas);
				img = new Image(imageTexture);
				
				addChild(img);
				
				if (innerIndex < frameCount -1)
				{
					innerIndex++;
				}
				else
				{
					innerIndex = 0;
				}
			}
		}
	}
}