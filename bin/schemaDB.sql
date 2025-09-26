CREATE TABLE monitor (
    id INTEGER PRIMARY KEY,  
    sync INTEGER,
    cluster INTEGER,
    now DATETIME,
    service TEXT,
    FROM_IP TEXT,
    FROM_MC TEXT,
    TO_IP TEXT,
    TO_MC    TEXT,
    state INTEGER ,
    message TEXT,
    idpadre INTEGER,
    durata INTEGER
);     

create index indice_now ON monitor (now);
create index indice_sync ON monitor (sync);
