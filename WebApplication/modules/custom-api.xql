xquery version "3.1";

(:~
 : This is the place to import your own XQuery modules for either:
 :
 : 1. custom API request handling functions
 : 2. custom templating functions to be called from one of the HTML templates
 :)
module namespace api="http://teipublisher.com/api/custom";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";

(: Add your own module imports here :)
import module namespace rutil="http://exist-db.org/xquery/router/util";
import module namespace app="teipublisher.com/app" at "app.xql";

(:~
 : Keep this. This function does the actual lookup in the imported modules.
 :)
declare function api:lookup($name as xs:string, $arity as xs:integer) {
    try {
        function-lookup(xs:QName($name), $arity)
    } catch * {
        ()
    }
};
declare function api:places($request as map(*)) {
    let $search := normalize-space($request?parameters?search)
    let $letterParam := $request?parameters?category
    let $limit := $request?parameters?limit
    let $places :=
        if ($search and $search != '') then
            doc($config:data-root || "/places.xml")//tei:listPlace/tei:place[matches(@n, "^" || $search, "i")]
        else
            doc($config:data-root || "/places.xml")//tei:listPlace/tei:place
    let $sorted := sort($places, "?lang=en", function($place) { lower-case($place/@n) })
    let $letter := 
        if (count($places) < $limit) then 
            "Alle"
        else if ($letterParam = '') then
            substring($sorted[1], 1, 1) => upper-case()
        else
            $letterParam
    let $byLetter :=
        if ($letter = 'Alle') then
            $sorted
        else
            filter($sorted, function($entry) {
                starts-with(lower-case($entry/@n), lower-case($letter))
            })
    return
        map {
            "items": api:output-place($byLetter, $letter, $search),
            "categories":
                if (count($places) < $limit) then
                    []
                else array {
                    for $index in 1 to string-length('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
                    let $alpha := substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', $index, 1)
                    let $hits := count(filter($sorted, function($entry) { starts-with(lower-case($entry/@n), lower-case($alpha))}))
                    where $hits > 0
                    return
                        map {
                            "category": $alpha,
                            "count": $hits
                        },
                    map {
                        "category": "Alle",
                        "count": count($sorted)
                    }
                }
        }
};

declare function api:places-all($request as map(*)) {
    let $places := doc($config:data-root || "/places.xml")//tei:listPlace/tei:place
    return 
        array { 
            for $place in $places
                let $tokenized := tokenize($place/tei:location/tei:geo)
                return 
                    map {
                        "latitude":$tokenized[1],
                        "longitude":$tokenized[2],
                        "label":$place/@n/string()
                    }
            }        
};

declare function api:output-place($list, $category as xs:string, $search as xs:string?) {
    array {
        for $place in $list
        let $categoryParam := if ($category = "all") then substring($place/@n, 1, 1) else $category
        let $params := "category=" || $categoryParam || "&amp;search=" || $search
        let $label := $place/@n/string()
        let $item := doc($config:data-root || "/masterfile.xml/")//tei:item[@xml:id = $label]
        let $coords := tokenize($place/tei:location/tei:geo)
        return
            <span class="place">
            <!-- Lien vers le template item.html, avec un paramètre "place" qui a pour valeur $label -->
            <a href="http://localhost:8080/exist/apps/SardiToponomasia/item.html?place={$label}">{$label}</a>
                <pb-geolocation latitude="{$coords[1]}" longitude="{$coords[2]}" label="{$label}" emit="map" event="click">
                    <paper-icon-button src="https://icons.iconarchive.com/icons/messbook/outdated/128/Magnify-Search-icon.png" alt="octocat" title="loupe"></paper-icon-button>
                </pb-geolocation>
            </span>
    }
};
(: Fonction qui permet d'afficher la portion de texte correspondant au lieu réalisée par Elina Leblanc :)
declare function api:get-latin-text($node as node(), $model as map(*)) {
    (:On récupère le paramètre "place" et sa valeur:)
    let $lieu := request:get-parameter("place", ())
    (: On utilise la valeur du paramètre pour chercher dans masterfile.xml la portion de texte :)
    let $item := doc($config:data-root || "/masterfile.xml/")//tei:item[@xml:id = $lieu] 
    (: On affiche le nom du lieu dans <h1> et le texte dans <p> :)
    return  
        <div class ="item"> 
            <h1>{$lieu}</h1>
            <p>{$item}</p>
             <a href="http://localhost:8080/exist/apps/SardiToponomasia/places.html">
                                <paper-icon-button src="https://icons.iconarchive.com/icons/graphicloads/100-flat-2/72/arrow-back-2-icon.png" alt="octocat" title="back"></paper-icon-button>
                            </a>
        </div>
         
};