

SELECT 
    *
FROM 
    CallStream


SELECT CallRecTime, SwitchNum, CallingIMSI, CallingNum, CalledNum 
INTO
    [MyPBIoutput]
FROM 
    CallStream

SELECT 
    System.Timestamp as WindowEnd, SwitchNum, COUNT(*) as CallCount 
FROM
    CallStream TIMESTAMP BY CallRecTime 
GROUP BY TUMBLINGWINDOW(s, 5), SwitchNum
SELECT System.Timestamp AS WindowEnd, COUNT(*) AS FraudulentCalls
    INTO "MyPBIoutput"
    FROM "CallStream" CS1 TIMESTAMP BY CallRecTime
    JOIN "CallStream" CS2 TIMESTAMP BY CallRecTime
    ON CS1.CallingIMSI = CS2.CallingIMSI
    AND DATEDIFF(ss, CS1, CS2) BETWEEN 1 AND 5
    WHERE CS1.SwitchNum != CS2.SwitchNum
    GROUP BY TumblingWindow(Duration(second, 1))