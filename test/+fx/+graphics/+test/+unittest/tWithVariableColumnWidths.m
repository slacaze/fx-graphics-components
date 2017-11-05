classdef tWithVariableColumnWidths < fx.graphics.test.WithFigure
    
    methods( Test )
        
        function this = testEnhance( this )
            base = uitable(...
                'Parent', [] );
            enhance( base, 'fx.graphics.WithVariableColumnWidths' );
        end
        
        function this = testVariableAdaptOnDataChanged( this )
            base = uitable(...
                'Parent', [] );
            enhance( base, 'fx.graphics.WithVariableColumnWidths' );
            this.verifyEmpty( base.VariableColumnWidths );
            base.Data = {1 false 'a';2 false 'b';3 true 'c'};
            this.verifyEqual( base.VariableColumnWidths, [-1 -1 -1] );
            base.Data = {1 false 'a' 1;2 false 'b' 2;3 true 'c' 3};
            this.verifyEqual( base.VariableColumnWidths, [-1 -1 -1 -1] );
            base.Data = {};
            this.verifyEmpty( base.VariableColumnWidths );
        end
        
        function this = testComputedSizes( this )
            base = uitable(...
                'Parent', this.Figure, ...
                'Position', [1 1 300 100] );
            enhance( base, 'fx.graphics.WithVariableColumnWidths' );
            this.verifyEmpty( base.VariableColumnWidths );
            base.Data = {1 false 'a';2 false 'b';3 true 'c'};
            this.verifyEqual( base.VariableColumnWidths, [-1 -1 -1] );
            %
            actualSizes = cell2mat( base.ColumnWidth );
            rowWidth = base.FxComponents.guessRowNameWidth();
            scrollbarWidth = base.FxComponents.guessScrollbarWidth();
            this.verifyEqual( actualSizes, [1 1 1] * ( 300 - rowWidth - scrollbarWidth ) / 3,...
                'AbsTol', eps( actualSizes ) );
            %
            base.RowName = '';
            actualSizes = cell2mat( base.ColumnWidth );
            rowWidth = base.FxComponents.guessRowNameWidth();
            scrollbarWidth = base.FxComponents.guessScrollbarWidth();
            this.verifyEqual( actualSizes, [1 1 1] * ( 300 - rowWidth - scrollbarWidth ) / 3,...
                'AbsTol', eps( actualSizes ) );
            %
            base.VariableColumnWidths = [-1 -3 -1];
            actualSizes = cell2mat( base.ColumnWidth );
            rowWidth = base.FxComponents.guessRowNameWidth();
            scrollbarWidth = base.FxComponents.guessScrollbarWidth();
            this.verifyEqual( actualSizes, [1 3 1] * ( 300 - rowWidth - scrollbarWidth ) / 5,...
                'AbsTol', eps( actualSizes ) );
            %
            base.VariableColumnWidths = [-1 20 -1];
            actualSizes = cell2mat( base.ColumnWidth );
            rowWidth = base.FxComponents.guessRowNameWidth();
            scrollbarWidth = base.FxComponents.guessScrollbarWidth();
            this.verifyEqual( actualSizes, [0 20 0] + [1 0 1] * ( 300 - rowWidth - scrollbarWidth - 20 ) / 2,...
                'AbsTol', eps( actualSizes ) );
        end
        
    end
    
end