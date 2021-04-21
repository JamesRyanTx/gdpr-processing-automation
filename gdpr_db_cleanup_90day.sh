#!/bin/bash
Original_Record_Count = "SELECT COUNT(*)"
Records_Over_90_days = "SELECT COUNT FROM table WHERE Created < DATE_SUB(CURDATE(), INTERVAL 90 DAY);"

echo Currently $Original_Record_Count records exist and $Records_Over_90_days records should be removed. 

echo Removing records older than 90 days...
"DELETE FROM table WHERE Created < DATE_SUB(CURDATE(),INTERVAL 90 DAY)"

echo Verifing Record Removal...
Expected_Current_Records = `expr $Original_Record_Count - $Records_Over_90_days`
New_Record_Count = "SELECT COUNT(*)"

if [$New_Record_Count = $Expected_Current_Records]; then
    echo Record removal successful! $Records_Over_90_days records deleted.
    curl -X POST -H 'Content-type: application/json' --data '{"text":"GDPR DB Records 90+ day deleted sucesfully <link to DB here> "}' https://hooks.slack.com/services/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
else
    echo Unsucessfull GDPR Records removal | Current Records = $New_Record_Count | Expected Current Records = $Expected_Current_Records
    curl -X POST -H 'Content-type: application/json' --data '{"text":"GDPR Database Records removal unsuccessful :( "}' https://hooks.slack.com/services/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
    exit 1
fi

    curl -X POST -H 'Content-type: application/json' --data '{"text":"GDPR Records deleted sucesfully "}' https://hooks.slack.com/services/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
