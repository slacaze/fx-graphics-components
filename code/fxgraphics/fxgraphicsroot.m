function thisPath = fxgraphicsroot()
    % Root of the MATLAB Custom Graphics Components Toolbox
    %
    %   path = fxgraphicsroot() return the root of the MATLAB Custom
    %   Graphics Components Toolbox in the "path" variable.
    
    thisPath = fileparts( mfilename( 'fullpath' ) );
end