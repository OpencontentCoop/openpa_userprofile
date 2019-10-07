<?php

use Opencontent\Opendata\Api\EnvironmentLoader;
use Opencontent\Opendata\Api\ContentSearch;

/** @var eZModule $module */
$module = $Params['Module'];
$tpl = eZTemplate::factory();

function scanAll($query, ContentSearch $contentSearch, $mandatoryFields, &$collectData)
{
    while ($query) {
        $data = $contentSearch->search($query, array());
        foreach ($data->searchHits as $hit) {
            $item = [];
            foreach ($mandatoryFields as $mandatoryField) {
                $item[$mandatoryField] = 0;
            }
            foreach ($hit['data'] as $language => $attributes) {
                foreach ($mandatoryFields as $mandatoryField) {
                    if ($item[$mandatoryField] == 0 && !empty($attributes[$mandatoryField])) {
                        $item[$mandatoryField] = 1;
                    }
                }
            }
            foreach ($item as $mandatoryField => $value) {
                $collectData[$mandatoryField] = $collectData[$mandatoryField] + $value;
            }

        }
        $query = $data->nextPageQuery;
    }

    return $data->totalCount;
}

/** @var eZContentClass[] $userClassList */
$userClassList = eZUser::fetchUserClassList(true);
$contentSearch = new ContentSearch();
$currentEnvironment = EnvironmentLoader::loadPreset('full');
$contentSearch->setEnvironment($currentEnvironment);

$classDataList = [];
foreach ($userClassList as $userClass) {
    $userProfileParameters = OCClassExtraParametersManager::instance($userClass)->getHandler('user_profile');
    $userClassIdentifier = $userClass->attribute('identifier');
    $isEnabled = $userProfileParameters->attribute('enabled');
    $mandatoryFields = [];
    $collectData = array();
    $total = 0;
    if ($isEnabled) {
        $mandatoryFields = $userProfileParameters->attribute('mandatory');
        foreach ($mandatoryFields as $mandatoryField) {
            $collectData[$mandatoryField] = 0;
        }
        $total = scanAll("classes [$userClassIdentifier]", $contentSearch, $mandatoryFields, $collectData);
    }
    $classDataList[] = [
        'class' => $userClass,
        'is_enabled' => $isEnabled,
        'mandatory_fields' => $mandatoryFields,
        'data' => $collectData,
        'total' => $total,
    ];
}

$tpl->setVariable('class_data_list', $classDataList);

$Result['path'] = [[
    'text' => ezpI18n::tr('openpa_userprofile', 'Status of user profiles'),
    'url' => false
]];
$Result['node_id'] = 0;
$Result['content'] = $tpl->fetch('design:userprofile/status.tpl');
