function runUnitTests( mode )
    if nargin < 1
        mode = 'fast';
    end
    switch mode
        case 'fast'
            testResults = runtests( 'fx.graphics.unittest',...
                'IncludeSubpackages', true );
            disp( testResults );
        case 'codeCoverage'
            suite = matlab.unittest.TestSuite.fromPackage(...
                'fx.graphics.unittest',...
                'IncludingSubpackages', true );
            runner = matlab.unittest.TestRunner.withTextOutput();
            coberturaReport = matlab.unittest.plugins.codecoverage.CoberturaFormat(...
                fullfile( fxgraphicstestroot, 'codeCoverage.xml' ) );
            codeCoveragePlugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder(...
                fxgraphicsroot,...
                'IncludingSubfolders', true,...
                'Producing', coberturaReport );
            runner.addPlugin( codeCoveragePlugin );
            testResults = runner.run( suite );
            disp( testResults );
    end
end