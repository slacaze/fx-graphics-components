classdef WithTableData < fx.graphics.Component
    
    properties( GetAccess = public, SetAccess = public, SetObservable, Dependent )
        TableData
    end
    
    methods
        
        function value = get.TableData( this )
            value = this.HgObject.Data;
        end
        
        function set.TableData( this, value )
            this.HgObject.Data = value;
        end
        
    end
    
    methods
        
        function this = WithTableData( hgObject )
            validateattributes( hgObject,...
                {'matlab.ui.control.Table'}, {'scalar'} );
            this@fx.graphics.Component( hgObject );
        end
        
    end
    
end