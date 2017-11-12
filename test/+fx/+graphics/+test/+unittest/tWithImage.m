classdef tWithImage < fx.graphics.test.WithFigure
    
    methods( Test )
        
        function this = testEnhance( this )
            base = axes(...
                'Parent', this.Figure );
            enhance( base, 'fx.graphics.WithImage' );
        end
        
        function this = testShowImageHasSameDimensionsAsAxes( this )
            base = axes(...
                'Parent', this.Figure );
            enhance( base, 'fx.graphics.WithImage' );
            base.Image = which( 'peppers.png' );
            axesPosition = round( getpixelposition( base ) );
            this.verifyEqual( axesPosition(3:4), [size( base.Children.CData, 2 ) size( base.Children.CData, 1 )] );
            base.Position(3:4) = [0.1 0.8];
            axesPosition = round( getpixelposition( base ) );
            this.verifyEqual( axesPosition(3:4), [size( base.Children.CData, 2 ) size( base.Children.CData, 1 )] );
        end
        
    end
    
end