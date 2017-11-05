classdef tfxgraphicsroot < matlab.unittest.TestCase
    
    methods( Test )
        
        function this = testEnhance( this )
            expectedRoot = fileparts( which( 'enhance' ) );
            this.verifyEqual( fxgraphicsroot, expectedRoot );
        end
        
    end
    
end