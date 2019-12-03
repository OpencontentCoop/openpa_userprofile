<?php

class OpenPAUserProfileListener
{
    const PROFILE_PREFERENCE_KEY = 'openpa_userprofile';
    const PROFILE_PREFERENCE_VALUE_OK = 'ok';
    const PROFILE_PREFERENCE_VALUE_KO = 'ko';
    const PROFILE_PREFERENCE_VALUE_INDETERMINATE = 'indeterminate';
    const PROFILE_PREFERENCE_VALUE_REQUEST_CHANGE = 'change';

    public static function onInput(eZURI $uri)
    {
        if (($uri->URI == ''
                || $uri->URI == 'user/edit'
                || $uri->URI == eZINI::instance()->variable('SiteSettings', 'IndexPage')
                || $uri->URI == eZINI::instance()->variable('SiteSettings', 'DefaultPage'))
            && self::checkCurrentUserProfile() === false) {
            $name = self::PROFILE_PREFERENCE_KEY;
            $userId = eZUser::currentUserID();
            $query = "DELETE FROM ezpreferences WHERE name = '$name' AND user_id = $userId";
            eZDB::instance()->arrayQuery($query);
            eZPreferences::sessionCleanup();

            $versionNumber = 'f';
            /** @var eZContentObject $object */
            $object = eZUser::currentUser()->attribute('contentobject');
            $draftVersions = $object->versions(true, array('conditions' => array(
                    'status' => array(array(eZContentObjectVersion::STATUS_DRAFT, eZContentObjectVersion::STATUS_INTERNAL_DRAFT)),
                    'language_code' => eZLocale::currentLocaleCode()))
            );
            if (count($draftVersions) > 0) {
                $mostRecentDraft = $draftVersions[0];
                foreach ($draftVersions as $currentDraft) {
                    if ($currentDraft->attribute('modified') > $mostRecentDraft->attribute('modified')) {
                        $mostRecentDraft = $currentDraft;
                    }
                }
                $versionNumber = $mostRecentDraft->attribute('version');
            }
            $http = eZHTTPTool::instance();
            $redirectUrl = '/content/edit/' . eZUser::currentUserID() . '/' . $versionNumber . '/' . eZLocale::currentLocaleCode() . '?openpauserprofile';
            eZURI::transformURI($redirectUrl);
            $http->redirect($redirectUrl);

        } else {
            return null;
        }
    }

    private static function checkCurrentUserProfile()
    {
        if (eZUser::currentUser()->isAnonymous()) {
            return true;
        }

        $preferenceValue = eZPreferences::value(self::PROFILE_PREFERENCE_KEY);

        if ($preferenceValue === false || $preferenceValue == self::PROFILE_PREFERENCE_VALUE_REQUEST_CHANGE) {

            /** @var eZContentObject $object */
            $object = eZUser::currentUser()->attribute('contentobject');

            if ($object instanceof eZContentObject) {
                $class = $object->attribute('content_class');
                if ($class instanceof eZContentClass) {
                    $userProfileParameters = OCClassExtraParametersManager::instance($class)->getHandler('user_profile');
                    if ($userProfileParameters->attribute('enabled')) {
                        $dataMap = $object->dataMap();
                        $preferenceValue = self::PROFILE_PREFERENCE_VALUE_OK;
                        foreach ($userProfileParameters->attribute('mandatory') as $identifier) {
                            if (isset($dataMap[$identifier])
                                && $dataMap[$identifier]->attribute('data_type_string') !== 'ocrecaptcha'
                                && !$dataMap[$identifier]->hasContent()
                            ) {
                                $preferenceValue = self::PROFILE_PREFERENCE_VALUE_KO;
                                break;
                            }
                        }

                    } else {
                        $preferenceValue = self::PROFILE_PREFERENCE_VALUE_INDETERMINATE;
                    }
                } else {
                    $preferenceValue = self::PROFILE_PREFERENCE_VALUE_INDETERMINATE;
                }
            } else {
                $preferenceValue = self::PROFILE_PREFERENCE_VALUE_INDETERMINATE;
            }

            if ($preferenceValue != self::PROFILE_PREFERENCE_VALUE_KO) {
                eZPreferences::setValue(
                    self::PROFILE_PREFERENCE_KEY,
                    $preferenceValue,
                    eZUser::currentUserID()
                );
                eZPreferences::sessionCleanup();
            }
        }

        eZDebug::writeDebug($preferenceValue, __METHOD__);

        return $preferenceValue != self::PROFILE_PREFERENCE_VALUE_KO;
    }

    public static function reset($userClassId)
    {
        $db = eZDB::instance();
        $name = self::PROFILE_PREFERENCE_KEY;

        if (!is_numeric($userClassId)) {
            $userClassId = eZContentClass::classIDByIdentifier($userClassId);
        }
        if ((int)$userClassId > 0) {
            $query = "DELETE FROM ezpreferences WHERE name = '$name' AND user_id in (SELECT DISTINCT id FROM ezcontentobject WHERE contentclass_id = $userClassId)";
            $result = $db->arrayQuery($query);
        }
        eZPreferences::sessionCleanup();
    }

}