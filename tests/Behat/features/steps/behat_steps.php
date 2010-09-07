<?php

$steps->Given('/^a standard Behat project directory structure$/', function() use(&$world) {
    chdir(sys_get_temp_dir());

    if (is_dir('features')) {
        exec('rm -rf features');
    }

    mkdir('features');
    mkdir('features/steps');
    mkdir('features/support');
});

$steps->Given('/^a file named "([^"]*)" with:$/', function($filename, $content) use(&$world) {
    file_put_contents($filename, strtr($content, array("'''" => '"""')));
});

$steps->When('/^I run "([^"]*)"$/', function($command) use(&$world) {
    $world->command = $command;
    exec($command, $world->output, $world->return);

    // Remove formatting & time from output
    $world->output = preg_replace(array("/\n[0-9\.]+s/", "/\\033\[[^m]*m/", "/\\033\[0m/"), '',
        trim(implode("\n", $world->output))
    );
});

$steps->Then('/^display last command exit code$/', function() use(&$world) {
    $world->printDebug("`" . $world->command . "`  =>  " . $world->return);
});

$steps->Then('/^display last command output$/', function() use(&$world) {
    $world->printDebug("`" . $world->command . "`:\n" . $world->output);
});

$steps->Then('/^it should (fail|pass) with:$/', function($success, $data) use(&$world) {
    if ('fail' === $success) {
        assertNotEquals(0, $world->return);
    } else {
        assertEquals(0, $world->return);
    }
    assertEquals(trim($data), $world->output);
});

$steps->Then('/^it should (fail|pass)$/', function($success) use(&$world) {
    if ('fail' === $success) {
        assertNotEquals(0, $world->return);
    } else {
        assertEquals(0, $world->return);
    }
});

$steps->Then('/^the output should contain$/', function($text) use(&$world) {
    assertContains($text, $world->output);
});

$steps->Then('/^the output should not contain$/', function($text) use(&$world) {
    assertNotContains($text, $world->output);
});
