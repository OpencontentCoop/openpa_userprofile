<?php

class OpenPAUserProfileClassExtraParameters extends OCClassExtraParametersHandlerBase
{
    private $canBeEnabled;

    public function getIdentifier()
    {
        return 'user_profile';
    }

    public function getName()
    {
        return 'Configurazioni dei profili utente';
    }

    public function attributes()
    {
        $attributes = parent::attributes();
        $attributes[] = 'mandatory';
        $attributes[] = 'recommended';

        return $attributes;
    }

    public function attribute($key)
    {
        if ($key == 'enabled' && !$this->canBeEnabled()) {
            return false;
        }

        if ($key == 'mandatory') {
            return $this->getAttributeIdentifierListByParameter('mandatory', 1, false);
        }

        if ($key == 'recommended') {
            return $this->getAttributeIdentifierListByParameter('recommended', 1, false);
        }

        return parent::attribute($key);
    }

    public function storeParameters($data)
    {
        OpenPAUserProfileListener::reset($this->class->attribute('identifier'));

        if (!$this->canBeEnabled()) {
            $data = [];
        }

        foreach ($this->classAttributes as $identifier => $attribute){
            if (isset($data['class_attribute'][$this->class->attribute('identifier')][$identifier]['mandatory'])){
                $attribute->setAttribute('is_required', 1);
            }else{
                $attribute->setAttribute('is_required', 0);
            }
            $attribute->store();
        }

        $db = eZDB::instance();
        $preferenceName = OpenPAUserProfileListener::PROFILE_PREFERENCE_KEY;
        $db->query( "DELETE FROM ezpreferences WHERE name='$preferenceName'" );

        parent::storeParameters($data);
    }

    private function getMandatoryAttributesByClassDefinition()
    {
        $attributes = [];
        foreach ($this->classAttributes as $attribute) {
            if ($attribute->attribute('is_required')) {
                $attributes[] = $attribute->attribute('identifier');
            }
        }

        return $attributes;
    }

    private function canBeEnabled()
    {
        if ($this->canBeEnabled === null) {
            /** @var eZContentClass[] $userClassList */
            $userClassList = eZUser::fetchUserClassList(true);
            $this->canBeEnabled = false;
            foreach ($userClassList as $userClass) {
                if ($userClass->attribute('identifier') == $this->class->attribute('identifier')) {
                    $this->canBeEnabled = true;
                    break;
                }
            }
        }

        return $this->canBeEnabled;
    }

    protected function attributeEditTemplateUrl()
    {
        return 'design:openpa/extraparameters/' . $this->getIdentifier() . '/edit_attribute.tpl';
    }

    protected function classEditTemplateUrl()
    {
        return 'design:openpa/extraparameters/' . $this->getIdentifier() . '/edit_class.tpl';
    }
}