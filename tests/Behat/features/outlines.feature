Feature: Scenario Outlines
  In order to write complex features
  As a features writer
  I want to write scenario outlines

  Background:
    Given a standard Behat project directory structure
    And a file named "features/support/env.php" with:
      """
      <?php
      require_once 'PHPUnit/Autoload.php';
      require_once 'PHPUnit/Framework/Assert/Functions.php';
      """
    And a file named "features/steps/math.php" with:
      """
      <?php
      $steps->Given('/^I have basic calculator$/', function() use(&$world) {
          $world->result  = 0;
          $world->numbers = array();
      });
      $steps->Given('/^I have entered (\d+)$/', function($number) use(&$world) {
          $world->numbers[] = intval($number);
      });
      $steps->When('/^I add$/', function() use(&$world) {
          foreach ($world->numbers as $number) {
              $world->result += $number;
          }
          $world->numbers = array();
      });
      $steps->When('/^I sub$/', function() use(&$world) {
          $world->result = array_shift($world->numbers);
          foreach ($world->numbers as $number) {
              $world->result -= $number;
          }
          $world->numbers = array();
      });
      $steps->When('/^I multiply$/', function() use(&$world) {
          $world->result = array_shift($world->numbers);
          foreach ($world->numbers as $number) {
              $world->result *= $number;
          }
          $world->numbers = array();
      });
      $steps->When('/^I div$/', function() use(&$world) {
          $world->result = array_shift($world->numbers);
          foreach ($world->numbers as $number) {
              $world->result /= $number;
          }
          $world->numbers = array();
      });
      $steps->Then('/^The result should be (\d+)$/', function($result) use(&$world) {
          assertEquals($result, $world->result);
      });
      """

  Scenario: Basic scenario outline
    Given a file named "features/math.feature" with:
      """
      Feature: Math
        Background:
          Given I have basic calculator

        Scenario Outline:
          Given I have entered <number1>
          And I have entered <number2>
          When I add
          Then The result should be <result>

          Examples:
            | number1 | number2 | result |
            | 10      | 12      | 22     |
            | 5       | 3       | 8      |
            | 5       | 5       | 10     |
      """
    When I run "behat -f progress features/math.feature"
    Then it should pass with:
      """
      ...............

      3 scenarios (3 passed)
      15 steps (15 passed)
      """

  Scenario: Multiple scenario outlines
    Given a file named "features/math.feature" with:
      """
      Feature: Math
        Background:
          Given I have basic calculator

        Scenario Outline:
          Given I have entered <number1>
          And I have entered <number2>
          When I multiply
          Then The result should be <result>

          Examples:
            | number1 | number2 | result |
            | 10      | 12      | 120    |
            | 5       | 3       | 15     |

        Scenario:
          Given I have entered 10
          And I have entered 3
          When I sub
          Then The result should be 7

        Scenario Outline:
          Given I have entered <number1>
          And I have entered <number2>
          When I div
          Then The result should be <result>

          Examples:
            | number1 | number2 | result |
            | 10      | 2       | 5      |
            | 50      | 5       | 10     |
      """
    When I run "behat -f progress features/math.feature"
    Then it should pass with:
      """
      .........................

      5 scenarios (5 passed)
      25 steps (25 passed)
      """

  Scenario: Multiple scenario outlines with failing steps
    Given a file named "features/math.feature" with:
      """
      Feature: Math
        Background:
          Given I have basic calculator

        Scenario Outline:
          Given I have entered <number1>
          And I have entered <number2>
          When I multiply
          Then The result should be <result>

          Examples:
            | number1 | number2 | result |
            | 10      | 12      | 120    |
            | 5       | 4       | 15     |

        Scenario:
          Given I have entered 10
          And I have entered 4
          When I sub
          Then The result should be 7

        Scenario Outline:
          Given I have entered <number1>
          And I have entered <number2>
          When I div
          Then The result should be <result>

          Examples:
            | number1 | number2 | result |
            | 10      | 2       | 5      |
            | 50      | 10      | 2      |
      """
    When I run "behat -f progress features/math.feature"
    Then it should fail with:
      """
      .........F....F.........F

      (::) failed steps (::)

      01. Failed asserting that <integer:20> is equal to <string:15>.
          In step `Then The result should be 15'. # features/steps/math.php:38
          From scenario ***.                      # features/math.feature:4

      02. Failed asserting that <integer:6> is equal to <string:7>.
          In step `Then The result should be 7'.  # features/steps/math.php:38
          From scenario ***.                      # features/math.feature:15

      03. Failed asserting that <integer:5> is equal to <string:2>.
          In step `Then The result should be 2'.  # features/steps/math.php:38
          From scenario ***.                      # features/math.feature:21

      5 scenarios (2 passed, 3 failed)
      25 steps (22 passed, 3 failed)
      """
