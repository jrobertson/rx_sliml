# Using the Rx_sliml gem to create an XML stylesheet from a RecordX object

    require 'rx_sliml'
    require 'dynarex'

    s = <<EOF
    dl
      dt from:
      dd $from

      dt to:
      dd $to

      dt subject:
      dd $subject
    EOF


    s2 =<<EOF
    &lt;?dynarex schema='email[title]/messages(from, to, subject)' delimiter='#'?&gt;
    title: Email for James
    -----------------------

    abc@ruby132.org     # james@jamesrobertson.eu # test 123
    info@gtdtoday.co.uk # james@jamesrobertson.eu # How to plan ahead (newsletter)
    a123456@aol.com     # info@jamesrobertson.eu  # hello

    EOF


    dx = Dynarex.new.import(s2)

    r = RxSliml.new(s, dx.all[2]).to_xslt

Output:

<pre>
&lt;?xml version='1.0' encoding='UTF-8'?&gt;
&lt;xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version='1.0'&gt;
  &lt;xsl:output method='xml' indent='yes' omit-xml-declaration='yes'/&gt;
  &lt;xsl:template match='kvx'&gt;
    &lt;html&gt;
      &lt;head&gt;
        &lt;title&gt;
          &lt;xsl:value-of select='summary/title'/&gt;
        &lt;/title&gt;
      &lt;/head&gt;
      &lt;body&gt;
        &lt;header&gt;
          &lt;xsl:apply-templates select='summary'/&gt;
        &lt;/header&gt;
        &lt;main&gt;
          &lt;xsl:apply-templates select='body'/&gt;
        &lt;/main&gt;
      &lt;/body&gt;
    &lt;/html&gt;
  &lt;/xsl:template&gt;
  &lt;xsl:template match='kvx/summary'&gt;
    &lt;dl&gt;
      &lt;xsl:for-each select='*'&gt;
        &lt;dt&gt;
          &lt;xsl:value-of select='name()'/&gt;
        &lt;/dt&gt;
        &lt;dd&gt;
          &lt;xsl:value-of select='.'/&gt;
        &lt;/dd&gt;
      &lt;/xsl:for-each&gt;
    &lt;/dl&gt;
  &lt;/xsl:template&gt;
  &lt;xsl:template match='body'&gt;
    &lt;dl&gt;
  &lt;dt&gt;from:&lt;/dt&gt;
  &lt;dd&gt;&lt;xsl:value-of select="from"/&gt;&lt;/dd&gt;
  &lt;dt&gt;to:&lt;/dt&gt;
  &lt;dd&gt;&lt;xsl:value-of select="to"/&gt;&lt;/dd&gt;
  &lt;dt&gt;subject:&lt;/dt&gt;
  &lt;dd&gt;&lt;xsl:value-of select="subject"/&gt;&lt;/dd&gt;
&lt;/dl&gt;
  &lt;/xsl:template&gt;
&lt;/xsl:stylesheet&gt;
</pre>

## Resources

* rx_sliml https://rubygems.org/gems/rx_sliml

rx_sliml kvx recordx xslt
