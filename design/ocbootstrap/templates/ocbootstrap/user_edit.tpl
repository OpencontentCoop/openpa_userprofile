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
    {set $_redirect = concat( $_redirect, '/(tab)/', ezhttp( 'tab', 'get' ) )}
{/if}

<form class="edit" enctype="multipart/form-data" method="post" action={concat("/content/edit/",$object.id,"/",$edit_version,"/",$edit_language|not|choose(concat($edit_language,"/"),''))|ezurl}>

    {include uri='design:parts/website_toolbar_edit.tpl'}

    <h1>
        <i class='fa fa-edit'></i>
        {if $edit_version|eq(1)}{"Create"|i18n( 'design/ocbootstrap/content/edit' )}{else}{"Edit"|i18n( 'design/ocbootstrap/content/edit' )}{/if} <span class="text-lowercase">{$class.name|wash}</span>
    </h1>

    {if ezhttp_hasvariable( 'openpauserprofile', 'get' )}
        {set $validation = $validation|merge(hash('processed', true()))}
        {set $validation = $validation|merge(hash('custom_rules', array(hash( text, "Enter all the requested data"|i18n("openpa_userprofile")))))}
    {/if}
    {include uri="design:content/edit_validation.tpl"}

    <div class="mb-3">
          {if ezini_hasvariable( 'EditSettings', 'AdditionalTemplates', 'content.ini' )}
            {foreach ezini( 'EditSettings', 'AdditionalTemplates', 'content.ini' ) as $additional_tpl}
              {include uri=concat( 'design:', $additional_tpl )}
            {/foreach}
          {/if}

          {include uri="design:ocbootstrap/user_edit_attribute.tpl"}

          <div class="clearfix">
              <input class="btn btn-lg btn-success pull-right" type="submit" name="PublishButton" value="{'Store'|i18n('ocbootstrap')}" />
              <input class="btn btn-lg btn-dark" type="submit" name="DiscardButton" value="{'Discard'|i18n('ocbootstrap')}" />
              <input type="hidden" name="DiscardConfirm" value="0" />
              <input type="hidden" name="RedirectIfDiscarded" value="{if ezhttp_hasvariable( 'RedirectIfDiscarded', 'session' )}{ezhttp( 'RedirectIfDiscarded', 'session' )}{else}{$_redirect}{/if}" />
              <input type="hidden" name="RedirectURIAfterPublish" value="{$_redirect}" />
          </div>
    </div>
</form>

{undef $_redirect}

{run-once}
{literal}
<script>
var select_to_string = function(element) {
  var newValue = $(element).val();
  var $input = $(element).next();
  if (newValue.length > 0) {
    var current = $input.val().length > 0 ? $input.val().split(',') : [];
    current.push(newValue);
    function unique(array){
      return array.filter(function(el, index, arr) {
          return index === arr.indexOf(el);
      });
    }
    $input.val(unique(current).join(','));
  }else{
    $input.val('');
  }
}
</script>
{/literal}
{/run-once}
