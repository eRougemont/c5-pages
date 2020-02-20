<?php
namespace Concrete\Package\Ddr1956ao;

use Package;

class Controller extends Package
{
    protected $pkgHandle = 'ddr1956ao';
    protected $pkgVersion = '0.5.0';

    public function getPackageName()
    {
        return $this->pkgHandle;
    }

    public function getPackageDescription()
    {
      return "l’Amour et l’Occident (1956)";
    }


    public function install()
    {
        parent::install();
        $this->installXml();
    }

    public function upgrade()
    {
        $this->delBook();
        parent::upgrade();
        $this->installXml();
    }

    public function uninstall()
    {
        $this->delBook();
        parent::uninstall();
    }

    protected function installXml()
    {
        $this->installContentFile('content.xml');
    }

    protected function delBook()
    {
        $path = "/livres/".$this->pkgHandle;
        $pl = new \Concrete\Core\Page\PageList();
        $pl->filterByPath($path, false);
        $pages = $pl->get();
        foreach ($pages as $page) {
          $url = \URL::to($page);
          \Log::addWarning("url ? ".$url);
          $page->delete();
        }
    }
}
