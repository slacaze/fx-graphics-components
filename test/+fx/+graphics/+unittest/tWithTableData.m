classdef tWithTableData < matlab.unittest.TestCase
    
    methods( Test )
        
        function this = testEnhance( this )
            base = uitable(...
                'Parent', [] );
            enhance( base, 'fx.graphics.WithTableData' );
        end
        
        function this = testPassTable( this )
            base = uitable(...
                'Parent', [] );
            enhance( base, 'fx.graphics.WithTableData' );
            myTable = table( [1; 2; 3], {'a'; 'b'; 'c'},...
                'VariableNames', {'m', 'n'} );
            base.TableData = myTable;
            this.verifyEqual( base.Data, {1, 'a'; 2, 'b'; 3, 'c'} );
            this.verifyEqual( base.ColumnName, {'m', 'n'}' );
        end
        
    end
    
end