{if and(ezini('DesignSettings', 'SiteDesign')|eq('designitalia'), ezini('DesignSettings', 'AdditionalSiteDesignList')|contains('openpa_solid'))}
    {include uri='design:designitalia/user_edit.tpl'}
{else}
    {include uri='design:ocbootstrap/user_edit.tpl'}
{/if}