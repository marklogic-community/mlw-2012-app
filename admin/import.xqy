import module namespace json="http://marklogic.com/json" at "/corona/lib/json.xqy";

for $i in /json:json[json:type = "session"]
let $speakers := /json:json[json:id = $i/json:speakerIds/*]
let $array := <json:speakerNames type="array">{
    for $speaker in $speakers
    return <json:speakerName type="string">{ string($speaker/json:name) }</json:speakerName>
}</json:speakerNames>
return
    if(exists($i/json:speakerName))
    then xdmp:node-replace($i/json:speakerName, $array)
    else xdmp:node-insert-child($i, $array)
