{*
    @var OCClassExtraParametersHandlerInterface $handler
    @var eZContentClass $class
    @var eZContentClassAttribute $attribute
*}
<td>
    <div class="checkbox">
        <label for="mandatory-{$attribute.id}">
            <input id="mandatory-{$attribute.id}" type="checkbox" name="extra_handler_{$handler.identifier}[class_attribute][{$class.identifier}][{$attribute.identifier}][mandatory]" value="1" {if $attribute.is_required}checked="checked"{/if} /> Obbligatorio
        </label>
    </div>
</td>

<td>
    {if $attribute.is_required|not()}
    <div class="checkbox">
        <label for="recommended-{$attribute.id}">
            <input for="recommended-{$attribute.id}" type="checkbox" name="extra_handler_{$handler.identifier}[class_attribute][{$class.identifier}][{$attribute.identifier}][recommended]" value="1" {if $handler.recommended|contains($attribute.identifier)}checked="checked"{/if} /> Raccomandato
        </label>
    </div>
    {/if}
</td>