function constructor = getComponentConstructor( className )
    metaClass = meta.class.fromName( className );
    assert( ~isempty( metaClass ),...
        'Fx:Graphics:InvalidComponent',...
        'The class "%s" does not appear to be a valid class name.',...
        className );
    foundComponent = false;
    while ~foundComponent && ~isempty( metaClass )
        if any( strcmp( {metaClass.Name}, 'fx.graphics.Component' ) )
            foundComponent = true;
        else
            metaClass = metaClass.SuperclassList;
        end
    end
    assert( foundComponent,...
        'Fx:Graphics:InvalidComponent',...
        'The class "%s" does not appear to be a valid "fx.graphics.Component".',...
        className );
    constructor = str2func( className );
end