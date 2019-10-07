<?php


$Module = array(
    'name' => 'User profile Module',
    'variable_params' => true
);

$ViewList['status'] = array(
    'functions' => array('stats'),
    'script' => 'status.php',
    'params' => array(),
    'unordered_params' => array()
);

$FunctionList['stats'] = array();