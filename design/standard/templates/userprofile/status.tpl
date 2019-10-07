<div class="container">
    <div class="row">
        <div class="col col-md-12 u-margin-bottom-xxl mb-4">
            <h1>{'Status of user profiles'|i18n('openpa_userprofile')}</h1>
        </div>
    </div>
    {foreach $class_data_list as $class_data}
        <div class="row">
            <div class="col col-md-12 u-margin-bottom-xxl mb-4">
                <h2>{$class_data.class.name|wash()} <a target='_blank' href="{concat('/classtools/extra/',$class_data.class.identifier,'/user_profile')|ezurl(no)}"><i class="fa fa-cogs"></i></a></h2>
                {if $class_data.is_enabled}
                    {foreach $class_data.class.data_map as $identifier => $attribute}
                        {if $class_data.mandatory_fields|contains($identifier)}
                            <div class="row u-margin-top-l mt-2">
                                <div class="col-sm-4">{$attribute.name|wash()}</div>
                                <div class="col-sm-8">
                                    <div class="progress">
                                        {def $value = mul(100,$class_data.data[$identifier])|div($class_data.total)}
                                        <div class="progress-bar" role="progressbar" style="width: {$value}%;" aria-valuenow="{$value}" aria-valuemin="0" aria-valuemax="100">{$class_data.data[$identifier]}/{$class_data.total}</div>
                                        {undef $value}
                                    </div>
                                </div>
                            </div>
                        {/if}
                    {/foreach}
                {else}
                    <p><em>Non abilitato</em></p>
                {/if}
            </div>
        </div>
    {/foreach}
</div>

{literal}
<style>
    .progress {
        overflow: hidden;
        height: 20px;
        margin-bottom: 20px;
        background-color: #bbb;
        border-radius: 4px;
        -webkit-box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
        box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
    }
    .progress-bar {
        float: left;
        width: 0%;
        height: 100%;
        font-size: 12px;
        line-height: 20px;
        color: #fff;
        text-align: center;
        background-color: #f90f00;
        -webkit-box-shadow: inset 0 -1px 0 rgba(0,0,0,0.15);
        box-shadow: inset 0 -1px 0 rgba(0,0,0,0.15);
        -webkit-transition: width .6s ease;
        transition: width .6s ease;
    }
</style>
{/literal}