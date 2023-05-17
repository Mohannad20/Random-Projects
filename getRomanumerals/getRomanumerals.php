<?php

function num2Romanumerals($x){
    // convert the given parameter into integer 
    $numbers = intval($x);
    $result = '';

    // an array that has all the roman numerals
    $rnumerals = array(
        'M' => 1000,
        'CM' => 900,
        'D' => 500,
        'CD' => 400, 
        'C' => 100,
        'XC' => 90,
        'L' => 50,
        'XL' => 40, 
        'X' => 10,
        'IX' => 9,
        'V' => 5,
        'IV' => 4,
        'I' => 1
    );
    
    foreach ($rnumerals as $key => $value) {
        // number of the matches
        $matches = intval($numbers / $value);
        // assign roman numerals($key) * matches
        $result .= str_repeat($key , $matches);
        // substract from the number
        $numbers %= $value;
    }
    return $result;
}

echo num2Romanumerals(1738);
?>