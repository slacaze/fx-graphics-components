classdef( Abstract ) Component < handle &...
        matlab.mixin.Heterogeneous
    
    properties( GetAccess = private, Constant )
        StorePropertyName = 'FxComponents'
        HiddenStorePropertyName = 'FxComponents_'
        MappedPropertyAttributes = {...
            'SetAccess',...
            'GetAccess',...
            'Dependent',...
            };
    end
    
    properties( GetAccess = public, SetAccess = immutable )
        HgObject matlab.graphics.Graphics
    end
    
    properties( GetAccess = private, SetAccess = private )
        HgObjectListeners event.listener
        StorePropertyListeners event.proplistener
    end
    
    methods( Access = public )
        
        function this = Component( hgObject )
            validateattributes( hgObject,...
                {'matlab.graphics.Graphics'}, {'scalar'} );
            this.HgObject = hgObject;
            this.linkLifeCycleToHgObject();
            this.decorateHgObject();
        end
        
        function delete( this )
            if ~isempty( this.HgObject ) && isvalid( this.HgObject )
                this.HgObject.delete();
            end
        end
        
    end
    
    methods( Access = private )
        
        function linkLifeCycleToHgObject( this )
            this.ensureStorePropertyExist();
            this.HgObject.(this.StorePropertyName)(end+1) = this;
            this.HgObjectListeners = event.listener( this.HgObject,...
                'ObjectBeingDestroyed', @(~,~) this.delete );
        end
        
        function ensureStorePropertyExist( this )
            if ~isprop( this.HgObject, this.StorePropertyName )
                this.createStoreProperty();
            end
        end
        
        function createStoreProperty( this )
            hiddenStoreProperty = this.HgObject.addprop( this.HiddenStorePropertyName );
            hiddenStoreProperty.Hidden = true;
            hiddenStoreProperty.GetAccess = 'public';
            hiddenStoreProperty.SetAccess = 'public';
            this.HgObject.(this.HiddenStorePropertyName) = fx.graphics.Component.empty;
            storeProperty = this.HgObject.addprop( this.StorePropertyName );
            storeProperty.GetAccess = 'public';
            storeProperty.SetAccess = 'public';
            storeProperty.SetObservable = true;
            preSetListener = event.proplistener( this.HgObject, storeProperty,...
                'PreSet', @this.onStorePropertyPreSet );
            postSetListener = event.proplistener( this.HgObject, storeProperty,...
                'PostSet', @this.onStorePropertyPostSet );
            this.StorePropertyListeners = [...
                preSetListener,...
                postSetListener ];
            this.HgObject.(this.StorePropertyName) = fx.graphics.Component.empty;
        end
        
        function decorateHgObject( this )
            thisMetaClass = metaclass( this );
            thisProperties = thisMetaClass.PropertyList';
            propertiesToMap = ...
                [thisProperties.Dependent] &...
                [thisProperties.SetObservable] &...
                strcmp( {thisProperties.SetAccess}, 'public' ) &...
                strcmp( {thisProperties.GetAccess}, 'public' );
            for property = thisProperties(propertiesToMap)
                newProperty = this.HgObject.addprop( property.Name );
                for attributeIndex = 1:numel( this.MappedPropertyAttributes )
                    newProperty.(this.MappedPropertyAttributes{attributeIndex}) =...
                        property.(this.MappedPropertyAttributes{attributeIndex});
                end
                newProperty.GetMethod = @(~) property.GetMethod( this );
                newProperty.SetMethod = @(~,value) property.SetMethod( this, value );
            end
        end
        
    end
    
    methods( Access = private )
        
        function onStorePropertyPreSet( this, ~, ~ )
            this.HgObject.(this.HiddenStorePropertyName) = this.HgObject.(this.StorePropertyName);
        end
        
        function onStorePropertyPostSet( this, ~, ~ )
            newValue = this.HgObject.(this.StorePropertyName);
            if ~isa( newValue, 'fx.graphics.Component' )
                this.HgObject.(this.StorePropertyName) = this.HgObject.(this.HiddenStorePropertyName);
                error(...
                    'Fx:Graphics:InvalidType',...
                    'The property "%s" must be an array of fx.graphics.Component.',...
                    this.StorePropertyName );
            end
        end
        
    end
    
end