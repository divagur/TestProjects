CREATE TABLE pl_functions
(
    id int IDENTITY (1,1) NOT NULL,
	code varchar(50) null,
    name varchar(120) null
	CONSTRAINT [PK_pl_functions] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];

GO

insert into pl_functions (code, name)
select id, name from functions

go 

exec sp_rename 'dbo.functions', 'functions_ex'

go 

exec sp_rename 'dbo.pl_functions', 'functions'
