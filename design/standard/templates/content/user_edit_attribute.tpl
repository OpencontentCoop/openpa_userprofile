{default $view_parameters            = array()
         $attribute_categorys        = ezini( 'ClassAttributeSettings', 'CategoryList', 'content.ini' )
         $attribute_default_category = ezini( 'ClassAttributeSettings', 'DefaultCategory', 'content.ini' )}

<div class="Accordion  Accordion--default {if $content_attributes_grouped_data_map|count()|gt(1)}fr-accordion js-fr-accordion{/if}" id="accordion-edit-attributes">
    {foreach $content_attributes_grouped_data_map as $attribute_group => $content_attributes_grouped}

        {if $attribute_group|eq('hidden')}<div style="display: none !important;">{/if}

        {if $attribute_default_category|ne($attribute_group)}
            <h2 class="Accordion-header js-fr-accordion__header fr-accordion__header"
                id="accordion-header-{$attribute_group}">
                <span class="Accordion-link u-text-r-s">{$attribute_categorys[$attribute_group]}</span>
            </h2>
        {/if}
        <div id="accordion-panel-{$attribute_group}"
             class="Accordion-panel{if $attribute_default_category|ne($attribute_group)} fr-accordion__panel js-fr-accordion__panel {/if} {*u-layout-prose*} u-background-grey-10 u-color-grey-90">

            {foreach $content_attributes_grouped as $attribute_identifier => $attribute}
                {def $contentclass_attribute = $attribute.contentclass_attribute}

                {* Show view GUI if we can't edit, otherwise: show edit GUI. *}
                {if and( eq( $attribute.can_translate, 0 ), ne( $object.initial_language_code, $attribute.language_code ) )}
                    <div class="ezcca-edit-datatype-{$attribute.data_type_string} u-padding-all-s">
                        <p class="Form-label">{first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}
                            {if $attribute.can_translate|not} <span class="nontranslatable"> ({'not translatable'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}:
                            {if $contentclass_attribute.description} <em class="classattribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</em>{/if}
                        </p>
                        {if $is_translating_content}
                            <div class="u-background-grey-20 u-padding-all-s">
                                {attribute_view_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters}
                                <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}"/>
                            </div>
                        {else}
                            {attribute_view_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters}
                            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}"/>
                        {/if}
                    </div>
                {else}
                    {if $is_translating_content}
                        <div class="ezcca-edit-datatype-{$attribute.data_type_string} u-padding-all-s">
                            {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters html_class='Form-input' contentclass_attribute=$contentclass_attribute}
                            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}"/>

                            <div class="u-background-grey-20 u-padding-all-s">
                                {attribute_view_gui attribute_base=$attribute_base attribute=$from_content_attributes_grouped_data_map[$attribute_group][$attribute_identifier] view_parameters=$view_parameters image_class=medium}
                            </div>

                        </div>
                    {else}
                        <div class="ezcca-edit-datatype-{$attribute.data_type_string} u-padding-all-s">
                            {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters html_class='Form-input' contentclass_attribute=$contentclass_attribute}
                            <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}"/>
                        </div>
                    {/if}
                {/if}
                {undef $contentclass_attribute}
            {/foreach}
        </div>
        {if $attribute_group|eq('hidden')}</div>{/if}
    {/foreach}
</div>
