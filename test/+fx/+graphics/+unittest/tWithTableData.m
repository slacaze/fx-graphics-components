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
                'VariableNames', {'m', 'n'},...
                'RowNames', {'Monday', 'Tuesday', 'Wednesday'} );
            base.TableData = myTable;
            this.verifyEqual( base.Data, {1, 'a'; 2, 'b'; 3, 'c'} );
            this.verifyEqual( base.ColumnName, {'m', 'n'}' );
            this.verifyEqual( base.RowName, {'Monday', 'Tuesday', 'Wednesday'}' );
        end
        
        function this = testGetTable( this )
            base = uitable(...
                'Parent', [] );
            enhance( base, 'fx.graphics.WithTableData' );
            base.Data = {1 false 'a';2 false 'b';3 true 'c'};
            base.ColumnName = {'Numbers', 'Logical', 'Strings'};
            myTable = base.TableData;
            this.verifyEqual( table2cell( myTable ), {1, false, 'a'; 2, false, 'b'; 3, true, 'c'} );
            this.verifyEqual( myTable.Properties.VariableNames, {'Numbers', 'Logical', 'Strings'} );
            this.verifyEqual( myTable.Properties.RowNames, {'1', '2', '3'}' );
        end
        
        function this = testGetTableWithRowNames( this )
            base = uitable(...
                'Parent', [] );
            enhance( base, 'fx.graphics.WithTableData' );
            base.Data = {1 false 'a';2 false 'b';3 true 'c'};
            base.ColumnName = {'Numbers', 'Logical', 'Strings'};
            base.RowName = {'Monday', 'Tuesday', 'Wednesday'};
            myTable = base.TableData;
            this.verifyEqual( table2cell( myTable ), {1, false, 'a'; 2, false, 'b'; 3, true, 'c'} );
            this.verifyEqual( myTable.Properties.VariableNames, {'Numbers', 'Logical', 'Strings'} );
            this.verifyEqual( myTable.Properties.RowNames, {'Monday', 'Tuesday', 'Wednesday'}' );
        end
        
        function this = testBaseDiesWithComponent( this )
            base = uitable(...
                'Parent', [] );
            enhance( base, 'fx.graphics.WithTableData' );
            component = base.FxComponents;
            delete( component );
            this.verifyFalse( isvalid( base ) );
        end
        
        function this = testErrorOnFxComponentsOverride( this )
            this.applyFixture(...
                matlab.unittest.fixtures.SuppressedWarningsFixture( 'MATLAB:callback:DynamicPropertyEventError' ) );
            base = uitable(...
                'Parent', [] );
            enhance( base, 'fx.graphics.WithTableData' );
            expectedComponents = base.FxComponents;
            base.FxComponents = 2;
            this.verifyEqual( base.FxComponents, expectedComponents );
        end
        
    end
    
end