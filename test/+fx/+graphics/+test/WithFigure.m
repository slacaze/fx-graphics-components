classdef WithFigure < matlab.unittest.TestCase
    
    properties( GetAccess = protected, SetAccess = private )
        Figure(1,:) matlab.ui.Figure = matlab.ui.Figure.empty
    end
    
    methods( TestMethodSetup )
        
        function createFigure( this )
            this.Figure = matlab.ui.Figure(...
                'Visible', 'off' );
        end
        
    end
    
    methods( TestMethodTeardown )
        
        function deleteFigure( this )
            if isvalid( this.Figure )
                delete( this.Figure );
            end
        end
        
    end
    
end