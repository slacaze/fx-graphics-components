classdef WithVariableColumnWidths < fx.graphics.Component
    
    properties( GetAccess = public, SetAccess = public, SetObservable, Dependent )
        VariableColumnWidths(1,:) double
        RowNameWidth(1,:) double
    end
    
    properties( GetAccess = private, SetAccess = private )
        VariableColumnWidths_(1,:) double = double.empty
        RowNameWidth_(1,:) double = double.empty
    end
    
    properties( GetAccess = private, SetAccess = private, Dependent )
        NumberOfColumns(1,1) double
    end
    
    properties( GetAccess = private, SetAccess = immutable )
        Listeners event.listener
    end
    
    methods
        
        function value = get.VariableColumnWidths( this )
            value = this.VariableColumnWidths_;
        end
        
        function set.VariableColumnWidths( this, value )
            validateattributes( value,...
                {'double'}, {'row', 'numel', this.NumberOfColumns} );
            this.VariableColumnWidths_ = value;
            this.update();
        end
        
        function value = get.RowNameWidth( this )
            value = this.RowNameWidth_;
        end
        
        function set.RowNameWidth( this, value )
            validateattributes( value,...
                {'double'}, {} );
            assert( isempty( value ) || isscalar( value ),...
                'FxGraphics:InvalidDimensions',...
                'THe value shoudl be scalar or empty.' );
            this.RowNameWidth_ = value;
            this.update();
        end
        
        function value = get.NumberOfColumns( this )
            value = size( this.HgObject.Data, 2 );
        end
        
    end
    
    methods
        
        function this = WithVariableColumnWidths( hgObject )
            validateattributes( hgObject,...
                {'matlab.ui.control.Table'}, {'scalar'} );
            this@fx.graphics.Component( hgObject );
            sizeChangedListener = event.listener( this.HgObject, 'SizeChanged',...
                @this.onSizeChanged );
            dataChangedListener = event.proplistener( this.HgObject,...
                findprop( this.HgObject, 'Data' ), 'PostSet', @this.onDataChanged );
            rowNameChangedListener = event.proplistener( this.HgObject,...
                findprop( this.HgObject, 'RowName' ), 'PostSet', @this.onRowNameChanged );
            this.Listeners = [...
                sizeChangedListener,...
                dataChangedListener,...
                rowNameChangedListener,...
                ];
        end
        
    end
    
    methods( Access = private )
        
        function onSizeChanged( this, ~, ~ )
            this.update();
        end
        
        function onDataChanged( this, ~, ~ )
            deltaColumns = this.NumberOfColumns - numel( this.VariableColumnWidths_ );
            if deltaColumns > 0
                this.VariableColumnWidths_ = [...
                    this.VariableColumnWidths_,...
                    -ones( 1, deltaColumns ),...
                    ];
                this.update();
            elseif deltaColumns < 0
                this.VariableColumnWidths_(this.NumberOfColumns+1:end) = [];
                this.update();
            end
        end
        
        function onRowNameChanged( this, ~, ~ )
            this.update();
        end
        
    end
    
    methods( Access = private )
        
        function update( this )
            if isempty( this.VariableColumnWidths_ )
                return;
            end
            fixedWidthsIdx = this.VariableColumnWidths_ >= 0;
            fixedWidths = this.VariableColumnWidths_(fixedWidthsIdx);
            variableWidthsIdx = this.VariableColumnWidths_ < 0;
            variableWidths = this.VariableColumnWidths_(variableWidthsIdx);
            scrollbarWidth = this.guessScrollbarWidth();
            if isempty( this.RowNameWidth_ )
                rowWidth = this.guessRowNameWidth();
            else
                rowWidth = this.RowNameWidth_;
            end
            tablePosition = getpixelposition( this.HgObject );
            availableWidth = tablePosition(3);
            remainingWidth = availableWidth - sum( fixedWidths ) - scrollbarWidth - rowWidth;
            remainingWidth = max( remainingWidth, 0 );
            widthShare = remainingWidth / abs( sum( variableWidths ) );
            widths = this.VariableColumnWidths_;
            widths(variableWidthsIdx) = -variableWidths * widthShare;
            this.HgObject.ColumnWidth = num2cell( widths );
        end
        
    end
    
    methods( Access = public, Hidden )
        
        function width = guessRowNameWidth( this )
            isNumbered = ...
               ( ischar( this.HgObject.RowName ) &&...
               strcmp( this.HgObject.RowName, 'numbered' ) ) ||...
               ( iscell( this.HgObject.RowName ) && numel( this.HgObject.RowName ) == 1 &&...
               strcmp( this.HgObject.RowName{1}, 'numbered' ) );
            if isNumbered
                width = 30;
            else
                width = 0;
            end
        end
        
        function width = guessScrollbarWidth( ~ )
            width = 19;
        end
        
    end
    
end