import module namespace m='http://www.tei-c.org/pm/models/Toponomasia/latex' at '/db/apps/SardiToponomasia/transform/Toponomasia-latex.xql';

declare variable $xml external;

declare variable $parameters external;

let $options := map {
    "styles": ["transform/docx.css"],
    "collection": "/db/apps/SardiToponomasia/transform",
    "parameters": if (exists($parameters)) then $parameters else map {}
}
return m:transform($options, $xml)