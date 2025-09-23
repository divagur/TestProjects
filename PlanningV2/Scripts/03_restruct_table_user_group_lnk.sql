
CREATE TABLE [dbo].[pl_user_group_lnk](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[group_id] [int] NOT NULL,
 CONSTRAINT [PK_pl_user_group_lnk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


insert into pl_user_group_lnk([user_id], group_id)
select [user_id], group_id
from user_group_lnk


go 

exec sp_rename 'dbo.user_group_lnk', 'user_group_lnk_ex'

go 

exec sp_rename 'dbo.pl_user_group_lnk', 'user_group_lnk'


