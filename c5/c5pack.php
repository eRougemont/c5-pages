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
      php c5pack.php  ../../ddr-livres/ddr1956ao_amour-occident.xml\n");
    foreach ($_SERVER['argv'] as $glob) {
      foreach(glob($glob) as $srcfile) {
        $bookid = pathinfo($srcfile, PATHINFO_FILENAME);
        $bookid = strtok($bookid, '_');
        $date = substr($bookid, 3, 4);

        $dom = self::dom($srcfile);
        $xpath = new DOMXpath($dom);
        $xpath->registerNamespace('tei', "http://www.tei-c.org/ns/1.0");

        $title = "";
        $nl = $xpath->query("/*/tei:teiHeader//tei:title");
        if ($nl->length) $title .= $nl->item(0)->textContent;
        $title .= " (".$date.")";
        $php = file_get_contents(dirname(__FILE__)."/controller.php");
        $version = date("y.m.d");
        // $version .= 1;
        $php = str_replace(
          array('%Class%', '%handle%', '%version%', '%title%'),
          array(ucfirst($bookid), $bookid, $version, $title),
          $php,
        );


        $xml = self::transform(dirname(__FILE__).'/c5-chapitres.xsl', $dom, null, array('bookid' => $bookid));
        $xml = str_replace(array("<content>", "</content>"), array("<content><![CDATA[", "]]></content>"), $xml);


        $dstdir = dirname(__FILE__).'/'.$bookid;
        if (!is_dir($dstdir)) {
          if (!@mkdir($dstdir, 0775, true)) exit(dirname($dstdir)." impossible à créer.\n");
          @chmod($dstdir, 0775);  // let @, if www-data is not owner but allowed to write
        }
        file_put_contents($dstdir.'/content.xml', $xml);
        file_put_contents($dstdir.'/controller.php', $php);
      }
    }
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
