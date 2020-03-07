<?php
namespace Concrete\Package\DdrLivres;

use Package;

class Controller extends Package
{
    protected $pkgHandle = 'ddr-livres';
    protected $pkgVersion = '0.5.0';

    public function getPackageName()
    {
        return $this->pkgHandle;
    }

    public function getPackageDescription()
    {
      return "Rougemont, les livres";
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
