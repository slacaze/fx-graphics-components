classdef WithImage < fx.graphics.Component
    
    properties( GetAccess = public, SetAccess = public, SetObservable, Dependent )
        Image
        Width
        Height
    end
    
    properties( GetAccess = private, SetAccess = private )
        Image_(1,:) char = char.empty
        ImageData
        ImageObject(1,1) matlab.graphics.primitive.Image
        Listeners(1,:) event.listener
    end
    
    methods
        
        function value = get.Image( this )
            value = this.Image_;
        end
        
        function set.Image( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.Image_ = value;
            this.ImageData = imread( this.Image_ );
            this.update();
        end
        
        function value = get.Width( this )
            value = size( this.ImageObject.CData, 2 );
        end
        
        function value = get.Height( this )
            value = size( this.ImageObject.CData, 1 );
        end
        
    end
    
    methods
        
        function this = WithImage( hgObject )
            validateattributes( hgObject,...
                {'matlab.graphics.axis.Axes'}, {'scalar'} );
            this@fx.graphics.Component( hgObject );
            this.Listeners = event.listener( this.HgObject,...
                'SizeChanged', @this.onSizeChanged );
        end
        
    end
    
    methods( Access = private )
        
        function update( this )
            axesPosition = getpixelposition( this.HgObject );
            axesWidth = axesPosition(3);
            axesHeight = axesPosition(4);
            resizedImage = imresize( this.ImageData, [axesHeight axesWidth] );
            this.ImageObject = imshow( resizedImage,...
                'Parent', this.HgObject );
        end
        
    end
    
    methods( Access = private )
        
        function onSizeChanged( this, ~, ~ )
            this.update();
        end
        
    end
    
end