CREATE TYPE [dbo].[empid]
    FROM CHAR (9) NOT NULL;


GO
GRANT REFERENCES
    ON TYPE::[dbo].[empid] TO PUBLIC;

