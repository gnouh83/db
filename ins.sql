SELECT * FROM mt_queue;

UPDATE mt_queue
SET content = content || id;

SELECT COUNT (*) FROM mt_queue;

SELECT * FROM mt_history;

--TRUNCATE TABLE mt_queue;

BEGIN
    FOR i IN 1 .. 1000000
    LOOP
        INSERT INTO mt_queue
        VALUES (mt_queue_seq.NEXTVAL,
                '936009977',
                'Test nhan tin ',
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
                'Test nhan tin ',
                '9034',
                SYSDATE,
                0,
                0,
                3,
                1);
    END LOOP;

    COMMIT;
END;