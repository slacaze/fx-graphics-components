function enhance( hgObject, template )
    % Enhance a MALTAB native graphics object
    % Enhance a MALTAB native graphics object with additional behaviors.
    %
    %   enhance( hgObject, template ) enhances the "hgObject" with the
    %   "template" behavior.
    %
    %   Example
    %      uiTable = uitable(...
    %          'Parent', figure,...
    %          'Data', {1 2 3;4 5 6},...
    %          'Units', 'normalized',...
    %          'Position', [0 0 1 1] );
    %      enhance( uiTable, 'fx.graphics.WithVariableColumnWidths' );
    
    validateattributes( hgObject,...
        {'matlab.graphics.Graphics'}, {'scalar'} );
    validateattributes( template,...
        {'char'}, {'scalartext'} );
    componentConstructor = fx.graphics.internal.getComponentConstructor(...
        template );
    componentConstructor( hgObject );
end

