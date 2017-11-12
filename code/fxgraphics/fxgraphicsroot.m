function thisPath = fxgraphicsroot()
    % Root of the Fx Graphics Components Toolbox
    %
    %   path = fxgraphicsroot() return the root of the Fx Custom Graphics
    %   Components Toolbox in the "path" variable.
    
    thisPath = fileparts( mfilename( 'fullpath' ) );
end