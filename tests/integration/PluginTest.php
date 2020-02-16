<?php

class PluginTest extends \Codeception\TestCase\WPTestCase {


    /**
     * @var \IntegrationTester
     */
    protected $tester;


    public function setUp(): void {

		parent::setUp();
    }


    public function tearDown(): void {

        parent::tearDown();
    }


    public function test_it_works() {

        $this->assertInstanceOf( \SkyVerge\WooCommerce\TestPlugin\Plugin::class, sv_test_plugin() );
	}


}
