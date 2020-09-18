<?php
namespace Concrete\Package\Ddrfv;

use Package;

class Controller extends Package
{
  protected $pkgHandle = 'ddr_fv';
  protected $pkgVersion = '20.09.17';
  protected $title = 'Articles parus dans Foi et Vie (1928–1977)';
  protected $bookpath = '/articles/fv';

  public function getPackageName()
  {
    return $this->pkgHandle;
  }

  public function getPackageDescription()
  {
    return $this->title;
  }


  public function install()
  {
    $bookPage = \Page::getByPath($this->bookpath);
    if($bookPage->isError()) {
      \Log::addWarning("Livre créé automatiquement: ".$this->bookpath);
      $parentPage = \Page::getByPath(dirname($this->bookpath));
      $pageType = \PageType::getByHandle('livre');
      $template = \PageTemplate::getByHandle('livre');
      $bookPage = $parentPage->add($pageType, array(
          'cName' => $this->title,
          'cHandle' => basename($this->bookpath),
        ), $template
      );
    }
    $this->installXml();
    $pkg = parent::install();
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
    $bookPage = \Page::getByPath($this->bookpath);
    if($bookPage->isError()) {
      throw new \Exception('Couverture pour ce livre ? '.$this->bookpath);
    }
    $tocfile = $this->getPackagePath()."/".$this->pkgHandle."_toc.html";
    if (file_exists($tocfile)) { // il y a une toc à écrire en page d’accueil
      $data = array();
      $data['content'] = file_get_contents($tocfile);
      $blocks = $bookPage->getBlocks('livre_sommaire');
      $count = count($blocks);
      for ($i = 1; $i < $count; $i++) { // delete too much blocks
        $blocks[$i]->delete();
      }
      if ($count == 0) {
        $bt = \BlockType::getByHandle('content');
        $bookPage->addBlock($bt, 'livre_sommaire', $data);
      }
      else {
        $blocks[0]->update($data);
      }
    }
    $this->installContentFile('content.xml');
  }

  protected function delBook()
  {
    $pl = new \Concrete\Core\Page\PageList();
    $pl->filterByPath($this->bookpath, true); // true = do not delete parent
    $pages = $pl->get();
    foreach ($pages as $page) {
      $page->delete();
    }
  }
}
