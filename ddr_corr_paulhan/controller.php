<?php
namespace Concrete\Package\Ddrcorrpaulhan;

use Package;

class Controller extends Package
{
    protected $pkgHandle = 'ddr_corr_paulhan';
    protected $pkgVersion = '20.08.24';

    public function getPackageName()
    {
        return $this->pkgHandle;
    }

    public function getPackageDescription()
    {
      return "Correspondance avec Jean Paulhan (1926-1961)";
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
        $path = "/correspondances/paulhan";
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
