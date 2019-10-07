{ezscript_require(array('ezjsc::jquery', 'plugins/chosen.jquery.js', 'plugins/edit.js'))}
{def $_redirect = false()}
{if ezhttp_hasvariable( 'RedirectURIAfterPublish', 'session' )}
    {set $_redirect = ezhttp( 'RedirectURIAfterPublish', 'session' )}
{elseif ezhttp_hasvariable( 'LastAccessesURI', 'session' )}
    {set $_redirect = ezhttp( 'LastAccessesURI', 'session' )}
{elseif $object.main_node_id}
    {set $_redirect = concat( 'content/view/full/', $object.main_node_id )}
{elseif ezhttp( 'url', 'get', true() )}
    {set $_redirect = ezhttp( 'url', 'get' )}
{/if}

{def $tab = ''}
{if and( ezhttp_hasvariable( 'tab', 'get' ), is_set( $view_parameters.tab )|not() )}
    {set $tab = ezhttp( 'tab', 'get' )}
    {set $_redirect = concat( $_redirect, '/(tab)/', $tab )}
{/if}

{def $language_index = 0
     $from_language_index = 0
     $translation_list = $content_version.translation_list}

<form class="Form Form--spaced {*u-layout-prose*} u-text-r-xs" enctype="multipart/form-data" method="post" action={concat("/content/edit/",$object.id,"/",$edit_version,"/",$edit_language|not|choose(concat($edit_language,"/"),''))|ezurl}>
    {include uri='design:parts/website_toolbar_edit.tpl'}

    <h2 class="u-text-h2">
        <i class='icon-edit'></i>
        <span>Modifica {$object.name|wash}</span>
        <small>{$class.name|wash}</small>
    </h2>

    {if ezhttp_hasvariable( 'openpauserprofile', 'get' )}
        {set $validation = $validation|merge(hash('processed', true()))}
        {set $validation = $validation|merge(hash('custom_rules', array(hash( text, "Enter all the requested data"|i18n("openpa_userprofile")))))}
    {/if}

    {include uri="design:content/edit_validation.tpl"}

    {if ezini_hasvariable( 'EditSettings', 'AdditionalTemplates', 'content.ini' )}
        {foreach ezini( 'EditSettings', 'AdditionalTemplates', 'content.ini' ) as $additional_tpl}
            {include uri=concat( 'design:', $additional_tpl )}
        {/foreach}
    {/if}

    {include uri="design:designitalia/user_edit_attribute.tpl"}

    <div class="Grid Grid--withGutter u-padding-top-xxl">
        <div class="Grid-cell u-size1of2">
            <input class="Button Button--danger" type="submit" name="DiscardButton" value="{'Discard'|i18n('ocbootstrap')}"/>
        </div>
        <div class="Grid-cell u-size1of2 u-textRight">
            <input class="Button Button--default" type="submit" name="PublishButton" value="{'Store'|i18n('ocbootstrap')}"/>
        </div>
        <input type="hidden" name="DiscardConfirm" value="0"/>
        <input type="hidden" name="RedirectIfDiscarded" value="{if ezhttp_hasvariable( 'RedirectIfDiscarded', 'session' )}{ezhttp( 'RedirectIfDiscarded', 'session' )}{else}{$_redirect|wash()}{/if}"/>
        <input type="hidden" name="RedirectURIAfterPublish" value="{$_redirect|wash()}"/>
    </div>

</form>


{undef $_redirect $tab}
