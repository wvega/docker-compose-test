<?php

class PluginCest {


    public function _before( AcceptanceTester $I ) {
    }


    public function tryToTest( AcceptanceTester $I ) {

		$I->loginAsAdmin();
		$I->amOnPluginsPage();
		$I->see( 'SkyVerge Test Plugin' );
	}


}
