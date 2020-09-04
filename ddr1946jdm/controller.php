<?php
namespace Concrete\Package\Ddr1946jdm;

use Package;

class Controller extends Package
{
    protected $pkgHandle = 'ddr1946jdm';
    protected $pkgVersion = '20.09.04';

    public function getPackageName()
    {
        return $this->pkgHandle;
    }

    public function getPackageDescription()
    {
      return "Journal des deux Mondes";
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
        $path = "/livres/ddr1946jdm";
        $pl = new \Concrete\Core\Page\PageList();
        $pl->filterByPath($path, true); // true = do not delete parent
        $pages = $pl->get();
        foreach ($pages as $page) {
          // $url = \URL::to($page);
          // \Log::addWarning("url ? ".$url);
          $page->delete();
        }
    }
}
