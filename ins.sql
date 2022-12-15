SELECT * FROM mt_queue;

SELECT COUNT (*) FROM mt_queue;
SELECT COUNT (*) FROM mt_history;

SELECT min(SENT_TIME),max(SENT_TIME) ,(max(SENT_TIME)-min(SENT_TIME))*24*60*60*10 FROM mt_history;

--TRUNCATE TABLE mt_queue;
--TRUNCATE TABLE mt_history;

BEGIN
    FOR i IN 1 .. 100000
    LOOP
        INSERT INTO mt_queue
        VALUES (mt_queue_seq.NEXTVAL,
                '936009977',
                'Test nhan tin '||i,
                '9034',
                SYSDATE,
                1,
                0,
                3,
                1);
    END LOOP;

    COMMIT;
END;


BEGIN
    FOR i IN 1 .. 10
    LOOP
        INSERT INTO mt_queue
        VALUES (mt_queue_seq.NEXTVAL,
                '918861983',
                'Test nhan tin '||i,
                '9034',
                SYSDATE,
                0,
                0,
                3,
                1);
    END LOOP;

    COMMIT;
END;