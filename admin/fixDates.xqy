import module namespace json="http://marklogic.com/json" at "/corona/lib/json.xqy";

declare function local:fix(
    $date as xs:string
) as xs:string
{
    replace($date, "-07:00$", "-04:00")
};


for $i in /json:json[json:type = "session"]
let $startTime := $i/json:startTime_003A_003Adate
let $endTime := $i/json:endTime_003A_003Adate
let $newStartTime := <json:startTime_003A_003Adate type="date" normalized-date="{ xs:dateTime(local:fix($startTime/@normalized-date)) }">{ local:fix(string($startTime)) }</json:startTime_003A_003Adate>
let $newEndTime := <json:endTime_003A_003Adate type="date" normalized-date="{ xs:dateTime(local:fix($endTime/@normalized-date)) }">{ local:fix(string($endTime)) }</json:endTime_003A_003Adate>
return (xdmp:node-replace($startTime, $newStartTime), xdmp:node-replace($endTime, $newEndTime))
