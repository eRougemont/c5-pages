<?php
namespace Concrete\Package\Ddrtool;

use Package;

class Controller extends Package
{
    protected $pkgHandle = 'ddr-tool';
    protected $pkgVersion = '0.0.1';

    public function getPackageName()
    {
        return $this->pkgHandle;
    }

    public function getPackageDescription()
    {
      return "Rougemont, un paquet pour bricoler des trucs";
    }


    public function install()
    {
        parent::install();
        $this->installXml();
    }

    public function upgrade()
    {
        parent::upgrade();
        $this->installXml();
    }

    public function uninstall()
    {
        parent::uninstall();
    }

    protected function installXml()
    {
        $this->installContentFile('content.xml');
    }

}
