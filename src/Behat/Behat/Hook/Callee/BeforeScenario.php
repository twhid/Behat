<?php

namespace Behat\Behat\Hook\Callee;

/*
 * This file is part of the Behat.
 * (c) Konstantin Kudryashov <ever.zet@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
use Behat\Behat\Event\EventInterface;

/**
 * BeforeScenario hook.
 *
 * @author Konstantin Kudryashov <ever.zet@gmail.com>
 */
class BeforeScenario extends ScenarioHook
{
    /**
     * Initializes hook.
     *
     * @param null|string $filterString
     * @param Callable    $callback
     * @param null|string $description
     */
    public function __construct($filterString, $callback, $description = null)
    {
        parent::__construct(EventInterface::HOOKABLE_BEFORE_SCENARIO, $filterString, $callback, $description);
    }

    /**
     * Returns hook name.
     *
     * @return string
     */
    public function getName()
    {
        return 'BeforeScenario';
    }
}
