classdef WithTableData < fx.graphics.Component
    
    properties( GetAccess = public, SetAccess = public, SetObservable, Dependent )
        TableData
    end
    
    methods
        
        function value = get.TableData( this )
            if ischar( this.HgObject.RowName ) && strcmp( this.HgObject.RowName, 'numbered' )
                rowNames = arrayfun( @num2str, 1:size( this.HgObject.Data, 1 ),...
                    'UniformOutput', false );
            else
                rowNames = this.HgObject.RowName;
            end
            value = cell2table( this.HgObject.Data,...
                'VariableNames', this.HgObject.ColumnName,...
                'RowNames', rowNames );
        end
        
        function set.TableData( this, value )
            validateattributes( value,...
                {'table', 'timetable'}, {} );
            this.HgObject.Data = table2cell( value );
            this.HgObject.ColumnName = value.Properties.VariableNames;
            this.HgObject.RowName = value.Properties.VariableNames;
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