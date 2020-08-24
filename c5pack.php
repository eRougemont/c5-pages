<?php

if (php_sapi_name() == "cli") C5pack::cli();


class C5pack
{
  /** XSLTProcessors */
  private static $_trans = array();
  
  /**
   * Command line transform
   */
  public static function cli()
  {
  
    array_shift($_SERVER['argv']); // shift first arg, the script filepath
    if (!count($_SERVER['argv'])) exit("
      php c5pack.php  ../ddr-articles/ddr-espr.xml\n");
    foreach ($_SERVER['argv'] as $glob) {
      foreach(glob($glob) as $srcfile) {
        self::file($srcfile);
      }
    }
  }
  
  public static function file($srcfile, $doctype=null)
  {
    $fullpath = realpath($srcfile);
    
    if ($doctype != null);
    else if (stripos($srcfile, 'corr')) $doctype = 'corr';
    else if (stripos($srcfile, 'articles')) $doctype = 'articles';
    else $doctype = 'livres';
    
    
    $filename = pathinfo($srcfile, PATHINFO_FILENAME);
    if ($doctype == "articles") {
      $bookpath = "/articles/".substr($filename, 4);
      $xsl = dirname(__FILE__).'/_engine/c5-articles.xsl';
      $package = strtr($filename, array('-' => '_'));
    }
    else if ($doctype == "corr") {
      $bookpath = "/correspondances/".substr($filename, 9);
      $xsl = dirname(__FILE__).'/_engine/c5-corr.xsl';
      $package = strtr($filename, array('-' => '_'));
    }
    else if ($doctype == "livres") {
      $bookpath = "/livres/".strtok($filename, '_');
      $xsl = dirname(__FILE__).'/_engine/c5-chapitres.xsl';
      $date = substr($filename, 3, 4);
      $package = strtok($filename, '_');
    }
    $dstdir = dirname(__FILE__).'/'.$package;
    if(!file_exists($dstdir));
    else if(filemtime($dstdir.'/content.xml') > filemtime($srcfile)) return;
    echo $srcfile."\n";

    
    $dom = self::dom($srcfile);
    $title = "";
    $xpath = new DOMXpath($dom);
    $xpath->registerNamespace('tei', "http://www.tei-c.org/ns/1.0");
    $nl = $xpath->query("//tei:title[1]");
    if ($nl->length) $title .= $nl->item(0)->textContent;
    

    $php = file_get_contents(dirname(__FILE__)."/_engine/controller.php");
    $version = date("y.m.d");
    $php = str_replace(
      array('%Class%', '%handle%', '%version%', '%bookpath%', '%title%'),
      array(ucfirst(strtr($package, array('_' => ''))), $package, $version, $bookpath, $title),
      $php,
    );

    
    $xml = self::transform($xsl, $dom, null, array('package' => $package, 'bookpath' => $bookpath));
    // contenus de page à encadrer de CDATA 
    $xml = str_replace(array("<content>", "</content>"), array("<content><![CDATA[", "]]></content>"), $xml);

    self::mkdir($dstdir);
    file_put_contents($dstdir.'/content.xml', $xml);
    file_put_contents($dstdir.'/controller.php', $php);
  }


  public static function mkdir($dir)
  {
    if(is_dir($dir)) return false;
    if (!@mkdir($dir, 0775, true)) exit($dir." impossible à créer.\n");
    @chmod($dstdir, 0775);  // let @, if www-data is not owner but allowed to write
  }

  public static function dom($xmlfile)
  {
    $dom = new DOMDocument();
    $dom->preserveWhiteSpace = false;
    $dom->formatOutput=true;
    $dom->substituteEntities=true;
    $dom->load($xmlfile, LIBXML_NOENT | LIBXML_NONET | LIBXML_NSCLEAN | LIBXML_NOCDATA | LIBXML_NOWARNING);
    return $dom;
  }

  /**
   * An xslt transformer
   * TOTHINK : deal with errors
   */
  public static function transform($xslfile, $dom, $dest=null, $pars=null)
  {
    $key = realpath($xslfile);
    // cache compiled xsl
    if (!isset(self::$_trans[$key])) {
      // renew the processor
      self::$_trans[$key] = new XSLTProcessor();
      $trans = self::$_trans[$key];
      //  $trans->registerPHPFunctions();
      // allow generation of <xsl:document>
      if (defined('XSL_SECPREFS_NONE')) $prefs = XSL_SECPREFS_NONE;
      else if (defined('XSL_SECPREF_NONE')) $prefs = XSL_SECPREF_NONE;
      else $prefs = 0;
      if(method_exists($trans, 'setSecurityPreferences')) $oldval = $trans->setSecurityPreferences($prefs);
      else if(method_exists($trans, 'setSecurityPrefs')) $oldval = $trans->setSecurityPrefs($prefs);
      else ini_set("xsl.security_prefs",  $prefs);
      $trans->importStyleSheet(DomDocument::load($xslfile));
    }
    $trans = self::$_trans[$key];
    // add params
    if(isset($pars) && count($pars)) {
      foreach ($pars as $key => $value) {
        $trans->setParameter(null, $key, $value);
      }
    }
    // return a DOM document for efficient piping
    if (is_a($dest, 'DOMDocument')) {
      $ret = $trans->transformToDoc($dom);
    }
    else if ($dest) {
      if (!is_dir(dirname($dest))) {
        if (!@mkdir(dirname($dest), 0775, true)) exit(dirname($dest)." impossible à créer.\n");
        @chmod(dirname($dest), 0775);  // let @, if www-data is not owner but allowed to write
      }
      $trans->transformToURI($dom, $dest);
      $ret = $dest;
    }
    // no dst file, return String
    else {
      $ret =$trans->transformToXML($dom);
    }
    // reset parameters ! or they will kept on next transform if transformer is reused
    if(isset($pars) && count($pars)) {
      foreach ($pars as $key => $value) $trans->removeParameter(null, $key);
    }
    return $ret;
  }

}
?>
