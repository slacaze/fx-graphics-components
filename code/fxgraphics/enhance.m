function enhance( hgObject, template )
    validateattributes( hgObject,...
        {'matlab.graphics.Graphics'}, {'scalar'} );
    validateattributes( template,...
        {'char'}, {'scalartext'} );
    componentConstructor = fx.graphics.internal.getComponentConstructor(...
        template );
    componentConstructor( hgObject );
end

